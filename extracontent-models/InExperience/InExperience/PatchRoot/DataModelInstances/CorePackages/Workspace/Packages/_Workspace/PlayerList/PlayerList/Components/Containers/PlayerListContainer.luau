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
local FFlagPlayerListReskinOptimization = require(ParentParent.Flags.FFlagPlayerListReskinOptimization)
local FFlagPlayerListTwoTabs = require(ParentParent.Flags.FFlagPlayerListTwoTabs)
local FStringPlayerListIXPLayer = require(ParentParent.Flags.FStringPlayerListIXPLayer)
local IXPService = game:GetService("IXPService")

return React.memo(function(t1: {[any]: any}) -- line: 37
	-- upvalues: FFlagPlayerListReskinOptimization (copy), React (copy), CreateLayoutValues (copy), FocusNavigationService (copy), ReactFocusNavigation (copy), SignalsReact (copy), FFlagEnablePlayerListExposureEvents (copy), IXPService (copy), FStringPlayerListIXPLayer (copy), FFlagPlayerListTwoTabs (copy), PlatformLeaderboardContainer (copy), LeaderboardStoreContext (copy), LayoutValuesContext (copy), FFlagAddNewPlayerListFocusNav (copy), FocusNavigationContext (copy), FFlagPlayerListLocalizeGameText (copy), GameTextTranslatorContext (copy)
	local v21, v22

	if FFlagPlayerListReskinOptimization then
		v21 = React.useMemo(function() -- line: 41
			-- upvalues: CreateLayoutValues (copy), t1 (copy)
			return CreateLayoutValues(t1.isTenFoot or false, t1.TopBarConstants)
		end, {
			t1.isTenFoot,
			t1.TopBarConstants
		})
		v22 = React.useMemo(function() -- line: 44
			-- upvalues: FocusNavigationService (copy), ReactFocusNavigation (copy)
			return FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
		end, {})
	else
		v21 = CreateLayoutValues(t1.isTenFoot or false, t1.TopBarConstants)
		v22 = FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
	end

	local v23 = SignalsReact.useSignalState(t1.leaderboardStore)

	if FFlagEnablePlayerListExposureEvents then
		React.useEffect(function() -- line: 54
			-- upvalues: IXPService (copy), FStringPlayerListIXPLayer (copy)
			IXPService:LogFlagLinkedUserLayerExposure(FStringPlayerListIXPLayer)
		end, {})
	end

	local v24 = if not FFlagPlayerListTwoTabs then t1.children else React.createElement(PlatformLeaderboardContainer, {}, t1.children)
	local v25 = React.createElement(LeaderboardStoreContext.Provider, {
		value = v23
	}, {
		LayoutValuesProvider = React.createElement(LayoutValuesContext.Provider, {
			value = v21
		}, if not FFlagAddNewPlayerListFocusNav then v24 else {
			FocusNavigationProvider = React.createElement(FocusNavigationContext.Provider, {
				value = v22
			}, v24)
		})
	})

	if FFlagPlayerListLocalizeGameText and t1.translateGameText then
		return React.createElement(GameTextTranslatorContext.Provider, {
			value = t1.translateGameText
		}, {
			LeaderboardStoreProvider = v25
		})
	end

	return v25
end)
