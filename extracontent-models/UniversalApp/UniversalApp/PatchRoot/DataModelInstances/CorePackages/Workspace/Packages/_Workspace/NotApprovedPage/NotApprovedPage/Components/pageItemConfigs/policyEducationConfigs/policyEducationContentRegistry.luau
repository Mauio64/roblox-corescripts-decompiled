local t1 = {
	ruleTitle = "Feature.NotApproved.Heading.RuleExplanation.Swearing",
	ruleSubtitle = "Feature.NotApproved.SubHeading.RuleExplanation.Swearing",
	ruleDescription = "Feature.NotApproved.Description.RuleExplanation.Swearing",
	importanceTitle = "Feature.NotApproved.Heading.RuleImportance",
	importanceDescription = "Feature.NotApproved.Description.RuleImportance.Swearing",
	policyKey = "swearing"
}
local t2 = {
	ruleTitle = "Feature.NotApproved.Heading.RuleExplanation.Dating",
	ruleSubtitle = "Feature.NotApproved.SubHeading.RuleExplanation.Dating",
	ruleDescription = "Feature.NotApproved.Description.RuleExplanation.Dating",
	importanceTitle = "Feature.NotApproved.Heading.RuleImportance",
	importanceDescription = "Feature.NotApproved.Description.RuleImportance.Dating",
	policyKey = "dating"
}
local t3 = {
	ruleTitle = "Feature.NotApproved.Heading.RuleExplanation.BullyingHarassmentDiscrimination",
	ruleSubtitle = "Feature.NotApproved.SubHeading.RuleExplanation.BullyingHarassmentDiscrimination",
	ruleDescription = "Feature.NotApproved.Description.RuleExplanation.BullyingHarassmentDiscrimination",
	importanceTitle = "Feature.NotApproved.Heading.RuleImportance",
	importanceDescription = "Feature.NotApproved.Description.RuleImportance.BullyingHarassmentDiscrimination",
	policyKey = "bullying-harassment-discrimination"
}
local t4 = {
	ruleTitle = "Feature.NotApproved.Heading.RuleExplanation.DirectingUsersOffPlatform",
	ruleSubtitle = "Feature.NotApproved.SubHeading.RuleExplanation.DirectingUsersOffPlatform",
	ruleDescription = "Feature.NotApproved.Description.RuleExplanation.DirectingUsersOffPlatform",
	importanceTitle = "Feature.NotApproved.Heading.RuleImportance",
	importanceDescription = "Feature.NotApproved.Description.RuleImportance.DirectingUsersOffPlatform",
	policyKey = "directing-users-off-platform"
}
local t5 = {
	ruleTitle = "Feature.NotApproved.Heading.RuleExplanation.MisusingRobloxSystems",
	ruleSubtitle = "Feature.NotApproved.SubHeading.RuleExplanation.MisusingRobloxSystems",
	ruleDescription = "Feature.NotApproved.Description.RuleExplanation.MisusingRobloxSystems",
	ruleDescriptionBullets = "Feature.NotApproved.Description.RuleExplanation.Bullets.MisusingRobloxSystems",
	importanceTitle = "Feature.NotApproved.Heading.RuleImportance",
	importanceDescription = "Feature.NotApproved.Description.RuleImportance.MisusingRobloxSystems",
	policyKey = "misusing-roblox-systems"
}
local t6 = {
	ruleTitle = "Feature.NotApproved.Heading.RuleExplanation.PII",
	ruleSubtitle = "Feature.NotApproved.SubHeading.RuleExplanation.PII",
	ruleDescription = "Feature.NotApproved.Description.RuleExplanation.PII",
	ruleDescriptionBullets = "Feature.NotApproved.Description.RuleExplanation.Bullets.PII",
	importanceTitle = "Feature.NotApproved.Heading.RuleImportance",
	importanceDescription = "Feature.NotApproved.Description.RuleImportance.PII",
	policyKey = "pii"
}
local t7 = {
	ruleTitle = "Feature.NotApproved.Heading.RuleExplanation.RealLifeEvents",
	ruleSubtitle = "Feature.NotApproved.SubHeading.RuleExplanation.RealLifeEvents",
	ruleDescription = "Feature.NotApproved.Description.RuleExplanation.RealLifeEvents",
	ruleDescriptionBullets = "Feature.NotApproved.Description.RuleExplanation.Bullets.RealLifeEvents",
	importanceTitle = "Feature.NotApproved.Heading.RuleImportance",
	importanceDescription = "Feature.NotApproved.Description.RuleImportance.RealLifeEvents",
	policyKey = "real-life-events"
}
local t8 = {
	ruleTitle = "Feature.NotApproved.Heading.RuleExplanation.Spam",
	ruleSubtitle = "Feature.NotApproved.SubHeading.RuleExplanation.Spam",
	ruleDescription = "Feature.NotApproved.Description.RuleExplanation.Spam",
	importanceTitle = "Feature.NotApproved.Heading.RuleImportance",
	importanceDescription = "Feature.NotApproved.Description.RuleImportance.Spam",
	policyKey = "spam"
}
local t9 = {
	ruleTitle = "Feature.NotApproved.Heading.RuleExplanation.SSHAndIllegalRegulatedActivities",
	ruleSubtitle = "Feature.NotApproved.SubHeading.RuleExplanation.SSHAndIllegalRegulatedActivities",
	ruleDescription = "Feature.NotApproved.Description.RuleExplanation.SSHAndIllegalRegulatedActivities",
	ruleDescriptionBullets = "Feature.NotApproved.Description.RuleExplanation.Bullets.SSHAndIllegalRegAct",
	importanceTitle = "Feature.NotApproved.Heading.RuleImportance",
	importanceDescription = "Feature.NotApproved.Description.RuleImportance.SSHAndIllegalRegulatedActivities",
	policyKey = "ssh-and-illegal-regulated-activities"
}
local t10 = {
	ruleTitle = "Feature.NotApproved.Heading.RuleExplanation.ViolentContentAndGore",
	ruleSubtitle = "Feature.NotApproved.SubHeading.RuleExplanation.ViolentContentAndGore",
	ruleDescription = "Feature.NotApproved.Description.RuleExplanation.ViolentContentAndGore",
	importanceTitle = "Feature.NotApproved.Heading.RuleImportance",
	importanceDescription = "Feature.NotApproved.Description.RuleImportance.ViolentContentAndGore",
	policyKey = "violent-content-and-gore"
}

