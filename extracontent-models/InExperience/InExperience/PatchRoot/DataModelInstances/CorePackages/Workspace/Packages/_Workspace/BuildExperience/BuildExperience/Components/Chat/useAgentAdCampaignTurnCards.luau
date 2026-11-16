local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent
local React = require(parent.React)
require(BuildExperience.Chat.chatTypes)
local adCampaignEligibilityUtils = require(BuildExperience.Components.Ads.adCampaignEligibilityUtils)
local adUpsellVisibilityUtils = require(BuildExperience.Components.Ads.AdUpsellMilestone.adUpsellVisibilityUtils)
local GetAgentAdCampaignStore = require(BuildExperience.Stores.GetAgentAdCampaignStore)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local FFlagBuildAgentAdCampaignToolCallStatusFallback = require(BuildExperience.Flags.FFlagBuildAgentAdCampaignToolCallStatusFallback)
local useAgentAdCampaignToolCallStatusFallback = require(script.Parent.useAgentAdCampaignToolCallStatusFallback)
local FFlagBuildAgentAdCampaignRefreshEligibility = require(BuildExperience.Flags.FFlagBuildAgentAdCampaignRefreshEligibility)

local function useAgentAdCampaignTurnCards(data, p: number?)
	local ref = React.useRef({})
	local v = React.useMemo(function()
		local toolCallIds = {}
		local states = {}

		for _, segment in data.segments do
			if segment.kind ~= "agent_ad_campaign_card" then
				continue
			end

			local v

			if data.getCardState ~= nil then
				v = data.getCardState(segment.toolCallId)
			end

			if v ~= nil then
				states[segment.toolCallId] = v
			end

			local v2

			if FFlagBuildAgentAdCampaignRefreshEligibility then
				v2 = v == nil or v.campaignId == nil
			else
				v2 = v == nil
			end

			if v2 and segment.shouldCheckCampaignStatus then
				table.insert(toolCallIds, segment.toolCallId)
			end
		end

		return { states = states, missing = toolCallIds }
	end, { data.segments, data.getCardState })
	local states = v.states
	local missing = v.missing
	local v2

	if FFlagBuildAgentAdCampaignToolCallStatusFallback then
		table.sort(missing)

		v2 = useAgentAdCampaignToolCallStatusFallback(missing, p)
	else
		v2 = nil
	end

	local v3 = React.useMemo(function()
		local result = {}

		for _, segment in data.segments do
			if segment.kind ~= "agent_ad_campaign_card" then
				continue
			end

			local toolCallId = segment.toolCallId
			local state = states[toolCallId]

			if not state then
				if v2 == nil then
					state = nil
				else
					state = v2.cardStates[toolCallId]
				end
			end

			state = FFlagBuildAgentAdCampaignRefreshEligibility
				and state ~= nil
				and state.campaignId == nil
				and v2 ~= nil
				and v2.cardStates[toolCallId]
				or state
			local isPending

			if v2 == nil then
				isPending = false
			else
				isPending = v2.pendingToolCallIds[toolCallId] == true
			end

			local v3

			if segment.offers ~= nil then
				v3 = adCampaignEligibilityUtils.getDefaultOffer(segment.offers)
			end

			local fundingType = v3 == nil and "paid" or v3.fundingType
			local isCreateDisabled

			if data.onOfferSelected == nil or data.isPageVisible == false then
				isCreateDisabled = true
			elseif isPending then
				isCreateDisabled = isPending
			elseif data.isCreateDisabled == nil then
				isCreateDisabled = false
			else
				isCreateDisabled = data.isCreateDisabled(toolCallId)
			end

			ref.current[toolCallId] = ref.current[toolCallId] or React.createRef()
			result[toolCallId] = {
				state = state,
				isPending = isPending,
				fundingType = fundingType,
				isCreateDisabled = isCreateDisabled,
				cardRef = ref.current[toolCallId],
				onCreate = function()
					local v4

					if FFlagBuildAgentAdCampaignRefreshEligibility then
						if state == nil then
							v4 = false
						else
							v4 = state.campaignId ~= nil
						end
					else
						v4 = state ~= nil
					end

					if isCreateDisabled or v4 or segment.offers == nil or data.onOfferSelected == nil then
						return
					end

					sendBuildExperienceEvent(
						"AD_UPSELL_CREATE_CLICK",
						{ universeId = data.universeId, conversationId = data.sessionId },
						{
							context = "agent_card",
							toolCallId = toolCallId,
							fundingType = fundingType
						}
					)

					data.onOfferSelected(toolCallId, segment.offers)
				end
			}
		end

		return result
	end, {
		data.segments,
		data.onOfferSelected,
		data.isPageVisible,
		data.isCreateDisabled,
		data.universeId,
		data.sessionId,
		states,
		v2
	})

	React.useEffect(function()
		local current

		if data.scrollingFrameRef == nil then
			current = nil
		else
			current = data.scrollingFrameRef.current
		end

		if data.isPageVisible ~= true or data.sessionId == nil or current == nil then
			return
		end

		local agentAdCampaignStore = GetAgentAdCampaignStore(false)
		local connections = {}

		for _, segment in data.segments do
			if not (segment.kind == "agent_ad_campaign_card" and segment.offers ~= nil) then
				continue
			end

			local v4 = v3[segment.toolCallId]
			local current2 = v4.cardRef.current

			if v4.state ~= nil or v4.isPending or current2 == nil then
				continue
			end

			local function reportIfVisible()
				if
					current2:IsDescendantOf(current)
					and adUpsellVisibilityUtils.isCardVisibleInScrollViewport(current, current2)
					and agentAdCampaignStore.markImpressed(data.sessionId, segment.toolCallId)
				then
					sendBuildExperienceEvent(
						"AD_UPSELL_IMPRESSION",
						{ universeId = data.universeId, conversationId = data.sessionId },
						{
							context = "agent_card",
							toolCallId = segment.toolCallId,
							fundingType = v4.fundingType
						}
					)
				end
			end

			for _, propertyName in { "CanvasPosition", "AbsolutePosition", "AbsoluteWindowSize" } do
				table.insert(connections, current:GetPropertyChangedSignal(propertyName):Connect(reportIfVisible))
			end

			for _, propertyName in { "AbsolutePosition", "AbsoluteSize" } do
				table.insert(connections, current2:GetPropertyChangedSignal(propertyName):Connect(reportIfVisible))
			end

			reportIfVisible()
		end

		return function()
			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end, {
		data.scrollingFrameRef,
		data.isPageVisible,
		data.sessionId,
		data.universeId,
		data.segments,
		v3
	})

	return v3
end

return useAgentAdCampaignTurnCards
