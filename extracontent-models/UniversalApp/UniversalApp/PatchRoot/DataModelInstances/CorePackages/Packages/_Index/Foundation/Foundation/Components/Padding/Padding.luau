local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)
local ReactIs = require(parent.ReactIs)

local getTestIdTag = require(Foundation.Utility.getTestIdTag)

require(Foundation.Components.Types)

local function getPadding(value)
	if ReactIs.isBinding(value) then
		return {
			PaddingTop = value,
			PaddingBottom = value,
			PaddingLeft = value,
			PaddingRight = value
		}
	end

	if typeof(value) == "table" then
		return {
			PaddingTop = value.top,
			PaddingBottom = value.bottom,
			PaddingLeft = value.left,
			PaddingRight = value.right
		}
	end

	if typeof(value) == "number" then
		return {
			PaddingTop = UDim.new(0, value),
			PaddingBottom = UDim.new(0, value),
			PaddingLeft = UDim.new(0, value),
			PaddingRight = UDim.new(0, value)
		}
	end

	if typeof(value) == "Vector2" then
		return {
			PaddingTop = UDim.new(0, value.Y),
			PaddingBottom = UDim.new(0, value.Y),
			PaddingLeft = UDim.new(0, value.X),
			PaddingRight = UDim.new(0, value.X)
		}
	end

	if typeof(value) == "UDim" then
		return {
			PaddingTop = value,
			PaddingBottom = value,
			PaddingLeft = value,
			PaddingRight = value
		}
	end

	if typeof(value) == "UDim2" then
		return {
			PaddingTop = value.Y,
			PaddingBottom = value.Y,
			PaddingLeft = value.X,
			PaddingRight = value.X
		}
	end

	return {}
end

local function Padding(p)
	local padding = getPadding(p.value)

	return React.createElement("UIPadding", {
		PaddingTop = padding.PaddingTop,
		PaddingBottom = padding.PaddingBottom,
		PaddingLeft = padding.PaddingLeft,
		PaddingRight = padding.PaddingRight,
		[React.Tag] = getTestIdTag(p.testId)
	})
end

return React.memo(Padding)
