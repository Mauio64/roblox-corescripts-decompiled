local ItemType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/ItemType")
local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local Symbol = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Symbols/Symbol")

local KeyMappings = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Localization/KeyMappings")

local named = Symbol.named("FormattedParam")

local function isFormattedParam(p2): boolean
	return typeof(p2) == "table" and p2[named] == true
end

local function createFormattedParam(p2)
	return { [named] = true, format = p2 }
end

local function getLocalizedString(p2, p3)
	local translations = p2.translations
	local fallbackTranslations = p2.fallbackTranslations

	if fallbackTranslations == nil or translations[p3] ~= nil then
		return translations[p3]
	end

	return fallbackTranslations[p3]
end

local function addGroupDelimiters(value, p2)
	local v5 = string.format("%%1%s%%2", p2)

	repeat
		local v6
		value, v6 = string.gsub(value, "^(-?%d+)(%d%d%d)", v5)
	until v6 == 0

	return value
end

return {
	getKeyFromItemType = function(value)
		assert(
			ItemType.isMember(value) or typeof(value) == "number" or typeof(value) == "string",
			"provided item type " .. tostring(value) .. " must be a number, string, or ItemType enum"
		)

		if value == ItemType.Bundle then
			return "CoreScripts.PurchasePrompt.ItemType.Bundle"
		end

		return KeyMappings.AssetTypeById[tostring(value)]
	end,
	getErrorKey = function(p2)
		assert(
			PurchaseError.isMember(p2),
			"provided value " .. tostring(p2) .. " is not a member of PurchaseError enum"
		)

		return KeyMappings.PurchaseErrorKey[p2]
	end
}
