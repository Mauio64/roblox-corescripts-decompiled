local AvatarExperienceSave = script:FindFirstAncestor("AvatarExperienceSave")
local AvatarExperienceSaveParent = AvatarExperienceSave.Parent
local React = require(AvatarExperienceSaveParent.React)
local Foundation = require(AvatarExperienceSaveParent.Foundation)

require(AvatarExperienceSave.SaveButton.useSaveButtonProps)

local function SaveButton(p1) -- line: 14
	-- upvalues: Foundation (copy), React (copy)
	local v7 = Foundation.Hooks.useTokens()
	local v8 = p1.text or "Save"

	return React.createElement(Foundation.Button, {
		text = v8,
		isDisabled = p1.disabled,
		size = Foundation.Enums.InputSize.Medium,
		variant = if not p1.disabled then Foundation.Enums.ButtonVariant.Emphasis else Foundation.Enums.ButtonVariant.Standard,
		onActivated = p1.onActivated,
		width = UDim.new(0, v7.Size.Size_2300),
		LayoutOrder = p1.LayoutOrder
	})
end

return SaveButton
