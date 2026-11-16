local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
require(parent.DataHydration.CreatorAgentChat)

local adCampaignEligibilityUtils = require(BuildExperience.Components.Ads.adCampaignEligibilityUtils)
local adCampaignScheduleUtils = require(BuildExperience.Components.Ads.adCampaignScheduleUtils)
require(BuildExperience.Chat.chatTypes)
local GetAdUpsellEventStore = require(BuildExperience.Stores.GetAdUpsellEventStore)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local useCreateAdCampaign = require(BuildExperience.Components.Ads.useCreateAdCampaign)
local useGetAdCampaignEligibility = require(BuildExperience.Components.Ads.useGetAdCampaignEligibility)
local useGetAdCampaigns = require(BuildExperience.Components.Ads.useGetAdCampaigns)
local adUpsellPublishUtils = require(script.Parent.adUpsellPublishUtils)
local FFlagEnablePaidAds = require(BuildExperience.Flags.FFlagEnablePaidAds)
local FFlagBuildAdUpsell = require(BuildExperience.Flags.FFlagBuildAdUpsell)
local FFlagBuildAdUpsellPinned = require(BuildExperience.Flags.FFlagBuildAdUpsellPinned)
local SharedFlags = require(parent.SharedFlags)
local FFlagBuildAdsNotificationRouting = SharedFlags.FFlagBuildAdsNotificationRouting
local useAdsCampaignDeepLink = require(BuildExperience.Components.Ads.useAdsCampaignDeepLink)

local engineFeature = game:GetEngineFeature("BuildAppStorageKey")
local BuildAppStorage

if engineFeature then
	BuildAppStorage = require(BuildExperience.Storage.BuildAppStorage)
else
	BuildAppStorage = nil
end

