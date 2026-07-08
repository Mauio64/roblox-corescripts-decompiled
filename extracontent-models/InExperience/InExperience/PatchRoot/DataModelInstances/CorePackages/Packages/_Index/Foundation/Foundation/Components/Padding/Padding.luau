local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local ReactIs = require(FoundationParent.ReactIs)
local getTestIdTag = require(Foundation.Utility.getTestIdTag)

require(Foundation.Components.Types)

local function getPadding(p1) -- line: 14
	-- upvalues: ReactIs (copy)
	if ReactIs.isBinding(p1) then
		return {
			PaddingTop = p1,
			PaddingBottom = p1,
			PaddingLeft = p1,
			PaddingRight = p1
		}
	end

	if typeof(p1) == "table" then
		return {
			PaddingTop = p1.top,
			PaddingBottom = p1.bottom,
			PaddingLeft = p1.left,
			PaddingRight = p1.right
		}
	end

	if typeof(p1) == "number" then
		return {
			PaddingTop = UDim.new(0, p1),
			PaddingBottom = UDim.new(0, p1),
			PaddingLeft = UDim.new(0, p1),
			PaddingRight = UDim.new(0, p1)
		}
	end

	if typeof(p1) == "Vector2" then
		return {
			PaddingTop = UDim.new(0, p1.Y),
			PaddingBottom = UDim.new(0, p1.Y),
			PaddingLeft = UDim.new(0, p1.X),
			PaddingRight = UDim.new(0, p1.X)
		}
	end

	if typeof(p1) == "UDim" then
		return {
			PaddingTop = p1,
			PaddingBottom = p1,
			PaddingLeft = p1,
			PaddingRight = p1
		}
	end

	if typeof(p1) == "UDim2" then
		return {
			PaddingTop = p1.Y,
			PaddingBottom = p1.Y,
			PaddingLeft = p1.X,
			PaddingRight = p1.X
		}
	end

	return {}
end
local function Padding(t1: {[any]: any}) -- line: 73
	-- upvalues: getPadding (copy), React (copy), getTestIdTag (copy)
	local v10 = getPadding(t1.value)

	return React.createElement("UIPadding", {
		PaddingTop = v10.PaddingTop,
		PaddingBottom = v10.PaddingBottom,
		PaddingLeft = v10.PaddingLeft,
		PaddingRight = v10.PaddingRight,
		[React.Tag] = getTestIdTag(t1.testId)
	})
end

return React.memo(Padding)
