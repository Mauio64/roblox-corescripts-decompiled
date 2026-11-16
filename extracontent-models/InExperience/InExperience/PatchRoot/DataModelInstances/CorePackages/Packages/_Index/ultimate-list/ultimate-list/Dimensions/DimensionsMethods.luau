local ultimatelist = script:FindFirstAncestor("ultimate-list")

local DataSourceMethods = require(ultimatelist.DataSources.DataSourceMethods)
require(ultimatelist.DataSources)
require(script.Parent)
local exhaustiveMatch = require(ultimatelist.Util.exhaustiveMatch)

local DimensionsMethods = {}

function DimensionsMethods.getCanvasSize(p, p2, vector2: Vector2, p3: string)
	local back = DataSourceMethods.back(p2)

	if back == nil then
		return UDim2.new()
	end

	local udimRect = DimensionsMethods.getUDimRect(p, back, DataSourceMethods.length(p2), vector2, p3)

	if p3 == "x" then
		return (UDim2.fromOffset(udimRect.position.X.Offset + udimRect.size.X.Offset, 0))
	elseif p3 == "y" then
		return (UDim2.fromOffset(0, udimRect.position.Y.Offset + udimRect.size.Y.Offset))
	end

	return (exhaustiveMatch(p3))
end

local function getUDimSizeForConsistentSize(size: number, p: string) -- 2 equivalent calls inferred from this helper
	if p == "x" then
		return UDim2.new(0, size, 1, 0)
	elseif p == "y" then
		return UDim2.new(1, 0, 0, size)
	end

	return exhaustiveMatch(p)
end

local function getPositionForConsistentSize(p: number, p2: number, p3: string) -- 2 equivalent calls inferred from this helper
	if p3 == "x" then
		return UDim2.fromOffset(p * (p2 - 1), 0)
	elseif p3 == "y" then
		return UDim2.fromOffset(0, p * (p2 - 1))
	end

	return exhaustiveMatch(p3)
end

local function getPositionForConsistentUDim2(udim: UDim2, p: number, vector2: Vector2, p2: string)
	local amountPerNonDominantInGrid = DimensionsMethods.getAmountPerNonDominantInGrid(udim, vector2, p2)

	if p2 == "x" then
		return UDim2.new(
			0,
			(math.ceil(p / amountPerNonDominantInGrid) - 1) * udim.X.Offset,
			udim.Y.Scale * ((p - 1) % amountPerNonDominantInGrid),
			udim.Y.Offset * ((p - 1) % amountPerNonDominantInGrid)
		)
	elseif p2 == "y" then
		return UDim2.new(
			udim.X.Scale * ((p - 1) % amountPerNonDominantInGrid),
			udim.X.Offset * ((p - 1) % amountPerNonDominantInGrid),
			0,
			(math.ceil(p / amountPerNonDominantInGrid) - 1) * udim.Y.Offset
		)
	end

	return exhaustiveMatch(p2)
end

function DimensionsMethods.getAmountPerNonDominantInGrid(udim: UDim2, vector2: Vector2, p: string)
	if p == "x" then
		return vector2.Y // (udim.Y.Offset + udim.Y.Scale * vector2.Y)
	elseif p == "y" then
		return vector2.X // (udim.X.Offset + udim.X.Scale * vector2.X)
	end

	return exhaustiveMatch(p)
end

function DimensionsMethods.getDominantAxis(vector2: Vector2, p: string)
	if p == "x" then
		return vector2.X
	elseif p == "y" then
		return vector2.Y
	end

	return exhaustiveMatch(p)
end

function DimensionsMethods.getUDimRect(data, p, p2: number, vector2: Vector2, p3: string)
	if data.type == "consistentSize" then
		return {
			size = getUDimSizeForConsistentSize(data.size, p3), -- inferred equivalent call
			position = getPositionForConsistentSize(data.size, p2, p3) -- inferred equivalent call
		}
	end

	if data.type == "consistentUDim2" then
		return {
			size = data.udim2,
			position = getPositionForConsistentUDim2(data.udim2, p2, vector2, p3)
		}
	end

	if data.type == "getter" then
		return data.callback(p, p2)
	end

	if data.type ~= "spaced" then
		return exhaustiveMatch(data.type)
	end

	if data.inner.type == "consistentSize" then
		return {
			size = getUDimSizeForConsistentSize(data.inner.size, p3), -- inferred equivalent call
			position = getPositionForConsistentSize(data.inner.size + data.spacing, p2, p3) -- inferred equivalent call
		}
	end

	if data.inner.type == "consistentUDim2" then
		return {
			size = data.inner.udim2,
			position = getPositionForConsistentUDim2(
				data.inner.udim2 + UDim2.fromOffset(p3 ~= "x" and 0 or data.spacing, p3 ~= "y" and 0 or data.spacing),
				p2,
				vector2,
				p3
			)
		}
	end

	if data.inner.type ~= "getter" and data.inner.type ~= "spaced" then
		return exhaustiveMatch(data.inner.type)
	end

	error("Unsupported spaced dimensions")
end

local function getElementsDisplayedForUDim2(udim: UDim2, vector2: Vector2, p: string)
	local amountPerNonDominantInGrid = DimensionsMethods.getAmountPerNonDominantInGrid(udim, vector2, p)

	if p == "x" then
		return amountPerNonDominantInGrid * (vector2.X // udim.Y.Offset + 2)
	elseif p == "y" then
		return amountPerNonDominantInGrid * (vector2.Y // udim.X.Offset + 2)
	end

	return exhaustiveMatch(p)
end

function DimensionsMethods.elementsDisplayedHint(data, vector2: Vector2, p: string)
	if data.type == "consistentSize" then
		return DimensionsMethods.getDominantAxis(vector2, p) // data.size + 2
	end

	if data.type == "consistentUDim2" then
		return getElementsDisplayedForUDim2(data.udim2, vector2, p)
	end

	if data.type == "getter" then
		return nil
	end

	if data.type ~= "spaced" then
		return exhaustiveMatch(data.type)
	end

	if data.inner.type == "consistentSize" then
		return DimensionsMethods.getDominantAxis(vector2, p) // (data.inner.size + data.spacing) + 2
	end

	if data.inner.type == "consistentUDim2" then
		return getElementsDisplayedForUDim2(
			data.inner.udim2 + UDim2.fromOffset(p ~= "x" and 0 or data.spacing, p ~= "y" and 0 or data.spacing),
			vector2,
			p
		)
	end

	if data.inner.type ~= "spaced" and data.inner.type ~= "getter" then
		return exhaustiveMatch(data.inner.type)
	end

	error("Unsupported spaced dimensions")
end

function DimensionsMethods.equals(data, data2)
	if data.type ~= data2.type then
		return false
	end

	if data.type == "getter" then
		assert(data2.type == "getter", "Luau")
		return data.callback == data2.callback
	end

	if data.type == "consistentSize" then
		assert(data2.type == "consistentSize", "Luau")
		return data.size == data2.size
	end

	if data.type == "consistentUDim2" then
		assert(data2.type == "consistentUDim2", "Luau")
		return data.udim2 == data2.udim2
	end

	if data.type ~= "spaced" then
		return exhaustiveMatch(data.type)
	end

	assert(data2.type == "spaced", "Luau")
	return data.spacing == data2.spacing
end

return DimensionsMethods
