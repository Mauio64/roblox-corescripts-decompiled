local function group(p1, s1: string) -- line: 29
	return "(" .. s1 .. ((if type(p1) ~= "string" then table.concat(p1, "|") else p1)) .. ")"
end

return {
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
	ALPHANUMERIC = "\\w",
	oneOf = function(p2) -- line: 33
		return "(" .. "?:" .. ((if type(p2) ~= "string" then table.concat(p2, "|") else p2)) .. ")"
	end,
	capture = function(p3) -- line: 37
		return "(" .. "" .. ((if type(p3) ~= "string" then table.concat(p3, "|") else p3)) .. ")"
	end,
	zeroOrOneOf = function(p4) -- line: 41
		return ("(" .. "?:" .. ((if type(p4) ~= "string" then table.concat(p4, "|") else p4)) .. ")") .. "?"
	end,
	zeroOrMore = function(p5) -- line: 65
		return ("(" .. "?:" .. ((if type(p5) ~= "string" then table.concat(p5, "|") else p5)) .. ")") .. "*"
	end,
	oneOrMore = function(p6) -- line: 61
		return ("(" .. "?:" .. ((if type(p6) ~= "string" then table.concat(p6, "|") else p6)) .. ")") .. "+"
	end,
	lookahead = function(p7) -- line: 45
		return "(" .. "?=" .. ((if type(p7) ~= "string" then table.concat(p7, "|") else p7)) .. ")"
	end,
	lookbehind = function(p8) -- line: 53
		return "(" .. "?<=" .. ((if type(p8) ~= "string" then table.concat(p8, "|") else p8)) .. ")"
	end,
	negativeLookahead = function(p9) -- line: 49
		return "(" .. "?!" .. ((if type(p9) ~= "string" then table.concat(p9, "|") else p9)) .. ")"
	end,
	negativeLookbehind = function(p10) -- line: 57
		return "(" .. "?<!" .. ((if type(p10) ~= "string" then table.concat(p10, "|") else p10)) .. ")"
	end,
	matchWhole = function(s2: string) -- line: 69
		return "^" .. s2 .. "$"
	end,
	regexOr = function(s3: string, s4: string) -- line: 73
		return s3 .. "|" .. s4
	end,
	set = function(s5: string) -- line: 77
		return "[" .. s5 .. "]"
	end,
	notSet = function(s6: string) -- line: 81
		return "[" .. "^" .. s6 .. "]"
	end
}
