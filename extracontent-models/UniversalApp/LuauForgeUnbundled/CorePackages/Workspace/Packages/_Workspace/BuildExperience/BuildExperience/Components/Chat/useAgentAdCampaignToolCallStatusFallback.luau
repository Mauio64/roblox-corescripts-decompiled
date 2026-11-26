local Players = game:GetService("Players")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local AdCampaignToolCallStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/AdCampaignToolCallStatus")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")

local computed = Signals.createComputed(function()
	return { cardStates = {}, pendingToolCallIds = {} }
end)

local function toolCallIdsKey(list)
	return table.concat(list, "\0")
end

local function useAgentAdCampaignToolCallStatusFallback(list, p2)
	local localPlayer = Players.LocalPlayer

	if not p2 then
		if localPlayer == nil or not (localPlayer.UserId > 0) then
			p2 = nil
		else
			p2 = localPlayer.UserId
		end
	end

	local adCampaignToolCallStatusStore = AdCampaignToolCallStatus.getAdCampaignToolCallStatusStore(false)
	local joined = table.concat(list, "\0")

	local ref = React.useRef({ key = "", value = {} })

	if ref.current.key ~= joined then
		ref.current = { key = joined, value = table.clone(list) }
	end

	local value = ref.current.value
	local v5 = React.useMemo(function()
		if p2 == nil or #value == 0 then
			return computed
		end

		return Signals.createComputed(function(p3)
			local set = {}
			local v6 = {}

			for k, v7 in value do
				local fetchToolCallStatus = adCampaignToolCallStatusStore.getAndFetchToolCallStatus(p2, v7)
				local data = fetchToolCallStatus.data(p3)
				local status = fetchToolCallStatus.status(p3)

				if status == "NotReady" then
					set[v7] = true
				elseif status == "Ready" and data ~= nil then
					if data.campaignId == nil then
						if data.status == "processing" or data.status == "created" then
							set[v7] = true
						end
					else
						v6[v7] = {
							campaignId = data.campaignId,
							variant = nil,
							campaignStartDate = nil,
							campaignEndDate = nil
						}
					end
				end
			end

			return { cardStates = v6, pendingToolCallIds = set }
		end)
	end, { adCampaignToolCallStatusStore, p2, value })
	local v6 = SignalsReact.useSignalState(v5)
	local ref2 = React.useRef({})
	React.useEffect(function()
		if p2 == nil or next(v6.pendingToolCallIds) == nil then
			return
		end

		local current = ref2.current

		for k in current do
			if v6.pendingToolCallIds[k] == nil then
				current[k] = nil
			end
		end

		local v7 = {}

		for k in v6.pendingToolCallIds do
			local v8 = current[k] or 0

			if v8 >= 3 then
				continue
			end

			local v9 = 5 * 2 ^ v8
			local thread = nil
			thread = task.delay(v9, function()
				if thread ~= nil then
					v7[thread] = nil
				end

				local toolCallStatus = adCampaignToolCallStatusStore.getToolCallStatus(p2, k)
				local data = toolCallStatus.data(false)

				if
					toolCallStatus.status(false) == "Ready"
					and data ~= nil
					and data.campaignId == nil
					and (data.status == "processing" or data.status == "created")
				then
					current[k] = v8 + 1
					adCampaignToolCallStatusStore.fetchToolCallStatus(p2, k)
				end
			end)

			if thread ~= nil then
				v7[thread] = true
			end
		end

		return function()
			for k in v7 do
				task.cancel(k)
			end
		end
	end, { v6, p2, adCampaignToolCallStatusStore })
	return v6
end

return useAgentAdCampaignToolCallStatusFallback
