local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local IconButton = Foundation.IconButton
local IconSize = Foundation.Enums.IconSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName

local function ProfileMoreButton(t1: {[any]: any}) -- line: 20
	-- upvalues: React (copy), IconButton (copy), IconName (copy), IconSize (copy), ButtonVariant (copy)
	return React.createElement(IconButton, {
		LayoutOrder = t1.layoutOrder,
		icon = IconName.ThreeDotsHorizontal,
		isDisabled = t1.isDisabled,
		onActivated = t1.onActivated,
		size = IconSize.Medium,
		ref = t1.buttonRef,
		variant = ButtonVariant.Standard
	})
end

return ProfileMoreButton
