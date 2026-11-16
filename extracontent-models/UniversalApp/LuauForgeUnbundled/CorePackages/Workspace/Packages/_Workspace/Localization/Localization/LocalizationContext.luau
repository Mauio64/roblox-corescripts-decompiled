local class = {}
class.__index = class

function class.getBaseLanguage(value)
	return value:match("^(%w+)[-_]")
end

function class.new(p2)
	local v5 = { _translations = p2 }

	setmetatable(v5, class)

	return v5
end

function class:addTranslations(translations)
	self._translations = translations
end

function class.getRelevantLanguages(p2)
	local relevantLanguages = {}

	table.insert(relevantLanguages, p2)

	local baseLanguage = class.getBaseLanguage(p2)

	if baseLanguage then
		table.insert(relevantLanguages, baseLanguage)
	end

	table.insert(relevantLanguages, "en-us")
	return relevantLanguages
end

function class:_getSourceString(p3, p4)
	local translation = self._translations[p3]

	if translation then
		return translation[p4]
	end

	return nil
end

function class:getString(p2, p3, p4)
	local sourceString = self:_getSourceString(p2, p3)

	local baseLanguage = class.getBaseLanguage(p2)

	local v5 = if baseLanguage then self:_getSourceString(baseLanguage, p3) else nil

	local sourceString2 = self:_getSourceString("en-us", p3)
	local v6 = sourceString or v5 or sourceString2

	if not v6 then
		local formatted = ("Couldn't find value for translation key %q!\nTried these languages: %s, %s, %s"):format(
			p3,
			p2,
			baseLanguage,
			"en-us"
		)

		error(formatted, 2)
	end

	if p4 then
		return (v6:gsub("{(.-)}", p4))
	end

	return v6
end

return class
