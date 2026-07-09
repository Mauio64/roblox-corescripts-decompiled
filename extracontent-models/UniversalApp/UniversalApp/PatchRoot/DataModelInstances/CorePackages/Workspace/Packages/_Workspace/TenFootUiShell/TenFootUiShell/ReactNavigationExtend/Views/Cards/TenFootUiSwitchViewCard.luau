local TenFootUiShell = script:FindFirstAncestor("TenFootUiShell")
local TenFootUiShellParent = TenFootUiShell.Parent
local React = require(TenFootUiShellParent.React)
local ReactNavigationExtend = TenFootUiShell.ReactNavigationExtend
local useTabAnimation = require(ReactNavigationExtend.Hooks.useTabAnimation)
local TenFootUiBaseViewCard = require(ReactNavigationExtend.Views.Cards.TenFootUiBaseViewCard)

require(TenFootUiShellParent.TenFootUiCommon)
require(TenFootUiShellParent.Navigation)

local function TenFootUiSwitchViewCard(t1: {[any]: any}) -- line: 24
	-- upvalues: useTabAnimation (copy), React (copy), TenFootUiBaseViewCard (copy)
	local v9 = useTabAnimation({
		isActiveTab = t1.isActiveTab,
		currentTabIndex = t1.currentTabIndex,
		previousTabIndex = t1.previousTabIndex
	})

	return React.createElement(TenFootUiBaseViewCard, {
		descriptor = t1.descriptor,
		screenProps = t1.screenProps,
		navigation = t1.navigation,
		isActiveCard = t1.isActiveTab,
		isVisible = v9.isVisible,
		adorneeCFrame = v9.cFrame,
		groupTransparency = v9.transparency
	})
end

return TenFootUiSwitchViewCard
