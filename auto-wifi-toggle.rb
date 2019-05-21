class AutoWifiToggle < Formula
  desc "Toggle enabling of macOS Wi-Fi devices when Ethernet devices connected"
  url "file:///dev/null"
  version "0.1.0"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"

  def install
    File.open("toggle.sh", "w") do |file|
      file.puts <<~'EOS'
        #!/bin/bash

        set -eu

        # get all device names
        devices="$(networksetup -listnetworkserviceorder | sed -En 's|^\(Hardware Port:.*Device: ?([a-zA-Z0-9-]*).*\)$|\1|p' | tr '\n' ' ')"

        # sort out Wi-Fi devices from ethernet devices
        declare -a wifi_devices=()
        declare -a other_devices=()
        already_wifi_on=false
        for d in $devices; do
          if networksetup -getairportpower $d >/dev/null 2>&1; then
            wifi_devices+=( $d )
            if networksetup -getairportpower $d 2>&1 | grep On >/dev/null 2>&1; then
              already_wifi_on=true
            fi
          else
            other_devices+=( $d )
          fi
        done

        # check ethernet device status
        other_connected=false
        for d in ${other_devices[@]+${other_devices[@]}}; do
          if ifconfig $d 2>/dev/null | grep 'status: active' >/dev/null 2>&1; then
            other_connected=true
            break
          fi
        done

        # toggle Wi-Fi device
        if [ ${#wifi_devices[@]} -gt 0 ]; then
          if $other_connected; then
            if $already_wifi_on; then
              for d in ${wifi_devices[@]+${wifi_devices[@]}}; do
                networksetup -setairportpower $d off
              done
              osascript -e 'display notification "Wired network detected. Turning AirPort off." with title "Wifi Toggle" sound name "Hero"'
            fi
          else
            if ! $already_wifi_on; then
              networksetup -setairportpower ${wifi_devices[0]} on
              osascript -e 'display notification "No wired network detected. Turning AirPort on." with title "Wifi Toggle" sound name "Hero"'
            fi
          fi
        fi
      EOS
    end
    chmod "+x", "toggle.sh"
    sbin.install "toggle.sh"
  end

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/toggle.sh</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WatchPaths</key>
        <array>
          <string>/Library/Preferences/SystemConfiguration</string>
        </array>
        <key>StandardErrorPath</key>
        <string>#{var}/log/#{plist_name}.log</string>
      </dict>
    </plist>
  EOS
  end

  test do
    system "#{opt_sbin}/toggle.sh"
  end
end
