local Graphing = script:FindFirstAncestor("Graphing")

local MathUtil = require(Graphing.Util.MathUtil)
local Types = require(Graphing.Types)

local GridUtil = {}

function GridUtil.getUniformValues(p, p2: number, p3: number, p4)
	if p3 < p2 then
		p3, p2 = p2, p3
	end

	local unit = p.Unit
	local offset = p.Offset or 0

	local uniformValues = {}

	for i = math.ceil((p2 - offset) / unit - unit * 1e-9), math.floor((p3 - offset) / unit + unit * 1e-9) do
		local v = offset + i * unit

		if not p4[v] then
			table.insert(uniformValues, v)
		end
	end

	return uniformValues
end

function GridUtil.getLogarithmicValues(data, p: number, p2: number, list)
	if p2 < p then
		p2, p = p, p2
	end

	local base = data.Base
	local subdivision = data.Subdivision or 0
	local v = math.max(data.MinExponent or -10, MathUtil.log(base, p))
	local v2 = math.max(v, MathUtil.log(base, p2))
	local v3 = 0
	local logarithmicValues = {}

	for i = math.floor(v), math.ceil(v2) do
		local v4 = math.pow(base, i + 1 - subdivision)

		for j = math.pow(base, i), math.pow(base, i + 1), v4 do
			if p2 < j then
				break
			end

			if j < p or j == v3 then
				continue
			end

			if not list[j] then
				table.insert(logarithmicValues, j)
			end

			v3 = j
		end
	end

	return logarithmicValues
end

function GridUtil.getValuesValues(p, p2: number, p3: number, p4)
	local valuesValues = {}

	for _, value in p.Values do
		if not (p2 <= value) or not (value <= p3) or p4[value] then
			continue
		end

		table.insert(valuesValues, value)
	end

	return valuesValues
end

function GridUtil.getValues(p, p2, p3, items)
	local set = {}

	if items then
		for _, item in items do
			set[item] = true
		end
	end

	local viewportRect = p3.getViewportRect()
	local v

	if p == Types.AXIS_X then
		v = viewportRect.Min.X
	else
		v = viewportRect.Min.Y
	end

	local v2

	if p == Types.AXIS_X then
		v2 = viewportRect.Max.X
	else
		v2 = viewportRect.Max.Y
	end

	if p2.Type == Types.SCALE_UNIFORM then
		return (GridUtil.getUniformValues(p2, v, v2, set))
	end

	if p2.Type == Types.SCALE_LOGARITHMIC then
		return (GridUtil.getLogarithmicValues(p2, v, v2, set))
	end

	if p2.Type == Types.SCALE_VALUES then
		return (GridUtil.getValuesValues(p2, v, v2, set))
	end

	assert(false, `Axis schema {p2.Type} not supported`)
	return {}
end

function GridUtil.trimRoundingError(p: number)
	local v = string.format("%.10f", p):gsub("^0*(.-)%.?0*$", "%1")

	if v == "" or v:sub(1, 1) == "." then
		return "0" .. v
	end

	return v
end

function GridUtil.getAnchorPointForSide(p)
	if p == Types.SIDE_LEFT then
		return Vector2.new(1, 0.5)
	end

	if p == Types.SIDE_RIGHT then
		return Vector2.new(0, 0.5)
	end

	if p == Types.SIDE_TOP then
		return Vector2.new(0.5, 1)
	end

	if p == Types.SIDE_BOTTOM then
		return Vector2.new(0.5, 0)
	end

	assert(false, `Side {p} not supported`)
end

function GridUtil.getTextAlignmentsFromAnchorPoint(vector2: Vector2)
	local v

	if vector2.X == 0 then
		v = Enum.TextXAlignment.Left
	elseif vector2.X == 1 then
		v = Enum.TextXAlignment.Right
	else
		v = Enum.TextXAlignment.Center
	end

	if vector2.Y == 0 then
		return v, Enum.TextYAlignment.Top
	end

	if vector2.Y == 1 then
		return v, Enum.TextYAlignment.Bottom
	end

	return v, Enum.TextYAlignment.Center
end

return GridUtil
