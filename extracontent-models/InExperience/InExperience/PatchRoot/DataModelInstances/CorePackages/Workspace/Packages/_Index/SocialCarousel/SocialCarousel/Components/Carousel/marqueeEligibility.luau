local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent

local SocialCommon = require(parent.SocialCommon)

local Enums = require(SocialCarousel.Common.Enums)
local tileVisibility = require(script.Parent.tileVisibility)

local PresenceTypes = SocialCommon.Enums.PresenceTypes
local Tile = Enums.Tile

local function loopKey(p: string, p2: string) -- 3 equivalent calls inferred from this helper
	return p .. "\0" .. p2
end

local function loopsLeft(id: string, lastLocation: string, loopsRemaining) -- 1 equivalent call inferred from this helper
	if loopsRemaining == nil then
		return 2
	end

	local v = loopsRemaining[loopKey(id, lastLocation)] -- inferred equivalent call

	return if v == nil then 2 else v
end

local function storedLoopKeys(items, p: string)
	local v = p .. "\0"
	local result = {}

	for k in items do
		if string.sub(k, 1, #v) == v then
			table.insert(result, k)
		end
	end

	return result
end

local function reconcileFriendPresence(items, id: string, p: string?)
	local v = storedLoopKeys(items, id)

	if p == nil or p == "" then
		for _, v2 in v do
			items[v2] = nil
		end
	else
		local v2 = loopKey(id, p) -- inferred equivalent call
		local v3 = items[v2] ~= nil

		for _, v4 in v do
			if v4 ~= v2 then
				items[v4] = nil
			end
		end

		if not v3 then
			items[v2] = 2
		end
	end
end

local function inGameLocation(item) -- 1 equivalent call inferred from this helper
	if item.tileType ~= Tile.Friend then
		return nil
	end

	local presence = item.presence

	if presence == nil or presence.userPresenceType ~= PresenceTypes.InGame then
		return nil
	end

	local lastLocation = presence.lastLocation

	if lastLocation == nil or lastLocation == "" then
		return nil
	end

	return lastLocation
end

local function friendIdFromLoopKey(value: string) -- 1 equivalent call inferred from this helper
	local v = string.find(value, "\0", 1, true)

	if v == nil then
		return nil
	end

	return (string.sub(value, 1, v - 1))
end

local function isHoverEligible(data): boolean -- 1 equivalent call inferred from this helper
	if data.tileType ~= Tile.Friend then
		return false
	end

	local presence = data.presence

	if presence == nil or presence.userPresenceType ~= PresenceTypes.InGame then
		return false
	end

	local lastLocation = presence.lastLocation
	return lastLocation ~= nil and lastLocation ~= "" and data.subtitle == lastLocation
end

local function isEligible(data, i: number, data2)
	if not isHoverEligible(data) then -- inferred equivalent call
		return false
	end

	local presence = data.presence
	local lastLocation

	if presence ~= nil then
		lastLocation = presence.lastLocation
	end

	if lastLocation ~= nil and not (loopsLeft(data.id, lastLocation, data2.loopsRemaining) <= 0) then -- inferred equivalent call
		return tileVisibility.isAtLeast70PercentVisible(
			i,
			data2.canvasX,
			data2.containerWidth,
			data2.tileWidth,
			data2.gap
		)
	end

	return false
end

local function scanRow(list, p, p2: string?)
	local result = {}
	local v = nil

	if p.interacting or p.reducedMotion then
		return result, nil
	end

	for i, item in ipairs(list) do
		if p2 ~= nil and v == nil and item.id == p2 then
			v = i
		end

		if isEligible(item, i, p) then
			table.insert(result, i)
		end
	end

	return result, v
end

local function leadingIndex(list, p) -- 2 equivalent calls inferred from this helper
	local count = #list

	if count == 0 then
		return nil
	end

	if p == Enum.TextDirection.RightToLeft then
		return list[count]
	end

	return list[1]
end

local function nextIndex(list, p: number?, direction)
	local count = #list

	if count == 0 then
		return nil
	end

	if p == nil then
		return leadingIndex(list, direction) -- inferred equivalent call
	elseif direction == Enum.TextDirection.RightToLeft then
		for i = count, 1, -1 do
			local item = list[i]

			if item < p then
				return item
			end
		end

		return list[count]
	else
		for _, item in ipairs(list) do
			if p < item then
				return item
			end
		end

		return list[1]
	end
end

local function leadingEligible(p, p2) -- 1 equivalent call inferred from this helper
	local v = leadingIndex(scanRow(p, p2, nil), p2.direction) -- inferred equivalent call

	if v == nil then
		return nil
	end

	return p[v].id
end

local MarqueeEligibility = {}
MarqueeEligibility.DEFAULT_LOOPS = 2
MarqueeEligibility.loopKey = loopKey

function MarqueeEligibility.recordFinishedLoop(p, p2: string, p3: string)
	local v = loopKey(p2, p3) -- inferred equivalent call
	local v2 = p[v]
	p[v] = (v2 == nil and 2 or v2) - 1
end

MarqueeEligibility.reconcileFriendPresence = reconcileFriendPresence

function MarqueeEligibility.reconcilePresence(items, list)
	local idSet = {}

	for _, item in ipairs(list) do
		if item.tileType ~= Tile.Friend then
			continue
		end

		idSet[item.id] = true
		reconcileFriendPresence(items, item.id, inGameLocation(item)) -- inferred equivalent call
	end

	local v = {}

	for k in items do
		local v2 = friendIdFromLoopKey(k) -- inferred equivalent call

		if v2 ~= nil and idSet[v2] ~= true then
			table.insert(v, k)
		end
	end

	for _, v2 in v do
		items[v2] = nil
	end
end

MarqueeEligibility.isHoverEligible = isHoverEligible
MarqueeEligibility.leadingEligible = leadingEligible

function MarqueeEligibility.resolveActiveTileId(p, p2, p3: string?)
	if p3 ~= nil then
		local v, v2 = scanRow(p, p2, p3)

		if v2 ~= nil and table.find(v, v2) ~= nil then
			return p3
		end
	end

	return leadingEligible(p, p2) -- inferred equivalent call
end

function MarqueeEligibility.nextEligibleAfter(p, p2: string, p3)
	local v, v2 = scanRow(p, p3, p2)
	local v3 = nextIndex(v, v2, p3.direction)

	if v3 == nil then
		return nil
	end

	return p[v3].id
end

return MarqueeEligibility
