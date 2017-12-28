package exporter

import (
	. "testing"
)

func TestParseSystemdServices(t *T) {
	services, err := parseServiceOutput(`Path                                                                                                                                          Tasks   %CPU   Memory  Input/s Output/s

/                                                                                                                                               224      -    21.3G        -        -
/system.slice                                                                                                                                     1      -   212.6M        -        -
/system.slice/NetworkManager.service                                                                                                              1      -        -        -        -
/system.slice/auditd.service                                                                                                                      1      -    20.0K        -        -
/system.slice/crond.service                                                                                                                       1      -    32.0K        -        -
/system.slice/dbus.service                                                                                                                        1      -    84.0K        -        -
/system.slice/ds_agent.service                                                                                                                    2      -   120.0K        -        -
/system.slice/gssproxy.service                                                                                                                    1      -        -        -        -
/system.slice/irqbalance.service                                                                                                                  1      -        -        -        -
/system.slice/lvm2-lvmetad.service                                                                                                                1      -        -        -        -
/system.slice/node_exporter.service                                                                                                               1      -        -        -        -
/system.slice/nrpe.service                                                                                                                        1      -    20.0K        -        -
/system.slice/ntpd.service                                                                                                                        1      -     4.0K        -        -
/system.slice/polkit.service                                                                                                                      1      -        -        -        -
/system.slice/postfix.service                                                                                                                     3      -     1.0M        -        -
/system.slice/rsyslog.service                                                                                                                     1      -    84.0K        -        -
/system.slice/slv-cms.service                                                                                                                     1      -   203.2M        -        -
/system.slice/splunk.service                                                                                                                      2      -    84.0K        -        -
/system.slice/sshd.service                                                                                                                        1      -    56.0K        -        -
/system.slice/system-getty.slice/getty@tty1.service                                                                                               1      -        -        -        -
/system.slice/system-jmx_exporter.slice/jmx_exporter@tomcat1.service                                                                              3      -        -        -        -
/system.slice/systemd-journald.service                                                                                                            1      -        -        -        -
/system.slice/systemd-logind.service                                                                                                              1      -    20.0K        -        -
/system.slice/systemd-udevd.service                                                                                                               1      -        -        -        -
/system.slice/tuned.service                                                                                                                       1      -        -        -        -
/system.slice/vmtoolsd.service                                                                                                                    1      -   100.0K        -        -
/system.slice/wpa_supplicant.service                                                                                                              1      -        -        -        -
/user.slice/user-60000.slice/session-1624.scope                                                                                                   1      -        -        -        -
/user.slice/user-60000.slice/session-8784.scope                                                                                                   4      -        -        -        -`)

	if err != nil {
		t.Fatal(err)
	}

	expected := []*PartitionInfo{
		{
			Topic:           "topic-A",
			PartitionId:     "2",
			CurrentOffset:   12345200,
			Lag:             0,
			ClientId:        "foobar-consumer-1-StreamThread-1-consumer",
			ConsumerAddress: "192.168.1.1",
		},
		{
			Topic:           "topic-A",
			PartitionId:     "1",
			CurrentOffset:   45678335,
			Lag:             2,
			ClientId:        "foobar-consumer-1-StreamThread-1-consumer",
			ConsumerAddress: "192.168.1.2",
		},
		{
			Topic:           "topic-A",
			PartitionId:     "0",
			CurrentOffset:   91011178,
			Lag:             1,
			ClientId:        "foobar-consumer-1-StreamThread-1-consumer",
			ConsumerAddress: "192.168.1.3",
		},
	}

	comparePartitionTable(t, partitions, expected)
}
