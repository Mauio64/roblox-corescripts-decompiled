local SduiSharedContent = script:FindFirstAncestor("SduiSharedContent")
local SduiSharedContentParent = SduiSharedContent.Parent
local Cryo = require(SduiSharedContentParent.Cryo)
local React = require(SduiSharedContentParent.React)
local PlayButton = require(SduiSharedContentParent.GamePlayButton).PlayButton
local SduiCoreSystem = require(SduiSharedContentParent.SduiCoreSystem)
local executeAction = SduiCoreSystem.executeAction
local findAnalyticsField = SduiCoreSystem.findAnalyticsField
local SduiActionType = SduiCoreSystem.SduiActionType
local getSduiActionHandlerRegistry = SduiCoreSystem.getSduiActionHandlerRegistry
local useSduiReportExperienceLaunched = require(SduiSharedContent.Components.useSduiReportExperienceLaunched)
local getSduiFocusActivationStore = require(SduiSharedContentParent.SduiSharedUtilities).getSduiFocusActivationStore
local FFlagSduiExperienceDetailsSupport = require(SduiSharedContentParent.SharedFlags).FFlagSduiExperienceDetailsSupport
local FFlagLuaAppResetHoverOnSduiPlayButtonActivation = require(SduiSharedContentParent.SharedFlags).FFlagLuaAppResetHoverOnSduiPlayButtonActivation
local FFlagLuaAppLaunchWhenLoadingEdp = require(SduiSharedContentParent.SharedFlags).FFlagLuaAppLaunchWhenLoadingEdp
local FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp = require(SduiSharedContentParent.SharedFlags).FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp
local FFlagLuaAppDemoModePlayButton = require(SduiSharedContentParent.SharedFlags).FFlagLuaAppDemoModePlayButton

local function SduiPlayButton(t1: {[any]: any}) -- line: 89
	-- upvalues: React (copy), getSduiActionHandlerRegistry (copy), SduiActionType (copy), findAnalyticsField (copy), FFlagSduiExperienceDetailsSupport (copy), useSduiReportExperienceLaunched (copy), FFlagLuaAppResetHoverOnSduiPlayButtonActivation (copy), executeAction (copy), getSduiFocusActivationStore (copy), PlayButton (copy), Cryo (copy), FFlagLuaAppDemoModePlayButton (copy), FFlagLuaAppLaunchWhenLoadingEdp (copy), FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp (copy)
	local analyticsContext = t1.analyticsContext
	local v21 = React.useCallback(function() -- line: 92
		-- upvalues: getSduiActionHandlerRegistry (copy), SduiActionType (copy), t1 (copy)
		local v36 = getSduiActionHandlerRegistry().getActionHandlerConfig(SduiActionType.OpenGameDetails)

		if v36 and v36.handler then
			v36.handler(nil, t1.analyticsContext, t1.sduiContext)
		end
	end, {
		t1.sduiContext,
		t1.analyticsContext
	})
	local v22 = t1.placeId or t1.rootPlaceId
	local v23 = t1.rootPlaceId or v22
	local universeId = t1.universeId
	local v25 = findAnalyticsField("eventContext", analyticsContext.analyticsData, "ExperienceTile")
	local v26 = findAnalyticsField("referralSource", analyticsContext.analyticsData)
	local v27 = if not FFlagSduiExperienceDetailsSupport or not t1.experienceJoinData then nil else t1.experienceJoinData.launchData
	local v28 = useSduiReportExperienceLaunched(t1.sduiContext, t1.analyticsContext, universeId, v22, v23, t1.appliedFilters, if not FFlagSduiExperienceDetailsSupport then nil else v27)
	local v29 = React.useCallback(function() -- line: 121
		-- upvalues: FFlagLuaAppResetHoverOnSduiPlayButtonActivation (copy), t1 (copy), SduiActionType (copy), executeAction (copy), analyticsContext (copy)
		if FFlagLuaAppResetHoverOnSduiPlayButtonActivation and t1.onActivatedEffect then
			t1.onActivatedEffect()
		end

		local t2 = {
			actionType = SduiActionType.PlayButtonClick
		}

		executeAction(t2, analyticsContext, t1.sduiContext)
	end, {
		analyticsContext,
		t1.sduiContext,
		if not FFlagLuaAppResetHoverOnSduiPlayButtonActivation then nil else t1.onActivatedEffect
	})
	local v30 = nil

	if FFlagSduiExperienceDetailsSupport then
		v30 = React.useCallback(function(p1: ((...any) -> ...any)) -- line: 144
			-- upvalues: t1 (copy), getSduiFocusActivationStore (copy)
			local tag = t1.tag

			if tag == nil then
				return function() -- line: 147
				end
			end

			return getSduiFocusActivationStore().register(tag, p1)
		end, { t1.tag })
	end

	local anchorPoint = t1.anchorPoint
	local layoutOrder = t1.layoutOrder
	local position = t1.position
	local v34 = if not FFlagSduiExperienceDetailsSupport then nil else findAnalyticsField("launchSource", analyticsContext.analyticsData)
	local v35 = t1.fetchDelayInSeconds or 0.1

	return React.createElement(PlayButton, Cryo.Dictionary.join(t1, {
		AnchorPoint = anchorPoint,
		LayoutOrder = layoutOrder,
		Position = position,
		tag = if not FFlagSduiExperienceDetailsSupport then nil else t1.tag,
		expandWidthForSecondaryPlayButton = if not FFlagLuaAppDemoModePlayButton then nil else t1.expandWidthForSecondaryPlayButton,
		preferSecondaryPlayButton = if not FFlagLuaAppDemoModePlayButton then nil else t1.preferSecondaryPlayButton,
		onRegisterActivation = if not FFlagSduiExperienceDetailsSupport then nil else v30,
		fetchDelayInSeconds = v35,
		universeId = t1.universeId,
		placeId = t1.placeId,
		useUIBloxButton = if not FFlagSduiExperienceDetailsSupport then nil else t1.enableUiBloxButton,
		reportExperienceLaunched = v28,
		onPurchaseRequiredCallback = if not t1.openGameDetailsOnPurchaseRequired then nil else v21,
		onActivated = v29,
		referralSource = v26,
		eventContext = v25,
		launchSource = if not FFlagSduiExperienceDetailsSupport then nil else v34,
		launchWhenLoading = if not FFlagLuaAppLaunchWhenLoadingEdp then nil else t1.launchWhenLoading,
		launchOnReleaseAfterUnmount = if not FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp then nil else t1.launchOnReleaseAfterUnmount
	}))
end

return React.memo(SduiPlayButton)