return {
	["Label.AbuseType.CheatandExploits"] = t5,
	["Label.AbuseType.ContestsandSweepstakes"] = t9,
	["Label.AbuseType.Dating"] = t2,
	["Label.AbuseType.DirectingUsersOffPlatform"] = t4,
	["Label.AbuseType.DiscriminatoryContent"] = t3,
	["Label.AbuseType.DisruptiveAudio"] = t5,
	["Label.AbuseType.EncouragingDangerousBehavior"] = t9,
	["Label.AbuseType.ExtortionandBlackmail"] = t3,
	["Label.AbuseType.Harassment"] = t3,
	["Label.AbuseType.IllegalandRegulatedContent"] = t9,
	["Label.AbuseType.Impersonation"] = t3,
	["Label.AbuseType.IrlDangerousActivities"] = t9,
	["Label.AbuseType.MisusingRobloxSystems"] = t5,
	["Label.AbuseType.OffPlatformSpeechandBehavior"] = t3,
	["Label.AbuseType.PrivacyAskingforPII"] = t6,
	["Label.AbuseType.PrivacyGivingPII"] = t6,
	["Label.AbuseType.RealLifeThreats"] = t3,
	["Label.AbuseType.Scamming"] = t5,
	["Label.AbuseType.SexualContent"] = t2,
	["Label.AbuseType.Spam"] = t8,
	["Label.AbuseType.SuicideSelfHarm"] = t9,
	["Label.AbuseType.Swearing"] = t1,
	["Label.AbuseType.ThreatsOrAbuseOfRobloxEmployeesOrAffiliates"] = t3,
	["Label.AbuseType.ViolentContentAndGore"] = t10,
	["Label.AbuseType.VirtualCasino"] = t9,
	["Label.Sublabel.RealLifeEvents"] = t7,
	["Label.Sublabel.RomanceOrSex"] = t2
}
