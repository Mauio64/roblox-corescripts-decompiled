local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local Frame = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Common/Frame")
local UIListLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Common/UIListLayout")
local AvatarThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Cells/AvatarCircle/AvatarThumbnail")
local CircleMask = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Cells/AvatarCircle/CircleMask")

local function AvatarGroup(props)
	local count = #props.thumbnails
	local v5 = count / 2
	local v6 = count % 2 == 0 and v5 or math.floor(v5)
	local v7 = count - v6

	local v8 = {}
	local v9 = {}

	for k, thumbnail in props.thumbnails do
		local v10 = 0
		local udim, v11, v12, children

		if k <= v6 then
			udim = UDim2.new(1 / v6, 0, 1 / v6, 0)

			v11 = count == 3 and 0.125 or count == 2 and 0.125 or v10

			v12 = React.createElement(Frame, {
				Size = UDim2.fromScale(1, 1),
				ZIndex = 2
			}, {
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
			children = v8
		else
			udim = UDim2.new(1 / v7, 0, 1 / v7, 0)

			v11 = count == 2 and -0.125 or v10

			v12 = React.createElement(Frame, { ZIndex = 2 }, {
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
			children = v9
		end

		children["thumbnail-" .. tostring(k)] = React.createElement(
			Frame,
			{ Size = udim, ClipsDescendants = true, LayoutOrder = k },
			{
				headshotContainer = React.createElement(
					Frame,
					{ Size = UDim2.fromScale(1, 1), Position = UDim2.new(v11, 0, 0, 0) },
					{
						headshot = React.createElement(AvatarThumbnail, {
							thumbnail = thumbnail
						})
					}
				),
				borderObject = v12
			}
		)
	end

	local element = React.createElement(React.Fragment, {}, {
		uiCorner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) }),
		left = React.createElement(
			Frame,
			{ Size = UDim2.new(1, -1, 1, 0), Position = UDim2.fromScale(-0.5, 0) },
			{
				elementContainer = React.createElement(Frame, {
					Size = UDim2.fromScale(1, 1)
				}, {
					layout = React.createElement(UIListLayout, {
						HorizontalAlignment = Enum.HorizontalAlignment.Right
					})
				}, v8)
			}
		),
		right = React.createElement(
			Frame,
			{ Size = UDim2.new(1, -1, 1, 0), Position = UDim2.new(0.5, -2, 0, 0) },
			{
				elementContainer = React.createElement(Frame, {
					Size = UDim2.fromScale(1, 1)
				}, {
					layout = React.createElement(UIListLayout, {
						HorizontalAlignment = Enum.HorizontalAlignment.Left
					})
				}, v9)
			}
		)
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
