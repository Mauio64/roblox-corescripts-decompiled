local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local ReactIs = require(FoundationParent.ReactIs)
local getTestIdTag = require(Foundation.Utility.getTestIdTag)
local mapBindable = require(Foundation.Utility.mapBindable)

require(Foundation.Components.Types)

local function toUDim(p1) -- line: 16
	-- upvalues: mapBindable (copy)
	if p1 == nil then
		return nil
	end

	return mapBindable(p1, function(p2) -- line: 20
		if typeof(p2) == "number" then
			return UDim.new(0, p2)
		end

		return p2
	end)
end
local function getCornerRadius(p3) -- line: 28
	-- upvalues: ReactIs (copy), mapBindable (copy)
	if ReactIs.isBinding(p3) then
		return {
			TopLeftRadius = p3,
			TopRightRadius = p3,
			BottomRightRadius = p3,
			BottomLeftRadius = p3
		}
	end

	if typeof(p3) == "number" then
		return {
			TopLeftRadius = UDim.new(0, p3),
			TopRightRadius = UDim.new(0, p3),
			BottomRightRadius = UDim.new(0, p3),
			BottomLeftRadius = UDim.new(0, p3)
		}
	end

	if typeof(p3) == "UDim" then
		return {
			TopLeftRadius = p3,
			TopRightRadius = p3,
			BottomRightRadius = p3,
			BottomLeftRadius = p3
		}
	end

	if typeof(p3) == "table" then
		local t1 = {}
		local topLeft = p3.topLeft

		t1.TopLeftRadius = if topLeft ~= nil then mapBindable(topLeft, function(p4) -- line: 20
			if typeof(p4) == "number" then
				return UDim.new(0, p4)
			end

			return p4
		end) else nil

		local topRight = p3.topRight

		t1.TopRightRadius = if topRight ~= nil then mapBindable(topRight, function(p5) -- line: 20
			if typeof(p5) == "number" then
				return UDim.new(0, p5)
			end

			return p5
		end) else nil

		local bottomRight = p3.bottomRight

		t1.BottomRightRadius = if bottomRight ~= nil then mapBindable(bottomRight, function(p6) -- line: 20
			if typeof(p6) == "number" then
				return UDim.new(0, p6)
			end

			return p6
		end) else nil

		local bottomLeft = p3.bottomLeft

		t1.BottomLeftRadius = if bottomLeft ~= nil then mapBindable(bottomLeft, function(p7) -- line: 20
			if typeof(p7) == "number" then
				return UDim.new(0, p7)
			end

			return p7
		end) else nil

		return t1
	end

	return {}
end
local function CornerRadius(t2: {[any]: any}) -- line: 73
	-- upvalues: getCornerRadius (copy), React (copy), getTestIdTag (copy)
	local v18 = getCornerRadius(t2.value)

	return React.createElement("UICorner", {
		TopLeftRadius = v18.TopLeftRadius,
		TopRightRadius = v18.TopRightRadius,
		BottomRightRadius = v18.BottomRightRadius,
		BottomLeftRadius = v18.BottomLeftRadius,
		[React.Tag] = getTestIdTag(t2.testId)
	})
end

return React.memo(CornerRadius)
