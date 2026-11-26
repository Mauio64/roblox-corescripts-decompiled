local module = require("@luauforge/bundled/hQO")

local module2 = require("@luauforge/bundled/hYP")

local v5 = {
	LocalizationKeyPrefix = "Feature.Home",
	LocalizationKeys = {
		ButtonText = "Feature.Home.Experiment.Reminders.Button",
		OkButtonText = "CommonUI.Controls.Action.OK",
		ReminderTitle = "Feature.Home.Experiment.Reminders.Title",
		SharedBody = "Feature.Home.Experiment.Reminders.BodyShared",
		PositiveVariantBody = "Feature.Home.Experiment.Reminders.BodyPositiveVariant",
		WarningVariantBody = "Feature.Home.Experiment.Reminders.BodyWarningVariant",
		TextFilterEducationKidsTitleModifiedVariant = "Feature.Home.Experiment.TextFilterEducation.Kids.Title.Modified",
		TextFilterEducationKidsTitleWarningVariant = "Feature.Home.Experiment.TextFilterEducation.Kids.Title.Warning",
		TextFilterEducationKidsBodyRespect = "Feature.Home.Experiment.TextFilterEducation.Kids.Body.Respect",
		TextFilterEducationKidsBodySpam = "Feature.Home.Experiment.TextFilterEducation.Kids.Body.Spam",
		TextFilterEducationKidsBodyPii = "Feature.Home.Experiment.TextFilterEducation.Kids.Body.Pii",
		TextFilterEducationGeneralTitleWarningVariant = "Feature.Home.Experiment.TextFilterEducation.General.Title.Warning",
		TextFilterEducationGeneralBodyRespectModifiedVariant = "Feature.Home.Experiment.TextFilterEducation.General.Body.Respect.Modified",
		TextFilterEducationGeneralBodyRespectWarningVariant = "Feature.Home.Experiment.TextFilterEducation.General.Body.Respect.Warning",
		TextFilterEducationGeneralBodySpamModifiedVariant = "Feature.Home.Experiment.TextFilterEducation.General.Body.Spam.Modified",
		TextFilterEducationGeneralBodySpamWarningVariant = "Feature.Home.Experiment.TextFilterEducation.General.Body.Spam.Warning",
		TextFilterEducationGeneralBodyPiiModifiedVariant = "Feature.Home.Experiment.TextFilterEducation.General.Body.Pii.Modified",
		TextFilterEducationGeneralBodyPiiWarningVariant = "Feature.Home.Experiment.TextFilterEducation.General.Body.Pii.Warning",
		TextFilterEducationGeneralBodyRomanceModifiedVariant = "Feature.Home.Experiment.TextFilterEducation.General.Body.Romance.Modified",
		TextFilterEducationGeneralBodyRomanceWarningVariant = "Feature.Home.Experiment.TextFilterEducation.General.Body.Romance.Warning",
		TextFilterEducationGeneralBodyRespectWarningVariantV2 = "Feature.Home.TextFilterEducation.General.Body.Respect.Warning.V2",
		TextFilterEducationGeneralBodySpamWarningVariantV2 = "Feature.Home.TextFilterEducation.General.Body.Spam.Warning.V2",
		TextFilterEducationGeneralBodyPiiWarningVariantV2 = "Feature.Home.TextFilterEducation.General.Body.Pii.Warning.V2"
	}
}

local v6 = {
	[module.ContentVariant.TextFilterEducationKindWord] = v5.LocalizationKeys.TextFilterEducationKidsBodyRespect,
	[module.ContentVariant.TextFilterEducationNoSpam] = v5.LocalizationKeys.TextFilterEducationKidsBodySpam,
	[module.ContentVariant.TextFilterEducationNoPersonalInfo] = v5.LocalizationKeys.TextFilterEducationKidsBodyPii
}

