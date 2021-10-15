{
	:global initTimeout 60
	:global connectTimeout 60
	:global minimumSignalLevel -99

	:global switchSIM do={
		:local simSlot [/system routerboard modem get sim-slot]
		:if ($simSlot="3") do={
			:log info message="Switching to sim slot 2 (Megafon)"
			/system routerboard modem set sim-slot=2
		} else={
			:log info message="Switching to sim slot 3 (Beeline)"
			/system routerboard modem set sim-slot=3
		}
	}

	:global initialize do={
		:global initTimeout
		:local i 0
		:while ($i < $initTimeout) do={
			:if ([:len [/interface lte find ]] > 0) do={
				:return true
			}			
			:set $i ($i+1)
			:delay 1s
		}
		:return false
	}
	:global waitConnect do={
		:global connectTimeout
		:local i 0
		:while ($i < $connectTimeout) do={
			:if ([/interface lte get [find name="lte1"] running] = true) do={
				:return true
			}
			:set $i ($i+1)
			:delay 1s
		}
		:return false
	}
	:if ([$initialize] = true) do={
		:if ([$waitConnect] = true) do={
			:local info [/interface lte info lte1 once as-value]
			:local rssi ($info->"rssi")
			:if ($rssi < $minimumSignalLevel) do={
				:log info message=("Current RSSI ".$rssi." < ".$minimumSignalLevel.". Trying to switch active sim slot.")
				$switchSIM
			}
		} else={
			:log info message="GSM network is not connected. Trying to switch active sim slot."
			$switchSIM
		}
	} else={
		:log info message="LTE modem did not appear, trying power-reset"
		/system routerboard usb power-reset duration=5s
	}		
}