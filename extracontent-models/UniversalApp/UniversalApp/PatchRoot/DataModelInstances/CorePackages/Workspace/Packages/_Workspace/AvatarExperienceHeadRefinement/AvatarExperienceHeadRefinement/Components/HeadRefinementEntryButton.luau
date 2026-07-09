local Parent = script:FindFirstAncestor("AvatarExperienceHeadRefinement").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local IconButton = UIBlox.App.Button.IconButton
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local v7 = Images["icons/menu/clothing/classicHead_on"]
local v8 = Images["icons/menu/clothing/classicHead_off"]

local function HeadRefinementEntryButton(t1: {[any]: any}) -- line: 25
	-- upvalues: useStyle (copy), React (copy), IconButton (copy), v7 (copy), v8 (copy), UIBlox (copy)
	local Theme = useStyle().Theme

	return React.createElement(IconButton, {
		showBackground = true,
		icon = if not t1.isSelected then v8 else v7,
		iconSize = UIBlox.App.Constant.IconSize.Medium,
		iconColor3 = if not t1.isSelected then Theme.IconDefault.Color else Theme.IconEmphasis.Color,
		iconTransparency = if not t1.isSelected then Theme.IconDefault.Transparency else Theme.IconEmphasis.Transparency,
		onActivated = function() -- line: 35
			-- upvalues: t1 (copy)
			if t1.onActivated then
				t1.onActivated()
			end
		end,
		buttonRef = t1.buttonRef,
		NextSelectionUp = t1.nextSelectionUp,
		NextSelectionDown = t1.nextSelectionDown
	})
end

return HeadRefinementEntryButton