local v7 = {
	[module.ContentVariant.TextFilterEducationKindWord] = v5.LocalizationKeys.TextFilterEducationGeneralBodyRespectModifiedVariant,
	[module.ContentVariant.TextFilterEducationNoSpam] = v5.LocalizationKeys.TextFilterEducationGeneralBodySpamModifiedVariant,
	[module.ContentVariant.TextFilterEducationNoPersonalInfo] = v5.LocalizationKeys.TextFilterEducationGeneralBodyPiiModifiedVariant,
	[module.ContentVariant.TextFilterEducationNoSexual] = v5.LocalizationKeys.TextFilterEducationGeneralBodyRomanceModifiedVariant
}

local v8 = {
	[module.ContentVariant.TextFilterEducationKindWord] = v5.LocalizationKeys.TextFilterEducationGeneralBodyRespectWarningVariant,
	[module.ContentVariant.TextFilterEducationNoSpam] = v5.LocalizationKeys.TextFilterEducationGeneralBodySpamWarningVariant,
	[module.ContentVariant.TextFilterEducationNoPersonalInfo] = v5.LocalizationKeys.TextFilterEducationGeneralBodyPiiWarningVariant,
	[module.ContentVariant.TextFilterEducationNoSexual] = v5.LocalizationKeys.TextFilterEducationGeneralBodyRomanceWarningVariant
}

local v9 = {
	[module.ContentVariant.TextFilterEducationKindWord] = v5.LocalizationKeys.TextFilterEducationGeneralBodyRespectWarningVariantV2,
	[module.ContentVariant.TextFilterEducationNoSpam] = v5.LocalizationKeys.TextFilterEducationGeneralBodySpamWarningVariantV2,
	[module.ContentVariant.TextFilterEducationNoPersonalInfo] = v5.LocalizationKeys.TextFilterEducationGeneralBodyPiiWarningVariantV2,
	[module.ContentVariant.TextFilterEducationNoSexual] = v5.LocalizationKeys.TextFilterEducationGeneralBodyRomanceWarningVariant
}

local function getBodyKey(p2, p3, p4)
	if p3 == nil then
		return p4
	end

	return p2[p3] or p4
end

return {
	Constants = v5,
	getReminderVariantBodyKey = function(p2)
		local v10 = ""

		if p2 == "positive" then
			return v5.LocalizationKeys.PositiveVariantBody
		end

		if p2 == "warning" then
			v10 = v5.LocalizationKeys.WarningVariantBody
		end

		return v10
	end,
	getTextFilterEducationLocalizationKeys = function(p2, p3, p4)
		local v10 = p2 == module.ExperimentVariant.ChangeOrBlock

		if p4 then
			local v11

			if v10 then
				v11 = v5.LocalizationKeys.TextFilterEducationKidsTitleModifiedVariant
			else
				v11 = v5.LocalizationKeys.TextFilterEducationKidsTitleWarningVariant
			end

			local textFilterEducationKidsBodyRespect = v5.LocalizationKeys.TextFilterEducationKidsBodyRespect

			if p3 == nil then
				return v11, textFilterEducationKidsBodyRespect
			end

			return v11, v6[p3] or textFilterEducationKidsBodyRespect
		else
			local v11

			if v10 then
				v11 = v5.LocalizationKeys.TextFilterEducationKidsTitleModifiedVariant
			else
				v11 = v5.LocalizationKeys.TextFilterEducationGeneralTitleWarningVariant
			end

			local v12 = if v10 then v7 else v8
			local v13

			if v10 then
				v13 = v5.LocalizationKeys.TextFilterEducationGeneralBodyRespectModifiedVariant
			else
				v13 = v5.LocalizationKeys.TextFilterEducationGeneralBodyRespectWarningVariant
			end

			if module2 and not v10 then
				v12 = v9
				v13 = v5.LocalizationKeys.TextFilterEducationGeneralBodyRespectWarningVariantV2
			end

			if p3 == nil then
				return v11, v13
			end

			return v11, v12[p3] or v13
		end
	end
}
