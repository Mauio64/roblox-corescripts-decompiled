local TenFootUiShell = script:FindFirstAncestor("TenFootUiShell")
local TenFootUiShellParent = TenFootUiShell.Parent
local ReactNavigationExtend = TenFootUiShell.ReactNavigationExtend
local React = require(TenFootUiShellParent.React)
local Navigation = require(TenFootUiShellParent.Navigation)
local useStackScreens = Navigation.useStackScreens
local ViewState = Navigation.ViewState
local TenFootUiStackViewCard = require(ReactNavigationExtend.Views.Cards.TenFootUiStackViewCard)

require(TenFootUiShellParent.TenFootUiCommon)

local function TenFootUiStackView(t1: {[any]: any}) -- line: 26
	-- upvalues: useStackScreens (copy), React (copy), TenFootUiStackViewCard (copy), ViewState (copy)
	local descriptors = t1.descriptors
	local navigation = t1.navigation
	local state = navigation.state
	local key = state.routes[state.index].key
	local t2 = {}

	for _, v17 in (useStackScreens({
		navigation = navigation,
		descriptors = descriptors
	})) do
		t2[v17.descriptor.key] = React.createElement(TenFootUiStackViewCard, {
			descriptor = v17.descriptor,
			screenProps = t1.screenProps,
			navigation = navigation,
			isTopOfStack = key == v17.descriptor.key,
			totalInStack = state.index,
			viewState = v17.viewState,
			onAnimationComplete = function() -- line: 48
				-- upvalues: v17 (copy), ViewState (copy)
				if v17.viewState == ViewState.Opening or v17.viewState == ViewState.Opened then
					v17.setOpened()

					return
				end

				if v17.viewState == ViewState.Closing then
					v17.setClosed()
				end
			end
		})
	end

	return t2
end

return TenFootUiStackView
