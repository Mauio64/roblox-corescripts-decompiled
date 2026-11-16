local parent = script:FindFirstAncestor("Utils").Parent.Parent

local React = require(parent.React)
local MarkdownCore = require(parent.MarkdownCore)
local Flags = MarkdownCore.Flags

local function renderInMeasuredFrame(element, p: number, layoutOrder: number)
	return React.createElement("Frame", {
		key = tostring(layoutOrder),
		LayoutOrder = layoutOrder,
		Size = UDim2.fromOffset(p, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}, not (Flags.FFlagMarkdownTables or Flags.FFlagMarkdownTagFallbacks) and { Element = element } or element)
end

return renderInMeasuredFrame
