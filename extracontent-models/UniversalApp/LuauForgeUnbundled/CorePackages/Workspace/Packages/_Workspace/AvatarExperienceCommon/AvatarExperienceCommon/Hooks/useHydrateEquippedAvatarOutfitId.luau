local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")

local getEquippedAvatarOutfitIdStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Stores/EquippedAvatarOutfitIdStore/getEquippedAvatarOutfitIdStore")

local function useHydrateEquippedAvatarOutfitId()
	local v5 = getEquippedAvatarOutfitIdStore(false)

	React.useEffect(function()
		v5.fetchCurrentlyWearingSavedOutfitId()
	end, { v5 })
end

return useHydrateEquippedAvatarOutfitId
