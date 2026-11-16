local v5 = {
	ruleTitle = "Feature.NotApproved.Heading.RuleExplanation.Dating",
	ruleSubtitle = "Feature.NotApproved.SubHeading.RuleExplanation.Dating",
	ruleDescription = "Feature.NotApproved.Description.RuleExplanation.Dating",
	importanceTitle = "Feature.NotApproved.Heading.RuleImportance",
	importanceDescription = "Feature.NotApproved.Description.RuleImportance.Dating",
	policyKey = "dating"
}

local v6 = {
	ruleTitle = "Feature.NotApproved.Heading.RuleExplanation.BullyingHarassmentDiscrimination",
	ruleSubtitle = "Feature.NotApproved.SubHeading.RuleExplanation.BullyingHarassmentDiscrimination",
	ruleDescription = "Feature.NotApproved.Description.RuleExplanation.BullyingHarassmentDiscrimination",
	importanceTitle = "Feature.NotApproved.Heading.RuleImportance",
	importanceDescription = "Feature.NotApproved.Description.RuleImportance.BullyingHarassmentDiscrimination",
	policyKey = "bullying-harassment-discrimination"
}

local v7 = {
	ruleTitle = "Feature.NotApproved.Heading.RuleExplanation.MisusingRobloxSystems",
	ruleSubtitle = "Feature.NotApproved.SubHeading.RuleExplanation.MisusingRobloxSystems",
	ruleDescription = "Feature.NotApproved.Description.RuleExplanation.MisusingRobloxSystems",
	ruleDescriptionBullets = "Feature.NotApproved.Description.RuleExplanation.Bullets.MisusingRobloxSystems",
	importanceTitle = "Feature.NotApproved.Heading.RuleImportance",
	importanceDescription = "Feature.NotApproved.Description.RuleImportance.MisusingRobloxSystems",
	policyKey = "misusing-roblox-systems"
}

local v8 = {
	ruleTitle = "Feature.NotApproved.Heading.RuleExplanation.PII",
	ruleSubtitle = "Feature.NotApproved.SubHeading.RuleExplanation.PII",
	ruleDescription = "Feature.NotApproved.Description.RuleExplanation.PII",
	ruleDescriptionBullets = "Feature.NotApproved.Description.RuleExplanation.Bullets.PII",
	importanceTitle = "Feature.NotApproved.Heading.RuleImportance",
	importanceDescription = "Feature.NotApproved.Description.RuleImportance.PII",
	policyKey = "pii"
}

