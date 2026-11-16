local module = require("@luauforge/deferred/ehb")
local module2 = require("@luauforge/deferred/egW")

local v5 = { Verified = "Verified", Pending = "Pending", Classmates = "Classmates" }

local v6 = {
	headingKey = module.WaitlistHeading,
	noNameHeadingKey = module.WaitlistInviteClassmatesHeading,
	bodyKey = module.WaitlistBody,
	shareTitleKey = module.ShareBannerTitle,
	shareBodyKey = module.ShareBannerBody,
	stages = {
		{ icon = v5.Verified, titleKey = module.StageVerifiedTitle },
		{
			icon = v5.Pending,
			titleKey = module.StageUnlockTitle,
			bodyKey = module.StageUnlockBody,
			usesCount = true
		},
		{
			icon = v5.Classmates,
			dimmed = true,
			titleKey = module.StageLaunchTitle,
			bodyKey = module.StageLaunchBody
		}
	}
}

local v7 = {
	headingKey = nil,
	noNameHeadingKey = module.WaitlistInviteFriendsHeading,
	bodyKey = module.WaitlistAlumniBody,
	shareTitleKey = module.ShareBannerTitleAlumni,
	shareBodyKey = module.ShareBannerAlumniBody,
	stages = {
		{ icon = v5.Verified, titleKey = module.StageVerifiedTitle },
		{
			icon = v5.Pending,
			titleKey = module.StageUnlockAlumniTitle,
			bodyKey = module.StageUnlockAlumniBody
		},
		{
			icon = v5.Classmates,
			dimmed = true,
			titleKey = module.StageLaunchAlumniTitle,
			bodyKey = module.StageLaunchAlumniBody
		}
	}
}

return {
	StageIcon = v5,
	byVariant = {
		[module2.SchoolWaitlistVariant.School] = v6,
		[module2.SchoolWaitlistVariant.Alumni] = v7
	}
}
