local scriptParent = script.Parent
local Foundation = script:FindFirstAncestor("Foundation")
local Wrappers = require(Foundation.Utility.Wrappers)
local LocalizationService = Wrappers.Services.LocalizationService
local GuiService = Wrappers.Services.GuiService
local Constants = require(scriptParent.Constants)
local Flags = require(Foundation.Utility.Flags)
local GeneratedTranslations = require(Foundation.Generated.Translations.GeneratedTranslations)
local v9 = if not Flags.FoundationTranslatorUseScript then GuiService else Foundation

local function createFoundationLocalizationTable(p1) -- line: 14
	-- upvalues: Constants (copy), GeneratedTranslations (copy), Flags (copy)
	local ConstantsLOCALIZATION_TABLE_NAME = p1:FindFirstChild(Constants.LOCALIZATION_TABLE_NAME)

	if ConstantsLOCALIZATION_TABLE_NAME ~= nil and ConstantsLOCALIZATION_TABLE_NAME:IsA("LocalizationTable") then
		ConstantsLOCALIZATION_TABLE_NAME:SetEntries(GeneratedTranslations)

		if Flags.FoundationTranslatorLocalizationRecovery then
			return ConstantsLOCALIZATION_TABLE_NAME
		end

		return nil
	end

	local LocalizationTable = Instance.new("LocalizationTable")

	LocalizationTable.Name = Constants.LOCALIZATION_TABLE_NAME
	LocalizationTable.Archivable = false
	LocalizationTable.SourceLocaleId = "en-us"
	LocalizationTable:SetEntries(GeneratedTranslations)
	LocalizationTable.Parent = p1

	if Flags.FoundationTranslatorLocalizationRecovery then
		return LocalizationTable
	end

	return nil
end

local u11 = createFoundationLocalizationTable(v9)
local Translator = v9:FindFirstChild(Constants.LOCALIZATION_TABLE_NAME):GetTranslator("en-us")
local t1 = {}

local function getTranslatorForLocale(p2) -- line: 49
	-- upvalues: Flags (copy), u11 (ref), createFoundationLocalizationTable (copy), v9 (copy), t1 (ref), Constants (copy)
	if Flags.FoundationTranslatorLocalizationRecovery and (u11 == nil or u11.Parent == nil) then
		u11 = createFoundationLocalizationTable(v9)
		t1 = {}
	end

	local v21 = t1[p2]

	if v21 then
		return v21
	end

	local Translator2 = v9:FindFirstChild(Constants.LOCALIZATION_TABLE_NAME):GetTranslator(p2)

	t1[p2] = Translator2

	return Translator2
end
local function getTranslator() -- line: 70
	-- upvalues: getTranslatorForLocale (copy), LocalizationService (copy)
	return (getTranslatorForLocale(LocalizationService.RobloxLocaleId))
end
local function formatByKeyWithFallback(p3, p4, p5) -- line: 74
	-- upvalues: Flags (copy), getTranslatorForLocale (copy), Translator (copy)
	local ok, result = pcall(function() -- line: 75
		-- upvalues: p5 (copy), p3 (copy), p4 (copy)
		return p5:FormatByKey(p3, p4)
	end)

	if ok then
		return result
	end

	if p5.LocaleId == "zh-cjv" then
		return ""
	end

	if Flags.FoundationTranslatorLocalizationRecovery then
		return getTranslatorForLocale("en-us"):FormatByKey(p3, p4)
	end

	return Translator:FormatByKey(p3, p4)
end

return {
	FormatByKey = function(_, p7, p8) -- line: 94
		-- upvalues: formatByKeyWithFallback (copy), getTranslatorForLocale (copy), LocalizationService (copy)
		return formatByKeyWithFallback(p7, p8, (getTranslatorForLocale(LocalizationService.RobloxLocaleId)))
	end,
	FormatByKeyForLocale = function(_, p10, p11, p12) -- line: 98
		-- upvalues: formatByKeyWithFallback (copy), getTranslatorForLocale (copy)
		return formatByKeyWithFallback(p10, p12, (getTranslatorForLocale(p11)))
	end
}
