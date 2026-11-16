local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

local Cryo = require(VirtualEvents.Parent.Cryo)
local React = require(VirtualEvents.Parent.React)
local Foundation = require(VirtualEvents.Parent.Foundation)

local Image = Foundation.Image

local useTokens = Foundation.Hooks.useTokens

local udim = UDim.new(0, -8)

local function EventSocialProof(p)
	local v = useTokens()

	local v2 = React.useMemo(function()
		if p.desiredFirstUserId and Cryo.List.find(p.userIds, p.desiredFirstUserId) then
			return p.desiredFirstUserId
		end

		return p.userIds[1]
	end, { p.userIds, p.desiredFirstUserId })

	local v3 = React.useMemo(function()
		return p.userIds[2] or nil
	end, { p.userIds })

	local createElement = React.createElement
	local v4 = { BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.XY }
	local v5 = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = udim
		}),
		FirstUser = 0,
		SecondUser = 0
	}
	local firstUser

	if v2 then
		firstUser = React.createElement("Frame", {
			BackgroundColor3 = v.Inverse.Surface.Surface_300.Color3,
			Size = UDim2.fromOffset(25, 25),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			ZIndex = 3
		}, {
			Corner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) }),
			FirstUserFace = React.createElement(Image, {
				ZIndex = 4,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				tag = "radius-circle",
				Image = ("rbxthumb://type=AvatarHeadShot&id=%s&w=100&h=100"):format(v2),
				backgroundStyle = { Color3 = v.Color.Shift.Shift_200.Color3, Transparency = 0 },
				Size = UDim2.fromOffset(20, 20)
			})
		})
	end

	v5.FirstUser = firstUser
	local secondUser

	if v3 then
		secondUser = React.createElement("Frame", {
			BackgroundColor3 = v.Inverse.Surface.Surface_300.Color3,
			Size = UDim2.fromOffset(25, 25),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			ZIndex = 1
		}, {
			Corner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) }),
			SecondUserFace = React.createElement(Image, {
				ZIndex = 2,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				tag = "radius-circle",
				Image = ("rbxthumb://type=AvatarHeadShot&id=%s&w=100&h=100"):format(v3),
				backgroundStyle = { Color3 = v.Color.Shift.Shift_200.Color3, Transparency = 0 },
				Size = UDim2.fromOffset(20, 20)
			})
		})
	end

	v5.SecondUser = secondUser
	return createElement("Frame", v4, v5)
end

return EventSocialProof
