local LocalizationContext = {}
LocalizationContext.__index = LocalizationContext

function LocalizationContext.getBaseLanguage(value)
	return value:match("^(%w+)[-_]")
end

function LocalizationContext.new(translations)
	local v = { _translations = translations }

	setmetatable(v, LocalizationContext)

	return v
end

function LocalizationContext:addTranslations(translations)
	self._translations = translations
end

function LocalizationContext.getRelevantLanguages(p)
	local relevantLanguages = {}

	table.insert(relevantLanguages, p)

	local baseLanguage = LocalizationContext.getBaseLanguage(p)

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

function LocalizationContext:getString(p, p2, p3)
	local sourceString = self:_getSourceString(p, p2)

	local baseLanguage = LocalizationContext.getBaseLanguage(p)
	local v

	if baseLanguage then
		v = self:_getSourceString(baseLanguage, p2)
	end

	local sourceString2 = self:_getSourceString("en-us", p2)
	local v2 = sourceString or v or sourceString2

	if not v2 then
		local formatted = ("Couldn't find value for translation key %q!\nTried these languages: %s, %s, %s"):format(
			p2,
			p,
			baseLanguage,
			"en-us"
		)

		error(formatted, 2)
	end

	if p3 then
		return (v2:gsub("{(.-)}", p3))
	end

	return v2
end

return LocalizationContext
