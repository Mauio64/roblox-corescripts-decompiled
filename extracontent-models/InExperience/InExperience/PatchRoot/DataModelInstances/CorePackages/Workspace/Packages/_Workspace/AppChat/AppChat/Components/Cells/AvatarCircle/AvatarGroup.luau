local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local React = require(parent.React)

local Frame = require(AppChat.Components.Common.Frame)
local UIListLayout = require(AppChat.Components.Common.UIListLayout)
local AvatarThumbnail = require(script.Parent.AvatarThumbnail)
local CircleMask = require(script.Parent.CircleMask)

local function AvatarGroup(props)
	local count = #props.thumbnails
	local halfCount = count / 2
	local v = count % 2 == 0 and halfCount or math.floor(halfCount)
	local v2 = count - v

	local v3 = {}
	local v4 = {}

	for k, thumbnail in props.thumbnails do
		local v5 = 0
		local udim, v6, borderObject, children

		if k <= v then
			udim = UDim2.new(1 / v, 0, 1 / v, 0)

			v6 = count == 3 and 0.125 or count == 2 and 0.125 or v5

			borderObject = React.createElement(Frame, { Size = UDim2.fromScale(1, 1), ZIndex = 2 }, {
				border = React.createElement(Frame, {
					Size = UDim2.new(1, 0, 0, 2),
					Position = UDim2.new(0, 0, 1, -1),
					BackgroundColor3 = props.circleDividerColor3,
					BackgroundTransparency = props.circleDividerTransparency
				}),
				borderVertical = React.createElement(Frame, {
					Size = UDim2.new(0, 2, 1, 0),
					Position = UDim2.new(0, -1, 0, 0),
					BackgroundColor3 = props.circleDividerColor3,
					BackgroundTransparency = props.circleDividerTransparency
				})
			})
			children = v3
		else
			udim = UDim2.new(1 / v2, 0, 1 / v2, 0)

			v6 = count == 2 and -0.125 or v5

			borderObject = React.createElement(Frame, { ZIndex = 2 }, {
				border = React.createElement(Frame, {
					Size = UDim2.new(1, 0, 0, 2),
					Position = UDim2.new(0, 0, 0, -1),
					BackgroundColor3 = props.circleDividerColor3,
					BackgroundTransparency = props.circleDividerTransparency
				}),
				borderVertical = React.createElement(Frame, {
					Size = UDim2.new(0, 2, 1, 0),
					Position = UDim2.new(0, -1, 0, 0),
					BackgroundColor3 = props.circleDividerColor3,
					BackgroundTransparency = props.circleDividerTransparency
				})
			})
			children = v4
		end

		children["thumbnail-" .. tostring(k)] = React.createElement(
			Frame,
			{ Size = udim, ClipsDescendants = true, LayoutOrder = k },
			{
				headshotContainer = React.createElement(
					Frame,
					{ Size = UDim2.fromScale(1, 1), Position = UDim2.new(v6, 0, 0, 0) },
					{
						headshot = React.createElement(AvatarThumbnail, { thumbnail = thumbnail })
					}
				),
				borderObject = borderObject
			}
		)
	end

	local element = React.createElement(React.Fragment, {}, {
		uiCorner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) }),
		left = React.createElement(Frame, {
			Size = UDim2.new(1, -1, 1, 0),
			Position = UDim2.fromScale(-0.5, 0)
		}, {
			elementContainer = React.createElement(Frame, { Size = UDim2.fromScale(1, 1) }, {
				layout = React.createElement(UIListLayout, {
					HorizontalAlignment = Enum.HorizontalAlignment.Right
				})
			}, v3)
		}),
		right = React.createElement(Frame, {
			Size = UDim2.new(1, -1, 1, 0),
			Position = UDim2.new(0.5, -2, 0, 0)
		}, {
			elementContainer = React.createElement(Frame, { Size = UDim2.fromScale(1, 1) }, {
				layout = React.createElement(UIListLayout, {
					HorizontalAlignment = Enum.HorizontalAlignment.Left
				})
			}, v4)
		})
	})

	return React.createElement(CircleMask, {
		circleColor3 = props.circleColor3,
		circleTransparency = props.circleTransparency,
		circleInteriorBackgroundColor3 = props.circleInteriorBackgroundColor3,
		circleInteriorBackgroundTransparency = props.circleInteriorBackgroundTransparency,
		circleDividerColor3 = props.circleDividerColor3,
		circleDividerTransparency = props.circleDividerTransparency,
		LayoutOrder = props.LayoutOrder,
		overlaySize = props.overlaySize,
		onActivated = props.onActivated,
		selectable = props.selectable
	}, { fragment = element })
end

return AvatarGroup
