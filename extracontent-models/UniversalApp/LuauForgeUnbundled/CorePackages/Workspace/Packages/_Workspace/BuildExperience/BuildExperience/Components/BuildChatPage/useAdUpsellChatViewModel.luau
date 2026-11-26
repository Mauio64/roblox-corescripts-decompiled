local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")

local adCampaignEligibilityUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/adCampaignEligibilityUtils")
local adCampaignScheduleUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/adCampaignScheduleUtils")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local GetAdUpsellEventStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetAdUpsellEventStore")
local sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")
local useCreateAdCampaign = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/useCreateAdCampaign")
local useGetAdCampaignEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/useGetAdCampaignEligibility")
local useGetAdCampaigns = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/useGetAdCampaigns")
local adUpsellPublishUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildChatPage/adUpsellPublishUtils")
local FFlagEnablePaidAds = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagEnablePaidAds")
local FFlagBuildAdUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAdUpsell")
local FFlagBuildAdUpsellPinned = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAdUpsellPinned")
local fFlagBuildAdsNotificationRouting = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags").FFlagBuildAdsNotificationRouting
local useAdsCampaignDeepLink = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/useAdsCampaignDeepLink")

local engineFeature = game:GetEngineFeature("BuildAppStorageKey")

local v5 = if engineFeature then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Storage/BuildAppStorage") else nil

