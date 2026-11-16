local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local HttpService = game:GetService("HttpService")

local HttpClient = require(parent.HttpClient)
local React = require(parent.React)

require(parent.DataHydration.AdCampaignEligibility)
require(parent.DataHydration.AdCampaigns)
require(parent.DataHydration.CampaignStats)
local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local FFlagBuildAgentAdCampaignCard = require(BuildExperience.Flags.FFlagBuildAgentAdCampaignCard)

local FFlagBuildAgentAdCampaignToolCallStatusFallback = require(BuildExperience.Flags.FFlagBuildAgentAdCampaignToolCallStatusFallback)
local useRefreshAdsData = require(script.Parent.useRefreshAdsData)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local FFlagEnablePaidAds = require(BuildExperience.Flags.FFlagEnablePaidAds)

local asPromise = HttpClient.asPromise
local classifyAdCampaignFailure = CreatorAgentChat.classifyAdCampaignFailure

local function useCreateAdCampaign(universeId: number?, conversationId: string?, options)
	local v = options or {}
	local sendEvent = v.sendEvent or sendBuildExperienceEvent

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

	local clearCreateError = React.useCallback(function()
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

		clearCreateError()
	end, { universeId, clearCreateError })

	local refresh = useRefreshAdsData(universeId, {
		includeEligibility = true,
		adCampaignsStore = v.adCampaignsStore,
		campaignStatsStore = v.campaignStatsStore,
		adCampaignEligibilityStore = v.adCampaignEligibilityStore
	})

	local v2 = {
		createCampaign = React.useCallback(function(p, callback, toolCallId: string?, p2)
			if universeId == nil or universeId == 0 or ref4.current or FFlagEnablePaidAds and p == nil then
				return
			end

			if FFlagBuildAgentAdCampaignCard and p2 ~= nil then
				ref.current = p2.idempotencyKey
				ref2.current = p
			end

			local current

			if FFlagEnablePaidAds then
				current = ref2.current
			end

			local v2

			if current == nil then
				v2 = false
			else
				v2 = current.paymentType ~= p.paymentType or current.campaignOption ~= p.campaignOption
			end

			local current2 = FFlagEnablePaidAds and ref3.current

			if v2 and not current2 then
				ref.current = nil
			end

			if ref.current == nil then
				local generateIdempotencyKey = v.generateIdempotencyKey
				local current3

				if generateIdempotencyKey == nil then
					current3 = HttpService:GenerateGUID(false)
				else
					current3 = generateIdempotencyKey()
				end

				ref.current = current3
			end

			if FFlagEnablePaidAds then
				ref2.current = p
			end

			ref4.current = true
			setState(true)
			setState2(false)

			local v3 = { universeId = universeId, idempotencyKey = ref.current }

			if FFlagEnablePaidAds and p ~= nil then
				v3.selectedOption = p
			end

			if FFlagBuildAgentAdCampaignToolCallStatusFallback and toolCallId ~= nil and toolCallId ~= "" then
				v3.toolCallId = toolCallId
			end

			local createCampaignAsync = v.createCampaignAsync or function(p3)
				return asPromise(CreatorAgentChat.getCreatorAgentChatStore(false).adCampaignCreate(p3))
			end

			local idempotencyKey = v3.idempotencyKey
			local clone

			if FFlagBuildAgentAdCampaignCard and v3.selectedOption ~= nil then
				clone = table.clone(v3.selectedOption)
			else
				clone = nil
			end

			createCampaignAsync(v3):andThen(function(p3)
				sendEvent("AD_CAMPAIGN_CREATE_SUCCESS", {
					universeId = universeId,
					conversationId = conversationId
				}, {
					campaignId = p3.campaignId
				})
				ref.current = nil

				if FFlagEnablePaidAds then
					ref2.current = nil
					ref3.current = false
				end

				refresh()
				ref4.current = false

				if ref5.current then
					setState(false)
				end

				if FFlagBuildAgentAdCampaignCard and callback ~= nil then
					pcall(callback, p3.campaignId, idempotencyKey, clone)
				end
			end):catch(function(p3)
				sendEvent("AD_CAMPAIGN_CREATE_FAILURE", {
					universeId = universeId,
					conversationId = conversationId
				}, {
					error = tostring(p3)
				})

				ref4.current = false
				local kind

				if FFlagEnablePaidAds then
					kind = classifyAdCampaignFailure(p3).kind
				end

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

				if FFlagBuildAgentAdCampaignCard and p2 ~= nil then
					pcall(p2.onFailed, kind)
				end
			end)
		end, {
			universeId,
			conversationId,
			refresh,
			sendEvent,
			v.createCampaignAsync,
			v.generateIdempotencyKey
		}),
		clearCreateError = clearCreateError,
		refresh = refresh,
		isCreatePending = state,
		hasCreateError = state2,
		createErrorKind = 0
	}

	if not FFlagEnablePaidAds then
		state3 = nil
	end

	v2.createErrorKind = state3
	return v2
end

return useCreateAdCampaign
