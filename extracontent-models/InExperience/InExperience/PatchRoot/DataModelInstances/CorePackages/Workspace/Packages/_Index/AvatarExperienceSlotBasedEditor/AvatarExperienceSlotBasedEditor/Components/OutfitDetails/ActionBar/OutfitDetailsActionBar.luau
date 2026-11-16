local AvatarExperienceSlotBasedEditor = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor")
local parent = AvatarExperienceSlotBasedEditor.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Constants = require(AvatarExperienceSlotBasedEditor.Constants)

local function OutfitDetailsActionBar(props)
	return React.createElement(
		Foundation.View,
		{
			tag = "col bg-surface-0",
			Size = UDim2.new(1, 0, 0, Constants.ActionBarHeight),
			LayoutOrder = props.LayoutOrder
		},
		{
			Divider = React.createElement(Foundation.Divider, { LayoutOrder = 1 }),
			Buttons = React.createElement(
				Foundation.View,
				{
					tag = "row align-x-right align-y-center fill gap-small size-full-0 padding-x-medium",
					LayoutOrder = 2
				},
				{
					RenameButton = React.createElement(Foundation.Button, {
						text = props.renameText,
						variant = Foundation.Enums.ButtonVariant.Standard,
						size = Foundation.Enums.ButtonSize.Medium,
						onActivated = props.onRenameOutfit,
						LayoutOrder = 1
					}),
					DeleteButton = React.createElement(Foundation.Button, {
						text = props.deleteText,
						variant = Foundation.Enums.ButtonVariant.Standard,
						size = Foundation.Enums.ButtonSize.Medium,
						onActivated = props.onDeleteOutfit,
						LayoutOrder = 2
					})
				}
			)
		}
	)
end

return OutfitDetailsActionBar
