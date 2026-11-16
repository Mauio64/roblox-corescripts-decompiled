local InterventionShared = script:FindFirstAncestor("InterventionShared")
local parent = InterventionShared.Parent

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Cryo = require(parent.Cryo)

local LocalizationService = game:GetService("LocalizationService")
local RobloxAppLocales = require(parent.RobloxAppLocales)
local localization = RobloxAppLocales.Localization.new(LocalizationService.RobloxLocaleId)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

require(InterventionShared.Utils.Types)

local function useParsedBadUtterances(items, p)
	local labelTranslationKey

	if p then
		labelTranslationKey = p.labelTranslationKey
	end

	local shouldAddPlayerName

	if p then
		shouldAddPlayerName = p.shouldAddPlayerName
	end

	local v = {}
	local v2 = {}

	if labelTranslationKey and labelTranslationKey ~= "" then
		v2[labelTranslationKey] = "Feature.NotApproved." .. labelTranslationKey
	end

	for _, item in items do
		local evidence = item.utteranceText

		if LocalPlayer and shouldAddPlayerName then
			evidence = localization:Format("Feature.InExperienceIntervention.Label.Player", {
				username = LocalPlayer.Name,
				evidence = evidence
			})
		end

		table.insert(v, evidence)

		v2[item.labelTranslationKey] = "Feature.NotApproved." .. item.labelTranslationKey
	end

	local v3 = useLocalization(v2)

	local set = {}

	for k, _ in v2 do
		local v4 = v3[k]

		if v4 and v4 ~= "" then
			set[v4] = true
		end
	end

	return { textItems = Cryo.List.reverse(v), abuseTypes = Cryo.Dictionary.keys(set) }
end

return useParsedBadUtterances
