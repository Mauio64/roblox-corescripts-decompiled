local ultimatelist = script:FindFirstAncestor("ultimate-list")

local DataSourceMethods = require(ultimatelist.DataSources.DataSourceMethods)
require(ultimatelist.DataSources)
require(ultimatelist.Dimensions)
local DimensionsMethods = require(ultimatelist.Dimensions.DimensionsMethods)
local binarySearchIndexRangeInView = require(script.binarySearchIndexRangeInView)
local createDebugLogger = require(ultimatelist.Util.createDebugLogger)
local exhaustiveMatch = require(ultimatelist.Util.exhaustiveMatch)

local debugLogger = createDebugLogger("createVirtualizedListController")

local function createVirtualizedListController(dataSource, lastDimensions, p: string)
	local v = {
		range = 0,
		canvasSize = 0,
		windowSize = 0,
		lastDimensions = 0,
		scrollSizeAxis = 0,
		cachedLastResult = 0,
		dataSource = 0
	}
	v.range = Vector3.new()
	v.canvasSize = UDim2.new()
	v.windowSize = Vector2.new()
	v.lastDimensions = lastDimensions

	v.cachedLastResult = {}
	v.dataSource = dataSource

	local v2 = 0

	local v3 = 0
	local windowSize = Vector2.new()
	local v4 = 0

	local function getRangeAxes() -- 2 equivalent calls inferred from this helper
		local v5 = math.max(0, v2 - v4)
		return v5, v2 + v3 + v4 - v5
	end

	local function getIndexRangeInViewForSize(p2: number, rangeAxes: number, p3: number) -- 2 equivalent calls inferred from this helper
		return (Vector3.new(rangeAxes // p2 + 1, (rangeAxes + p3) // p2 + 1))
	end

	local function getIndexRangeInViewForUDim2(udim: UDim2, rangeAxes: number, p2: number)
		local amountPerNonDominantInGrid = DimensionsMethods.getAmountPerNonDominantInGrid(udim, windowSize, p)
		local v5

		if p == "x" then
			v5 = udim.X.Offset
		elseif p == "y" then
			v5 = udim.Y.Offset
		else
			v5 = exhaustiveMatch(p)
		end

		local v6 = 1 + rangeAxes // v5 * amountPerNonDominantInGrid
		local v7 = (1 + (rangeAxes + p2) // v5) * amountPerNonDominantInGrid

		debugLogger(
			"getIndexRangeInView: amountPerNonDominant = %d, scrollAxis = %d, dominantSize = %d. Going from %d to %d",
			amountPerNonDominantInGrid,
			rangeAxes,
			v5,
			v6,
			v7
		)

		return (Vector3.new(v6, v7))
	end

	local function getIndexRangeInView()
		local rangeAxes, v5 = getRangeAxes() -- inferred equivalent call

		if lastDimensions.type == "consistentUDim2" then
			return getIndexRangeInViewForUDim2(lastDimensions.udim2, rangeAxes, v5)
		end

		if lastDimensions.type == "consistentSize" then
			return getIndexRangeInViewForSize(lastDimensions.size, rangeAxes, v5) -- inferred equivalent call
		end

		if lastDimensions.type == "getter" then
			return binarySearchIndexRangeInView(dataSource, lastDimensions.callback, rangeAxes, v5, p)
		end

		if lastDimensions.type ~= "spaced" then
			return exhaustiveMatch(lastDimensions.type)
		end

		if lastDimensions.inner.type == "consistentSize" then
			return getIndexRangeInViewForSize(lastDimensions.inner.size + lastDimensions.spacing, rangeAxes, v5) -- inferred equivalent call
		end

		if lastDimensions.inner.type == "consistentUDim2" then
			return getIndexRangeInViewForUDim2(
				lastDimensions.inner.udim2 + UDim2.fromOffset(
					p ~= "x" and 0 or lastDimensions.spacing,
					p ~= "y" and 0 or lastDimensions.spacing
				),
				rangeAxes,
				v5
			)
		end

		if lastDimensions.inner.type ~= "spaced" and lastDimensions.inner.type ~= "getter" then
			return exhaustiveMatch(lastDimensions.inner.type)
		end

		error("Unsupported spaced dimensions")
	end

	local v5 = {}

	local function callUpdateCallbacks() -- 2 equivalent calls inferred from this helper
		for k in v5 do
			k()
		end
	end

	local function update()
		local rangeAxes, v6 = getRangeAxes() -- inferred equivalent call

		if v.offsetBoundaries ~= nil and v.offsetBoundaries.X <= rangeAxes then
			local y = v.offsetBoundaries.Y

			if
				v6 + rangeAxes <= y
				and v.windowSize == windowSize
				and v.dataSource == dataSource
				and v.lastDimensions == lastDimensions
			then
				return
			end
		end

		local indexRangeInView = getIndexRangeInView()
		local cachedLastResult = DataSourceMethods.getByRange(dataSource, indexRangeInView)

		if #cachedLastResult == 0 then
			debugLogger("View changed, but no items in list")

			v = {
				range = indexRangeInView,
				canvasSize = DimensionsMethods.getCanvasSize(lastDimensions, dataSource, windowSize, p),
				windowSize = windowSize,
				lastDimensions = lastDimensions,
				cachedLastResult = {},
				offsetBoundaries = Vector3.new(rangeAxes, v6 + rangeAxes),
				dataSource = dataSource
			}
			callUpdateCallbacks() -- inferred equivalent call
		else
			local udimRect = DimensionsMethods.getUDimRect(
				lastDimensions,
				cachedLastResult[1],
				indexRangeInView.X,
				windowSize,
				p
			)

			local udimRect2 = DimensionsMethods.getUDimRect(
				lastDimensions,
				cachedLastResult[#cachedLastResult],
				indexRangeInView.Y,
				windowSize,
				p
			)

			debugLogger(
				"View changed: %d..%d (scroll axis: %d, window axis: %d, offset boundaries: %* - %*)",
				indexRangeInView.X,
				indexRangeInView.Y,
				v2,
				v3,
				v.offsetBoundaries and v.offsetBoundaries.X,
				v.offsetBoundaries and v.offsetBoundaries.Y
			)

			local v7 = {
				range = indexRangeInView,
				canvasSize = DimensionsMethods.getCanvasSize(lastDimensions, dataSource, windowSize, p),
				windowSize = windowSize,
				lastDimensions = lastDimensions,
				cachedLastResult = cachedLastResult,
				offsetBoundaries = 0,
				dataSource = 0
			}
			local v8

			if p == "x" then
				v8 = udimRect.position.X.Offset
			elseif p == "y" then
				v8 = udimRect.position.Y.Offset
			else
				v8 = exhaustiveMatch(p)
			end

			local v9

			if p == "x" then
				v9 = udimRect2.position.X.Offset + udimRect2.size.X.Offset
			elseif p == "y" then
				v9 = udimRect2.position.Y.Offset + udimRect2.size.Y.Offset
			else
				v9 = exhaustiveMatch(p)
			end

			v7.offsetBoundaries = Vector3.new(v8, v9)

			v7.dataSource = dataSource
			v = v7
			callUpdateCallbacks() -- inferred equivalent call
		end
	end

	local function setScrollAxis(p2: number)
		v2 = p2
		update()
	end

	local function setDataSource(p2)
		assert(dataSource.type == p2.type, "Data source type changed, you must keep it the same")

		if DataSourceMethods.equals(dataSource, p2) then
			return
		end

		dataSource = p2
		update()
	end

	local function setDimensions(p2)
		if DimensionsMethods.equals(lastDimensions, p2) then
			return
		end

		lastDimensions = p2
		update()
	end

	local function setWindowSize(vector2: Vector2)
		if windowSize == vector2 then
			return
		end

		windowSize = vector2
		v3 = DimensionsMethods.getDominantAxis(vector2, p)

		update()
	end

	local function getWindowSize()
		return windowSize
	end

	local function setOverscan(p2: number)
		assert(p2 >= 0, "overscan must not be negative")

		if v4 == p2 then
			return
		end

		v4 = p2
		update()
	end

	local function get()
		return v.cachedLastResult
	end

	local function getCanvasSize()
		return v.canvasSize
	end

	local function getRange()
		return v.range
	end

	local v6

	if dataSource.type == "mutableSource" then
		v6 = dataSource.methods.bindToChanged(update)
	else
		v6 = nil
	end

	return {
		setScrollAxis = setScrollAxis,
		setDataSource = setDataSource,
		setDimensions = setDimensions,
		setWindowSize = setWindowSize,
		getWindowSize = getWindowSize,
		setOverscan = setOverscan,
		get = get,
		getCanvasSize = getCanvasSize,
		getRange = getRange,
		bindToUpdate = function(callback)
			v5[callback] = true
			return function()
				v5[callback] = nil
			end
		end,
		destroy = function()
			if v6 ~= nil then
				v6()
			end
		end
	}
end

return createVirtualizedListController
