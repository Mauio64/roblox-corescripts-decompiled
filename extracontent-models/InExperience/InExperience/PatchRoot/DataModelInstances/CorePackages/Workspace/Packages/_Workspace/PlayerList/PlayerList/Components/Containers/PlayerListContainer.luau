local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)

require(ParentParentParent.Signals)

local SignalsReact = require(ParentParentParent.SignalsReact)
local ReactFocusNavigation = require(ParentParentParent.ReactFocusNavigation)

require(ParentParentParent.LeaderboardStore)

local LeaderboardStoreContext = require(ParentParent.Common.LeaderboardStoreContext)
local LayoutValuesContext = require(ParentParent.Common.LayoutValuesContext)
local GameTextTranslatorContext = require(ParentParent.Common.GameTextTranslatorContext)
local CreateLayoutValues = require(ParentParent.Common.CreateLayoutValues)
local PlatformLeaderboardContainer = require(ParentParent.Components.Containers.PlatformLeaderboardContainer)
local FocusNavigationContext = ReactFocusNavigation.FocusNavigationContext
local FocusNavigationService = ReactFocusNavigation.FocusNavigationService
local FFlagAddNewPlayerListFocusNav = require(ParentParent.Flags.FFlagAddNewPlayerListFocusNav)
local FFlagEnablePlayerListExposureEvents = require(ParentParent.Flags.FFlagEnablePlayerListExposureEvents)
local FFlagPlayerListLocalizeGameText = require(ParentParent.Flags.FFlagPlayerListLocalizeGameText)
local FFlagPlayerListTwoTabs = require(ParentParent.Flags.FFlagPlayerListTwoTabs)
local FStringPlayerListIXPLayer = require(ParentParent.Flags.FStringPlayerListIXPLayer)
local IXPService = game:GetService("IXPService")

return React.memo(function(t1: {[any]: any}) -- line: 36
	-- upvalues: CreateLayoutValues (copy), SignalsReact (copy), FocusNavigationService (copy), ReactFocusNavigation (copy), FFlagEnablePlayerListExposureEvents (copy), React (copy), IXPService (copy), FStringPlayerListIXPLayer (copy), FFlagPlayerListTwoTabs (copy), PlatformLeaderboardContainer (copy), LeaderboardStoreContext (copy), LayoutValuesContext (copy), FFlagAddNewPlayerListFocusNav (copy), FocusNavigationContext (copy), FFlagPlayerListLocalizeGameText (copy), GameTextTranslatorContext (copy)
	local v20 = CreateLayoutValues(t1.isTenFoot or false, t1.TopBarConstants)
	local v21 = SignalsReact.useSignalState(t1.leaderboardStore)
	local v22 = FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)

	if FFlagEnablePlayerListExposureEvents then
		React.useEffect(function() -- line: 42
			-- upvalues: IXPService (copy), FStringPlayerListIXPLayer (copy)
			IXPService:LogFlagLinkedUserLayerExposure(FStringPlayerListIXPLayer)
		end, {})
	end

	local v23 = if not FFlagPlayerListTwoTabs then t1.children else React.createElement(PlatformLeaderboardContainer, {}, t1.children)
	local v24 = React.createElement(LeaderboardStoreContext.Provider, {
		value = v21
	}, {
		LayoutValuesProvider = React.createElement(LayoutValuesContext.Provider, {
			value = v20
		}, if not FFlagAddNewPlayerListFocusNav then v23 else {
			FocusNavigationProvider = React.createElement(FocusNavigationContext.Provider, {
				value = v22
			}, v23)
		})
	})

	if FFlagPlayerListLocalizeGameText and t1.translateGameText then
		return React.createElement(GameTextTranslatorContext.Provider, {
			value = t1.translateGameText
		}, {
			LeaderboardStoreProvider = v24
		})
	end

	return v24
end)
