local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Map = LuauPolyfill.Map
local Set = LuauPolyfill.Set
local Object = LuauPolyfill.Object
local console = LuauPolyfill.console
local setTimeout = LuauPolyfill.setTimeout
local clearTimeout = LuauPolyfill.clearTimeout
local invariant = require(ParentParent.jsUtils.invariant)
local _isEntirelyVisible = nil
local _getPixelsVisible = nil
local _isViewable = nil
local t1 = {}

t1.__index = t1

function t1.new(t2: {[any]: any}?) -- line: 146
	-- upvalues: t1 (copy), Set (copy), Map (copy)
	local self = setmetatable({}, t1)

	if t2 == nil then
		t2 = {
			viewAreaCoveragePercentThreshold = 0
		}
	end

	self._hasInteracted = false
	self._timers = Set.new()
	self._viewableIndices = {}
	self._viewableItems = Map.new()
	self._config = t2

	return self
end
function t1.dispose(p1) -- line: 159
	-- upvalues: clearTimeout (copy)
	p1._timers:forEach(function(p2) -- line: 163
		-- upvalues: clearTimeout (copy)
		clearTimeout(p2)
	end)
end
function t1.computeViewableItems(t3: {[any]: any}, n1: number, n2: number, n3: number, p3: ((...any) -> ...any), p4) -- line: 168
	-- upvalues: invariant (copy), console (copy), _isViewable (ref)
	local itemVisiblePercentThreshold = t3._config.itemVisiblePercentThreshold
	local viewAreaCoveragePercentThreshold = t3._config.viewAreaCoveragePercentThreshold
	local v27 = viewAreaCoveragePercentThreshold ~= nil
	local v28 = if not v27 then itemVisiblePercentThreshold else viewAreaCoveragePercentThreshold

	invariant(v28 ~= nil and itemVisiblePercentThreshold ~= nil ~= (viewAreaCoveragePercentThreshold ~= nil), "Must set exactly one of itemVisiblePercentThreshold or viewAreaCoveragePercentThreshold")

	local t4 = {}

	if n1 == 0 then
		return t4
	end

	local n4 = 0
	local v31 = p4 or {
		first = 1,
		last = n1
	}
	local first = v31.first
	local last = v31.last

	if n1 < last then
		console.warn("Invalid render range computing viewability { renderRange = " .. tostring(p4) .. ", itemCount = " .. tostring(n1) .. " }")

		return {}
	end

	while first <= last do
		local v34 = p3(first)

		if not v34 then
			first += 1

			continue
		end

		local v35 = v34.offset - n2
		local v36 = v35 + v34.length

		if v35 < n3 and v36 > 0 then
			n4 = first

			if _isViewable(v27, v28, v35, v36, n3, v34.length) then
				table.insert(t4, first)
			end
		elseif n4 >= 1 then
			return t4
		end

		first += 1
	end

	return t4
end
function t1.onUpdate(t5: {[any]: any}, n5: number, n6: number, n7: number, p5: ((...any) -> ...any), p6: ((...any) -> ...any), p7: ((...any) -> ...any), p8) -- line: 245
	-- upvalues: Array (copy), setTimeout (copy)
	if t5._config.waitForInteraction and not t5._hasInteracted or (n5 == 0 or not p5(1)) then
		return
	end

	local t6 = {}

	if n5 then
		t6 = t5:computeViewableItems(n5, n6, n7, p5, p8)
	end

	if #t5._viewableIndices == #t6 and Array.every(t5._viewableIndices, function(p9, p10) -- line: 278
		-- upvalues: t6 (ref)
		return p9 == t6[p10]
	end) then
		return
	end

	t5._viewableIndices = t6

	if t5._config.minimumViewTime then
		local u46 = nil

		u46 = setTimeout(function() -- line: 289
			-- upvalues: t5 (copy), u46 (ref), t6 (ref), p7 (copy), p6 (copy)
			t5._timers:delete(u46)
			t5:_onUpdateSync(t6, p7, p6)
		end, t5._config.minimumViewTime)
		t5._timers:add(u46)
	else
		t5:_onUpdateSync(t6, p7, p6)
	end
end
function t1.resetViewableIndices(p11) -- line: 305
	p11._viewableIndices = {}
end
function t1.recordInteraction(p12) -- line: 309
	p12._hasInteracted = true
end
function t1._onUpdateSync(p13, p14, p15, p16) -- line: 313
	-- upvalues: Array (copy), Map (copy), Object (copy)
	local v53 = Array.filter(p14, function(p17) -- line: 315
		-- upvalues: Array (copy), p13 (copy)
		return Array.includes(p13._viewableIndices, p17)
	end)
	local _viewableItems = p13._viewableItems
	local v55 = Map.new(Array.map(v53, function(p18) -- line: 319
		-- upvalues: p16 (copy)
		local v80 = p16(p18, true)

		return {
			v80.key,
			v80
		}
	end))
	local t7 = {}

	for _, v in ipairs(v55:keys()) do
		if not _viewableItems:has(v) then
			table.insert(t7, v55:get(v))
		end
	end

	for _, v in ipairs(_viewableItems:keys()) do
		if not v55:has(v) then
			local v61 = _viewableItems:get(v)

			table.insert(t7, Object.assign({}, v61, {
				isViewable = false
			}))
		end
	end

	if #t7 > 0 then
		p13._viewableItems = v55
		p15({
			viewableItems = Array.from(v55:values()),
			changed = t7,
			viewabilityConfig = p13._config
		})
	end
end
function _isViewable(b1: boolean, n8: number, n9: number, n10: number, n11: number, n12: number) -- line: 345
	-- upvalues: _isEntirelyVisible (ref), _getPixelsVisible (ref)
	if _isEntirelyVisible(n9, n10, n11) then
		return true
	end

	local v68 = _getPixelsVisible(n9, n10, n11)

	return n8 <= 100 * if not b1 then v68 / n12 else v68 / n11
end
function _getPixelsVisible(n13: number, n14: number, n15: number) -- line: 362
	return (math.max(0, math.min(n14, n15) - math.max(n13, 0)))
end
function _isEntirelyVisible(n16: number, n17: number, n18: number) -- line: 367
	return n16 >= 0 and (n17 <= n18 and n16 < n17)
end

return t1
