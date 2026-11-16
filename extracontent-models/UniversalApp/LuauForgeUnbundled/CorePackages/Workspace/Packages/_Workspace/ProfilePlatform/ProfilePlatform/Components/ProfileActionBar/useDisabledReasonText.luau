local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")

local v5 = {
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

return function(p2)
	local v6 = if p2 then v5[p2] else nil

	return useLocalization({ disabledReasonText = v6 }).disabledReasonText
end
