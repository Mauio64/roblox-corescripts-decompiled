local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local React = require(parent.React)

local FFlagMomentsTextOverlayColorPickerIcon = require(MomentsCreation.Flags.FFlagMomentsTextOverlayColorPickerIcon)

local Image = Foundation.Image
local IconButton = Foundation.IconButton
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function TextColorButton(props)
	local v = useTokens()

	if FFlagMomentsTextOverlayColorPickerIcon then
		local createElement = React.createElement
		local v2 = {
			LayoutOrder = props.LayoutOrder,
			Size = UDim2.fromOffset(v.Size.Size_1000, v.Size.Size_1000),
			tag = "radius-circle",
			onActivated = props.onToggle,
			cursor = {
				radius = UDim.new(0, v.Radius.Circle),
				offset = v.Size.Size_150,
				borderWidth = v.Stroke.Thicker
			}
		}
		local highlight

		if props.expanded then
			highlight = React.createElement(View, {
				ZIndex = 1,
				tag = "size-full radius-circle",
				backgroundStyle = v.Color.State.Hover
			})
		end

		return createElement(View, v2, {
			Highlight = highlight,
			Icon = React.createElement(Image, {
				ZIndex = 2,
				Image = "rbxasset://textures/ui/Moments/text-color-picker.png",
				Size = UDim2.fromOffset(v.Size.Size_600, v.Size.Size_600),
				tag = "position-center-center anchor-center-center"
			})
		})
	else
		local createElement = React.createElement
		local v2 = { LayoutOrder = props.LayoutOrder, tag = "auto-xy radius-circle" }

		local v3 = {
			Icon = React.createElement(IconButton, {
				icon = BuilderIcons.Icon.PaintBucket,
				onActivated = props.onToggle,
				size = Foundation.Enums.InputSize.Medium,
				isCircular = true
			}),
			Highlight = 0
		}
		local highlight

		if props.expanded then
			highlight = React.createElement(View, {
				ZIndex = 2,
				tag = "size-full radius-circle",
				backgroundStyle = v.Color.State.Hover
			})
		end

		v3.Highlight = highlight
		return createElement(View, v2, v3)
	end
end

return TextColorButton
