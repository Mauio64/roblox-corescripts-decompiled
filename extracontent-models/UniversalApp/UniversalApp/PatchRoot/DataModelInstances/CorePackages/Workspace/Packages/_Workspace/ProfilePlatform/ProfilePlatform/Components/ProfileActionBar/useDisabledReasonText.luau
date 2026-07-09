local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local Enums = require(ProfilePlatform.Common.Enums)
local t1 = {
	[Enums.DisabledReasons.BannedFromCommunity] = TextKeys.BannedFromGroup,
	[Enums.DisabledReasons.CommunityIsClosed] = TextKeys.GroupClosed,
	[Enums.DisabledReasons.MaxCommunitiesJoined] = TextKeys.PremiumMaxGroups,
	[Enums.DisabledReasons.AccountCreatedLessThanOneDay] = TextKeys.RequiresAccountTenureTooltipOneDay,
	[Enums.DisabledReasons.AccountCreatedLessThanThreeDays] = TextKeys.RequiresAccountTenureTooltipThreeDays,
	[Enums.DisabledReasons.AccountCreatedLessThanOneWeek] = TextKeys.RequiresAccountTenureTooltipOneWeek,
	[Enums.DisabledReasons.AccountCreatedLessThanOneMonth] = TextKeys.RequiresAccountTenureTooltipOneMonth,
	[Enums.DisabledReasons.AccountCreatedLessThanThreeMonths] = TextKeys.RequiresAccountTenureTooltipThreeMonths,
	[Enums.DisabledReasons.InsufficientVerificationLevelHigh] = nil,
	[Enums.DisabledReasons.InsufficientVerificationLevelMedium] = nil,
	[Enums.DisabledReasons.InsufficientVerificationLevelLow] = nil
}

return function(p1) -- line: 24
	-- upvalues: t1 (copy), useLocalization (copy)
	local v8 = if not p1 then nil else t1[p1]

	return useLocalization({
		disabledReasonText = v8
	}).disabledReasonText
end
