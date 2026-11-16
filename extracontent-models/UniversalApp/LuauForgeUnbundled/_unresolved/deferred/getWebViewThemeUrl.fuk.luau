local module = require("@luauforge/bundled/ful")

local v5 = { "roblox.com", "robloxlabs.com" }

local function isRobloxUrl(value): boolean
	local v6 = string.match(string.lower(value), "^[%a][%w+.-]*://([^/?#:]+)")

	if v6 == nil then
		return false
	end

	for k, v7 in v5 do
		if v6 == v7 or string.sub(v6, -(#v7 + 1)) == "." .. v7 then
			return true
		end
	end

	return false
end

local function hasQueryParam(value, p2): boolean
	return string.find(value, "[?&]" .. p2 .. "=", 1) ~= nil
end

local function appendQueryParam(value, p2, p3)
	if string.find(value, "[?&]" .. p2 .. "=", 1) ~= nil then
		return value
	end

	local v6 = string.find(value, "#", 1, true)
	local v7 = if v6 then string.sub(value, 1, v6 - 1) else value
	local v8 = not v6 and "" or string.sub(value, v6)
	return v7 .. (string.find(v7, "?", 1, true) and "&" or "?") .. p2 .. "=" .. p3 .. v8
end

local function getWebViewThemeUrl(p2, p3)
	if p2 == nil or not isRobloxUrl(p2) then
		return p2
	end

	local v6 = require("@luauforge/bundled/fun")(false)
	local v7 = if p3 and p3.accountTheme then p3.accountTheme else v6.getColorThemeKey(false)

	if module and v7 == "Halloween2026" then
		return appendQueryParam(p2, "deviceThemeOverride", "Halloween2026")
	end

	return p2
end

return getWebViewThemeUrl