local function useAdUpsellChatViewModel(data)
	local adUpsellEventStore = GetAdUpsellEventStore(false)
	local v = SignalsReact.useSignalState(adUpsellEventStore.getRevision)
	local ref = React.useRef(nil)

	local current3, v2 = useGetAdCampaignEligibility(data.universeId, data.eligibilityStore)
	local freeCreditsRemaining = adCampaignEligibilityUtils.freeCreditsRemaining(current3)

	local v3 = adCampaignEligibilityUtils.isEligibleForFreePromotion(current3)
		and adCampaignEligibilityUtils.hasFreeCredit(current3)
		and adCampaignEligibilityUtils.hasUsableOffer(current3)
	local v4 = useCreateAdCampaign(data.universeId, data.sessionId)
	local isCreatePending = v4.isCreatePending
	local state, setState = React.useState(false)

	local state2, setState2 = React.useState(nil)
	local state3, setState3 = React.useState(false)

	local ref2 = React.useRef(nil)

	local state4, setState4 = React.useState(false)
	local ref3 = React.useRef(nil)
	local ref4

	if FFlagEnablePaidAds then
		ref4 = React.useRef(nil)
	else
		ref4 = nil
	end

	local v5, v6 = useGetAdCampaigns()

	local v7 = React.useMemo(function()
		if data.nowMs == nil then
			return DateTime.now().UnixTimestampMillis
		end

		return data.nowMs
	end, { data.nowMs or 0, v5 or false })
	local v8

	if v6 == "Ready" then
		v8 = adCampaignScheduleUtils.hasActiveCampaign(v5, data.universeId, v7)
	else
		v8 = false
	end

	local v9 = React.useCallback(function(p)
		setState3(false)

		if not FFlagEnablePaidAds then
			v4.clearCreateError()
		end

		setState2(function(p2)
			if FFlagEnablePaidAds and v4.hasCreateError and p2 ~= nil then
				return p2
			end

			return adCampaignEligibilityUtils.campaignSheetTerms(p, DateTime.now().UnixTimestampMillis)
		end)

		setState(true)
	end, { v4.clearCreateError, v4.hasCreateError })
	local v10

	if FFlagBuildAdUpsell then
		local v11 = {
			universeId = data.universeId,
			sessionId = data.sessionId,
			isPageVisible = data.isPageVisible,
			eligibilityStore = data.eligibilityStore,
			canPresent = 0,
			onOpen = 0
		}
		local canPresent

		if FFlagBuildAdsNotificationRouting then
			canPresent = not (isCreatePending or state4)
		end

		v11.canPresent = canPresent

		function v11.onOpen(p): boolean
			if state or isCreatePending or state4 then
				return false
			end

			v9(p)
			return true
		end

		v10 = useAdsCampaignDeepLink(v11)
	else
		v10 = nil
	end

	local v11 = React.useMemo(function()
		return adUpsellPublishUtils.getLastMessageKey(data.messages)
	end, { data.messages })
	local useEffect = React.useEffect
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

	local v12

	if v10 == nil then
		v12 = data.universeId or 0
	else
		v12 = v10.scopeRevision
	end

	useEffect(fn, { v12, v10 == nil and data.sessionId or "" })

	React.useEffect(function()
		if FFlagEnablePaidAds then
			local v13

			if v2 == "Ready" and current3 ~= nil then
				v13 = current3 ~= ref4.current
			else
				v13 = false
			end

			if state4 and (v13 or v2 == "Failed") then
				ref3.current = nil
				ref4.current = nil
				setState4(false)
			end
		elseif state4 and v2 == "Ready" and current3 ~= nil and freeCreditsRemaining ~= ref3.current then
			ref3.current = nil
			setState4(false)
		end
	end, { state4, v2, current3, freeCreditsRemaining })

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
			local v13

			if v10 == nil then
				if current2 == nil or current2.universeId ~= data.universeId then
					v13 = false
				else
					v13 = current2.sessionId == data.sessionId
				end
			else
				v13 = v10.finishCreate()
			end

			if not v4.hasCreateError and v13 then
				if data.universeId ~= nil then
					adUpsellEventStore.dismissPermanently(data.universeId)
				end

				local v14

				if FFlagEnablePaidAds then
					v14 = ref4.current ~= nil
				else
					v14 = ref3.current ~= nil
				end

				setState4(v14)

				if data.isPageVisible then
					setState(false)
					setState3(true)
				end
			end
		end
	end, {
		adUpsellEventStore,
		isCreatePending,
		data.isPageVisible,
		v4.hasCreateError,
		v10,
		data.universeId ~= nil,
		data.universeId or 0,
		data.sessionId ~= nil,
		data.sessionId or ""
	})

	local v13 = React.useMemo(function()
		if engineFeature and data.universeId ~= nil then
			return (BuildAppStorage.getAdUpsellState(data.universeId, data.sessionId))
		end

		return nil
	end, {
		v,
		data.universeId ~= nil,
		data.universeId or 0,
		data.sessionId ~= nil,
		data.sessionId or ""
	})

	local v14 = v13 == nil or (not v13.isAvailable or v13.dismissedPermanently)
	local v15 = data.isPublic and v3 and not (v14 or v8 or state4)

	local function fn2()
		if v13 ~= nil and not v13.isAvailable then
			adUpsellEventStore.retryStorageRead()
		end
	end

	React.useEffect(fn2, { adUpsellEventStore, v13 ~= nil, v13 ~= nil and (v13.isAvailable or false) })

	React.useEffect(function()
		if
			data.universeId == nil
			or data.sessionId == nil
			or not FFlagBuildAdUpsellPinned and v11 == nil
			or v13 == nil
			or v13.pendingMilestoneCount == 0
		then
			return
		end

		local attachPendingMilestones = adUpsellEventStore.attachPendingMilestones
		local universeId = data.universeId
		local sessionId = data.sessionId
		local v16

		if not FFlagBuildAdUpsellPinned then
			v16 = v11
		end

		attachPendingMilestones(universeId, sessionId, v16)
	end, {
		adUpsellEventStore,
		data.universeId,
		data.sessionId,
		v11,
		v13 == nil and 0 or v13.pendingMilestoneCount or 0
	})

	local adUpsellCards = {}
	local adUpsellCongratsAnchorIndex = nil
	local v16 = React.useMemo(function()
		return adUpsellPublishUtils.getMessageIndexByKey(data.messages)
	end, { data.messages })
	React.useEffect(function()
		if FFlagBuildAdUpsellPinned then
			return
		end

		local current

		if not (data.universeId == nil or data.sessionId == nil) then
			current = `{data.universeId}:{data.sessionId}`
		end

		if not data.isHistoryExhausted then
			ref.current = nil
		end

		if not data.isHistoryExhausted or current == nil or ref.current == current then
			return
		end

		local set = {}

		for k in v16 do
			set[k] = true
		end

		if adUpsellEventStore.pruneAnchors(data.universeId, data.sessionId, set) then
			ref.current = current
		end
	end, { adUpsellEventStore, data.isHistoryExhausted, data.universeId, data.sessionId, v16, v })

	if v13 ~= nil and v13.isAvailable and v15 then
		for _, anchor in v13.anchors do
			if FFlagBuildAdUpsellPinned then
				table.insert(adUpsellCards, {
					id = anchor.id,
					order = anchor.order,
					isImpressed = anchor.impressed
				})

				local transientCongratsMessageKey = adUpsellEventStore.getTransientCongratsMessageKey(anchor.id)

				if transientCongratsMessageKey ~= nil then
					adUpsellCongratsAnchorIndex = v16[transientCongratsMessageKey]
				end
			else
				local afterMessageKey = anchor.afterMessageKey

				if afterMessageKey ~= nil then
					local anchorIndex = v16[afterMessageKey]

					if anchorIndex ~= nil then
						table.insert(adUpsellCards, {
							id = anchor.id,
							order = anchor.order,
							anchorIndex = anchorIndex,
							isImpressed = anchor.impressed
						})
					end
				end
			end
		end
	end

	local onAdUpsellImpression = React.useCallback(function(p: string)
		if data.universeId == nil or data.sessionId == nil then
			return
		end

		if adUpsellEventStore.markAnchorImpressed(data.universeId, data.sessionId, p) then
			sendBuildExperienceEvent("AD_UPSELL_IMPRESSION", {
				universeId = data.universeId,
				conversationId = data.sessionId
			})
		end
	end, { adUpsellEventStore, data.universeId or 0, data.sessionId or "" })

	local onAdUpsellCreate = React.useCallback(function()
		if not data.isPageVisible then
			return
		end

		if FFlagBuildAdUpsell and not v4.hasCreateError then
			v10.clearPresentedRequest()
		end

		sendBuildExperienceEvent("AD_UPSELL_CREATE_CLICK", {
			universeId = data.universeId,
			conversationId = data.sessionId
		})

		v9(current3)
	end, {
		data.isPageVisible,
		data.universeId or 0,
		data.sessionId or "",
		current3,
		v9,
		v4.hasCreateError,
		v10
	})

	local onAdCampaignSheetClose = React.useCallback(function()
		setState(false)

		if FFlagBuildAdUpsell then
			v10.clearPresentedRequest()
		end

		if FFlagEnablePaidAds then
			v4.clearCreateError()
		end
	end, { v4.clearCreateError, v10 })

	local onAdCampaignSheetCreate = React.useCallback(function(p)
		local requestId

		if FFlagBuildAdUpsell then
			requestId = v10.getPresentedRequestId()
		end

		local v17 = { universeId = data.universeId, conversationId = data.sessionId }

		if requestId == nil then
			sendBuildExperienceEvent("AD_UPSELL_CREATE_CONFIRM_CLICK", v17)
		else
			sendBuildExperienceEvent("AD_CAMPAIGN_DEEP_LINK_CONFIRM_CLICK", v17, {
				requestId = requestId
			})
		end

		if v10 == nil then
			ref2.current = { universeId = data.universeId, sessionId = data.sessionId }
		else
			v10.startCreate()
		end

		ref3.current = freeCreditsRemaining

		if FFlagEnablePaidAds then
			ref4.current = current3
		end

		local createCampaign = v4.createCampaign

		if not FFlagEnablePaidAds then
			p = nil
		end

		createCampaign(p)
	end, {
		data.universeId or 0,
		data.sessionId or "",
		freeCreditsRemaining,
		current3,
		v4.createCampaign,
		v10
	})

	local onAdCampaignCreatedToastDismiss = React.useCallback(function()
		setState3(false)
	end, {})

	local onAdUpsellDismiss = React.useCallback(function()
		if data.universeId == nil then
			return
		end

		adUpsellEventStore.dismissPermanently(data.universeId)
		sendBuildExperienceEvent("AD_UPSELL_DISMISS_CLICK", {
			universeId = data.universeId,
			conversationId = data.sessionId
		})
	end, { adUpsellEventStore, data.universeId or 0, data.sessionId or "" })
	local adCampaignRunEndTimeMs

	if not (state2 == nil or state2.durationDays == nil) then
		adCampaignRunEndTimeMs = adCampaignScheduleUtils.campaignEndMs(state2.runStartMs, state2.durationDays)
	end

	local v17 = {
		adUpsellCards = adUpsellCards,
		adUpsellCongratsAnchorIndex = adUpsellCongratsAnchorIndex,
		adUpsellFreePromotionsRemaining = freeCreditsRemaining,
		isAdUpsellCreatePending = isCreatePending,
		isAdCampaignSheetOpen = state,
		hasAdCampaignCreateError = v4.hasCreateError,
		adCampaignCreateErrorKind = v4.createErrorKind,
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
	local adCampaignDurationDays

	if state2 ~= nil then
		adCampaignDurationDays = state2.durationDays
	end

	v17.adCampaignDurationDays = adCampaignDurationDays
	local adCampaignEstimatedPriceRobux

	if state2 ~= nil then
		adCampaignEstimatedPriceRobux = state2.estimatedPriceRobux
	end

	v17.adCampaignEstimatedPriceRobux = adCampaignEstimatedPriceRobux
	local adCampaignOffers

	if state2 ~= nil then
		adCampaignOffers = state2.campaignOffers
	end

	v17.adCampaignOffers = adCampaignOffers
	local adCampaignRunStartTimeMs

	if state2 ~= nil then
		adCampaignRunStartTimeMs = state2.runStartMs
	end

	v17.adCampaignRunStartTimeMs = adCampaignRunStartTimeMs
	v17.adCampaignRunEndTimeMs = adCampaignRunEndTimeMs
	v17.isAdCampaignCreatedToastVisible = state3
	v17.onAdCampaignCreatedToastDismiss = onAdCampaignCreatedToastDismiss
	v17.onAdUpsellCreate = onAdUpsellCreate
	v17.onAdUpsellDismiss = onAdUpsellDismiss
	v17.onAdUpsellImpression = onAdUpsellImpression
	v17.onAdCampaignSheetClose = onAdCampaignSheetClose
	v17.onAdCampaignSheetCreate = onAdCampaignSheetCreate
	return v17
end

return useAdUpsellChatViewModel
