local LocalizationService = game:GetService("LocalizationService")
local GuiService = game:GetService("GuiService")

local parent = script.Parent
local Constants = require(parent.Constants)
local GeneratedTranslations = require(parent.GeneratedTranslations)

local function createUIBloxLocalizationTable(GuiService2) -- 1 equivalent call inferred from this helper
	if GuiService:FindFirstChild(Constants.LOCALIZATION_TABLE_NAME) then
		return
	end

	local localizationTable = Instance.new("LocalizationTable")
	localizationTable.Name = Constants.LOCALIZATION_TABLE_NAME
	localizationTable.Archivable = false
	localizationTable.SourceLocaleId = "en-us"
	localizationTable:SetEntries(GeneratedTranslations)
	localizationTable.Parent = GuiService2
end

createUIBloxLocalizationTable(GuiService) -- inferred equivalent call
local translator = GuiService.UIBloxLocalization:GetTranslator("en-us")

local v = {}

local function getTranslatorForLocale(robloxLocaleId) -- 1 equivalent call inferred from this helper
	local v2 = v[robloxLocaleId]

	if v2 then
		return v2
	end

	local translator2 = GuiService.UIBloxLocalization:GetTranslator(robloxLocaleId)
	v[robloxLocaleId] = translator2

	return translator2
end

local function getTranslator()
	return getTranslatorForLocale(LocalizationService.RobloxLocaleId) -- inferred equivalent call
end

local function formatByKeyWithFallback(p, p2, object)
	local success, result = pcall(function()
		return object:FormatByKey(p, p2)
	end)

	if success then
		return result
	end

	if object.LocaleId == "zh-cjv" then
		return ""
	end

	return translator:FormatByKey(p, p2)
end

local Translator = {}

function Translator:FormatByKey(p, p2)
	local robloxLocaleId = LocalizationService.RobloxLocaleId
	local v2 = v[robloxLocaleId]

	if not v2 then
		v2 = GuiService.UIBloxLocalization:GetTranslator(robloxLocaleId)
		v[robloxLocaleId] = v2
	end

	return formatByKeyWithFallback(p, p2, v2)
end

function Translator.FormatByKeyForLocale(_, p, p2, p3)
	local v2 = v[p2]

	if not v2 then
		v2 = GuiService.UIBloxLocalization:GetTranslator(p2)
		v[p2] = v2
	end

	return formatByKeyWithFallback(p, p3, v2)
end

return Translator
