local retrievalStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/GameLaunch/Http").Enum.RetrievalStatus
local playabilityStatusEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/GameLaunch/DiscoveryTypes").PlayabilityStatusEnum

local fFlagLuaAppBlockedUnplayableError = require("@game/CorePackages/Workspace/Packages/_Workspace/GameLaunch/SharedFlags").FFlagLuaAppBlockedUnplayableError

local v5 = {}

local v6 = {
	[retrievalStatus.Failed] = "Feature.GamePage.QuickLaunch.LaunchError.RequestFailed",
	[playabilityStatusEnum.GuestProhibited] = "Feature.GamePage.QuickLaunch.LaunchError.GuestProhibited",
	[playabilityStatusEnum.GameUnapproved] = "Feature.ExperienceDetails.UnplayableError.GameUnapproved",
	[playabilityStatusEnum.UniverseRootPlaceIsPrivate] = "Feature.ExperienceDetails.UnplayableError.UniverseRootPlaceIsPrivate",
	[playabilityStatusEnum.InsufficientPermissionFriendsOnly] = "Feature.ExperienceDetails.UnplayableError.InsufficientPermissionFriendsOnly",
	[playabilityStatusEnum.InsufficientPermissionGroupOnly] = "Feature.ExperienceDetails.UnplayableError.InsufficientPermissionGroupOnly",
	[playabilityStatusEnum.DeviceRestricted] = "Feature.ExperienceDetails.UnplayableError.DeviceRestrictedDefault",
	[playabilityStatusEnum.UnderReview] = "Feature.ExperienceDetails.UnplayableError.UnderReview",
	[playabilityStatusEnum.PurchaseRequired] = "Feature.GamePage.QuickLaunch.LaunchError.PurchaseRequired",
	[playabilityStatusEnum.AccountRestricted] = "Feature.ExperienceDetails.UnplayableError.AccountRestricted",
	[playabilityStatusEnum.TemporarilyUnavailable] = "Feature.ExperienceDetails.UnplayableError.TemporarilyUnavailable",
	[playabilityStatusEnum.ComplianceBlocked] = "Feature.ExperienceDetails.UnplayableError.ComplianceBlocked",
	[playabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls] = "Feature.ExperienceDetails.UnplayableError.ContextualPlayabilityAgeRecommendationParentalControls",
	[playabilityStatusEnum.ContextualPlayabilityRegionalAvailability] = "Feature.ExperienceDetails.UnplayableError.ContextualPlayabilityRegionalAvailability",
	[playabilityStatusEnum.ContextualPlayabilityRegionalCompliance] = "Feature.ExperienceDetails.UnplayableError.ContextualPlayabilityRegionalCompliance",
	[playabilityStatusEnum.ContextualPlayabilityUnverifiedSeventeenPlusUser] = "Feature.GamePage.QuickLaunch.LaunchError.ContextualPlayabilityUnverifiedSeventeenPlusUser",
	[playabilityStatusEnum.PlaceHasNoPublishedVersion] = "Feature.ExperienceDetails.UnplayableError.PlaceHasNoPublishedVersion",
	[playabilityStatusEnum.IncorrectConfiguration] = "Feature.ExperienceDetails.UnplayableError.IncorrectConfiguration",
	[playabilityStatusEnum.ContextualPlayabilityAgeGated] = "Feature.ExperienceDetails.UnplayableError.ContextualPlayabilityAgeGated",
	[playabilityStatusEnum.ContextualPlayabilityUnrated] = "Feature.ExperienceDetails.UnplayableError.ContextualPlayabilityUnrated",
	[playabilityStatusEnum.ContextualPlayabilityAgeGatedByDescriptor] = "Feature.ExperienceDetails.UnplayableError.ContextualPlayabilityAgeGatedByDescriptor",
	[playabilityStatusEnum.FiatPurchaseDeviceRestricted] = "Feature.ExperienceDetails.UnplayableError.FiatPurchaseDeviceRestricted",
	[playabilityStatusEnum.ContextualPlayabilityExperienceBlockedParentalControls] = fFlagLuaAppBlockedUnplayableError and "Feature.ExperienceDetails.UnplayableError.ContextualPlayabilityExperienceBlockedParentalControls" or nil,
	Default = "Feature.ExperienceDetails.UnplayableError.UnplayableOther"
}

setmetatable(v5, {
	__newindex = function(p2, p3, p4) end,
	__index = function(p2, p3)
		assert(p3 ~= nil, "LaunchErrorLocalizationKeys needs a key")
		return v6[p3] or v6.Default
	end
})

return v5
