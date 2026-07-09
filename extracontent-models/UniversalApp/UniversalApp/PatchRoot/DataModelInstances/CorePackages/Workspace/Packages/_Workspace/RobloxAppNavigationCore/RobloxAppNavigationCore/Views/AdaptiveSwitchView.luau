local Parent = script:FindFirstAncestor("RobloxAppNavigationCore").Parent
local React = require(Parent.React)
local useUiModeInfo = require(Parent.RobloxAppHooks).useUiModeInfo
local UiMode = require(Parent.RobloxAppEnums).UiMode
local TenFootUiSwitchView = require(Parent.TenFootUiShell).Views.TenFootUiSwitchView

require(Parent.Navigation)

local AppSwitchView = require(script.Parent.AppSwitchView)
local FFlagEnableLeftNavOnConsole = require(Parent.SharedFlags).FFlagEnableLeftNavOnConsole

local function AdaptiveSwitchView(p1) -- line: 15
	-- upvalues: useUiModeInfo (copy), FFlagEnableLeftNavOnConsole (copy), UiMode (copy), React (copy), TenFootUiSwitchView (copy), AppSwitchView (copy)
	local v10 = useUiModeInfo()

	if not FFlagEnableLeftNavOnConsole and v10.uiMode == UiMode.TenFoot then
		return React.createElement(TenFootUiSwitchView, p1)
	end

	return React.createElement(AppSwitchView, p1)
end

return AdaptiveSwitchView
