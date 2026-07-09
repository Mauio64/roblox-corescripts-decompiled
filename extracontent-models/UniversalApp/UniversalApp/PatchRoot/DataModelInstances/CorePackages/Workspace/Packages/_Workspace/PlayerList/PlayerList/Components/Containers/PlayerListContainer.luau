local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)

require(ParentParentParent.Signals)

local SignalsReact = require(ParentParentParent.SignalsReact)
local ReactFocusNavigation = require(ParentParentParent.ReactFocusNavigation)

require(ParentParentParent.LeaderboardStore)

local LeaderboardStoreContext = require(ParentParent.Common.LeaderboardStoreContext)
local LayoutValuesContext = require(ParentParent.Common.LayoutValuesContext)
local CreateLayoutValues = require(ParentParent.Common.CreateLayoutValues)
local FocusNavigationContext = ReactFocusNavigation.FocusNavigationContext
local FocusNavigationService = ReactFocusNavigation.FocusNavigationService
local FFlagAddNewPlayerListFocusNav = require(ParentParent.Flags.FFlagAddNewPlayerListFocusNav)

return React.memo(function(t1: {[any]: any}) -- line: 27
	-- upvalues: CreateLayoutValues (copy), SignalsReact (copy), FocusNavigationService (copy), ReactFocusNavigation (copy), React (copy), LeaderboardStoreContext (copy), LayoutValuesContext (copy), FFlagAddNewPlayerListFocusNav (copy), FocusNavigationContext (copy)
	local v13 = CreateLayoutValues(t1.isTenFoot or false, t1.TopBarConstants)
	local v14 = SignalsReact.useSignalState(t1.leaderboardStore)
	local v15 = FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)

	return React.createElement(LeaderboardStoreContext.Provider, {
		value = v14
	}, {
		LayoutValuesProvider = React.createElement(LayoutValuesContext.Provider, {
			value = v13
		}, if not FFlagAddNewPlayerListFocusNav then t1.children else {
			FocusNavigationProvider = React.createElement(FocusNavigationContext.Provider, {
				value = v15
			}, t1.children)
		})
	})
end)
