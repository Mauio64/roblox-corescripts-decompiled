local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/Cryo")

local LocalizationService = game:GetService("LocalizationService")
local localization = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/RobloxAppLocales").Localization.new(LocalizationService.RobloxLocaleId)
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/Localization").Hooks.useLocalization

require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Utils/Types")

local function useParsedBadUtterances(items, p2)
	local labelTranslationKey = if p2 then p2.labelTranslationKey else nil
	local shouldAddPlayerName = if p2 then p2.shouldAddPlayerName else nil

	local v5 = {}
	local v6 = {}

	if labelTranslationKey and labelTranslationKey ~= "" then
		v6[labelTranslationKey] = "Feature.NotApproved." .. labelTranslationKey
	end

	for k, item in items do
		local v7 = item.utteranceText

		if localPlayer and shouldAddPlayerName then
			v7 = localization:Format("Feature.InExperienceIntervention.Label.Player", {
				username = localPlayer.Name,
				evidence = v7
			})
		end

		table.insert(v5, v7)

		v6[item.labelTranslationKey] = "Feature.NotApproved." .. item.labelTranslationKey
	end

	local v7 = useLocalization(v6)

	local set = {}

	for k, v8 in v6 do
		local v9 = v7[k]

		if v9 and v9 ~= "" then
			set[v9] = true
		end
	end

	return {
		textItems = Cryo.List.reverse(v5),
		abuseTypes = Cryo.Dictionary.keys(set)
	}
end

return useParsedBadUtterances
