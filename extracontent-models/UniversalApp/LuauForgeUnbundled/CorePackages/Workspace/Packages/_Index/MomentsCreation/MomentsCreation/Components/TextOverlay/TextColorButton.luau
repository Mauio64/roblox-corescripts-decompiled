local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/BuilderIcons")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local FFlagMomentsTextOverlayColorPickerIcon = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsTextOverlayColorPickerIcon")

local image = Foundation.Image
local iconButton = Foundation.IconButton
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function TextColorButton(props)
	local v5 = useTokens()

	if FFlagMomentsTextOverlayColorPickerIcon then
		local createElement = React.createElement
		local v7 = {
			LayoutOrder = props.LayoutOrder,
			Size = UDim2.fromOffset(v5.Size.Size_1000, v5.Size.Size_1000),
			tag = "radius-circle",
			onActivated = props.onToggle,
			cursor = {
				radius = UDim.new(0, v5.Radius.Circle),
				offset = v5.Size.Size_150,
				borderWidth = v5.Stroke.Thicker
			}
		}

		local v9 = if props.expanded then React.createElement(view, {
			ZIndex = 1,
			tag = "size-full radius-circle",
			backgroundStyle = v5.Color.State.Hover
		}) else nil
		return createElement(view, v7, {
			Highlight = v9,
			Icon = React.createElement(image, {
				ZIndex = 2,
				Image = "rbxasset://textures/ui/Moments/text-color-picker.png",
				Size = UDim2.fromOffset(v5.Size.Size_600, v5.Size.Size_600),
				tag = "position-center-center anchor-center-center"
			})
		})
	else
		local createElement = React.createElement
		local v7 = { LayoutOrder = props.LayoutOrder, tag = "auto-xy radius-circle" }

		local v8 = {
			Icon = React.createElement(iconButton, {
				icon = BuilderIcons.Icon.PaintBucket,
				onActivated = props.onToggle,
				size = Foundation.Enums.InputSize.Medium,
				isCircular = true
			}),
			Highlight = 0
		}

		local v9 = if props.expanded then React.createElement(view, {
			ZIndex = 2,
			tag = "size-full radius-circle",
			backgroundStyle = v5.Color.State.Hover
		}) else nil
		v8.Highlight = v9
		return createElement(view, v7, v8)
	end
end

return TextColorButton
