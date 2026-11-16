local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local parent = AvatarExperienceCommon.Parent

local Signals = require(parent.Signals)

local createTimeoutStatusStore = require(AvatarExperienceCommon.Stores.TimeoutStatusStore.createTimeoutStatusStore)

return Signals.createComputed(createTimeoutStatusStore)
