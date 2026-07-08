local LocalizationService = game:GetService("LocalizationService")
local GuiService = game:GetService("GuiService")
local scriptParent = script.Parent
local Constants = require(scriptParent.Constants)
local GeneratedTranslations = require(scriptParent.GeneratedTranslations)

local function createUIBloxLocalizationTable(p1) -- line: 9
	-- upvalues: GuiService (copy), Constants (copy), GeneratedTranslations (copy)
	if GuiService:FindFirstChild(Constants.LOCALIZATION_TABLE_NAME) then
		return
	end

	local LocalizationTable = Instance.new("LocalizationTable")

	LocalizationTable.Name = Constants.LOCALIZATION_TABLE_NAME
	LocalizationTable.Archivable = false
	LocalizationTable.SourceLocaleId = "en-us"
	LocalizationTable:SetEntries(GeneratedTranslations)
	LocalizationTable.Parent = p1
end

if not GuiService:FindFirstChild(Constants.LOCALIZATION_TABLE_NAME) then
	local LocalizationTable = Instance.new("LocalizationTable")

	LocalizationTable.Name = Constants.LOCALIZATION_TABLE_NAME
	LocalizationTable.Archivable = false
	LocalizationTable.SourceLocaleId = "en-us"
	LocalizationTable:SetEntries(GeneratedTranslations)
	LocalizationTable.Parent = GuiService
end

local Translator = GuiService.UIBloxLocalization:GetTranslator("en-us")
local t1 = {}

local function getTranslatorForLocale(p2) -- line: 28
	-- upvalues: t1 (copy), GuiService (copy)
	local v16 = t1[p2]

	if v16 then
		return v16
	end

	local Translator2 = GuiService.UIBloxLocalization:GetTranslator(p2)

	t1[p2] = Translator2

	return Translator2
end
local function getTranslator() -- line: 40
	-- upvalues: LocalizationService (copy), t1 (copy), GuiService (copy)
	local RobloxLocaleId = LocalizationService.RobloxLocaleId
	local v19 = t1[RobloxLocaleId]

	if v19 then
		return v19
	end

	local Translator3 = GuiService.UIBloxLocalization:GetTranslator(RobloxLocaleId)

	t1[RobloxLocaleId] = Translator3

	return Translator3
end
local function formatByKeyWithFallback(p3, p4, p5) -- line: 44
	-- upvalues: Translator (copy)
	local ok, result = pcall(function() -- line: 45
		-- upvalues: p5 (copy), p3 (copy), p4 (copy)
		return p5:FormatByKey(p3, p4)
	end)

	if ok then
		return result
	end

	if p5.LocaleId == "zh-cjv" then
		return ""
	end

	return Translator:FormatByKey(p3, p4)
end

return {
	FormatByKey = function(_, p7, p8) -- line: 60
		-- upvalues: formatByKeyWithFallback (copy), LocalizationService (copy), t1 (copy), GuiService (copy)
		local v29 = formatByKeyWithFallback
		local RobloxLocaleId = LocalizationService.RobloxLocaleId
		local v31 = t1[RobloxLocaleId]

		if v31 then
		else
			v31 = GuiService.UIBloxLocalization:GetTranslator(RobloxLocaleId)
			t1[RobloxLocaleId] = v31
		end

		return v29(p7, p8, v31)
	end,
	FormatByKeyForLocale = function(_, p10, p11, p12) -- line: 64
		-- upvalues: formatByKeyWithFallback (copy), t1 (copy), GuiService (copy)
		local v36 = formatByKeyWithFallback
		local v37 = t1[p11]

		if v37 then
		else
			v37 = GuiService.UIBloxLocalization:GetTranslator(p11)
			t1[p11] = v37
		end

		return v36(p10, p12, v37)
	end
}
