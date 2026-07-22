local AvatarExperienceSlotBasedEditor = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor")
local AvatarExperienceSlotBasedEditorParent = AvatarExperienceSlotBasedEditor.Parent
local React = require(AvatarExperienceSlotBasedEditorParent.React)
local Foundation = require(AvatarExperienceSlotBasedEditorParent.Foundation)
local Constants = require(AvatarExperienceSlotBasedEditor.Constants)

local function OutfitDetailsActionBar(t1: {[any]: any}) -- line: 17
	-- upvalues: React (copy), Foundation (copy), Constants (copy)
	return React.createElement(Foundation.View, {
		tag = "col bg-surface-0",
		Size = UDim2.new(1, 0, 0, Constants.ActionBarHeight),
		LayoutOrder = t1.LayoutOrder
	}, {
		Divider = React.createElement(Foundation.Divider, {
			LayoutOrder = 1
		}),
		Buttons = React.createElement(Foundation.View, {
			tag = "row align-x-right align-y-center fill gap-small size-full-0 padding-x-medium",
			LayoutOrder = 2
		}, {
			RenameButton = React.createElement(Foundation.Button, {
				LayoutOrder = 1,
				text = t1.renameText,
				variant = Foundation.Enums.ButtonVariant.Standard,
				size = Foundation.Enums.ButtonSize.Medium,
				onActivated = t1.onRenameOutfit
			}),
			DeleteButton = React.createElement(Foundation.Button, {
				LayoutOrder = 2,
				text = t1.deleteText,
				variant = Foundation.Enums.ButtonVariant.Standard,
				size = Foundation.Enums.ButtonSize.Medium,
				onActivated = t1.onDeleteOutfit
			})
		})
	})
end

return OutfitDetailsActionBar
