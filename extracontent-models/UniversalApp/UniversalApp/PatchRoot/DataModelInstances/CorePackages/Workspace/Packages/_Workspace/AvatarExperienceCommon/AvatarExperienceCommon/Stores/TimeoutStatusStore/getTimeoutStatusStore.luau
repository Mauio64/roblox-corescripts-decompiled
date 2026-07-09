local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local AvatarExperienceCommonParent = AvatarExperienceCommon.Parent
local Signals = require(AvatarExperienceCommonParent.Signals)
local createTimeoutStatusStore = require(AvatarExperienceCommon.Stores.TimeoutStatusStore.createTimeoutStatusStore)

return Signals.createComputed(createTimeoutStatusStore)
