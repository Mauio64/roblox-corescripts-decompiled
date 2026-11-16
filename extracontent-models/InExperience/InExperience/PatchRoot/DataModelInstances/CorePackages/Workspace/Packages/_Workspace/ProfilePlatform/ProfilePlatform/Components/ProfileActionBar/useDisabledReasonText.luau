local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local Enums = require(ProfilePlatform.Common.Enums)

local v = {
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

return function(p)
	local disabledReasonText

	if p then
		disabledReasonText = v[p]
	end

	return useLocalization({ disabledReasonText = disabledReasonText }).disabledReasonText
end
