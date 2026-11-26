local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Foundation")

local image = Foundation.Image

local useTokens = Foundation.Hooks.useTokens

local udim = UDim.new(0, -8)

local function EventSocialProof(p2)
	local v5 = useTokens()

	local v6 = React.useMemo(function()
		if p2.desiredFirstUserId and Cryo.List.find(p2.userIds, p2.desiredFirstUserId) then
			return p2.desiredFirstUserId
		end

		return p2.userIds[1]
	end, { p2.userIds, p2.desiredFirstUserId })

	local v7 = React.useMemo(function()
		return p2.userIds[2] or nil
	end, { p2.userIds })

	local createElement = React.createElement
	local v9 = { BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.XY }
	local v10 = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = udim
		}),
		FirstUser = 0,
		SecondUser = 0
	}

	local v11 = if v6 then React.createElement("Frame", {
		BackgroundColor3 = v5.Inverse.Surface.Surface_300.Color3,
		Size = UDim2.fromOffset(25, 25),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		ZIndex = 3
	}, {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) }),
		FirstUserFace = React.createElement(image, {
			ZIndex = 4,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			tag = "radius-circle",
			Image = ("rbxthumb://type=AvatarHeadShot&id=%s&w=100&h=100"):format(v6),
			backgroundStyle = {
				Color3 = v5.Color.Shift.Shift_200.Color3,
				Transparency = 0
			},
			Size = UDim2.fromOffset(20, 20)
		})
	}) else nil
	v10.FirstUser = v11

	local v12 = if v7 then React.createElement("Frame", {
		BackgroundColor3 = v5.Inverse.Surface.Surface_300.Color3,
		Size = UDim2.fromOffset(25, 25),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		ZIndex = 1
	}, {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) }),
		SecondUserFace = React.createElement(image, {
			ZIndex = 2,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			tag = "radius-circle",
			Image = ("rbxthumb://type=AvatarHeadShot&id=%s&w=100&h=100"):format(v7),
			backgroundStyle = {
				Color3 = v5.Color.Shift.Shift_200.Color3,
				Transparency = 0
			},
			Size = UDim2.fromOffset(20, 20)
		})
	}) else nil
	v10.SecondUser = v12
	return createElement("Frame", v9, v10)
end

return EventSocialProof
