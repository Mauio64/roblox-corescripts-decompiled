require("@luauforge/deferred/gAg")

local v5 = {
	displayLabel = "Feature.NotApproved.Label.AbuseType.SharingPII.Kids",
	moderatorNote = "Feature.NotApproved.Label.AbuseType.SharingPII.Note.Kids",
	education = {
		ruleTitle = "Feature.NotApproved.Heading.RuleExplanation.SharingPII.Kids",
		ruleDescription = "Feature.NotApproved.Description.RuleExplanation.SharingPII.Kids",
		ruleDescriptionBullets = "Feature.NotApproved.Description.RuleExplanation.Bullets.SharingPII.Kids",
		importanceTitle = "Feature.NotApproved.Heading.RuleImportance.Kids",
		importanceDescriptionBullets = "Feature.NotApproved.Description.RuleImportance.Bullets.SharingPII.Kids",
		policyKey = "kids-sharing-pii",
		deduplicationKey = "pii"
	}
}
local v6 = {
	["Label.AbuseType.Harassment"] = {
		displayLabel = "Feature.NotApproved.Label.AbuseType.Bullying.Kids",
		moderatorNote = "Feature.NotApproved.Label.AbuseType.Bullying.Note.Kids",
		education = {
			ruleTitle = "Feature.NotApproved.Heading.RuleExplanation.Bullying.Kids",
			ruleDescriptionBullets = "Feature.NotApproved.Description.RuleExplanation.Bullets.Bullying.Kids",
			importanceTitle = "Feature.NotApproved.Heading.RuleImportance.Kids",
			importanceDescription = "Feature.NotApproved.Description.RuleImportance.Bullying.Kids",
			policyKey = "kids-bullying",
			deduplicationKey = "bullying-harassment-discrimination"
		}
	},
	["Label.AbuseType.PrivacyAskingforPII"] = v5,
	["Label.AbuseType.PrivacyGivingPII"] = v5,
	["Label.AbuseType.SexualContent"] = {
		displayLabel = "Feature.NotApproved.Label.AbuseType.SexualContent.Kids",
		moderatorNote = "Feature.NotApproved.Label.AbuseType.SexualContent.Note.Kids",
		education = {
			ruleTitle = "Feature.NotApproved.Heading.RuleExplanation.SexualContent.Kids",
			ruleDescriptionBullets = "Feature.NotApproved.Description.RuleExplanation.Bullets.SexualContent.Kids",
			importanceTitle = "Feature.NotApproved.Heading.RuleImportance.Kids",
			importanceDescription = "Feature.NotApproved.Description.RuleImportance.SexualContent.Kids",
			policyKey = "kids-sexual-content",
			deduplicationKey = "dating"
		}
	}
}

local v7 = {}

for k, v8 in v6 do
	v7[v8.displayLabel] = v8.displayLabel
	v7[v8.moderatorNote] = v8.moderatorNote
end

return { CONTENT_BY_ABUSE_KEY = v6, TRANSLATION_KEYS = v7 }
