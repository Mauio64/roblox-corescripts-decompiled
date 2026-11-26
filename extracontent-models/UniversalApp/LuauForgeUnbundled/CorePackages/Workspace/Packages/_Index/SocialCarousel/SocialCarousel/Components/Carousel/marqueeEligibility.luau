local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SocialCommon")

local Enums = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Common/Enums")
local tileVisibility = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Components/Carousel/tileVisibility")

local presenceTypes = SocialCommon.Enums.PresenceTypes
local tile = Enums.Tile

local function loopsLeft(p2, p3, p4)
	if p4 == nil then
		return 2
	end

	local v5 = p4[p2 .. "\0" .. p3]

	if v5 == nil then
		return 2
	end

	return v5
end

local function storedLoopKeys(items, p2)
	local v5 = p2 .. "\0"
	local result = {}

	for k in items do
		if string.sub(k, 1, #v5) == v5 then
			table.insert(result, k)
		end
	end

	return result
end

local function reconcileFriendPresence(p2, p3, p4)
	local v5 = storedLoopKeys(p2, p3)

	if p4 == nil or p4 == "" then
		for k, v6 in v5 do
			p2[v6] = nil
		end
	else
		local v6 = p3 .. "\0" .. p4

		local v7 = p2[v6] ~= nil

		for k, v8 in v5 do
			if v8 ~= v6 then
				p2[v8] = nil
			end
		end

		if not v7 then
			p2[v6] = 2
		end
	end
end

local function inGameLocation(p2)
	if p2.tileType ~= tile.Friend then
		return nil
	end

	local presence = p2.presence

	if presence == nil or presence.userPresenceType ~= presenceTypes.InGame then
		return nil
	end

	local lastLocation = presence.lastLocation

	if lastLocation == nil or lastLocation == "" then
		return nil
	end

	return lastLocation
end

local function friendIdFromLoopKey(value)
	local v5 = string.find(value, "\0", 1, true)

	if v5 == nil then
		return nil
	end

	return (string.sub(value, 1, v5 - 1))
end

local function isEligible(data, i, data2)
	local v5

	if data.tileType == tile.Friend then
		local presence = data.presence

		if presence == nil or presence.userPresenceType ~= presenceTypes.InGame then
			v5 = false
		else
			local lastLocation = presence.lastLocation
			v5 = lastLocation ~= nil and lastLocation ~= "" and data.subtitle == lastLocation
		end
	else
		v5 = false
	end

	if not v5 then
		return false
	end

	local presence = data.presence
	local lastLocation = if presence ~= nil then presence.lastLocation else nil

	if lastLocation == nil then
		return false
	end

	local id = data.id
	local loopsRemaining = data2.loopsRemaining
	local v6

	if loopsRemaining == nil then
		v6 = 2
	else
		local v7 = loopsRemaining[id .. "\0" .. lastLocation]

		v6 = v7 == nil and 2 or v7
	end

	if not (v6 <= 0) then
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

local function scanRow(list, p2, p3)
	local result = {}
	local v5 = nil

	if p2.interacting or p2.reducedMotion then
		return result, nil
	end

	for i, item in ipairs(list) do
		if p3 ~= nil and v5 == nil and item.id == p3 then
			v5 = i
		end

		if isEligible(item, i, p2) then
			table.insert(result, i)
		end
	end

	return result, v5
end

local function leadingIndex(list, p2)
	local count = #list

	if count == 0 then
		return nil
	end

	if p2 == Enum.TextDirection.RightToLeft then
		return list[count]
	end

	return list[1]
end

local function nextIndex(list, p2, direction)
	local count = #list

	if count == 0 then
		return nil
	end

	if p2 == nil then
		local count2 = #list

		if count2 == 0 then
			return nil
		end

		if direction == Enum.TextDirection.RightToLeft then
			return list[count2]
		end

		return list[1]
	elseif direction == Enum.TextDirection.RightToLeft then
		for i = count, 1, -1 do
			local item = list[i]

			if item < p2 then
				return item
			end
		end

		return list[count]
	else
		for i, item in ipairs(list) do
			if p2 < item then
				return item
			end
		end

		return list[1]
	end
end

return {
	DEFAULT_LOOPS = 2,
	loopKey = function(p2, p3)
		return p2 .. "\0" .. p3
	end,
	recordFinishedLoop = function(p2, p3, p4)
		local v5 = p3 .. "\0" .. p4

		local v6 = p2[v5]
		p2[v5] = (v6 == nil and 2 or v6) - 1
	end,
	reconcileFriendPresence = reconcileFriendPresence,
	reconcilePresence = function(items, list)
		local idSet = {}

		for i, item in ipairs(list) do
			if item.tileType ~= tile.Friend then
				continue
			end

			idSet[item.id] = true
			local id = item.id
			local lastLocation

			if item.tileType == tile.Friend then
				local presence = item.presence

				if not (presence == nil or presence.userPresenceType ~= presenceTypes.InGame) then
					lastLocation = presence.lastLocation

					if lastLocation == nil or lastLocation == "" then
						lastLocation = nil
					end
				end
			end

			reconcileFriendPresence(items, id, lastLocation)
		end

		local v5 = {}

		for k in items do
			local v6 = string.find(k, "\0", 1, true)

			local v7 = if v6 ~= nil then string.sub(k, 1, v6 - 1) else nil

			if v7 ~= nil and idSet[v7] ~= true then
				table.insert(v5, k)
			end
		end

		for k, v6 in v5 do
			items[v6] = nil
		end
	end,
	isHoverEligible = function(data): boolean
		if data.tileType ~= tile.Friend then
			return false
		end

		local presence = data.presence

		if presence == nil or presence.userPresenceType ~= presenceTypes.InGame then
			return false
		end

		local lastLocation = presence.lastLocation
		return lastLocation ~= nil and lastLocation ~= "" and data.subtitle == lastLocation
	end,
	leadingEligible = function(p2, p3)
		local v5 = scanRow(p2, p3, nil)
		local direction = p3.direction
		local count = #v5
		local v6

		if count ~= 0 then
			v6 = if direction == Enum.TextDirection.RightToLeft then v5[count] else v5[1]
		end

		if v6 == nil then
			return nil
		end

		return p2[v6].id
	end,
	resolveActiveTileId = function(p2, p3, p4)
		if p4 ~= nil then
			local v5, v6 = scanRow(p2, p3, p4)

			if v6 ~= nil and table.find(v5, v6) ~= nil then
				return p4
			end
		end

		local v5 = scanRow(p2, p3, nil)
		local direction = p3.direction
		local count = #v5
		local v6

		if count ~= 0 then
			v6 = if direction == Enum.TextDirection.RightToLeft then v5[count] else v5[1]
		end

		if v6 == nil then
			return nil
		end

		return p2[v6].id
	end,
	nextEligibleAfter = function(p2, p3, p4)
		local v5, v6 = scanRow(p2, p4, p3)
		local v7 = nextIndex(v5, v6, p4.direction)

		if v7 == nil then
			return nil
		end

		return p2[v7].id
	end
}
