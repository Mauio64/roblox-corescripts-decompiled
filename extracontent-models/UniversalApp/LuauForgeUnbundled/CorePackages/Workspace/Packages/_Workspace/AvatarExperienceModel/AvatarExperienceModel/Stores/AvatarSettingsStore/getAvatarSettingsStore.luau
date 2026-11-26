local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/Signals")

local createAvatarSettingsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/AvatarExperienceModel/Stores/AvatarSettingsStore/createAvatarSettingsStore")

return Signals.createComputed(createAvatarSettingsStore)
