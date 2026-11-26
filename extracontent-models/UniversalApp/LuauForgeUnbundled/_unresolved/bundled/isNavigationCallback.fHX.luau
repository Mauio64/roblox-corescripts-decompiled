local module = require("@luauforge/bundled/fHY")

local function isNavigationCallback(p2, value)
	if typeof(value) ~= "string" or value == "" then
		return false
	end

	if string.sub(string.lower(value), 1, 20) == "roblox://navigation/" then
		return module.new(p2):matches(value)
	end

	return false
end

return isNavigationCallback
