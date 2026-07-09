local Parent = script:FindFirstAncestor("RobloxAppNavigationCore").Parent
local React = require(Parent.React)
local useUiModeInfo = require(Parent.RobloxAppHooks).useUiModeInfo
local UiMode = require(Parent.RobloxAppEnums).UiMode
local TenFootUiStackView = require(Parent.TenFootUiShell).Views.TenFootUiStackView

require(Parent.Navigation)

local AppStackView = require(script.Parent.AppStackView)
local FFlagEnableLeftNavOnConsole = require(Parent.SharedFlags).FFlagEnableLeftNavOnConsole

local function AdaptiveStackView(p1) -- line: 15
	-- upvalues: useUiModeInfo (copy), FFlagEnableLeftNavOnConsole (copy), UiMode (copy), React (copy), TenFootUiStackView (copy), AppStackView (copy)
	local v10 = useUiModeInfo()

	if not FFlagEnableLeftNavOnConsole and v10.uiMode == UiMode.TenFoot then
		return React.createElement(TenFootUiStackView, p1)
	end

	return React.createElement(AppStackView, p1)
end

return AdaptiveStackView
