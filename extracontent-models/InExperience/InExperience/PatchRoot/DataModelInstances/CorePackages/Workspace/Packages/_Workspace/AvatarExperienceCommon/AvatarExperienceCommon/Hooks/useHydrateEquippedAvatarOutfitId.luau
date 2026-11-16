local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local parent = AvatarExperienceCommon.Parent

local React = require(parent.React)

local getEquippedAvatarOutfitIdStore = require(AvatarExperienceCommon.Stores.EquippedAvatarOutfitIdStore.getEquippedAvatarOutfitIdStore)

local function useHydrateEquippedAvatarOutfitId()
	local equippedAvatarOutfitIdStore = getEquippedAvatarOutfitIdStore(false)

	React.useEffect(function()
		equippedAvatarOutfitIdStore.fetchCurrentlyWearingSavedOutfitId()
	end, { equippedAvatarOutfitIdStore })
end

return useHydrateEquippedAvatarOutfitId
