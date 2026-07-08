local CoreGui = game:GetService("CoreGui")
local Parent = script:FindFirstAncestor("AppStartup").Parent
local React = require(Parent.React)
local ReactRoblox = require(Parent.ReactRoblox)
local useStartupMessageProps = require(script.Parent.useStartupMessageProps)
local StartupMessage = require(script.Parent.StartupMessage)

local function StartupMessageContainer() -- line: 9
	-- upvalues: useStartupMessageProps (copy), ReactRoblox (copy), React (copy), StartupMessage (copy), CoreGui (copy)
	local v8 = useStartupMessageProps()

	return ReactRoblox.createPortal({ React.createElement("ScreenGui", {
		Enabled = true,
		IgnoreGuiInset = true,
		AutoLocalize = false,
		DisplayOrder = 100,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
		StartupMessage = v8.displayStartupMessage and React.createElement(StartupMessage, v8)
	}) }, CoreGui)
end

return React.memo(StartupMessageContainer)
