local parent = script:FindFirstAncestor("ChatLineReporting").Parent

local AbuseCategory = require(parent.GenericAbuseReporting.AbuseCategory)

return {
	{
		localizationKey = "Feature.ReportAbuse.Problem.Bullying",
		value = AbuseCategory.ABUSE_CATEGORY_BULLYING,
		descriptionLocalizationKey = "Feature.ReportAbuse.ProblemDescription.Bullying"
	},
	{
		localizationKey = "Feature.ReportAbuse.Problem.Cheating",
		value = AbuseCategory.ABUSE_CATEGORY_CHEATING,
		descriptionLocalizationKey = "Feature.ReportAbuse.ProblemDescription.Cheating"
	},
	{
		localizationKey = "Feature.ReportAbuse.Problem.Dating",
		value = AbuseCategory.ABUSE_CATEGORY_DATING,
		descriptionLocalizationKey = "Feature.ReportAbuse.ProblemDescription.Dating"
	},
	{
		localizationKey = "Feature.ReportAbuse.Problem.Hate",
		value = AbuseCategory.ABUSE_CATEGORY_HATE_SPEECH,
		descriptionLocalizationKey = "Feature.ReportAbuse.ProblemDescription.Hate"
	},
	{
		localizationKey = "Feature.ReportAbuse.Problem.Links",
		value = AbuseCategory.ABUSE_CATEGORY_OFFSITE_LINKS,
		descriptionLocalizationKey = "Feature.ReportAbuse.ProblemDescription.Links"
	},
	{
		localizationKey = "Feature.ReportAbuse.Problem.Personal",
		value = AbuseCategory.ABUSE_CATEGORY_PERSONAL_QUESTION,
		descriptionLocalizationKey = "Feature.ReportAbuse.ProblemDescription.Personal"
	},
	{
		localizationKey = "Feature.ReportAbuse.Problem.Scamming",
		value = AbuseCategory.ABUSE_CATEGORY_SCAMMING,
		descriptionLocalizationKey = "Feature.ReportAbuse.ProblemDescription.Scamming"
	},
	{
		localizationKey = "Feature.ReportAbuse.Problem.Spamming",
		value = AbuseCategory.ABUSE_CATEGORY_SPAMMING,
		descriptionLocalizationKey = "Feature.ReportAbuse.ProblemDescription.Spamming"
	},
	{
		localizationKey = "Feature.ReportAbuse.Problem.Swearing",
		value = AbuseCategory.ABUSE_CATEGORY_SWEARING,
		descriptionLocalizationKey = "Feature.ReportAbuse.ProblemDescription.Swearing"
	},
	{
		localizationKey = "Feature.ReportAbuse.Problem.Violence",
		value = AbuseCategory.ABUSE_CATEGORY_VIOLENCE_OR_TERRORISM,
		descriptionLocalizationKey = "Feature.ReportAbuse.ProblemDescription.Violence"
	}
}
