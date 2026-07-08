local t1 = {}

t1.__index = t1

function t1.getBaseLanguage(p1) -- line: 47
	return p1:match("^(%w+)[-_]")
end
function t1.new(p2) -- line: 51
	-- upvalues: t1 (copy)
	local t2 = {
		_translations = p2
	}

	setmetatable(t2, t1)

	return t2
end
function t1.addTranslations(p3, p4) -- line: 65
	p3._translations = p4
end
function t1.getRelevantLanguages(p5) -- line: 75
	-- upvalues: t1 (copy)
	local t3 = {}

	table.insert(t3, p5)

	local v9 = t1.getBaseLanguage(p5)

	if v9 then
		table.insert(t3, v9)
	end

	table.insert(t3, "en-us")

	return t3
end
function t1._getSourceString(p6, p7, p8) -- line: 92
	local v13 = p6._translations[p7]

	if not v13 then
		return nil
	end

	return v13[p8]
end
function t1.getString(p9, p10, p11, p12) -- line: 107
	-- upvalues: t1 (copy)
	local v18 = p9:_getSourceString(p10, p11)
	local v19 = t1.getBaseLanguage(p10)
	local v20 = nil

	if v19 then
		v20 = p9:_getSourceString(v19, p11)
	end

	local v21 = p9:_getSourceString("en-us", p11)
	local v22 = v18 or (v20 or v21)

	if not v22 then
		local v23 = ("Couldn't find value for translation key %q!\nTried these languages: %s, %s, %s"):format(p11, p10, v19, "en-us")

		error(v23, 2)
	end

	if p12 then
		return (v22:gsub("{(.-)}", p12))
	end

	return v22
end

return t1
