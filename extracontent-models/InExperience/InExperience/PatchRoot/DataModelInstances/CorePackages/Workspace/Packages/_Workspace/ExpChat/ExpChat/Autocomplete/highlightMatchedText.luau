local v = {
	["&"] = "&amp;",
	["<"] = "&lt;",
	[">"] = "&gt;",
	["\""] = "&quot;",
	["'"] = "&apos;"
}

local function escape(value: string) -- 4 equivalent calls inferred from this helper
	return (string.gsub(value, "[&<>\"']", v))
end

local function findMatchStart(value: string, p: string)
	local v2 = string.find(value, p, 1, true)
	local v3 = v2

	while v3 ~= nil do
		if v3 == 1 or string.match(string.sub(value, v3 - 1, v3 - 1), "%w") == nil then
			return v3
		end

		v3 = string.find(value, p, v3 + 1, true)
	end

	return v2
end

local function highlightMatchedText(value: string, value2: string?, color: Color3)
	if value2 == nil or value2 == "" then
		return escape(value) -- inferred equivalent call
	end

	local matchStart = findMatchStart(string.lower(value), string.lower(value2))

	if matchStart == nil then
		return escape(value) -- inferred equivalent call
	end

	local v2 = matchStart + #value2 - 1
	local formatted = `<font color="#{color:ToHex()}">`

	local function muted(value3: string) -- 2 equivalent calls inferred from this helper
		if value3 == "" then
			return ""
		end

		return `{formatted}{escape(value3)}</font>` -- inferred equivalent call
	end

	local v3 = muted(string.sub(value, 1, matchStart - 1)) -- inferred equivalent call
	return v3 .. `<b>{escape(string.sub(value, matchStart, v2))}</b>` .. muted(string.sub(value, v2 + 1)) -- inferred equivalent call
end

return highlightMatchedText
