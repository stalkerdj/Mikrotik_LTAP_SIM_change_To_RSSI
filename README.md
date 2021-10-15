# Mikrotik_LTAP_SIM_change_To_RSSI
Скрипт RouterOS Меняет Сим карту на Mikrotik LTAP между 2 и 3 слотом по уровню сигнала либо по потери сети

Original script: https://wiki.mikrotik.com/wiki/Dual_SIM_Application

# установка планировщика
/system scheduler add interval=4m on-event=simScript name="SIM Switch"
