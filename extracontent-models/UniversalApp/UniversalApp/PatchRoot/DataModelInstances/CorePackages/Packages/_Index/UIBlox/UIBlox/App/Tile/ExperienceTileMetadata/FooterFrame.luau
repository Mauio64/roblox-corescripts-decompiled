local parent = script.Parent.Parent.Parent.Parent.Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)

local v = { size = UDim2.fromScale(1, 1) }

local function FooterFrame(p)
	local joined = Cryo.Dictionary.join(v, p)

	return React.createElement("Frame", {
		Size = joined.size,
		Position = joined.position,
		AnchorPoint = joined.anchorPoint,
		LayoutOrder = joined.layoutOrder,
		BorderSizePixel = 0,
		BackgroundTransparency = 1
	}, joined.children)
end

return FooterFrame
