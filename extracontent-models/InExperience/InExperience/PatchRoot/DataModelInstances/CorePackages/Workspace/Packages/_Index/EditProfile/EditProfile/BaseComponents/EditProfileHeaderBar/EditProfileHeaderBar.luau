local Parent = script:FindFirstAncestor("EditProfile").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local FoundationText = Foundation.Text
local View = Foundation.View
local IconButton = Foundation.IconButton
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local useTokens = Foundation.Hooks.useTokens
local v11 = game:DefineFastFlag("EditProfileIncreaseTopPadding", false)

local function EditProfileHeaderBar(t1: {[any]: any}) -- line: 25
	-- upvalues: v11 (copy), useTokens (copy), React (copy), View (copy), IconButton (copy), IconName (copy), IconSize (copy), ButtonVariant (copy), FoundationText (copy)
	local v14 = if not v11 then nil else useTokens()

	return React.createElement(View, {
		tag = not v11 and "row flex-between align-y-center gap-small size-full-0 auto-y padding-x-xlarge padding-bottom-xlarge padding-top-xxlarge" or "row flex-between align-y-center gap-small size-full-0 auto-y padding-x-xlarge padding-bottom-xlarge",
		padding = if not v11 then nil else {
			top = UDim.new(0, v14.Margin.Large)
		}
	}, {
		HeaderBar = React.createElement(View, {
			tag = "row align-y-center size-0-1800 auto-x gap-small"
		}, {
			BackButton = React.createElement(IconButton, {
				isCircular = true,
				LayoutOrder = 1,
				icon = IconName.ChevronLargeLeft,
				size = IconSize.Medium,
				variant = ButtonVariant.Utility,
				onActivated = t1.onClose
			}),
			HeaderText = React.createElement(FoundationText, {
				tag = "text-heading-small auto-xy",
				LayoutOrder = 2,
				Text = t1.headerText
			})
		}),
		SaveButton = if not t1.onSave then nil else React.createElement(IconButton, {
			isCircular = true,
			icon = IconName.CheckLarge,
			size = IconSize.Medium,
			variant = ButtonVariant.Utility,
			onActivated = t1.onSave,
			isDisabled = t1.isLoading or t1.isDisabled == true
		})
	})
end

return EditProfileHeaderBar
