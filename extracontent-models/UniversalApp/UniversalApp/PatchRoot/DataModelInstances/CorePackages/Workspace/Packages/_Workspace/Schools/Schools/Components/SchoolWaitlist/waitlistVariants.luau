local Schools = script:FindFirstAncestor("Schools")
local TextKeys = require(Schools.Common.TextKeys)
local Enums = require(Schools.Common.Enums)
local t1 = {
	Verified = "Verified",
	Pending = "Pending",
	Badge = "Badge",
	Classmates = "Classmates",
	Trends = "Trends"
}
local t2 = {
	hasShareMedia = true,
	bodyKey = TextKeys.WaitlistBody,
	shareTitleKey = TextKeys.ShareBannerTitle,
	shareBodyKey = TextKeys.ShareBannerBody,
	stages = {
		{
			icon = t1.Verified,
			titleKey = TextKeys.StageVerifiedTitle
		},
		{
			usesCount = true,
			icon = t1.Pending,
			titleKey = TextKeys.StageUnlockTitle,
			bodyKey = TextKeys.StageUnlockBody
		},
		{
			dimmed = true,
			icon = t1.Badge,
			titleKey = TextKeys.StageBadgeTitle,
			bodyKey = TextKeys.StageBadgeBody
		},
		{
			dimmed = true,
			icon = t1.Classmates,
			titleKey = TextKeys.StageClassmatesTitle,
			bodyKey = TextKeys.StageClassmatesBody
		},
		{
			dimmed = true,
			icon = t1.Trends,
			titleKey = TextKeys.StageTrendsTitle,
			bodyKey = TextKeys.StageTrendsBody
		}
	}
}
local t3 = {
	hasShareMedia = false,
	bodyKey = TextKeys.WaitlistAlumniBody,
	shareTitleKey = TextKeys.ShareBannerTitle,
	shareBodyKey = TextKeys.ShareBannerAlumniBody,
	stages = {
		{
			icon = t1.Verified,
			titleKey = TextKeys.StageVerifiedTitle
		},
		{
			icon = t1.Pending,
			titleKey = TextKeys.StageUnlockAlumniTitle,
			bodyKey = TextKeys.StageUnlockAlumniBody
		},
		{
			dimmed = true,
			icon = t1.Badge,
			titleKey = TextKeys.StageBadgeAlumniTitle,
			bodyKey = TextKeys.StageBadgeAlumniBody
		},
		{
			dimmed = true,
			icon = t1.Classmates,
			titleKey = TextKeys.StageClassmatesTitle,
			bodyKey = TextKeys.StageClassmatesAlumniBody
		},
		{
			dimmed = true,
			icon = t1.Trends,
			titleKey = TextKeys.StageTrendsAlumniTitle,
			bodyKey = TextKeys.StageTrendsAlumniBody
		}
	}
}
local t4 = {
	[Enums.SchoolWaitlistVariant.School] = t2,
	[Enums.SchoolWaitlistVariant.Alumni] = t3
}

return {
	StageIcon = t1,
	byVariant = t4
}
