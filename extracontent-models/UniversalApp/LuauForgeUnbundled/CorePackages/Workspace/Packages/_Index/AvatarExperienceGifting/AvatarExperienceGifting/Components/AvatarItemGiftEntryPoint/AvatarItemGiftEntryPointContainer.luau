local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceGifting/React")

local AvatarItemGiftEntryPointView = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceGifting/AvatarExperienceGifting/Components/AvatarItemGiftEntryPoint/AvatarItemGiftEntryPointView")
local useAvatarItemGiftEntryPointViewModel = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceGifting/AvatarExperienceGifting/Components/AvatarItemGiftEntryPoint/useAvatarItemGiftEntryPointViewModel")

local function AvatarItemGiftEntryPointContainer(p2)
	local v5 = useAvatarItemGiftEntryPointViewModel(p2)
	return React.createElement(AvatarItemGiftEntryPointView, v5)
end

return AvatarItemGiftEntryPointContainer