local function useAdUpsellChatViewModel(data)
	local v6 = GetAdUpsellEventStore(false)
	local v7 = SignalsReact.useSignalState(v6.getRevision)
	local ref = React.useRef(nil)

	local v8, v9 = useGetAdCampaignEligibility(data.universeId, data.eligibilityStore)
	local freeCreditsRemaining = adCampaignEligibilityUtils.freeCreditsRemaining(v8)

	local v10 = adCampaignEligibilityUtils.isEligibleForFreePromotion(v8)
		and adCampaignEligibilityUtils.hasFreeCredit(v8)
		and adCampaignEligibilityUtils.hasUsableOffer(v8)
	local v11 = useCreateAdCampaign(data.universeId, data.sessionId)
	local isCreatePending = v11.isCreatePending
	local state, setState = React.useState(false)

	local state2, setState2 = React.useState(nil)
	local state3, setState3 = React.useState(false)

	local ref2 = React.useRef(nil)

	local state4, setState4 = React.useState(false)
	local ref3 = React.useRef(nil)

	local ref4 = if FFlagEnablePaidAds then React.useRef(nil) else nil

	local v12, v13 = useGetAdCampaigns()

	local v14 = React.useMemo(function()
		if data.nowMs == nil then
			return DateTime.now().UnixTimestampMillis
		end

		return data.nowMs
	end, { data.nowMs or 0, v12 or false })

	local v15 = v13 == "Ready" and adCampaignScheduleUtils.hasActiveCampaign(v12, data.universeId, v14)

	local v16 = React.useCallback(function(p2)
		setState3(false)

		if not FFlagEnablePaidAds then
			v11.clearCreateError()
		end

		setState2(function(p3)
			if FFlagEnablePaidAds and v11.hasCreateError and p3 ~= nil then
				return p3
			end

			return adCampaignEligibilityUtils.campaignSheetTerms(p2, DateTime.now().UnixTimestampMillis)
		end)

		setState(true)
	end, { v11.clearCreateError, v11.hasCreateError })
	local v17

	if FFlagBuildAdUpsell then
		local v19 = {
			universeId = data.universeId,
			sessionId = data.sessionId,
			isPageVisible = data.isPageVisible,
			eligibilityStore = data.eligibilityStore,
			canPresent = 0,
			onOpen = 0
		}
		local v20 = if fFlagBuildAdsNotificationRouting then not (isCreatePending or state4) else nil
		v19.canPresent = v20

		function v19.onOpen(p2): boolean
			if state or isCreatePending or state4 then
				return false
			end

			v16(p2)
			return true
		end

		v17 = useAdsCampaignDeepLink(v19)
	else
		v17 = nil
	end

	local v18 = React.useMemo(function()
		return adUpsellPublishUtils.getLastMessageKey(data.messages)
	end, { data.messages })

	local function fn()
		setState(false)
		setState2(nil)

		setState3(false)

		ref3.current = nil

		if FFlagEnablePaidAds then
			ref4.current = nil
		end

		setState4(false)
	end

	React.useEffect(fn, {
		if v17 == nil then data.universeId or 0 else v17.scopeRevision,
		v17 == nil and data.sessionId or ""
	})

	React.useEffect(function()
		if FFlagEnablePaidAds then
			local v21 = v9 == "Ready" and v8 ~= nil and v8 ~= ref4.current

			if state4 and (v21 or v9 == "Failed") then
				ref3.current = nil
				ref4.current = nil
				setState4(false)
			end
		elseif state4 and v9 == "Ready" and v8 ~= nil and freeCreditsRemaining ~= ref3.current then
			ref3.current = nil
			setState4(false)
		end
	end, { state4, v9, v8, freeCreditsRemaining })

	React.useEffect(function()
		if not data.isPageVisible then
			setState3(false)

			if not isCreatePending then
				setState(false)
			end
		end
	end, { data.isPageVisible, isCreatePending })

	local ref5 = React.useRef(false)
	React.useEffect(function()
		local current = ref5.current
		ref5.current = isCreatePending

		if current and not isCreatePending then
			local current2 = ref2.current
			ref2.current = nil
			local v21

			if v17 == nil then
				if current2 == nil or current2.universeId ~= data.universeId then
					v21 = false
				else
					v21 = current2.sessionId == data.sessionId
				end
			else
				v21 = v17.finishCreate()
			end

			if not v11.hasCreateError and v21 then
				if data.universeId ~= nil then
					v6.dismissPermanently(data.universeId)
				end

				local v23 = if FFlagEnablePaidAds then ref4.current ~= nil else ref3.current ~= nil
				setState4(v23)

				if data.isPageVisible then
					setState(false)
					setState3(true)
				end
			end
		end
	end, {
		v6,
		isCreatePending,
		data.isPageVisible,
		v11.hasCreateError,
		v17,
		data.universeId ~= nil,
		data.universeId or 0,
		data.sessionId ~= nil,
		data.sessionId or ""
	})

	local v21 = React.useMemo(function()
		if engineFeature and data.universeId ~= nil then
			return (v5.getAdUpsellState(data.universeId, data.sessionId))
		end

		return nil
	end, {
		v7,
		data.universeId ~= nil,
		data.universeId or 0,
		data.sessionId ~= nil,
		data.sessionId or ""
	})

	local v22 = v21 == nil or (not v21.isAvailable or v21.dismissedPermanently)
	local v23 = data.isPublic and v10 and not (v22 or v15 or state4)

	local function fn2()
		if v21 ~= nil and not v21.isAvailable then
			v6.retryStorageRead()
		end
	end

	React.useEffect(fn2, { v6, v21 ~= nil, v21 ~= nil and (v21.isAvailable or false) })

	React.useEffect(function()
		if
			data.universeId == nil
			or data.sessionId == nil
			or not FFlagBuildAdUpsellPinned and v18 == nil
			or v21 == nil
			or v21.pendingMilestoneCount == 0
		then
			return
		end

		v6.attachPendingMilestones(data.universeId, data.sessionId, if not FFlagBuildAdUpsellPinned then v18 else nil)
	end, {
		v6,
		data.universeId,
		data.sessionId,
		v18,
		v21 == nil and 0 or v21.pendingMilestoneCount or 0
	})

	local v27 = {}
	local v28 = nil
	local v29 = React.useMemo(function()
		return adUpsellPublishUtils.getMessageIndexByKey(data.messages)
	end, { data.messages })
	React.useEffect(function()
		if FFlagBuildAdUpsellPinned then
			return
		end

		local v30

		if not (data.universeId == nil or data.sessionId == nil) then
			v30 = `{data.universeId}:{data.sessionId}`
		end

		if not data.isHistoryExhausted then
			ref.current = nil
		end

		if not data.isHistoryExhausted or v30 == nil or ref.current == v30 then
			return
		end

		local set = {}

		for k in v29 do
			set[k] = true
		end

		if v6.pruneAnchors(data.universeId, data.sessionId, set) then
			ref.current = v30
		end
	end, { v6, data.isHistoryExhausted, data.universeId, data.sessionId, v29, v7 })

	if v21 ~= nil and v21.isAvailable and v23 then
		for k, anchor in v21.anchors do
			if FFlagBuildAdUpsellPinned then
				table.insert(v27, {
					id = anchor.id,
					order = anchor.order,
					isImpressed = anchor.impressed
				})

				local transientCongratsMessageKey = v6.getTransientCongratsMessageKey(anchor.id)

				if transientCongratsMessageKey ~= nil then
					v28 = v29[transientCongratsMessageKey]
				end
			else
				local afterMessageKey = anchor.afterMessageKey

				if afterMessageKey ~= nil then
					local v30 = v29[afterMessageKey]

					if v30 ~= nil then
						table.insert(v27, {
							id = anchor.id,
							order = anchor.order,
							anchorIndex = v30,
							isImpressed = anchor.impressed
						})
					end
				end
			end
		end
	end

	local v30 = React.useCallback(function(p2)
		if data.universeId == nil or data.sessionId == nil then
			return
		end

		if v6.markAnchorImpressed(data.universeId, data.sessionId, p2) then
			sendBuildExperienceEvent("AD_UPSELL_IMPRESSION", {
				universeId = data.universeId,
				conversationId = data.sessionId
			})
		end
	end, { v6, data.universeId or 0, data.sessionId or "" })

	local v31 = React.useCallback(function()
		if not data.isPageVisible then
			return
		end

		if FFlagBuildAdUpsell and not v11.hasCreateError then
			v17.clearPresentedRequest()
		end

		sendBuildExperienceEvent("AD_UPSELL_CREATE_CLICK", {
			universeId = data.universeId,
			conversationId = data.sessionId
		})

		v16(v8)
	end, {
		data.isPageVisible,
		data.universeId or 0,
		data.sessionId or "",
		v8,
		v16,
		v11.hasCreateError,
		v17
	})

	local v32 = React.useCallback(function()
		setState(false)

		if FFlagBuildAdUpsell then
			v17.clearPresentedRequest()
		end

		if FFlagEnablePaidAds then
			v11.clearCreateError()
		end
	end, { v11.clearCreateError, v17 })

	local v33 = React.useCallback(function(p2)
		local v34 = if FFlagBuildAdUpsell then v17.getPresentedRequestId() else nil

		local v35 = { universeId = data.universeId, conversationId = data.sessionId }

		if v34 == nil then
			sendBuildExperienceEvent("AD_UPSELL_CREATE_CONFIRM_CLICK", v35)
		else
			sendBuildExperienceEvent("AD_CAMPAIGN_DEEP_LINK_CONFIRM_CLICK", v35, { requestId = v34 })
		end

		if v17 == nil then
			ref2.current = { universeId = data.universeId, sessionId = data.sessionId }
		else
			v17.startCreate()
		end

		ref3.current = freeCreditsRemaining

		if FFlagEnablePaidAds then
			ref4.current = v8
		end

		local createCampaign = v11.createCampaign

		if not FFlagEnablePaidAds then
			p2 = nil
		end

		createCampaign(p2)
	end, {
		data.universeId or 0,
		data.sessionId or "",
		freeCreditsRemaining,
		v8,
		v11.createCampaign,
		v17
	})

	local v34 = React.useCallback(function()
		setState3(false)
	end, {})

	local v35 = React.useCallback(function()
		if data.universeId == nil then
			return
		end

		v6.dismissPermanently(data.universeId)
		sendBuildExperienceEvent("AD_UPSELL_DISMISS_CLICK", {
			universeId = data.universeId,
			conversationId = data.sessionId
		})
	end, { v6, data.universeId or 0, data.sessionId or "" })
	local v36

	if not (state2 == nil or state2.durationDays == nil) then
		v36 = adCampaignScheduleUtils.campaignEndMs(state2.runStartMs, state2.durationDays)
	end

	local v37 = {
		adUpsellCards = v27,
		adUpsellCongratsAnchorIndex = v28,
		adUpsellFreePromotionsRemaining = freeCreditsRemaining,
		isAdUpsellCreatePending = isCreatePending,
		isAdCampaignSheetOpen = state,
		hasAdCampaignCreateError = v11.hasCreateError,
		adCampaignCreateErrorKind = v11.createErrorKind,
		adCampaignDurationDays = 0,
		adCampaignEstimatedPriceRobux = 0,
		adCampaignOffers = 0,
		adCampaignRunStartTimeMs = 0,
		adCampaignRunEndTimeMs = 0,
		isAdCampaignCreatedToastVisible = 0,
		onAdCampaignCreatedToastDismiss = 0,
		onAdUpsellCreate = 0,
		onAdUpsellDismiss = 0,
		onAdUpsellImpression = 0,
		onAdCampaignSheetClose = 0,
		onAdCampaignSheetCreate = 0
	}
	local v38 = if state2 ~= nil then state2.durationDays else nil
	v37.adCampaignDurationDays = v38
	local v39 = if state2 ~= nil then state2.estimatedPriceRobux else nil
	v37.adCampaignEstimatedPriceRobux = v39
	local v40 = if state2 ~= nil then state2.campaignOffers else nil
	v37.adCampaignOffers = v40
	local v41 = if state2 ~= nil then state2.runStartMs else nil
	v37.adCampaignRunStartTimeMs = v41
	v37.adCampaignRunEndTimeMs = v36
	v37.isAdCampaignCreatedToastVisible = state3
	v37.onAdCampaignCreatedToastDismiss = v34
	v37.onAdUpsellCreate = v31
	v37.onAdUpsellDismiss = v35
	v37.onAdUpsellImpression = v30
	v37.onAdCampaignSheetClose = v32
	v37.onAdCampaignSheetCreate = v33
	return v37
end

return useAdUpsellChatViewModel
