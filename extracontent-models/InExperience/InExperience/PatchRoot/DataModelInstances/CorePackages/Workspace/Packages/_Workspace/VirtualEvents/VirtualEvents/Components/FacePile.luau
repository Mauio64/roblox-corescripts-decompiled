local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local Cryo = require(VirtualEvents.Parent.Cryo)
local React = require(VirtualEvents.Parent.React)
local uDim = UDim.new(0, 12)

local function FacePile(t1: {[any]: any}) -- line: 19
	-- upvalues: React (copy), Cryo (copy), uDim (copy)
	local t2 = {}

	for v8, v9 in (React.useMemo(function() -- line: 22
		-- upvalues: t1 (copy), Cryo (copy)
		if t1.desiredFirstUserId then
			local v10 = Cryo.List.find(t1.userIds, t1.desiredFirstUserId)

			if v10 then
				local v11 = table.clone(t1.userIds)

				table.remove(v11, v10)
				table.insert(v11, 1, t1.desiredFirstUserId)

				return v11
			end
		end

		return t1.userIds
	end, {
		t1.userIds,
		t1.desiredFirstUserId
	})) do
		t2[v9] = React.createElement("ImageLabel", {
			LayoutOrder = v8,
			BackgroundColor3 = Color3.fromRGB(209, 209, 209),
			Image = ("rbxthumb://type=AvatarHeadShot&id=%s&w=100&h=100"):format(v9),
			Size = UDim2.fromOffset(36, 36)
		}, {
			BorderRadius = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.5, 0)
			})
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = t1.layoutOrder,
		AutomaticSize = Enum.AutomaticSize.XY
	}, {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = uDim
		}),
		Faces = React.createElement(React.Fragment, nil, t2)
	})
end

return FacePile
