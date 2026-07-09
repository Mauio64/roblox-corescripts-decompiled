local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local Cryo = require(VirtualEvents.Parent.Cryo)
local React = require(VirtualEvents.Parent.React)
local Foundation = require(VirtualEvents.Parent.Foundation)
local FoundationImage = Foundation.Image
local useTokens = Foundation.Hooks.useTokens
local uDim = UDim.new(0, -8)

local function EventSocialProof(t1: {[any]: any}) -- line: 21
	-- upvalues: useTokens (copy), React (copy), Cryo (copy), uDim (copy), FoundationImage (copy)
	local v10 = useTokens()
	local v11 = React.useMemo(function() -- line: 24
		-- upvalues: t1 (copy), Cryo (copy)
		if t1.desiredFirstUserId and Cryo.List.find(t1.userIds, t1.desiredFirstUserId) then
			return t1.desiredFirstUserId
		end

		return t1.userIds[1]
	end, {
		t1.userIds,
		t1.desiredFirstUserId
	})
	local v12 = React.useMemo(function() -- line: 35
		-- upvalues: t1 (copy)
		return t1.userIds[2] or nil
	end, { t1.userIds })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY
	}, {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = uDim
		}),
		FirstUser = if not v11 then nil else React.createElement("Frame", {
			ZIndex = 3,
			BackgroundColor3 = v10.Inverse.Surface.Surface_300.Color3,
			Size = UDim2.fromOffset(25, 25),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5)
		}, {
			Corner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			}),
			FirstUserFace = React.createElement(FoundationImage, {
				ZIndex = 4,
				tag = "radius-circle",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Image = ("rbxthumb://type=AvatarHeadShot&id=%s&w=100&h=100"):format(v11),
				backgroundStyle = {
					Transparency = 0,
					Color3 = v10.Color.Shift.Shift_200.Color3
				},
				Size = UDim2.fromOffset(20, 20)
			})
		}),
		SecondUser = if not v12 then nil else React.createElement("Frame", {
			ZIndex = 1,
			BackgroundColor3 = v10.Inverse.Surface.Surface_300.Color3,
			Size = UDim2.fromOffset(25, 25),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5)
		}, {
			Corner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			}),
			SecondUserFace = React.createElement(FoundationImage, {
				ZIndex = 2,
				tag = "radius-circle",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Image = ("rbxthumb://type=AvatarHeadShot&id=%s&w=100&h=100"):format(v12),
				backgroundStyle = {
					Transparency = 0,
					Color3 = v10.Color.Shift.Shift_200.Color3
				},
				Size = UDim2.fromOffset(20, 20)
			})
		})
	})
end

return EventSocialProof
