local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local playButton = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/GamePlayButton").PlayButton

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem")
local executeAction = SduiCoreSystem.executeAction
local findAnalyticsField = SduiCoreSystem.findAnalyticsField
local sduiActionType = SduiCoreSystem.SduiActionType
local getSduiActionHandlerRegistry = SduiCoreSystem.getSduiActionHandlerRegistry

local useSduiReportExperienceLaunched = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/useSduiReportExperienceLaunched")
local getSduiFocusActivationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedUtilities").getSduiFocusActivationStore
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/RobloxAppEnums").AppPage
local fFlagLuaAppLaunchWhenLoadingEdp = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagLuaAppLaunchWhenLoadingEdp
local fFlagEnableGameJoinEarlyAccess = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagEnableGameJoinEarlyAccess

local function SduiPlayButton(props)
	local analyticsContext = props.analyticsContext

	local v5 = React.useCallback(function()
		local actionHandlerConfig = getSduiActionHandlerRegistry().getActionHandlerConfig(sduiActionType.OpenGameDetails)

		if actionHandlerConfig and actionHandlerConfig.handler then
			actionHandlerConfig.handler(nil, props.analyticsContext, props.sduiContext)
		end
	end, { props.sduiContext, props.analyticsContext })

	local placeId = props.placeId or props.rootPlaceId
	local rootPlaceId = props.rootPlaceId or placeId
	local universeId = props.universeId
	local analyticsField = findAnalyticsField(
		"eventContext",
		analyticsContext.analyticsData,
		"ExperienceTile"
	)
	local analyticsField2 = findAnalyticsField("referralSource", analyticsContext.analyticsData)

	local v6 = if props.experienceJoinData then props.experienceJoinData.launchData else nil
	local v7 = useSduiReportExperienceLaunched(
		props.sduiContext,
		props.analyticsContext,
		universeId,
		placeId,
		rootPlaceId,
		props.appliedFilters,
		v6
	)

	local v8 = React.useCallback(function()
		if props.onActivatedEffect then
			props.onActivatedEffect()
		end

		executeAction({ actionType = sduiActionType.PlayButtonClick }, analyticsContext, props.sduiContext)
	end, { analyticsContext, props.sduiContext, props.onActivatedEffect })

	local v9 = React.useCallback(function(p2)
		local tag = props.tag

		if tag == nil then
			return function() end
		end

		return getSduiFocusActivationStore().register(tag, p2)
	end, { props.tag })

	local anchorPoint = props.anchorPoint
	local layoutOrder = props.layoutOrder
	local position = props.position

	local analyticsField3 = findAnalyticsField("launchSource", analyticsContext.analyticsData)

	local fetchDelayInSeconds = props.fetchDelayInSeconds or 0.1

	local v10 = fFlagEnableGameJoinEarlyAccess
		and (props.sduiContext.appPage == appPage.ExperienceDetail or props.sduiContext.appPage == appPage.GameDetail)

	local createElement = React.createElement

	local join = Cryo.Dictionary.join
	local v12 = {
		AnchorPoint = anchorPoint,
		LayoutOrder = layoutOrder,
		Position = position,
		tag = props.tag,
		expandWidthForSecondaryPlayButton = props.expandWidthForSecondaryPlayButton,
		preferSecondaryPlayButton = props.preferSecondaryPlayButton,
		onRegisterActivation = v9,
		fetchDelayInSeconds = fetchDelayInSeconds,
		universeId = props.universeId,
		placeId = props.placeId,
		useUIBloxButton = props.enableUiBloxButton,
		reportExperienceLaunched = v7,
		onPurchaseRequiredCallback = 0,
		onActivated = 0,
		referralSource = 0,
		eventContext = 0,
		launchSource = 0,
		launchWhenLoading = 0,
		launchOnReleaseAfterUnmount = 0,
		enableEarlyAccessPlusTooltip = 0,
		enableEarlyAccessState = 0
	}

	if not props.openGameDetailsOnPurchaseRequired then
		v5 = nil
	end

	v12.onPurchaseRequiredCallback = v5
	v12.onActivated = v8
	v12.referralSource = analyticsField2
	v12.eventContext = analyticsField
	v12.launchSource = analyticsField3
	local v13 = if fFlagLuaAppLaunchWhenLoadingEdp then props.launchWhenLoading else nil
	v12.launchWhenLoading = v13
	v12.launchOnReleaseAfterUnmount = props.launchOnReleaseAfterUnmount
	v12.enableEarlyAccessPlusTooltip = fFlagEnableGameJoinEarlyAccess and v10 and true or nil

	local v14 = if fFlagEnableGameJoinEarlyAccess and props.enableEarlyAccessState ~= nil then props.enableEarlyAccessState else fFlagEnableGameJoinEarlyAccess and v10 and true or nil
	v12.enableEarlyAccessState = v14
	return createElement(playButton, join(props, v12))
end

return React.memo(SduiPlayButton)
