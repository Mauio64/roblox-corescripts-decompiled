local CoreGui = game:GetService("CoreGui")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/ReactRoblox")
local useStartupMessageProps = require("@game/CorePackages/Workspace/Packages/_Index/AppStartup/AppStartup/Components/StartupMessage/useStartupMessageProps")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/AppStartup/AppStartup/Components/StartupMessage/StartupMessage")

local function StartupMessageContainer()
	local v5 = useStartupMessageProps()

	return ReactRoblox.createPortal({ React.createElement("ScreenGui", {
			Enabled = true,
			IgnoreGuiInset = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			AutoLocalize = false,
			DisplayOrder = 100
		}, {
			StartupMessage = v5.displayStartupMessage and React.createElement(module4, v5)
		}) }, CoreGui)
end

return React.memo(StartupMessageContainer)
