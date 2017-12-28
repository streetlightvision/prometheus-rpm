package exporter

import (
	"fmt"
	"regexp"
	"sync"

	"github.com/kawamuray/prometheus-exporter-harness/harness"
)

type ServiceInfo struct {
	Path         string
	Tasks        string
	CPU          string
	Memory       string
	InputPerSec  string
	OutputPerSec string
}

var ServiceCommandDescribeOutputSeparatorRegexp = regexp.MustCompile(`,?\s+`)

type Collector struct {
	BootstrapServers         string
	ConsumerGroupCommandPath string
	fetchBarrier             uintptr
	updateLock               sync.Mutex
	lastValue                map[string][]*ServiceInfo
}

func NewCollector(bootstrapServers, consumerGroupCommandPath string) *Collector {
	return &Collector{
		BootstrapServers:         bootstrapServers,
		ConsumerGroupCommandPath: consumerGroupCommandPath,
	}
}

func ParseServiceOutput(line string) (*ServiceInfo, error) {
	fields := ServiceCommandDescribeOutputSeparatorRegexp.Split(line, -1)
	if len(fields) != 5 {
		return nil, fmt.Errorf("malformed line")
	}

	//serviceName, consumerAddress := parseClientIdAndConsumerAddress(fields[6])
	serviceInfo := &ServiceInfo{
		Path:         fields[0],
		Tasks:        fields[1],
		CPU:          fields[2],
		Memory:       fields[3],
		InputPerSec:  fields[4],
		OutputPerSec: fields[5],
	}

	return serviceInfo, nil
}

func (col *Collector) Collect(reg *harness.MetricRegistry) {
	col.updateLock.Lock()
	defer col.updateLock.Unlock()

	// for group, partitionInfos := range col.lastValue {
	// 	for _, partitionInfo := range partitionInfos {
	// 		labels := map[string]string{
	// 			"group_id":         group,
	// 			"consumer_address": partitionInfo.ConsumerAddress,
	// 			"client_id":        partitionInfo.ClientId,
	// 			"topic":            partitionInfo.Topic,
	// 			"partition":        partitionInfo.PartitionId,
	// 		}

	// 		reg.Get(MetricCurrentOffset).(*prometheus.GaugeVec).With(labels).Set(float64(partitionInfo.CurrentOffset))
	// 		reg.Get(MetricOffsetLag).(*prometheus.GaugeVec).With(labels).Set(float64(partitionInfo.Lag))
	// 	}
	// }

	// Prepare next update(if necessary)
	go col.maybeUpdate()
}
