local Gifting = script:FindFirstAncestor("Gifting")
local parent = Gifting.Parent

local DataHydration = require(parent.DataHydration)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local DataStatus = DataHydration.DataStatus

require(Gifting.Models.CanGiftResponseModel)
require(Gifting.Stores.createCanGiftStore)
local getCanGiftStore = require(Gifting.Stores.getCanGiftStore)
local GiftEligibility = require(Gifting.Enums.GiftEligibility)
local itemGiftabilityCacheKey = require(Gifting.Stores.itemGiftabilityCacheKey)
require(Gifting.Types)

local buildItemGiftabilityKey = itemGiftabilityCacheKey.buildItemGiftabilityKey

local v = {}

local function buildItemsSignature(current)
	if current == nil or #current == 0 then
		return nil
	end

	local v2 = {}

	for _, item in current do
		table.insert(v2, buildItemGiftabilityKey(item))
	end

	return table.concat(v2, ",")
end

local function createEligibilitySignal(p, current)
	local v2

	if current == nil then
		v2 = false
	else
		v2 = #current > 0
	end

	local senderEligibility = p.getSenderEligibility()
	local v3 = (current == nil or not (#current > 0)) and {} or p.getAndFetchItemGiftabilities(current)

	return Signals.createComputed(function(p2)
		local status = senderEligibility.status(p2)
		local data = senderEligibility.data(p2)
		local senderEligibility2

		if data == nil then
			senderEligibility2 = GiftEligibility.Unknown
		else
			senderEligibility2 = data.eligibility
		end

		local requiredActions

		if data == nil then
			requiredActions = v
		else
			requiredActions = data.requiredActions
		end

		local v4 = false
		local v5 = false
		local v6 = false

		for _, v7 in v3 do
			local status2 = v7.status(p2)

			if status2 == DataStatus.NotReady then
				v4 = true
			elseif status2 == DataStatus.Failed then
				v5 = true
			end

			local data2 = v7.data(p2)

			if data2 == nil or not data2.isGiftable then
				v6 = true
			end
		end

		local isLoading = status == DataStatus.NotReady or v4
		local hasFailed = status == DataStatus.Failed or v5

		local canGift = not (isLoading or hasFailed)

		if canGift then
			if senderEligibility2 == GiftEligibility.Eligible then
				canGift = not v6
			else
				canGift = false
			end
		end

		return {
			canGift = canGift,
			areItemsGiftable = v2 and not v4 and not (v5 or v6),
			senderEligibility = senderEligibility2,
			requiredActions = requiredActions,
			isLoading = isLoading,
			hasFailed = hasFailed
		}
	end)
end

local function useGiftEligibility(current, p)
	local v2

	if p then
		v2 = p.store
	end

	local v3 = v2 or getCanGiftStore(false)

	local itemsSignature = buildItemsSignature(current)

	local ref = React.useRef(current)
	ref.current = current

	local v4 = React.useMemo(function()
		return createEligibilitySignal(v3, ref.current)
	end, { v3, itemsSignature })

	return SignalsReact.useSignalState(v4)
end

return useGiftEligibility
