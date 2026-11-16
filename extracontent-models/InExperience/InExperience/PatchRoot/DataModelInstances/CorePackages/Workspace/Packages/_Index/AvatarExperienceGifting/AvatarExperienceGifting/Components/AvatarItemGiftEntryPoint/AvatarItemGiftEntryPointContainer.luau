local parent = script:FindFirstAncestor("AvatarExperienceGifting").Parent

local React = require(parent.React)

local AvatarItemGiftEntryPointView = require(script.Parent.AvatarItemGiftEntryPointView)
local useAvatarItemGiftEntryPointViewModel = require(script.Parent.useAvatarItemGiftEntryPointViewModel)

local function AvatarItemGiftEntryPointContainer(p)
	local v = useAvatarItemGiftEntryPointViewModel(p)
	return React.createElement(AvatarItemGiftEntryPointView, v)
end

return AvatarItemGiftEntryPointContainer
