local LocalizationService = game:GetService("LocalizationService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Utility = require(RobloxGui.Modules.Settings.Utility)
local Localization = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization
local t1 = {
	[1] = "On",
	[2] = "Off"
}

return function(p1, p2, p3) -- line: 19
	-- upvalues: Localization (copy), LocalizationService (copy), Utility (copy), t1 (copy)
	local v11 = Localization.new(LocalizationService.RobloxLocaleId)
	local v12 = v11:Format("Translation.PlayerChoiceSettings.GameSettings.PlayerChoiceSettingLabel")
	local v13 = v11:Format("Translation.PlayerChoiceSettings.GameSettings.PlayerChoiceSettingDescription")
	local v14 = not LocalizationService:GetIsLoadingInternalTranslations() and 2 or 1
	local v15, v16, v17 = Utility:AddNewRow(p1, v12, "Selector", t1, v14, nil, v13)

	p1.PlayerChoiceTranslationFrame = v15
	p1.PlayerChoiceSettingLabel = v16
	p1.PlayerChoiceSettingMode = v17
	p1.PlayerChoiceTranslationFrame.LayoutOrder = p2.PlayerChoiceTranslationFrame
	p1.PlayerChoiceSettingMode.IndexChanged:connect(function(p4) -- line: 38
		-- upvalues: v14 (copy), LocalizationService (copy), p3 (copy)
		local v19 = p4 == 1
		local v20 = v14 == 1

		LocalizationService:IsLoadingInternalTranslationsSettingChanged(v19)
		p3("player_choice_translation", v20, v19)
	end)

	return p1.PlayerChoiceTranslationFrame, p1.PlayerChoiceSettingLabel, p1.PlayerChoiceSettingMode
end
