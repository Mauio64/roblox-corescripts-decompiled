local Parent = script:FindFirstAncestor("AddFriends").Parent
local ImpressionCacheImpl = require(Parent.SocialCommon).Utils.ImpressionCacheImpl
local EngineFeature = game:GetEngineFeature("RegisterFriendingOSAEducationImpressionsCountKey")

return ImpressionCacheImpl({
	appStorageKey = "FriendingOSAEducationImpressionsCount",
	dismissedValue = -1,
	isKeyAvailableInEngine = EngineFeature
})
