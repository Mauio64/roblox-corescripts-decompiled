local InterventionShared = script:FindFirstAncestor("InterventionShared")
local InterventionSharedParent = InterventionShared.Parent
local LocalPlayer = game:GetService("Players").LocalPlayer
local Cryo = require(InterventionSharedParent.Cryo)
local LocalizationService = game:GetService("LocalizationService")
local v6 = require(InterventionSharedParent.RobloxAppLocales).Localization.new(LocalizationService.RobloxLocaleId)
local useLocalization = require(InterventionSharedParent.Localization).Hooks.useLocalization

require(InterventionShared.Utils.Types)

local function useParsedBadUtterances(t1: {[any]: any}, s1: string?) -- line: 40
	-- upvalues: LocalPlayer (copy), v6 (copy), useLocalization (copy), Cryo (copy)
	local t2 = {}
	local t3 = {}

	if s1 and s1 ~= "" then
		t3[s1] = "Feature.NotApproved." .. s1
	end

	for _, v14 in t1 do
		local utteranceText = v14.utteranceText

		table.insert(t2, if not LocalPlayer then utteranceText else v6:Format("Feature.InExperienceIntervention.Label.Player", {
			username = LocalPlayer.Name,
			evidence = utteranceText
		}))
		t3[v14.labelTranslationKey] = "Feature.NotApproved." .. v14.labelTranslationKey
	end

	local v16 = useLocalization(t3)
	local t4 = {}

	for v18, _ in t3 do
		local v20 = v16[v18]

		if v20 and v20 ~= "" then
			t4[v20] = true
		end
	end

	return {
		textItems = Cryo.List.reverse(t2),
		abuseTypes = Cryo.Dictionary.keys(t4)
	}
end

return useParsedBadUtterances
