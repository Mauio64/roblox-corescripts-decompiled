local function getBaseLanguage(value) -- 2 equivalent calls inferred from this helper
	return value:match("^(%w+)[-_]")
end

local LocalizationContext = {}
LocalizationContext.__index = LocalizationContext

function LocalizationContext.new(translations)
	local v = { _translations = translations }

	setmetatable(v, LocalizationContext)

	return v
end

function LocalizationContext:addTranslations(translations)
	self._translations = translations
end

function LocalizationContext.getRelevantLanguages(value)
	local relevantLanguages = {}

	table.insert(relevantLanguages, value)
	local baseLanguage = getBaseLanguage(value) -- inferred equivalent call

	if baseLanguage then
		table.insert(relevantLanguages, baseLanguage)
	end

	table.insert(relevantLanguages, "en-us")
	return relevantLanguages
end

function LocalizationContext:_getSourceString(p, p2)
	local translation = self._translations[p]

	if translation then
		return translation[p2]
	end

	return nil
end

function LocalizationContext:getString(value, p, p2)
	local sourceString = self:_getSourceString(value, p)
	local baseLanguage = getBaseLanguage(value) -- inferred equivalent call
	local v

	if baseLanguage then
		v = self:_getSourceString(baseLanguage, p)
	end

	local sourceString2 = self:_getSourceString("en-us", p)
	local v2 = sourceString or v or sourceString2

	if not v2 then
		local formatted = ("Couldn't find value for translation key %q!\nTried these languages: %s, %s, %s"):format(
			p,
			value,
			baseLanguage,
			"en-us"
		)

		error(formatted, 2)
	end

	if p2 then
		return (v2:gsub("{(.-)}", p2))
	end

	return v2
end

return LocalizationContext
