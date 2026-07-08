local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local AvatarExperienceFlags = require(Parent.AvatarExperienceFlags)

require(script.Parent.Parent.Types.CategoryTypes.CategoryTypes)

local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport

return {
	Avatar = "Avatar",
	EditableAvatar = "EditableAvatar",
	DynamicHead = "DynamicHead",
	Shoes = "Shoes",
	Animations = "Animations",
	Makeup = if not FFlagAXCustomizeMakeupSupport then nil else "Makeup"
}