local v9 = {
	ruleTitle = "Feature.NotApproved.Heading.RuleExplanation.SSHAndIllegalRegulatedActivities",
	ruleSubtitle = "Feature.NotApproved.SubHeading.RuleExplanation.SSHAndIllegalRegulatedActivities",
	ruleDescription = "Feature.NotApproved.Description.RuleExplanation.SSHAndIllegalRegulatedActivities",
	ruleDescriptionBullets = "Feature.NotApproved.Description.RuleExplanation.Bullets.SSHAndIllegalRegAct",
	importanceTitle = "Feature.NotApproved.Heading.RuleImportance",
	importanceDescription = "Feature.NotApproved.Description.RuleImportance.SSHAndIllegalRegulatedActivities",
	policyKey = "ssh-and-illegal-regulated-activities"
}
return {
	["Label.AbuseType.CheatandExploits"] = v7,
	["Label.AbuseType.ContestsandSweepstakes"] = v9,
	["Label.AbuseType.Dating"] = v5,
	["Label.AbuseType.DirectingUsersOffPlatform"] = {
		ruleTitle = "Feature.NotApproved.Heading.RuleExplanation.DirectingUsersOffPlatform",
		ruleSubtitle = "Feature.NotApproved.SubHeading.RuleExplanation.DirectingUsersOffPlatform",
		ruleDescription = "Feature.NotApproved.Description.RuleExplanation.DirectingUsersOffPlatform",
		importanceTitle = "Feature.NotApproved.Heading.RuleImportance",
		importanceDescription = "Feature.NotApproved.Description.RuleImportance.DirectingUsersOffPlatform",
		policyKey = "directing-users-off-platform"
	},
	["Label.AbuseType.DiscriminatoryContent"] = v6,
	["Label.AbuseType.DisruptiveAudio"] = v7,
	["Label.AbuseType.EncouragingDangerousBehavior"] = v9,
	["Label.AbuseType.ExtortionandBlackmail"] = v6,
	["Label.AbuseType.Harassment"] = v6,
	["Label.AbuseType.IllegalandRegulatedContent"] = v9,
	["Label.AbuseType.Impersonation"] = v6,
	["Label.AbuseType.IrlDangerousActivities"] = v9,
	["Label.AbuseType.MisusingRobloxSystems"] = v7,
	["Label.AbuseType.OffPlatformSpeechandBehavior"] = v6,
	["Label.AbuseType.PrivacyAskingforPII"] = v8,
	["Label.AbuseType.PrivacyGivingPII"] = v8,
	["Label.AbuseType.RealLifeThreats"] = v6,
	["Label.AbuseType.Scamming"] = v7,
	["Label.AbuseType.SexualContent"] = v5,
	["Label.AbuseType.Spam"] = {
		ruleTitle = "Feature.NotApproved.Heading.RuleExplanation.Spam",
		ruleSubtitle = "Feature.NotApproved.SubHeading.RuleExplanation.Spam",
		ruleDescription = "Feature.NotApproved.Description.RuleExplanation.Spam",
		importanceTitle = "Feature.NotApproved.Heading.RuleImportance",
		importanceDescription = "Feature.NotApproved.Description.RuleImportance.Spam",
		policyKey = "spam"
	},
	["Label.AbuseType.SuicideSelfHarm"] = v9,
	["Label.AbuseType.Swearing"] = {
		ruleTitle = "Feature.NotApproved.Heading.RuleExplanation.Swearing",
		ruleSubtitle = "Feature.NotApproved.SubHeading.RuleExplanation.Swearing",
		ruleDescription = "Feature.NotApproved.Description.RuleExplanation.Swearing",
		importanceTitle = "Feature.NotApproved.Heading.RuleImportance",
		importanceDescription = "Feature.NotApproved.Description.RuleImportance.Swearing",
		policyKey = "swearing"
	},
	["Label.AbuseType.ThreatsOrAbuseOfRobloxEmployeesOrAffiliates"] = v6,
	["Label.AbuseType.ViolentContentAndGore"] = {
		ruleTitle = "Feature.NotApproved.Heading.RuleExplanation.ViolentContentAndGore",
		ruleSubtitle = "Feature.NotApproved.SubHeading.RuleExplanation.ViolentContentAndGore",
		ruleDescription = "Feature.NotApproved.Description.RuleExplanation.ViolentContentAndGore",
		importanceTitle = "Feature.NotApproved.Heading.RuleImportance",
		importanceDescription = "Feature.NotApproved.Description.RuleImportance.ViolentContentAndGore",
		policyKey = "violent-content-and-gore"
	},
	["Label.AbuseType.VirtualCasino"] = v9,
	["Label.Sublabel.RealLifeEvents"] = {
		ruleTitle = "Feature.NotApproved.Heading.RuleExplanation.RealLifeEvents",
		ruleSubtitle = "Feature.NotApproved.SubHeading.RuleExplanation.RealLifeEvents",
		ruleDescription = "Feature.NotApproved.Description.RuleExplanation.RealLifeEvents",
		ruleDescriptionBullets = "Feature.NotApproved.Description.RuleExplanation.Bullets.RealLifeEvents",
		importanceTitle = "Feature.NotApproved.Heading.RuleImportance",
		importanceDescription = "Feature.NotApproved.Description.RuleImportance.RealLifeEvents",
		policyKey = "real-life-events"
	},
	["Label.Sublabel.RomanceOrSex"] = v5
}
