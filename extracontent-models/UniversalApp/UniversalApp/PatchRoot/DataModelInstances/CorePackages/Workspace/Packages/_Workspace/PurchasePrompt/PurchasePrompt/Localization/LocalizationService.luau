local ParentParent = script.Parent.Parent
local ItemType = require(ParentParent.Enums.ItemType)
local PurchaseError = require(ParentParent.Enums.PurchaseError)
local Symbol = require(ParentParent.Symbols.Symbol)
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
local v7 = Symbol.named("FormattedParam")

local function isFormattedParam(p1) -- line: 44
	-- upvalues: v7 (copy)
	return typeof(p1) == "table" and p1[v7] == true
end
local function createFormattedParam(p2) -- line: 48
	-- upvalues: v7 (copy)
	return {
		[v7] = true,
		format = p2
	}
end
local function getLocalizedString(p3, p4) -- line: 58
	local translations = p3.translations
	local fallbackTranslations = p3.fallbackTranslations

	if fallbackTranslations ~= nil and translations[p4] == nil then
		return fallbackTranslations[p4]
	end

	return translations[p4]
end
local function addGroupDelimiters(p5, p6) -- line: 81
	local v20 = string.format("%%1%s%%2", p6)

	repeat
		local count

		p5, count = string.gsub(p5, "^(-?%d+)(%d%d%d)", v20)
	until count == 0

	return p5
end

return {
	getKeyFromItemType = function(p7) -- line: 98
		-- upvalues: ItemType (copy), KeyMappings (copy)
		assert(ItemType.isMember(p7) or (typeof(p7) == "number" or typeof(p7) == "string"), "provided item type " .. tostring(p7) .. " must be a number, string, or ItemType enum")

		if p7 == ItemType.Bundle then
			return "CoreScripts.PurchasePrompt.ItemType.Bundle"
		end

		return KeyMappings.AssetTypeById[tostring(p7)]
	end,
	getErrorKey = function(p8) -- line: 122
		-- upvalues: PurchaseError (copy), KeyMappings (copy)
		assert(PurchaseError.isMember(p8), "provided value " .. tostring(p8) .. " is not a member of PurchaseError enum")

		return KeyMappings.PurchaseErrorKey[p8]
	end
}
