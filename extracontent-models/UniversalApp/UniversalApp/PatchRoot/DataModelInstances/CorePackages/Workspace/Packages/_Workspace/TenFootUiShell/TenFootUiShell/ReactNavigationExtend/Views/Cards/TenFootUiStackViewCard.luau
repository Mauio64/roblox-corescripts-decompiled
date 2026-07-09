local TenFootUiShell = script:FindFirstAncestor("TenFootUiShell")
local TenFootUiShellParent = TenFootUiShell.Parent
local ReactNavigationExtend = TenFootUiShell.ReactNavigationExtend
local React = require(TenFootUiShellParent.React)
local useStackAnimation = require(ReactNavigationExtend.Hooks.useStackAnimation)
local TenFootUiBaseViewCard = require(ReactNavigationExtend.Views.Cards.TenFootUiBaseViewCard)

require(TenFootUiShellParent.TenFootUiCommon)
require(TenFootUiShellParent.Navigation)

local function TenFootUiStackViewCard(t1: {[any]: any}) -- line: 26
	-- upvalues: useStackAnimation (copy), React (copy), TenFootUiBaseViewCard (copy)
	local v9 = useStackAnimation({
		isTopOfStack = t1.isTopOfStack,
		totalInStack = t1.totalInStack,
		viewState = t1.viewState,
		onAnimationComplete = t1.onAnimationComplete
	})

	return React.createElement(TenFootUiBaseViewCard, {
		descriptor = t1.descriptor,
		screenProps = t1.screenProps,
		navigation = t1.navigation,
		isActiveCard = t1.isTopOfStack,
		isVisible = v9.isVisible,
		adorneeCFrame = v9.cFrame,
		groupTransparency = v9.transparency
	})
end

return TenFootUiStackViewCard
