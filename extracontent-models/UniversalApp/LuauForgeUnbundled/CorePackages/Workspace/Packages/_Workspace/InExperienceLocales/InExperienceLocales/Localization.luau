local localizationContext = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceLocales/Localization").LocalizationContext
local signal = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceLocales/AppCommonLib").Signal

local CoreGui = game:GetService("CoreGui")

local locales = CoreGui.RobloxGui.Modules.Common:FindFirstChild("Locales")

local function loadTables(p2)
	if not locales then
		error("ERROR: Locales tables does not exist")
	end

	local relevantLanguages = localizationContext.getRelevantLanguages(p2)
	local modulesByChildName = {}

	for i, childName in ipairs(relevantLanguages) do
		local child = locales:FindFirstChild(childName)

		if not child then
			continue
		end

		local module = require(child)
		modulesByChildName[childName] = module
	end

	return modulesByChildName
end

local class = {}
class.__index = class

function class.new(p2)
	local v5 = {
		locale = p2,
		changed = signal.new(),
		localizationContext = localizationContext.new(loadTables(p2))
	}

	setmetatable(v5, class)
	return v5
end

function class:SetLocale(locale)
	self.locale = locale
	local v5 = loadTables(locale)
	self.localizationContext:addTranslations(v5)
	self.changed:fire()
end

function class:GetLocale()
	return self.locale
end

function class:Format(p3, p4)
	if not p3 then
		error("ERROR: NO STRING FOR KEY")
	end

	return (self.localizationContext:getString(self.locale, p3, p4))
end

return class
