local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)
local ReactIs = require(parent.ReactIs)

local getTestIdTag = require(Foundation.Utility.getTestIdTag)
local mapBindable = require(Foundation.Utility.mapBindable)

require(Foundation.Components.Types)

local function toUDim(p)
	if p == nil then
		return nil
	end

	return mapBindable(p, function(value)
		if typeof(value) == "number" then
			return UDim.new(0, value)
		end

		return value
	end)
end

local function getCornerRadius(value)
	if ReactIs.isBinding(value) then
		return {
			TopLeftRadius = value,
			TopRightRadius = value,
			BottomRightRadius = value,
			BottomLeftRadius = value
		}
	end

	if typeof(value) == "number" then
		return {
			TopLeftRadius = UDim.new(0, value),
			TopRightRadius = UDim.new(0, value),
			BottomRightRadius = UDim.new(0, value),
			BottomLeftRadius = UDim.new(0, value)
		}
	end

	if typeof(value) == "UDim" then
		return {
			TopLeftRadius = value,
			TopRightRadius = value,
			BottomRightRadius = value,
			BottomLeftRadius = value
		}
	end

	if typeof(value) ~= "table" then
		return {}
	end

	local topLeft = value.topLeft
	local topLeftRadius

	local function fn(value2)
		if typeof(value2) == "number" then
			return UDim.new(0, value2)
		end

		return value2
	end

	if topLeft ~= nil then
		topLeftRadius = mapBindable(topLeft, fn)
	end

	local topRight = value.topRight
	local topRightRadius

	if topRight ~= nil then
		topRightRadius = mapBindable(topRight, fn)
	end

	local bottomRight = value.bottomRight
	local bottomRightRadius

	if bottomRight ~= nil then
		bottomRightRadius = mapBindable(bottomRight, fn)
	end

	local bottomLeft = value.bottomLeft
	local bottomLeftRadius

	if bottomLeft ~= nil then
		bottomLeftRadius = mapBindable(bottomLeft, fn)
	end

	return {
		TopLeftRadius = topLeftRadius,
		TopRightRadius = topRightRadius,
		BottomRightRadius = bottomRightRadius,
		BottomLeftRadius = bottomLeftRadius
	}
end

local function CornerRadius(p)
	local cornerRadius = getCornerRadius(p.value)

	return React.createElement("UICorner", {
		TopLeftRadius = cornerRadius.TopLeftRadius,
		TopRightRadius = cornerRadius.TopRightRadius,
		BottomRightRadius = cornerRadius.BottomRightRadius,
		BottomLeftRadius = cornerRadius.BottomLeftRadius,
		[React.Tag] = getTestIdTag(p.testId)
	})
end

return React.memo(CornerRadius)
