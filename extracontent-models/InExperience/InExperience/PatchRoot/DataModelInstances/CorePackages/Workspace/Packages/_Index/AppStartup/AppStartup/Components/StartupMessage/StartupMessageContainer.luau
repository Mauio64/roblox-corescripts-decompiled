local CoreGui = game:GetService("CoreGui")
local parent = script:FindFirstAncestor("AppStartup").Parent
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local useStartupMessageProps = require(script.Parent.useStartupMessageProps)
local StartupMessage = require(script.Parent.StartupMessage)

local function StartupMessageContainer()
	local v = useStartupMessageProps()

	return ReactRoblox.createPortal({ React.createElement("ScreenGui", {
			Enabled = true,
			IgnoreGuiInset = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			AutoLocalize = false,
			DisplayOrder = 100
		}, {
			StartupMessage = v.displayStartupMessage and React.createElement(StartupMessage, v)
		}) }, CoreGui)
end

return React.memo(StartupMessageContainer)
