local LocalizationService = game:GetService("LocalizationService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Utility = require(RobloxGui.Modules.Settings.Utility)
local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local Localization = InExperienceLocales.Localization

local v = { "On", "Off" }

return function(state, p, callback)
	local v2 = Localization.new(LocalizationService.RobloxLocaleId)

	local formatted = v2:Format("Translation.PlayerChoiceSettings.GameSettings.PlayerChoiceSettingLabel")
	local formatted2 = v2:Format("Translation.PlayerChoiceSettings.GameSettings.PlayerChoiceSettingDescription")

	local v3 = LocalizationService:GetIsLoadingInternalTranslations() and 1 or 2
	local playerChoiceTranslationFrame, playerChoiceSettingLabel, playerChoiceSettingMode = Utility:AddNewRow(
		state,
		formatted,
		"Selector",
		v,
		v3,
		nil,
		formatted2
	)
	state.PlayerChoiceTranslationFrame = playerChoiceTranslationFrame
	state.PlayerChoiceSettingLabel = playerChoiceSettingLabel
	state.PlayerChoiceSettingMode = playerChoiceSettingMode

	state.PlayerChoiceTranslationFrame.LayoutOrder = p.PlayerChoiceTranslationFrame

	state.PlayerChoiceSettingMode.IndexChanged:connect(function(p2)
		local v4 = p2 == 1
		local v5 = v3 == 1
		LocalizationService:IsLoadingInternalTranslationsSettingChanged(v4)

		callback("player_choice_translation", v5, v4)
	end)

	return state.PlayerChoiceTranslationFrame, state.PlayerChoiceSettingLabel, state.PlayerChoiceSettingMode
end
