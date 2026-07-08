local ancestor = script:FindFirstAncestor("ultimate-list")
local DataSourceMethods = require(ancestor.DataSources.DataSourceMethods)

require(ancestor.DataSources)
require(script.Parent)

local exhaustiveMatch = require(ancestor.Util.exhaustiveMatch)
local t1 = {}

function t1.getCanvasSize(p1, p2, vector2: Vector2, s1: string) -- line: 11
	-- upvalues: DataSourceMethods (copy), t1 (copy), exhaustiveMatch (copy)
	local v13 = DataSourceMethods.back(p2)

	if v13 == nil then
		return UDim2.new()
	end

	local v14 = t1.getUDimRect(p1, v13, DataSourceMethods.length(p2), vector2, s1)

	if s1 == "x" then
		return (UDim2.fromOffset(v14.position.X.Offset + v14.size.X.Offset, 0))
	end

	if s1 == "y" then
		return (UDim2.fromOffset(0, v14.position.Y.Offset + v14.size.Y.Offset))
	end

	return (exhaustiveMatch(s1))
end

local function getUDimSizeForConsistentSize(n1: number, s2: string) -- line: 30
	-- upvalues: exhaustiveMatch (copy)
	if s2 == "x" then
		return UDim2.new(0, n1, 1, 0)
	end

	if s2 == "y" then
		return UDim2.new(1, 0, 0, n1)
	end

	return exhaustiveMatch(s2)
end
local function getPositionForConsistentSize(n2: number, n3: number, s3: string) -- line: 40
	-- upvalues: exhaustiveMatch (copy)
	if s3 == "x" then
		return UDim2.fromOffset(n2 * (n3 - 1), 0)
	end

	if s3 == "y" then
		return UDim2.fromOffset(0, n2 * (n3 - 1))
	end

	return exhaustiveMatch(s3)
end
local function getPositionForConsistentUDim2(uDim2: UDim2, n4: number, vector2: Vector2, s4: string) -- line: 50
	-- upvalues: t1 (copy), exhaustiveMatch (copy)
	local v24 = t1.getAmountPerNonDominantInGrid(uDim2, vector2, s4)

	if s4 == "x" then
		return UDim2.new(0, (math.ceil(n4 / v24) - 1) * uDim2.X.Offset, uDim2.Y.Scale * ((n4 - 1) % v24), uDim2.Y.Offset * ((n4 - 1) % v24))
	end

	if s4 == "y" then
		return UDim2.new(uDim2.X.Scale * ((n4 - 1) % v24), uDim2.X.Offset * ((n4 - 1) % v24), 0, (math.ceil(n4 / v24) - 1) * uDim2.Y.Offset)
	end

	return exhaustiveMatch(s4)
end

function t1.getAmountPerNonDominantInGrid(uDim2: UDim2, vector2: Vector2, s5: string) -- line: 79
	-- upvalues: exhaustiveMatch (copy)
	if s5 == "x" then
		return vector2.Y // (uDim2.Y.Offset + uDim2.Y.Scale * vector2.Y)
	end

	if s5 == "y" then
		return vector2.X // (uDim2.X.Offset + uDim2.X.Scale * vector2.X)
	end

	return exhaustiveMatch(s5)
end
function t1.getDominantAxis(vector2: Vector2, s6: string) -- line: 93
	-- upvalues: exhaustiveMatch (copy)
	if s6 == "x" then
		return vector2.X
	end

	if s6 == "y" then
		return vector2.Y
	end

	return exhaustiveMatch(s6)
