local SduiSharedContent = script:FindFirstAncestor("SduiSharedContent")
local parent = SduiSharedContent.Parent
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local GamePlayButton = require(parent.GamePlayButton)
local PlayButton = GamePlayButton.PlayButton

local SduiCoreSystem = require(parent.SduiCoreSystem)
local executeAction = SduiCoreSystem.executeAction
local findAnalyticsField = SduiCoreSystem.findAnalyticsField
local SduiActionType = SduiCoreSystem.SduiActionType
local getSduiActionHandlerRegistry = SduiCoreSystem.getSduiActionHandlerRegistry

local useSduiReportExperienceLaunched = require(SduiSharedContent.Components.useSduiReportExperienceLaunched)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local getSduiFocusActivationStore = SduiSharedUtilities.getSduiFocusActivationStore
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppLaunchWhenLoadingEdp = SharedFlags.FFlagLuaAppLaunchWhenLoadingEdp
local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnableGameJoinEarlyAccess = SharedFlags2.FFlagEnableGameJoinEarlyAccess

local function SduiPlayButton(props)
	local analyticsContext = props.analyticsContext

	local onPurchaseRequiredCallback = React.useCallback(function()
		local actionHandlerConfig = getSduiActionHandlerRegistry().getActionHandlerConfig(SduiActionType.OpenGameDetails)

		if actionHandlerConfig and actionHandlerConfig.handler then
			actionHandlerConfig.handler(nil, props.analyticsContext, props.sduiContext)
		end
	end, { props.sduiContext, props.analyticsContext })

	local placeId = props.placeId or props.rootPlaceId
	local rootPlaceId = props.rootPlaceId or placeId
	local universeId = props.universeId
	local analyticsField = findAnalyticsField("eventContext", analyticsContext.analyticsData, "ExperienceTile")
	local analyticsField2 = findAnalyticsField("referralSource", analyticsContext.analyticsData)
	local v

	if props.experienceJoinData then
		v = props.experienceJoinData.launchData
	end

	local reportExperienceLaunched = useSduiReportExperienceLaunched(
		props.sduiContext,
		props.analyticsContext,
		universeId,
		placeId,
		rootPlaceId,
		props.appliedFilters,
		v
	)

	local onActivated = React.useCallback(function()
		if props.onActivatedEffect then
			props.onActivatedEffect()
		end

		executeAction({ actionType = SduiActionType.PlayButtonClick }, analyticsContext, props.sduiContext)
	end, { analyticsContext, props.sduiContext, props.onActivatedEffect })

	local onRegisterActivation = React.useCallback(function(callback)
		local tag = props.tag

		if tag == nil then
			return function() end
		end

		return getSduiFocusActivationStore().register(tag, callback)
	end, { props.tag })

	local anchorPoint = props.anchorPoint
	local layoutOrder = props.layoutOrder
	local position = props.position

	local analyticsField3 = findAnalyticsField("launchSource", analyticsContext.analyticsData)

	local fetchDelayInSeconds = props.fetchDelayInSeconds or 0.1

	local v2 = FFlagEnableGameJoinEarlyAccess
		and (props.sduiContext.appPage == AppPage.ExperienceDetail or props.sduiContext.appPage == AppPage.GameDetail)

	local createElement = React.createElement

	local join = Cryo.Dictionary.join
	local v3 = {
		AnchorPoint = anchorPoint,
		LayoutOrder = layoutOrder,
		Position = position,
		tag = props.tag,
		expandWidthForSecondaryPlayButton = props.expandWidthForSecondaryPlayButton,
		preferSecondaryPlayButton = props.preferSecondaryPlayButton,
		onRegisterActivation = onRegisterActivation,
		fetchDelayInSeconds = fetchDelayInSeconds,
		universeId = props.universeId,
		placeId = props.placeId,
		useUIBloxButton = props.enableUiBloxButton,
		reportExperienceLaunched = reportExperienceLaunched,
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
		onPurchaseRequiredCallback = nil
	end

	v3.onPurchaseRequiredCallback = onPurchaseRequiredCallback
	v3.onActivated = onActivated
	v3.referralSource = analyticsField2
	v3.eventContext = analyticsField
	v3.launchSource = analyticsField3
	local launchWhenLoading

	if FFlagLuaAppLaunchWhenLoadingEdp then
		launchWhenLoading = props.launchWhenLoading
	end

	v3.launchWhenLoading = launchWhenLoading
	v3.launchOnReleaseAfterUnmount = props.launchOnReleaseAfterUnmount
	v3.enableEarlyAccessPlusTooltip = FFlagEnableGameJoinEarlyAccess and v2 and true or nil
	local enableEarlyAccessState

	if FFlagEnableGameJoinEarlyAccess and props.enableEarlyAccessState ~= nil then
		enableEarlyAccessState = props.enableEarlyAccessState
	else
		enableEarlyAccessState = FFlagEnableGameJoinEarlyAccess and v2 and true or nil
	end

	v3.enableEarlyAccessState = enableEarlyAccessState
	return createElement(PlayButton, join(props, v3))
end

return React.memo(SduiPlayButton)
