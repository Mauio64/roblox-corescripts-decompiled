local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local adCampaignEligibilityUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/adCampaignEligibilityUtils")
local adUpsellVisibilityUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/AdUpsellMilestone/adUpsellVisibilityUtils")
local GetAgentAdCampaignStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetAgentAdCampaignStore")
local sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")
local FFlagBuildAgentAdCampaignToolCallStatusFallback = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAgentAdCampaignToolCallStatusFallback")
local useAgentAdCampaignToolCallStatusFallback = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/useAgentAdCampaignToolCallStatusFallback")
local FFlagBuildAgentAdCampaignRefreshEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAgentAdCampaignRefreshEligibility")

local function useAgentAdCampaignTurnCards(data, p2)
	local ref = React.useRef({})
	local v5 = React.useMemo(function()
		local toolCallIds = {}
		local v6 = {}

		for k, segment in data.segments do
			if segment.kind ~= "agent_ad_campaign_card" then
				continue
			end

			local v7 = if data.getCardState ~= nil then data.getCardState(segment.toolCallId) else nil

			if v7 ~= nil then
				v6[segment.toolCallId] = v7
			end

			local v8 = if FFlagBuildAgentAdCampaignRefreshEligibility then v7 == nil or v7.campaignId == nil else v7 == nil

			if v8 and segment.shouldCheckCampaignStatus then
				table.insert(toolCallIds, segment.toolCallId)
			end
		end

		return { states = v6, missing = toolCallIds }
	end, { data.segments, data.getCardState })
	local states = v5.states
	local missing = v5.missing
	local v6

	if FFlagBuildAgentAdCampaignToolCallStatusFallback then
		table.sort(missing)

		v6 = useAgentAdCampaignToolCallStatusFallback(missing, p2)
	else
		v6 = nil
	end

	local v7 = React.useMemo(function()
		local result = {}

		for k, segment in data.segments do
			if segment.kind ~= "agent_ad_campaign_card" then
				continue
			end

			local toolCallId = segment.toolCallId
			local v8 = states[toolCallId]

			if not v8 then
				v8 = if v6 ~= nil then v6.cardStates[toolCallId] else nil
			end

			v8 = FFlagBuildAgentAdCampaignRefreshEligibility
				and v8 ~= nil
				and v8.campaignId == nil
				and v6 ~= nil
				and v6.cardStates[toolCallId]
				or v8

			local v9 = not (v6 == nil) and v6.pendingToolCallIds[toolCallId] == true
			local v10 = if segment.offers ~= nil then adCampaignEligibilityUtils.getDefaultOffer(segment.offers) else nil

			local v11 = v10 == nil and "paid" or v10.fundingType
			local v12

			if data.onOfferSelected == nil or data.isPageVisible == false then
				v12 = true
			elseif v9 then
				v12 = v9
			else
				v12 = not (data.isCreateDisabled == nil) and data.isCreateDisabled(toolCallId)
			end

			ref.current[toolCallId] = ref.current[toolCallId] or React.createRef()
			result[toolCallId] = {
				state = v8,
				isPending = v9,
				fundingType = v11,
				isCreateDisabled = v12,
				cardRef = ref.current[toolCallId],
				onCreate = function()
					local v14 = if FFlagBuildAgentAdCampaignRefreshEligibility then not (v8 == nil) and v8.campaignId ~= nil else v8 ~= nil

					if v12 or v14 or segment.offers == nil or data.onOfferSelected == nil then
						return
					end

					sendBuildExperienceEvent(
						"AD_UPSELL_CREATE_CLICK",
						{
							universeId = data.universeId,
							conversationId = data.sessionId
						},
						{
							context = "agent_card",
							toolCallId = toolCallId,
							fundingType = v11
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
		v6
	})

	React.useEffect(function()
		local current = if data.scrollingFrameRef ~= nil then data.scrollingFrameRef.current else nil

		if data.isPageVisible ~= true or data.sessionId == nil or current == nil then
			return
		end

		local v8 = GetAgentAdCampaignStore(false)
		local connections = {}

		for k, segment in data.segments do
			if not (segment.kind == "agent_ad_campaign_card" and segment.offers ~= nil) then
				continue
			end

			local v9 = v7[segment.toolCallId]
			local current2 = v9.cardRef.current

			if v9.state ~= nil or v9.isPending or current2 == nil then
				continue
			end

			local function reportIfVisible()
				if
					current2:IsDescendantOf(current)
					and adUpsellVisibilityUtils.isCardVisibleInScrollViewport(current, current2)
					and v8.markImpressed(data.sessionId, segment.toolCallId)
				then
					sendBuildExperienceEvent(
						"AD_UPSELL_IMPRESSION",
						{
							universeId = data.universeId,
							conversationId = data.sessionId
						},
						{
							context = "agent_card",
							toolCallId = segment.toolCallId,
							fundingType = v9.fundingType
						}
					)
				end
			end

			for k2, propertyName in { "CanvasPosition", "AbsolutePosition", "AbsoluteWindowSize" } do
				table.insert(
					connections,
					current:GetPropertyChangedSignal(propertyName):Connect(reportIfVisible)
				)
			end

			for k2, propertyName in { "AbsolutePosition", "AbsoluteSize" } do
				table.insert(
					connections,
					current2:GetPropertyChangedSignal(propertyName):Connect(reportIfVisible)
				)
			end

			reportIfVisible()
		end

		return function()
			for k, connection in connections do
				connection:Disconnect()
			end
		end
	end, {
		data.scrollingFrameRef,
		data.isPageVisible,
		data.sessionId,
		data.universeId,
		data.segments,
		v7
	})

	return v7
end

return useAgentAdCampaignTurnCards