end
function t1.getUDimRect(p3, p4, n5: number, vector2: Vector2, s7: string) -- line: 103
	-- upvalues: exhaustiveMatch (copy), getPositionForConsistentUDim2 (copy)
	if p3.type == "consistentSize" then
		local t2 = {}
		local size = p3.size

		t2.size = if s7 ~= "x" then if s7 ~= "y" then exhaustiveMatch(s7) else UDim2.new(1, 0, 0, size) else UDim2.new(0, size, 1, 0)

		local size2 = p3.size

		t2.position = if s7 ~= "x" then if s7 ~= "y" then exhaustiveMatch(s7) else UDim2.fromOffset(0, size2 * (n5 - 1)) else UDim2.fromOffset(size2 * (n5 - 1), 0)

		return t2
	end

	if p3.type == "consistentUDim2" then
		return {
			size = p3.udim2,
			position = getPositionForConsistentUDim2(p3.udim2, n5, vector2, s7)
		}
	end

	if p3.type == "getter" then
		return p3.callback(p4, n5)
	end

	if p3.type == "spaced" then
		if p3.inner.type == "consistentSize" then
			local t3 = {}
			local size = p3.inner.size

			t3.size = if s7 ~= "x" then if s7 ~= "y" then exhaustiveMatch(s7) else UDim2.new(1, 0, 0, size) else UDim2.new(0, size, 1, 0)

			local v40 = p3.inner.size + p3.spacing

			t3.position = if s7 ~= "x" then if s7 ~= "y" then exhaustiveMatch(s7) else UDim2.fromOffset(0, v40 * (n5 - 1)) else UDim2.fromOffset(v40 * (n5 - 1), 0)

			return t3
		end

		if p3.inner.type == "consistentUDim2" then
			return {
				size = p3.inner.udim2,
				position = getPositionForConsistentUDim2(p3.inner.udim2 + UDim2.fromOffset(s7 ~= "x" and 0 or p3.spacing, s7 ~= "y" and 0 or p3.spacing), n5, vector2, s7)
			}
		end

		if p3.inner.type == "getter" or p3.inner.type == "spaced" then
			error("Unsupported spaced dimensions")

			return
		end

		return exhaustiveMatch(p3.inner.type)
	end

	return exhaustiveMatch(p3.type)
end

local function getElementsDisplayedForUDim2(uDim2: UDim2, vector2: Vector2, s8: string) -- line: 152
	-- upvalues: t1 (copy), exhaustiveMatch (copy)
	local v44 = t1.getAmountPerNonDominantInGrid(uDim2, vector2, s8)

	if s8 == "x" then
		return v44 * (vector2.X // uDim2.Y.Offset + 2)
	end

	if s8 == "y" then
		return v44 * (vector2.Y // uDim2.X.Offset + 2)
	end

	return exhaustiveMatch(s8)
end

function t1.elementsDisplayedHint(p5, vector2: Vector2, s9: string) -- line: 165
	-- upvalues: t1 (copy), getElementsDisplayedForUDim2 (copy), exhaustiveMatch (copy)
	if p5.type == "consistentSize" then
		return t1.getDominantAxis(vector2, s9) // p5.size + 2
	end

	if p5.type == "consistentUDim2" then
		return getElementsDisplayedForUDim2(p5.udim2, vector2, s9)
	end

	if p5.type == "getter" then
		return nil
	end

	if p5.type == "spaced" then
		if p5.inner.type == "consistentSize" then
			return t1.getDominantAxis(vector2, s9) // (p5.inner.size + p5.spacing) + 2
		end

		if p5.inner.type == "consistentUDim2" then
			return getElementsDisplayedForUDim2(p5.inner.udim2 + UDim2.fromOffset(s9 ~= "x" and 0 or p5.spacing, s9 ~= "y" and 0 or p5.spacing), vector2, s9)
		end

		if p5.inner.type == "spaced" or p5.inner.type == "getter" then
			error("Unsupported spaced dimensions")

			return
		end

		return exhaustiveMatch(p5.inner.type)
	end

	return exhaustiveMatch(p5.type)
end
function t1.equals(p6, p7) -- line: 203
	-- upvalues: exhaustiveMatch (copy)
	if p6.type ~= p7.type then
		return false
	end

	if p6.type == "getter" then
		assert(p7.type == "getter", "Luau")

		return p6.callback == p7.callback
	end

	if p6.type == "consistentSize" then
		assert(p7.type == "consistentSize", "Luau")

		return p6.size == p7.size
	end

	if p6.type == "consistentUDim2" then
		assert(p7.type == "consistentUDim2", "Luau")

		return p6.udim2 == p7.udim2
	end

	if p6.type == "spaced" then
		assert(p7.type == "spaced", "Luau")

		return p6.spacing == p7.spacing
	end

	return exhaustiveMatch(p6.type)
end

return t1
