local parent = script.Parent.Parent

local ItemType = require(parent.Enums.ItemType)
local PurchaseError = require(parent.Enums.PurchaseError)
local Symbol = require(parent.Symbols.Symbol)

local KeyMappings = require(script.Parent.KeyMappings)

local _ = {
	["en-us"] = ",",
	["en-gb"] = ",",
	["es-mx"] = ",",
	["es-es"] = ".",
	["fr-fr"] = " ",
	["de-de"] = " ",
	["pt-br"] = ".",
	["zh-cn"] = ",",
	["zh-cjv"] = ",",
	["zh-tw"] = ",",
	["ko-kr"] = ",",
	["ja-jp"] = ",",
	["it-it"] = " ",
	["ru-ru"] = ".",
	["id-id"] = ".",
	["vi-vn"] = ".",
	["th-th"] = ",",
	["tr-tr"] = "."
}

local named = Symbol.named("FormattedParam")

local function isFormattedParam(p): boolean
	return typeof(p) == "table" and p[named] == true
end

local function createFormattedParam(format)
	return { [named] = true, format = format }
end

local function getLocalizedString(p, p2)
	local translations = p.translations
	local fallbackTranslations = p.fallbackTranslations

	if fallbackTranslations == nil or translations[p2] ~= nil then
		return translations[p2]
	end

	return fallbackTranslations[p2]
end

local function addGroupDelimiters(value, p)
	local v = string.format("%%1%s%%2", p)

	repeat
		local v2
		value, v2 = string.gsub(value, "^(-?%d+)(%d%d%d)", v)
	until v2 == 0

	return value
end

local LocalizationService = {}

function LocalizationService.getKeyFromItemType(value)
	assert(
		ItemType.isMember(value) or typeof(value) == "number" or typeof(value) == "string",
		"provided item type " .. tostring(value) .. " must be a number, string, or ItemType enum"
	)

	if value == ItemType.Bundle then
		return "CoreScripts.PurchasePrompt.ItemType.Bundle"
	end

	return KeyMappings.AssetTypeById[tostring(value)]
end

function LocalizationService.getErrorKey(p)
	assert(PurchaseError.isMember(p), "provided value " .. tostring(p) .. " is not a member of PurchaseError enum")

	return KeyMappings.PurchaseErrorKey[p]
end

return LocalizationService
