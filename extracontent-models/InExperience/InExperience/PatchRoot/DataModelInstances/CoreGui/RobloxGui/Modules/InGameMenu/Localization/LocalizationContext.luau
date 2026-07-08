local function getBaseLanguage(p1) -- line: 43
	return p1:match("^(%w+)[-_]")
end

local t1 = {}

t1.__index = t1

function t1.new(p2) -- line: 50
	-- upvalues: t1 (copy)
	local t2 = {
		_translations = p2
	}

	setmetatable(t2, t1)

	return t2
end
function t1.addTranslations(p3, p4) -- line: 64
	p3._translations = p4
end
function t1.getRelevantLanguages(p5) -- line: 74
	local t3 = {}

	table.insert(t3, p5)

	local v10 = p5:match("^(%w+)[-_]")

	if v10 then
		table.insert(t3, v10)
	end

	table.insert(t3, "en-us")

	return t3
end
function t1._getSourceString(p6, p7, p8) -- line: 91
	local v14 = p6._translations[p7]

	if not v14 then
		return nil
	end

	return v14[p8]
end
function t1.getString(p9, p10, p11, p12) -- line: 106
	local v19 = p9:_getSourceString(p10, p11)
	local v20 = p10:match("^(%w+)[-_]")
	local v21 = nil

	if v20 then
		v21 = p9:_getSourceString(v20, p11)
	end

	local v22 = p9:_getSourceString("en-us", p11)
	local v23 = v19 or (v21 or v22)

	if not v23 then
		local v24 = ("Couldn't find value for translation key %q!\nTried these languages: %s, %s, %s"):format(p11, p10, v20, "en-us")

		error(v24, 2)
	end

	if p12 then
		return (v23:gsub("{(.-)}", p12))
	end

	return v23
end

return t1
