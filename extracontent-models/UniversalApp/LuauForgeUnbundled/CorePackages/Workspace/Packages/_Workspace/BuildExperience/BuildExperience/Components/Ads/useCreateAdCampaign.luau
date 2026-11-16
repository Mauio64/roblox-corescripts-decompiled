local HttpService = game:GetService("HttpService")

local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/HttpClient")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/AdCampaignEligibility")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/AdCampaigns")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CampaignStats")
local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local FFlagBuildAgentAdCampaignCard = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAgentAdCampaignCard")

local FFlagBuildAgentAdCampaignToolCallStatusFallback = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAgentAdCampaignToolCallStatusFallback")
local useRefreshAdsData = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/useRefreshAdsData")
local sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")
local FFlagEnablePaidAds = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagEnablePaidAds")

local asPromise = HttpClient.asPromise
local classifyAdCampaignFailure = CreatorAgentChat.classifyAdCampaignFailure

local function useCreateAdCampaign(p2, p3, options)
	local v5 = options or {}
	local sendEvent = v5.sendEvent or sendBuildExperienceEvent

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local ref = React.useRef(nil)
	local state3, setState3, ref2, ref3

	if FFlagEnablePaidAds then
		state3, setState3 = React.useState(nil)

		ref2 = React.useRef(nil)

		ref3 = React.useRef(false)
	else
		setState3 = nil
		ref2 = nil
		ref3 = nil
	end

	local ref4 = React.useRef(false)
	local ref5 = React.useRef(true)

	React.useEffect(function()
		ref5.current = true
		return function()
			ref5.current = false
		end
	end, {})

	local v6 = React.useCallback(function()
		setState2(false)

		if FFlagEnablePaidAds then
			setState3(nil)
		end
	end, {})

	React.useEffect(function()
		ref.current = nil

		if FFlagEnablePaidAds then
			ref2.current = nil
			ref3.current = false
		end

		v6()
	end, { p2, v6 })

	local v7 = useRefreshAdsData(p2, {
		includeEligibility = true,
		adCampaignsStore = v5.adCampaignsStore,
		campaignStatsStore = v5.campaignStatsStore,
		adCampaignEligibilityStore = v5.adCampaignEligibilityStore
	})

	local v8 = {
		createCampaign = React.useCallback(function(p4, callback, toolCallId, p5)
			if p2 == nil or p2 == 0 or ref4.current or FFlagEnablePaidAds and p4 == nil then
				return
			end

			if FFlagBuildAgentAdCampaignCard and p5 ~= nil then
				ref.current = p5.idempotencyKey
				ref2.current = p4
			end

			local current = if FFlagEnablePaidAds then ref2.current else nil
			local v9

			if current == nil then
				v9 = false
			else
				v9 = current.paymentType ~= p4.paymentType or current.campaignOption ~= p4.campaignOption
			end

			local current2 = FFlagEnablePaidAds and ref3.current

			if v9 and not current2 then
				ref.current = nil
			end

			if ref.current == nil then
				local generateIdempotencyKey = v5.generateIdempotencyKey
				local v10 = ref
				local v11 = if generateIdempotencyKey == nil then HttpService:GenerateGUID(false) else generateIdempotencyKey()
				v10.current = v11
			end

			if FFlagEnablePaidAds then
				ref2.current = p4
			end

			ref4.current = true
			setState(true)
			setState2(false)

			local v10 = { universeId = p2, idempotencyKey = ref.current }

			if FFlagEnablePaidAds and p4 ~= nil then
				v10.selectedOption = p4
			end

			if FFlagBuildAgentAdCampaignToolCallStatusFallback and toolCallId ~= nil and toolCallId ~= "" then
				v10.toolCallId = toolCallId
			end

			local createCampaignAsync = v5.createCampaignAsync or function(p6)
				return asPromise(CreatorAgentChat.getCreatorAgentChatStore(false).adCampaignCreate(p6))
			end

			local idempotencyKey = v10.idempotencyKey
			local clone = if FFlagBuildAgentAdCampaignCard and v10.selectedOption ~= nil then table.clone(v10.selectedOption) else nil

			createCampaignAsync(v10):andThen(function(p6)
				sendEvent("AD_CAMPAIGN_CREATE_SUCCESS", {
					universeId = p2,
					conversationId = p3
				}, {
					campaignId = p6.campaignId
				})
				ref.current = nil

				if FFlagEnablePaidAds then
					ref2.current = nil
					ref3.current = false
				end

				v7()
				ref4.current = false

				if ref5.current then
					setState(false)
				end

				if FFlagBuildAgentAdCampaignCard and callback ~= nil then
					pcall(callback, p6.campaignId, idempotencyKey, clone)
				end
			end):catch(function(p6)
				sendEvent("AD_CAMPAIGN_CREATE_FAILURE", {
					universeId = p2,
					conversationId = p3
				}, {
					error = tostring(p6)
				})

				ref4.current = false

				local kind = if FFlagEnablePaidAds then classifyAdCampaignFailure(p6).kind else nil

				if FFlagEnablePaidAds and kind == "unknown" then
					ref3.current = true
				end

				if ref5.current then
					setState2(true)

					if FFlagEnablePaidAds then
						setState3(kind)
					end

					setState(false)
				end

				if FFlagBuildAgentAdCampaignCard and p5 ~= nil then
					pcall(p5.onFailed, kind)
				end
			end)
		end, {
			p2,
			p3,
			v7,
			sendEvent,
			v5.createCampaignAsync,
			v5.generateIdempotencyKey
		}),
		clearCreateError = v6,
		refresh = v7,
		isCreatePending = state,
		hasCreateError = state2,
		createErrorKind = 0
	}

	if not FFlagEnablePaidAds then
		state3 = nil
	end

	v8.createErrorKind = state3
	return v8
end

return useCreateAdCampaign
