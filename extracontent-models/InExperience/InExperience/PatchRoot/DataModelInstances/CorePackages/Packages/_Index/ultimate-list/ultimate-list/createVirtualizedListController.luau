local ancestor = script:FindFirstAncestor("ultimate-list")
local DataSourceMethods = require(ancestor.DataSources.DataSourceMethods)

require(ancestor.DataSources)
require(ancestor.Dimensions)

local DimensionsMethods = require(ancestor.Dimensions.DimensionsMethods)
local binarySearchIndexRangeInView = require(script.binarySearchIndexRangeInView)
local createDebugLogger = require(ancestor.Util.createDebugLogger)
local exhaustiveMatch = require(ancestor.Util.exhaustiveMatch)
local v7 = createDebugLogger("createVirtualizedListController")

local function createVirtualizedListController(p1, p2, s1: string) -- line: 42
	-- upvalues: DimensionsMethods (copy), exhaustiveMatch (copy), v7 (copy), binarySearchIndexRangeInView (copy), DataSourceMethods (copy)
	local t1 = {
		scrollSizeAxis = 0,
		range = Vector3.new(),
		canvasSize = UDim2.new(),
		windowSize = Vector2.new(),
		lastDimensions = p2,
		cachedLastResult = {},
		dataSource = p1
	}
	local n1 = 0
	local n2 = 0
	local vector2 = Vector2.new()

	local function getIndexRangeInViewForSize(n3: number) -- line: 62
		-- upvalues: n1 (ref), n2 (ref)
		return (Vector3.new(n1 // n3 + 1, (n1 + n2) // n3 + 1))
	end
	local function getIndexRangeInViewForUDim2(uDim2: UDim2) -- line: 69
		-- upvalues: DimensionsMethods (copy), vector2 (ref), s1 (copy), exhaustiveMatch (copy), n1 (ref), n2 (ref), v7 (copy)
		local v27 = DimensionsMethods.getAmountPerNonDominantInGrid(uDim2, vector2, s1)
		local v28 = if s1 ~= "x" then if s1 ~= "y" then exhaustiveMatch(s1) else uDim2.Y.Offset else uDim2.X.Offset
		local v29 = 1 + n1 // v28 * v27
		local v30 = (1 + (n1 + n2) // v28) * v27

		v7("getIndexRangeInView: amountPerNonDominant = %d, scrollAxis = %d, dominantSize = %d. Going from %d to %d", v27, n1, v28, v29, v30)

		return (Vector3.new(v29, v30))
	end
	local function getIndexRangeInView() -- line: 97
		-- upvalues: p2 (ref), getIndexRangeInViewForUDim2 (copy), n1 (ref), n2 (ref), binarySearchIndexRangeInView (copy), p1 (ref), s1 (copy), exhaustiveMatch (copy)
		if p2.type == "consistentUDim2" then
			return (getIndexRangeInViewForUDim2(p2.udim2))
		end

		if p2.type == "consistentSize" then
			local size = p2.size

			return (Vector3.new(n1 // size + 1, (n1 + n2) // size + 1))
		end

		if p2.type == "getter" then
			return binarySearchIndexRangeInView(p1, p2.callback, n1, n2, s1)
		end

		if p2.type == "spaced" then
			if p2.inner.type == "consistentSize" then
				local v32 = p2.inner.size + p2.spacing

				return (Vector3.new(n1 // v32 + 1, (n1 + n2) // v32 + 1))
			end

			if p2.inner.type == "consistentUDim2" then
				return (getIndexRangeInViewForUDim2(p2.inner.udim2 + UDim2.fromOffset(s1 ~= "x" and 0 or p2.spacing, s1 ~= "y" and 0 or p2.spacing)))
			end

			if p2.inner.type == "spaced" or p2.inner.type == "getter" then
				error("Unsupported spaced dimensions")

				return
			end

			return exhaustiveMatch(p2.inner.type)
		end

		return exhaustiveMatch(p2.type)
	end

	local t2 = {}

	local function callUpdateCallbacks() -- line: 127
		-- upvalues: t2 (copy)
		for v33 in t2 do
			v33()
		end
	end
	local function update() -- line: 133
		-- upvalues: t1 (ref), n1 (ref), n2 (ref), vector2 (ref), p1 (ref), p2 (ref), getIndexRangeInView (copy), DataSourceMethods (copy), v7 (copy), t2 (copy), DimensionsMethods (copy), s1 (copy), exhaustiveMatch (copy)
		if t1.offsetBoundaries ~= nil and (t1.offsetBoundaries.X <= n1 and t1.offsetBoundaries.Y >= n2 + n1 and t1.windowSize == vector2 and t1.dataSource == p1 and t1.lastDimensions == p2) then
			return
		end

		local v34 = getIndexRangeInView()
		local v35 = DataSourceMethods.getByRange(p1, v34)

		if #v35 == 0 then
			v7("View changed, but no items in list")
			t1 = {
				range = v34,
				canvasSize = UDim2.new(),
				windowSize = vector2,
				lastDimensions = p2,
				cachedLastResult = {},
				offsetBoundaries = Vector3.new(n1, n2 + n1),
				dataSource = p1
			}

			for v36 in t2 do
				v36()
			end

			return
		end

		local v37 = DimensionsMethods.getUDimRect(p2, v35[1], v34.X, vector2, s1)
		local v38 = DimensionsMethods.getUDimRect(p2, v35[#v35], v34.Y, vector2, s1)

		v7("View changed: %d..%d (scroll axis: %d, window axis: %d, offset boundaries: %* - %*)", v34.X, v34.Y, n1, n2, t1.offsetBoundaries and t1.offsetBoundaries.X, t1.offsetBoundaries and t1.offsetBoundaries.Y)
		t1 = {
			range = v34,
			canvasSize = DimensionsMethods.getCanvasSize(p2, p1, vector2, s1),
			windowSize = vector2,
			lastDimensions = p2,
			cachedLastResult = v35,
			offsetBoundaries = Vector3.new(if s1 ~= "x" then if s1 ~= "y" then exhaustiveMatch(s1) else v37.position.Y.Offset else v37.position.X.Offset, if s1 ~= "x" then if s1 ~= "y" then exhaustiveMatch(s1) else v38.position.Y.Offset + v38.size.Y.Offset else v38.position.X.Offset + v38.size.X.Offset),
			dataSource = p1
		}

		for v39 in t2 do
			v39()
		end
	end

	local v24 = if p1.type ~= "mutableSource" then nil else p1.methods.bindToChanged(update)

	return {
		setScrollAxis = function(n4: number) -- line: 208
			-- upvalues: n1 (ref), update (copy)
			n1 = n4
			update()
		end,
		setDataSource = function(p3) -- line: 213
			-- upvalues: p1 (ref), DataSourceMethods (copy), update (copy)
			assert(p1.type == p3.type, "Data source type changed, you must keep it the same")

			if DataSourceMethods.equals(p1, p3) then
				return
			end

			p1 = p3
			update()
		end,
		setDimensions = function(p4) -- line: 224
			-- upvalues: DimensionsMethods (copy), p2 (ref), update (copy)
			if DimensionsMethods.equals(p2, p4) then
				return
			end

			p2 = p4
			update()
		end,
		setWindowSize = function(vector2_2: Vector2) -- line: 233
			-- upvalues: vector2 (ref), n2 (ref), DimensionsMethods (copy), s1 (copy), update (copy)
			if vector2_2 == vector2 then
				return
			end

			vector2 = vector2_2
			n2 = DimensionsMethods.getDominantAxis(vector2_2, s1)
			update()
		end,
		getWindowSize = function() -- line: 244
			-- upvalues: vector2 (ref)
			return vector2
		end,
		get = function() -- line: 248
			-- upvalues: t1 (ref)
			return t1.cachedLastResult
		end,
		getCanvasSize = function() -- line: 252
			-- upvalues: t1 (ref)
			return t1.canvasSize
		end,
		getRange = function() -- line: 256
			-- upvalues: t1 (ref)
			return t1.range
		end,
		bindToUpdate = function(p5: ((...any) -> ...any)) -- line: 260
			-- upvalues: t2 (copy)
			t2[p5] = true

			return function() -- line: 262
				-- upvalues: t2 (copy), p5 (copy)
				t2[p5] = nil
			end
		end,
		destroy = function() -- line: 271
			-- upvalues: v24 (copy)
			if v24 ~= nil then
				v24()
			end
		end
	}
end

return createVirtualizedListController
