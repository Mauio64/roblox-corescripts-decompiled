local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Frame = require(AppChat.Components.Common.Frame)
local UIListLayout = require(AppChat.Components.Common.UIListLayout)
local AvatarThumbnail = require(script.Parent.AvatarThumbnail)
local CircleMask = require(script.Parent.CircleMask)

local function AvatarGroup(t1: {[any]: any}) -- line: 26
	-- upvalues: React (copy), Frame (copy), AvatarThumbnail (copy), UIListLayout (copy), CircleMask (copy)
	local v10 = #t1.thumbnails
	local v11 = v10 / 2
	local v12 = v10 % 2 == 0 and v11 or math.floor(v11)
	local v13 = v10 - v12
	local t2 = {}
	local t3 = {}

	for v16, v17 in t1.thumbnails do
		local n1 = 0
		local uDim2, v20, v21

		if v16 <= v12 then
			uDim2 = UDim2.new(1 / v12, 0, 1 / v12, 0)
			v20 = t2

			if v10 == 3 then
				n1 = 0.125
			elseif v10 == 2 then
				n1 = 0.125
			end

			v21 = React.createElement(Frame, {
				ZIndex = 2,
				Size = UDim2.fromScale(1, 1)
			}, {
				border = React.createElement(Frame, {
					Size = UDim2.new(1, 0, 0, 2),
					Position = UDim2.new(0, 0, 1, -1),
					BackgroundColor3 = t1.circleDividerColor3,
					BackgroundTransparency = t1.circleDividerTransparency
				}),
				borderVertical = React.createElement(Frame, {
					Size = UDim2.new(0, 2, 1, 0),
					Position = UDim2.new(0, -1, 0, 0),
					BackgroundColor3 = t1.circleDividerColor3,
					BackgroundTransparency = t1.circleDividerTransparency
				})
			})
		else
			uDim2 = UDim2.new(1 / v13, 0, 1 / v13, 0)
			v20 = t3

			if v10 == 2 then
				n1 = -0.125
			end

			v21 = React.createElement(Frame, {
				ZIndex = 2
			}, {
				border = React.createElement(Frame, {
					Size = UDim2.new(1, 0, 0, 2),
					Position = UDim2.new(0, 0, 0, -1),
					BackgroundColor3 = t1.circleDividerColor3,
					BackgroundTransparency = t1.circleDividerTransparency
				}),
				borderVertical = React.createElement(Frame, {
					Size = UDim2.new(0, 2, 1, 0),
					Position = UDim2.new(0, -1, 0, 0),
					BackgroundColor3 = t1.circleDividerColor3,
					BackgroundTransparency = t1.circleDividerTransparency
				})
			})
		end

		v20["thumbnail-" .. tostring(v16)] = React.createElement(Frame, {
			ClipsDescendants = true,
			Size = uDim2,
			LayoutOrder = v16
		}, {
			headshotContainer = React.createElement(Frame, {
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.new(n1, 0, 0, 0)
			}, {
				headshot = React.createElement(AvatarThumbnail, {
					thumbnail = v17
				})
			}),
			borderObject = v21
		})
	end

	local v22 = React.createElement(React.Fragment, {}, {
		uiCorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(1, 0)
		}),
		left = React.createElement(Frame, {
			Size = UDim2.new(1, -1, 1, 0),
			Position = UDim2.fromScale(-0.5, 0)
		}, {
			elementContainer = React.createElement(Frame, {
				Size = UDim2.fromScale(1, 1)
			}, {
				layout = React.createElement(UIListLayout, {
					HorizontalAlignment = Enum.HorizontalAlignment.Right
				})
			}, t2)
		}),
		right = React.createElement(Frame, {
			Size = UDim2.new(1, -1, 1, 0),
			Position = UDim2.new(0.5, -2, 0, 0)
		}, {
			elementContainer = React.createElement(Frame, {
				Size = UDim2.fromScale(1, 1)
			}, {
				layout = React.createElement(UIListLayout, {
					HorizontalAlignment = Enum.HorizontalAlignment.Left
				})
			}, t3)
		})
	})

	return React.createElement(CircleMask, {
		circleColor3 = t1.circleColor3,
		circleTransparency = t1.circleTransparency,
		circleInteriorBackgroundColor3 = t1.circleInteriorBackgroundColor3,
		circleInteriorBackgroundTransparency = t1.circleInteriorBackgroundTransparency,
		circleDividerColor3 = t1.circleDividerColor3,
		circleDividerTransparency = t1.circleDividerTransparency,
		LayoutOrder = t1.LayoutOrder,
		overlaySize = t1.overlaySize,
		onActivated = t1.onActivated,
		selectable = t1.selectable
	}, {
		fragment = v22
	})
end

return AvatarGroup
