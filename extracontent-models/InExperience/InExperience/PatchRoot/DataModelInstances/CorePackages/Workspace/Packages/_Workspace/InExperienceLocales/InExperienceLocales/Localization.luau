local parent = script:FindFirstAncestor("InExperienceLocales").Parent

local Localization = require(parent.Localization)
local LocalizationContext = Localization.LocalizationContext
local AppCommonLib = require(parent.AppCommonLib)

local Signal = AppCommonLib.Signal

local CoreGui = game:GetService("CoreGui")

local Locales = CoreGui.RobloxGui.Modules.Common:FindFirstChild("Locales")

local function loadTables(p: string)
	if not Locales then
		error("ERROR: Locales tables does not exist")
	end

	local relevantLanguages = LocalizationContext.getRelevantLanguages(p)
	local modulesByChildName = {}

	for _, childName in ipairs(relevantLanguages) do
		local child = Locales:FindFirstChild(childName)

		if not child then
			continue
		end

		local module = require(child)
		modulesByChildName[childName] = module
	end

	return modulesByChildName
end

local Localization2 = {}
Localization2.__index = Localization2

function Localization2.new(locale: string)
	local v = {
		locale = locale,
		changed = Signal.new(),
		localizationContext = LocalizationContext.new(loadTables(locale))
	}

	setmetatable(v, Localization2)
	return v
end

function Localization2:SetLocale(locale: string)
	self.locale = locale
	local v = loadTables(locale)
	self.localizationContext:addTranslations(v)
	self.changed:fire()
end

function Localization2.GetLocale(p)
	return p.locale
end

function Localization2.Format(p, p2: string, p3)
	if not p2 then
		error("ERROR: NO STRING FOR KEY")
	end

	return (p.localizationContext:getString(p.locale, p2, p3))
end

return Localization2
