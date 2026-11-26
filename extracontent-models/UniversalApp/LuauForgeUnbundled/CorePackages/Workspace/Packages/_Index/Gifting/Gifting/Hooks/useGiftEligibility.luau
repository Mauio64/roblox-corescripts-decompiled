local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/DataHydration")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/SignalsReact")

local dataStatus = DataHydration.DataStatus

require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Models/CanGiftResponseModel")
require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Stores/createCanGiftStore")
local getCanGiftStore = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Stores/getCanGiftStore")
local GiftEligibility = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Enums/GiftEligibility")
local itemGiftabilityCacheKey = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Stores/itemGiftabilityCacheKey")
require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Types")

local buildItemGiftabilityKey = itemGiftabilityCacheKey.buildItemGiftabilityKey

local v5 = {}

local function buildItemsSignature(current)
	if current == nil or #current == 0 then
		return nil
	end

	local v6 = {}

	for k, item in current do
		table.insert(v6, buildItemGiftabilityKey(item))
	end

	return table.concat(v6, ",")
end

local function createEligibilitySignal(p2, current)
	local v6 = not (current == nil) and #current > 0
	local senderEligibility = p2.getSenderEligibility()
	local v7 = (current == nil or not (#current > 0)) and {} or p2.getAndFetchItemGiftabilities(current)

	return Signals.createComputed(function(p3)
		local status = senderEligibility.status(p3)
		local data = senderEligibility.data(p3)

		local v8 = if data == nil then GiftEligibility.Unknown else data.eligibility
		local v9 = if data == nil then v5 else data.requiredActions
		local v10 = false
		local v11 = false
		local v12 = false

		for k, v13 in v7 do
			local status2 = v13.status(p3)

			if status2 == dataStatus.NotReady then
				v10 = true
			elseif status2 == dataStatus.Failed then
				v11 = true
			end

			local data2 = v13.data(p3)

			if data2 == nil or not data2.isGiftable then
				v12 = true
			end
		end

		local v13 = status == dataStatus.NotReady or v10
		local v14 = status == dataStatus.Failed or v11

		local v17 = not (v13 or v14)

		if v17 then
			v17 = v8 == GiftEligibility.Eligible and not v12
		end

		return {
			canGift = v17,
			areItemsGiftable = v6 and not v10 and not (v11 or v12),
			senderEligibility = v8,
			requiredActions = v9,
			isLoading = v13,
			hasFailed = v14
		}
	end)
end

local function useGiftEligibility(current, p2)
	local v7 = (if p2 then p2.store else nil) or getCanGiftStore(false)

	local itemsSignature = buildItemsSignature(current)

	local ref = React.useRef(current)
	ref.current = current

	local v8 = React.useMemo(function()
		return createEligibilitySignal(v7, ref.current)
	end, { v7, itemsSignature })

	return SignalsReact.useSignalState(v8)
end

return useGiftEligibility
