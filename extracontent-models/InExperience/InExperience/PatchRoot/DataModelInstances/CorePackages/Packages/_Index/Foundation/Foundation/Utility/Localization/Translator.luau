local parent = script.Parent
local parent2 = script.Parent.Parent.Parent

local Wrappers = require(parent2.Utility.Wrappers)
local LocalizationService = Wrappers.Services.LocalizationService

local Constants = require(parent.Constants)
local GeneratedTranslations = require(parent2.Generated.Translations.GeneratedTranslations)
local devAssert = require(parent2.Utility.devAssert)
local getMainGui = require(parent2.Utility.getMainGui)
local mainGui = getMainGui()
devAssert(mainGui ~= nil, "MainGui not found")

local HttpService = game:GetService("HttpService")
local name = Constants.LOCALIZATION_TABLE_NAME .. HttpService:GenerateGUID(false)

local function createFoundationLocalizationTable(mainGui2)
	local localizationTable = mainGui2:FindFirstChild(name)

	if localizationTable ~= nil and localizationTable:IsA("LocalizationTable") then
		localizationTable:SetEntries(GeneratedTranslations)
		return localizationTable
	end

	local localizationTable2 = Instance.new("LocalizationTable")
	localizationTable2.Name = name
	localizationTable2.Archivable = false
	localizationTable2.SourceLocaleId = "en-us"
	localizationTable2:SetEntries(GeneratedTranslations)
	localizationTable2.Parent = mainGui2
	return localizationTable2
end

local v = createFoundationLocalizationTable(mainGui)

local translators = {}

local function getTranslatorForLocale(p)
	if v == nil or v.Parent == nil then
		v = createFoundationLocalizationTable(mainGui)
		translators = {}
	end

	local v2 = translators[p]

	if v2 then
		return v2
	end

	local translator = mainGui:FindFirstChild(name):GetTranslator(p)

	translators[p] = translator

	return translator
end

local function getTranslator() -- 1 equivalent call inferred from this helper
	return getTranslatorForLocale(LocalizationService.RobloxLocaleId)
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

	return getTranslatorForLocale("en-us"):FormatByKey(p, p2)
end

local Translator = {}

function Translator:FormatByKey(p, p2)
	return formatByKeyWithFallback(p, p2, getTranslator()) -- inferred equivalent call
end

function Translator.FormatByKeyForLocale(_, p, p2, p3)
	return formatByKeyWithFallback(p, p3, getTranslatorForLocale(p2))
end

return Translator
