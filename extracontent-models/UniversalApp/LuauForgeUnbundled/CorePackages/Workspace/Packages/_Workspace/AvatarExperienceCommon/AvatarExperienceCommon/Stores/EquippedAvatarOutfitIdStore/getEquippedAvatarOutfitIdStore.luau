local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Signals")

local createEquippedAvatarOutfitIdStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Stores/EquippedAvatarOutfitIdStore/createEquippedAvatarOutfitIdStore")

return Signals.createComputed(createEquippedAvatarOutfitIdStore)
