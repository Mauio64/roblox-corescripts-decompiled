local function group(list, p2)
	if type(list) ~= "string" then
		list = table.concat(list, "|")
	end

	return "(" .. p2 .. list .. ")"
end

return {
	oneOf = function(list)
		if type(list) ~= "string" then
			list = table.concat(list, "|")
		end

		return "(" .. "?:" .. list .. ")"
	end,
	capture = function(list)
		if type(list) ~= "string" then
			list = table.concat(list, "|")
		end

		return "(" .. "" .. list .. ")"
	end,
	zeroOrOneOf = function(list)
		if type(list) ~= "string" then
			list = table.concat(list, "|")
		end

		return ("(" .. "?:" .. list .. ")") .. "?"
	end,
	zeroOrMore = function(list)
		if type(list) ~= "string" then
			list = table.concat(list, "|")
		end

		return ("(" .. "?:" .. list .. ")") .. "*"
	end,
	oneOrMore = function(list)
		if type(list) ~= "string" then
			list = table.concat(list, "|")
		end

		return ("(" .. "?:" .. list .. ")") .. "+"
	end,
	lookahead = function(list)
		if type(list) ~= "string" then
			list = table.concat(list, "|")
		end

		return "(" .. "?=" .. list .. ")"
	end,
	lookbehind = function(list)
		if type(list) ~= "string" then
			list = table.concat(list, "|")
		end

		return "(" .. "?<=" .. list .. ")"
	end,
	negativeLookahead = function(list)
		if type(list) ~= "string" then
			list = table.concat(list, "|")
		end

		return "(" .. "?!" .. list .. ")"
	end,
	negativeLookbehind = function(list)
		if type(list) ~= "string" then
			list = table.concat(list, "|")
		end

		return "(" .. "?<!" .. list .. ")"
	end,
	matchWhole = function(p2)
		return "^" .. p2 .. "$"
	end,
	regexOr = function(p2, p3)
		return p2 .. "|" .. p3
	end,
	set = function(p2)
		return "[" .. p2 .. "]"
	end,
	notSet = function(p2)
		return "[" .. "^" .. p2 .. "]"
	end,
	SLASH = "\\/",
	QUESTION = "\\?",
	DASH = "\\-",
	DOT = "\\.",
	HASH = "\\#",
	COLON = "\\:",
	STRING_START = "^",
	STRING_END = "$",
	NON_WHITESPACE = "\\S",
	WHITESPACE = "\\s",
	ALPHANUMERIC = "\\w"
}
