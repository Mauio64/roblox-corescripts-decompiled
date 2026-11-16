local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Players = game:GetService("Players")

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local AdCampaignToolCallStatus = require(parent.DataHydration.AdCampaignToolCallStatus)
require(BuildExperience.Chat.chatTypes)

local computed = Signals.createComputed(function()
	return { cardStates = {}, pendingToolCallIds = {} }
end)

local function toolCallIdsKey(list) -- 1 equivalent call inferred from this helper
	return table.concat(list, "\0")
end

local function useAgentAdCampaignToolCallStatusFallback(list, p: number?)
	local localPlayer = Players.LocalPlayer

	if not p then
		if localPlayer == nil or not (localPlayer.UserId > 0) then
			p = nil
		else
			p = localPlayer.UserId
		end
	end

	local adCampaignToolCallStatusStore = AdCampaignToolCallStatus.getAdCampaignToolCallStatusStore(false)
	local v = toolCallIdsKey(list) -- inferred equivalent call
	local ref = React.useRef({ key = "", value = {} })

	if ref.current.key ~= v then
		ref.current = { key = v, value = table.clone(list) }
	end

	local value = ref.current.value
	local v2 = React.useMemo(function()
		if p == nil or #value == 0 then
			return computed
		end

		return Signals.createComputed(function(p2)
			local set = {}
			local cardStates = {}

			for _, v2 in value do
				local fetchToolCallStatus = adCampaignToolCallStatusStore.getAndFetchToolCallStatus(p, v2)
				local data = fetchToolCallStatus.data(p2)
				local status = fetchToolCallStatus.status(p2)

				if status == "NotReady" then
					set[v2] = true
				elseif status == "Ready" and data ~= nil then
					if data.campaignId == nil then
						if data.status == "processing" or data.status == "created" then
							set[v2] = true
						end
					else
						cardStates[v2] = {
							campaignId = data.campaignId,
							variant = nil,
							campaignStartDate = nil,
							campaignEndDate = nil
						}
					end
				end
			end

			return { cardStates = cardStates, pendingToolCallIds = set }
		end)
	end, { adCampaignToolCallStatusStore, p, value })
	local v3 = SignalsReact.useSignalState(v2)
	local ref2 = React.useRef({})
	React.useEffect(function()
		if p == nil or next(v3.pendingToolCallIds) == nil then
			return
		end

		local current = ref2.current

		for k in current do
			if v3.pendingToolCallIds[k] == nil then
				current[k] = nil
			end
		end

		local v4 = {}

		for k in v3.pendingToolCallIds do
			local v5 = current[k] or 0

			if v5 >= 3 then
				continue
			end

			local v6 = 5 * 2 ^ v5
			local thread = nil
			thread = task.delay(v6, function()
				if thread ~= nil then
					v4[thread] = nil
				end

				local toolCallStatus = adCampaignToolCallStatusStore.getToolCallStatus(p, k)
				local data = toolCallStatus.data(false)

				if
					toolCallStatus.status(false) == "Ready"
					and data ~= nil
					and data.campaignId == nil
					and (data.status == "processing" or data.status == "created")
				then
					current[k] = v5 + 1
					adCampaignToolCallStatusStore.fetchToolCallStatus(p, k)
				end
			end)

			if thread ~= nil then
				v4[thread] = true
			end
		end

		return function()
			for k in v4 do
				task.cancel(k)
			end
		end
	end, { v3, p, adCampaignToolCallStatusStore })
	return v3
end

return useAgentAdCampaignToolCallStatusFallback
