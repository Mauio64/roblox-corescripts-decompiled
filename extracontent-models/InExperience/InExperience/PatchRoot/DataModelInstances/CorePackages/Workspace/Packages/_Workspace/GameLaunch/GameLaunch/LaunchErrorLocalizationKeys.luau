local Parent = script:FindFirstAncestor("GameLaunch").Parent
local RetrievalStatus = require(Parent.Http).Enum.RetrievalStatus
local PlayabilityStatusEnum = require(Parent.DiscoveryTypes).PlayabilityStatusEnum
local FFlagLuaAppBlockedUnplayableError = require(Parent.SharedFlags).FFlagLuaAppBlockedUnplayableError
local t1 = {}
local t2 = {
	[RetrievalStatus.Failed] = "Feature.GamePage.QuickLaunch.LaunchError.RequestFailed",
	[PlayabilityStatusEnum.GuestProhibited] = "Feature.GamePage.QuickLaunch.LaunchError.GuestProhibited",
	[PlayabilityStatusEnum.GameUnapproved] = "Feature.ExperienceDetails.UnplayableError.GameUnapproved",
	[PlayabilityStatusEnum.UniverseRootPlaceIsPrivate] = "Feature.ExperienceDetails.UnplayableError.UniverseRootPlaceIsPrivate",
	[PlayabilityStatusEnum.InsufficientPermissionFriendsOnly] = "Feature.ExperienceDetails.UnplayableError.InsufficientPermissionFriendsOnly",
	[PlayabilityStatusEnum.InsufficientPermissionGroupOnly] = "Feature.ExperienceDetails.UnplayableError.InsufficientPermissionGroupOnly",
	[PlayabilityStatusEnum.DeviceRestricted] = "Feature.ExperienceDetails.UnplayableError.DeviceRestrictedDefault",
	[PlayabilityStatusEnum.UnderReview] = "Feature.ExperienceDetails.UnplayableError.UnderReview",
	[PlayabilityStatusEnum.PurchaseRequired] = "Feature.GamePage.QuickLaunch.LaunchError.PurchaseRequired",
	[PlayabilityStatusEnum.AccountRestricted] = "Feature.ExperienceDetails.UnplayableError.AccountRestricted",
	[PlayabilityStatusEnum.TemporarilyUnavailable] = "Feature.ExperienceDetails.UnplayableError.TemporarilyUnavailable",
	[PlayabilityStatusEnum.ComplianceBlocked] = "Feature.ExperienceDetails.UnplayableError.ComplianceBlocked",
	[PlayabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls] = "Feature.ExperienceDetails.UnplayableError.ContextualPlayabilityAgeRecommendationParentalControls",
	[PlayabilityStatusEnum.ContextualPlayabilityRegionalAvailability] = "Feature.ExperienceDetails.UnplayableError.ContextualPlayabilityRegionalAvailability",
	[PlayabilityStatusEnum.ContextualPlayabilityRegionalCompliance] = "Feature.ExperienceDetails.UnplayableError.ContextualPlayabilityRegionalCompliance",
	[PlayabilityStatusEnum.ContextualPlayabilityUnverifiedSeventeenPlusUser] = "Feature.GamePage.QuickLaunch.LaunchError.ContextualPlayabilityUnverifiedSeventeenPlusUser",
	[PlayabilityStatusEnum.PlaceHasNoPublishedVersion] = "Feature.ExperienceDetails.UnplayableError.PlaceHasNoPublishedVersion",
	[PlayabilityStatusEnum.IncorrectConfiguration] = "Feature.ExperienceDetails.UnplayableError.IncorrectConfiguration",
	[PlayabilityStatusEnum.ContextualPlayabilityAgeGated] = "Feature.ExperienceDetails.UnplayableError.ContextualPlayabilityAgeGated",
	[PlayabilityStatusEnum.ContextualPlayabilityUnrated] = "Feature.ExperienceDetails.UnplayableError.ContextualPlayabilityUnrated",
	[PlayabilityStatusEnum.ContextualPlayabilityAgeGatedByDescriptor] = "Feature.ExperienceDetails.UnplayableError.ContextualPlayabilityAgeGatedByDescriptor",
	[PlayabilityStatusEnum.FiatPurchaseDeviceRestricted] = "Feature.ExperienceDetails.UnplayableError.DeviceRestrictedDefault",
	[PlayabilityStatusEnum.ContextualPlayabilityExperienceBlockedParentalControls] = if not FFlagLuaAppBlockedUnplayableError then nil else "Feature.ExperienceDetails.UnplayableError.ContextualPlayabilityExperienceBlockedParentalControls",
	Default = "Feature.ExperienceDetails.UnplayableError.UnplayableOther"
}

setmetatable(t1, {
	__newindex = function(_, _, _) -- line: 42
	end,
	__index = function(_, p5) -- line: 43
		-- upvalues: t2 (copy)
		assert(p5 ~= nil, "LaunchErrorLocalizationKeys needs a key")

		return t2[p5] or t2.Default
	end
})

return t1
