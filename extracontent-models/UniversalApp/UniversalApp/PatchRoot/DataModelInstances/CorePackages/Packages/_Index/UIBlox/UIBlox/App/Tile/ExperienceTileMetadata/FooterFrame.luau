local ParentParent = script.Parent.Parent.Parent.Parent.Parent
local React = require(ParentParent.React)
local Cryo = require(ParentParent.Cryo)
local t1 = {
	size = UDim2.fromScale(1, 1)
}

local function FooterFrame(t2: {[any]: any}) -- line: 22
	-- upvalues: Cryo (copy), t1 (copy), React (copy)
	local v7 = Cryo.Dictionary.join(t1, t2)

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = v7.size,
		Position = v7.position,
		AnchorPoint = v7.anchorPoint,
		LayoutOrder = v7.layoutOrder
	}, v7.children)
end

return FooterFrame
