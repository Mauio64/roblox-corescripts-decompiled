local parent = script.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Map = LuauPolyfill.Map
local Set = LuauPolyfill.Set
local Object = LuauPolyfill.Object
local console = LuauPolyfill.console
local setTimeout = LuauPolyfill.setTimeout
local clearTimeout = LuauPolyfill.clearTimeout
local invariant = require(parent.jsUtils.invariant)

local _isEntirelyVisible
local _getPixelsVisible
local _isViewable

local ViewabilityHelper = {}
ViewabilityHelper.__index = ViewabilityHelper
function ViewabilityHelper.new(p)
	local self = setmetatable({}, ViewabilityHelper)
	local config = p == nil and { viewAreaCoveragePercentThreshold = 0 } or p

	self._hasInteracted = false
	self._timers = Set.new()
	self._viewableIndices = {}
	self._viewableItems = Map.new()
	self._config = config
	return self
end

function ViewabilityHelper:dispose()
	self._timers:forEach(function(p)
		clearTimeout(p)
	end)
end

function ViewabilityHelper:computeViewableItems(last2: number, p: number, p2: number, callback, p3)
	local itemVisiblePercentThreshold = self._config.itemVisiblePercentThreshold
	local viewAreaCoveragePercentThreshold = self._config.viewAreaCoveragePercentThreshold
	local v = viewAreaCoveragePercentThreshold ~= nil
	local v2

	if v then
		v2 = viewAreaCoveragePercentThreshold
	else
		v2 = itemVisiblePercentThreshold
	end

	invariant(
		v2 ~= nil and (itemVisiblePercentThreshold ~= nil) ~= (viewAreaCoveragePercentThreshold ~= nil),
		"Must set exactly one of itemVisiblePercentThreshold or viewAreaCoveragePercentThreshold"
	)

	local firsts = {}

	if last2 == 0 then
		return firsts
	end

	local v3 = p3 or { first = 1, last = last2 }
	local first = v3.first
	local last = v3.last

	if last2 < last then
		console.warn("Invalid render range computing viewability { renderRange = " .. tostring(p3) .. ", itemCount = " .. tostring(last2) .. " }")

		return {}
	end

	local v4 = 0

	while first <= last do
		local v5 = callback(first)

		if v5 then
			local v6 = v5.offset - p
			local v7 = v6 + v5.length

			if v6 < p2 and v7 > 0 then
				if _isViewable(v, v2, v6, v7, p2, v5.length) then
					table.insert(firsts, first)
				end

				v4 = first
			elseif v4 >= 1 then
				break
			end
		end

		first += 1
	end

	return firsts
end

function ViewabilityHelper:onUpdate(p: number, p2: number, p3: number, callback, callback2, callback3, p4)
	if self._config.waitForInteraction and not self._hasInteracted or p == 0 or not callback(1) then
		return
	end

	local viewableIndices = not p and {} or self:computeViewableItems(p, p2, p3, callback, p4)

	if #self._viewableIndices == #viewableIndices and Array.every(self._viewableIndices, function(p5, p6): boolean
		return p5 == viewableIndices[p6]
	end) then
		return
	end

	self._viewableIndices = viewableIndices

	if self._config.minimumViewTime then
		local v = nil
		v = setTimeout(function()
			self._timers:delete(v)
			self:_onUpdateSync(viewableIndices, callback3, callback2)
		end, self._config.minimumViewTime)

		self._timers:add(v)
	else
		self:_onUpdateSync(viewableIndices, callback3, callback2)
	end
end

function ViewabilityHelper:resetViewableIndices()
	self._viewableIndices = {}
end

function ViewabilityHelper:recordInteraction()
	self._hasInteracted = true
end

function ViewabilityHelper:_onUpdateSync(p, callback, callback2)
	local filtered = Array.filter(p, function(p2)
		return Array.includes(self._viewableIndices, p2)
	end)

	local viewableItems = self._viewableItems
	local viewableItems2 = Map.new(Array.map(filtered, function(p2)
		local v = callback2(p2, true)
		return { v.key, v }
	end))

	local changed = {}

	for _, v in ipairs(viewableItems2:keys()) do
		if not viewableItems:has(v) then
			table.insert(changed, viewableItems2:get(v))
		end
	end

	for _, v in ipairs(viewableItems:keys()) do
		if viewableItems2:has(v) then
			continue
		end

		local v2 = viewableItems:get(v)
		table.insert(changed, Object.assign({}, v2, { isViewable = false }))
	end

	if #changed > 0 then
		self._viewableItems = viewableItems2
		callback({
			viewableItems = Array.from(viewableItems2:values()),
			changed = changed,
			viewabilityConfig = self._config
		})
	end
end

_isViewable = function(flag: boolean, p: number, p2: number, p3: number, p4: number, length: number): boolean
	if _isEntirelyVisible(p2, p3, p4) then
		return true
	end

	local v = _getPixelsVisible(p2, p3, p4)
	local v2

	if flag then
		v2 = v / p4
	else
		v2 = v / length
	end

	return p <= 100 * v2
end

_getPixelsVisible = function(p: number, p2: number, p3: number)
	return (math.max(0, math.min(p2, p3) - math.max(p, 0)))
end

_isEntirelyVisible = function(p: number, p2: number, p3: number): boolean
	return p >= 0 and p2 <= p3 and p < p2
end

return ViewabilityHelper
