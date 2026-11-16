local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

local Cryo = require(VirtualEvents.Parent.Cryo)
local React = require(VirtualEvents.Parent.React)

local udim = UDim.new(0, 12)

local function FacePile(props)
	local v = React.useMemo(function()
		local v = props.desiredFirstUserId and Cryo.List.find(props.userIds, props.desiredFirstUserId)

		if not v then
			return props.userIds
		end

		local clone = table.clone(props.userIds)
		table.remove(clone, v)
		table.insert(clone, 1, props.desiredFirstUserId)
		return clone
	end, { props.userIds, props.desiredFirstUserId })
	local children = {}

	for k, v2 in v do
		children[v2] = React.createElement(
			"ImageLabel",
			{
				LayoutOrder = k,
				BackgroundColor3 = Color3.fromRGB(209, 209, 209),
				Image = ("rbxthumb://type=AvatarHeadShot&id=%s&w=100&h=100"):format(v2),
				Size = UDim2.fromOffset(36, 36)
			},
			{
				BorderRadius = React.createElement("UICorner", { CornerRadius = UDim.new(0.5, 0) })
			}
		)
	end

	return React.createElement(
		"Frame",
		{
			LayoutOrder = props.layoutOrder,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY
		},
		{
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = udim
			}),
			Faces = React.createElement(React.Fragment, nil, children)
		}
	)
end

return FacePile
