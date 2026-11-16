local parent = script.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Error = LuauPolyfill.Error

local HttpService = game:GetService("HttpService")

local invariant = require(parent.jsUtils.invariant)

local function elementsThatOverlapOffsets(list, p: number, callback)
	local result = {}
	local count = 0

	for i = 1, p do
		local v = callback(i)
		local v2 = v.offset + v.length

		for j = 1, #list do
			if not (result[j] == nil and list[j] <= v2) then
				continue
			end

			result[j] = i
			count += 1

			if j == #list then
				if count ~= #list then
					invariant(
						count == #list,
						"bad offsets input, should be in increasing order: %s",
						HttpService:JSONEncode(list)
					)
				end

				return result
			end
		end
	end

	return result
end

local VirtualizeUtils = {}
VirtualizeUtils.elementsThatOverlapOffsets = elementsThatOverlapOffsets

local function newRangeCount(p, p2) -- 1 equivalent call inferred from this helper
	return p2.last - p2.first + 1 - math.max(0, math.min(p2.last, p.last) + 1 - math.max(p2.first, p.first))
end

VirtualizeUtils.newRangeCount = newRangeCount

function VirtualizeUtils.computeWindowedRenderLimits(p, callback, p2: number, p3: number, p4, callback2, data)
	local v = callback(p)

	if v == 0 then
		return p4
	end

	local offset = data.offset
	local velocity = data.velocity
	local visibleLength = data.visibleLength

	local v2 = math.max(0, offset)
	local v3 = v2 + visibleLength
	local v4 = (p3 - 1) * visibleLength

	local v5 = velocity > 1 and "after" or velocity < -1 and "before" or "none"
	local v6 = math.max(0, v2 - 0.5 * v4)
	local v7 = math.max(0, v3 + 0.5 * v4)

	if callback2(v).offset < v6 then
		return {
			first = math.max(1, v - p2),
			last = v
		}
	end

	local v8, first, last, overscanLast = table.unpack(
		elementsThatOverlapOffsets({ v6, v2, v3, v7 }, v, callback2),
		1,
		4
	)

	local overscanFirst = v8 == nil and 1 or v8

	if first == nil then
		first = math.max(1, overscanFirst)
	end

	if overscanLast == nil then
		overscanLast = v
	end

	if last == nil then
		last = math.min(overscanLast, first + p2 - 1)
	end

	local visible = { first = first, last = last }
	local rangeCount = newRangeCount(p4, visible) -- inferred equivalent call

	while not (first <= overscanFirst and overscanLast <= last) do
		local v9 = p2 <= rangeCount
		local v10 = first <= p4.first or p4.last < first
		local v11

		if overscanFirst < first then
			v11 = not (v9 and v10)
		else
			v11 = false
		end

		local v12 = p4.last <= last or last < p4.first
		local v13

		if last < overscanLast then
			v13 = not (v9 and v12)
		else
			v13 = false
		end

		if v9 and not (v11 or v13) then
			break
		end

		if v11 and (v5 ~= "after" or not (v13 and v12)) then
			if v10 then
				rangeCount += 1
			end

			first -= 1
		end

		if not (v13 and (v5 ~= "before" or not (v11 and v10))) then
			continue
		end

		if v12 then
			rangeCount += 1
		end

		last += 1
	end

	if not (first <= last and first >= 1 and last <= v and overscanFirst <= first and last <= overscanLast and first <= visible.first and visible.last <= last) then
		error(Error.new("Bad window calculation " .. HttpService:JSONEncode({
			first = first,
			last = last,
			itemCount = v,
			overscanFirst = overscanFirst,
			overscanLast = overscanLast,
			visible = visible
		})))
	end

	return { first = first, last = last }
end

function VirtualizeUtils.keyExtractor(p, p2: number)
	if typeof(p) == "table" and p.key ~= nil then
		return p.key
	end

	if typeof(p) == "table" and p.id ~= nil then
		return p.id
	end

	return (tostring(p2))
end
return VirtualizeUtils
