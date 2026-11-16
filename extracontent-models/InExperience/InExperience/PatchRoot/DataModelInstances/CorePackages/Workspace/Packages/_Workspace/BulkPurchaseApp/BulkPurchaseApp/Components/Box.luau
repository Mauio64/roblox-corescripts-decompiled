local parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(parent.React)

local function Box(props)
	local children = not props.children and {} or table.clone(props.children)
	local clone = table.clone(props)
	clone.cornerRadius = nil
	clone.padding = nil
	clone.children = nil
	local v

	if typeof(props.padding) == "number" then
		v = {
			PaddingBottom = UDim.new(0, props.padding),
			PaddingLeft = UDim.new(0, props.padding),
			PaddingRight = UDim.new(0, props.padding),
			PaddingTop = UDim.new(0, props.padding)
		}
	else
		v = typeof(props.padding) == "table" and {
			PaddingTop = UDim.new(0, not (props.padding and props.padding[1]) and 0 or props.padding[1]),
			PaddingRight = UDim.new(0, not (props.padding and props.padding[2]) and 0 or props.padding[2]),
			PaddingBottom = UDim.new(0, not (props.padding and props.padding[3]) and 0 or props.padding[3]),
			PaddingLeft = UDim.new(0, not (props.padding and props.padding[4]) and 0 or props.padding[4])
		} or nil
	end

	if v then
		children.Padding = React.createElement("UIPadding", v)
	end

	if props.cornerRadius then
		children.Radius = React.createElement("UICorner", { CornerRadius = props.cornerRadius })
	end

	return React.createElement("Frame", clone, children)
end

return Box
