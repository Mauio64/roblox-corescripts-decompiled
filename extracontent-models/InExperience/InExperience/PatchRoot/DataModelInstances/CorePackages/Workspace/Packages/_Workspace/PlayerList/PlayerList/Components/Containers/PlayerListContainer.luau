local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local React = require(parent2.React)
local Signals = require(parent2.Signals)
local SignalsReact = require(parent2.SignalsReact)
local ReactFocusNavigation = require(parent2.ReactFocusNavigation)
require(parent2.LeaderboardStore)

local LocalizationService = game:GetService("LocalizationService")
local InExperienceLocales = require(parent2.InExperienceLocales)
local Localization = require(parent2.Localization)
local LocalizationProvider = Localization.LocalizationProvider

local LeaderboardStoreContext = require(parent.Common.LeaderboardStoreContext)
local LayoutValuesContext = require(parent.Common.LayoutValuesContext)
local GameTextTranslatorContext = require(parent.Common.GameTextTranslatorContext)
local PlayerListVisibilityStore = require(parent.Common.PlayerListVisibilityStore)

local CreateLayoutValues = require(parent.Common.CreateLayoutValues)
local PlatformLeaderboardContainer = require(parent.Components.Containers.PlatformLeaderboardContainer)

local FocusNavigationContext = ReactFocusNavigation.FocusNavigationContext
local FocusNavigationService = ReactFocusNavigation.FocusNavigationService

local FFlagAddNewPlayerListFocusNav = require(parent.Flags.FFlagAddNewPlayerListFocusNav)
local FFlagEnablePlayerListExposureEvents = require(parent.Flags.FFlagEnablePlayerListExposureEvents)
local FFlagPlayerListLocalizeGameText = require(parent.Flags.FFlagPlayerListLocalizeGameText)
local FFlagPlayerListReskin = require(parent.Flags.FFlagPlayerListReskin)
local FStringPlayerListIXPLayer = require(parent.Flags.FStringPlayerListIXPLayer)

local IXPService = game:GetService("IXPService")

local leaderboardViewChangeTelemetry = nil
local function getLeaderboardViewChangeTelemetry()
	if leaderboardViewChangeTelemetry == nil then
		local LeaderboardViewChangeTelemetry = require(parent.Common.LeaderboardViewChangeTelemetry)
		leaderboardViewChangeTelemetry = LeaderboardViewChangeTelemetry
	end

	return leaderboardViewChangeTelemetry
end

local function fn(props)
	local v, v2

	if FFlagPlayerListReskin then
		v = React.useMemo(function()
			return CreateLayoutValues(props.isTenFoot or false, props.TopBarConstants)
		end, { props.isTenFoot, props.TopBarConstants })
		v2 = React.useMemo(function()
			return FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
		end, {})
	else
		v = CreateLayoutValues(props.isTenFoot or false, props.TopBarConstants)
		v2 = FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
	end

	local v3 = SignalsReact.useSignalState(props.leaderboardStore)

	if FFlagEnablePlayerListExposureEvents then
		React.useEffect(function()
			IXPService:LogFlagLinkedUserLayerExposure(FStringPlayerListIXPLayer)
		end, {})
	end

	local localization

	if FFlagPlayerListLocalizeGameText then
		localization = React.useMemo(function()
			return InExperienceLocales.Localization.new(LocalizationService.RobloxLocaleId)
		end, {})
	end

	if FFlagPlayerListReskin then
		React.useEffect(function()
			local v4 = false
			return Signals.createEffect(function(p)
				local effectiveVisible = PlayerListVisibilityStore.getEffectiveVisible(p)

				if not v4 then
					v4 = true

					return
				end

				if leaderboardViewChangeTelemetry == nil then
					local LeaderboardViewChangeTelemetry = require(parent.Common.LeaderboardViewChangeTelemetry)
					leaderboardViewChangeTelemetry = LeaderboardViewChangeTelemetry
				end

				leaderboardViewChangeTelemetry.logVisibility(effectiveVisible, true)
			end)
		end, {})
	end

	local v4

	if FFlagPlayerListReskin then
		v4 = React.createElement(PlatformLeaderboardContainer, {}, props.children)
	else
		v4 = props.children
	end

	local v5 = React.createElement(LeaderboardStoreContext.Provider, { value = v3 }, {
		LayoutValuesProvider = React.createElement(
			LayoutValuesContext.Provider,
			{ value = v },
			FFlagAddNewPlayerListFocusNav and {
				FocusNavigationProvider = React.createElement(FocusNavigationContext.Provider, {
					value = v2
				}, v4)
			} or v4
		)
	})

	if FFlagPlayerListLocalizeGameText and props.translateGameText then
		v5 = React.createElement(GameTextTranslatorContext.Provider, {
			value = props.translateGameText
		}, {
			LeaderboardStoreProvider = v5
		})
	end

	if FFlagPlayerListLocalizeGameText then
		return React.createElement(LocalizationProvider, { localization = localization }, {
			LeaderboardTree = v5
		})
	end

	return v5
end

return React.memo(fn)
