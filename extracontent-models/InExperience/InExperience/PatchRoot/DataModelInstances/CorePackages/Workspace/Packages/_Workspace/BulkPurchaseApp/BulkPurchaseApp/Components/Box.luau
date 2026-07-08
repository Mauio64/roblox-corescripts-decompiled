local Parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(Parent.React)

local function Box(t1: {[any]: any}) -- line: 12
	-- upvalues: React (copy)
	local v5 = if not t1.children then {} else table.clone(t1.children)
	local v6 = table.clone(t1)

	v6.cornerRadius = nil
	v6.padding = nil
	v6.children = nil

	local v7 = if typeof(t1.padding) ~= "number" then if typeof(t1.padding) ~= "table" then nil else {
		PaddingTop = UDim.new(0, (not t1.padding or not t1.padding[1]) and 0 or t1.padding[1]),
		PaddingRight = UDim.new(0, (not t1.padding or not t1.padding[2]) and 0 or t1.padding[2]),
		PaddingBottom = UDim.new(0, (not t1.padding or not t1.padding[3]) and 0 or t1.padding[3]),
		PaddingLeft = UDim.new(0, (not t1.padding or not t1.padding[4]) and 0 or t1.padding[4])
	} else {
		PaddingBottom = UDim.new(0, t1.padding),
		PaddingLeft = UDim.new(0, t1.padding),
		PaddingRight = UDim.new(0, t1.padding),
		PaddingTop = UDim.new(0, t1.padding)
	}

	if v7 then
		v5.Padding = React.createElement("UIPadding", v7)
	end

	if t1.cornerRadius then
		v5.Radius = React.createElement("UICorner", {
			CornerRadius = t1.cornerRadius
		})
	end

	return React.createElement("Frame", v6, v5)
end

return Box
