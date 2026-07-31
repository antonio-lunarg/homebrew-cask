cask "vulkan-sdk" do
  version "1.4.357.0"
  sha256 "539433589c83522e6f31b1c7b418a4167e21597a4a361ab119e1dc0760cf3865"

  url "https://sdk.lunarg.com/sdk/download/#{version}/mac/vulkansdk-macos-#{version}.zip"
  name "Vulkan SDK"
  desc "Enables developing Vulkan applications"
  homepage "https://vulkan.lunarg.com/sdk/home"

  livecheck do
    url "https://vulkan.lunarg.com/sdk/latest/mac.json"
    strategy :json do |json|
      json["mac"]
    end
  end

  depends_on :macos
  depends_on formula: "python3"

  installer script: {
    executable: "vulkansdk-macOS-#{version}.app/Contents/MacOS/vulkansdk-macOS-#{version}",
    args:       [
      "--root", "#{staged_path}/#{token}", "--accept-licenses", "--default-answer",
      "--confirm-command", "install", "com.lunarg.vulkan.kosmic"
    ],
  }

  installer script: {
    executable: "#{HOMEBREW_PREFIX}/bin/python3",
    args:       [
      "#{staged_path}/#{token}/install_vulkan.py",
      "--install-json-location",
      "#{staged_path}/#{token}",
    ],
    sudo:       true,
  }

  uninstall script: {
    executable: "#{staged_path}/#{token}/uninstall.sh",
    sudo:       true,
  }
  uninstall delete: "#{staged_path}/#{token}"

  caveats do
    license "https://vulkan.lunarg.com/license/"
  end
end
