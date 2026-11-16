local function group(list, p: string) -- 6 equivalent calls inferred from this helper
	if type(list) ~= "string" then
		list = table.concat(list, "|")
	end

	return "(" .. p .. list .. ")"
end

local Regex = {}

function Regex.oneOf(list)
	return group(list, "?:") -- inferred equivalent call
end

function Regex.capture(list)
	return group(list, "") -- inferred equivalent call
end

function Regex.zeroOrOneOf(list)
	if type(list) ~= "string" then
		list = table.concat(list, "|")
	end

	return ("(" .. "?:" .. list .. ")") .. "?"
end

function Regex.zeroOrMore(list)
	if type(list) ~= "string" then
		list = table.concat(list, "|")
	end

	return ("(" .. "?:" .. list .. ")") .. "*"
end

function Regex.oneOrMore(list)
	if type(list) ~= "string" then
		list = table.concat(list, "|")
	end

	return ("(" .. "?:" .. list .. ")") .. "+"
end

function Regex.lookahead(list)
	return group(list, "?=") -- inferred equivalent call
end

function Regex.lookbehind(list)
	return group(list, "?<=") -- inferred equivalent call
end

function Regex.negativeLookahead(list)
	return group(list, "?!") -- inferred equivalent call
end

function Regex.negativeLookbehind(list)
	return group(list, "?<!") -- inferred equivalent call
end

function Regex.matchWhole(p: string)
	return "^" .. p .. "$"
end

function Regex.regexOr(p: string, p2: string)
	return p .. "|" .. p2
end

function Regex.set(p: string)
	return "[" .. p .. "]"
end

function Regex.notSet(p: string)
	return "[" .. "^" .. p .. "]"
end

Regex.SLASH = "\\/"
Regex.QUESTION = "\\?"
Regex.DASH = "\\-"
Regex.DOT = "\\."
Regex.HASH = "\\#"
Regex.COLON = "\\:"
Regex.STRING_START = "^"
Regex.STRING_END = "$"
Regex.NON_WHITESPACE = "\\S"
Regex.WHITESPACE = "\\s"
Regex.ALPHANUMERIC = "\\w"
return Regex
