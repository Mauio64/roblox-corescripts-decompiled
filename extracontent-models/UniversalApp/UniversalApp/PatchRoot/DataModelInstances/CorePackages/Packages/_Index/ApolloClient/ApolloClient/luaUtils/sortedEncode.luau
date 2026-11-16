local parent = script.Parent.Parent.Parent

local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local HttpService = game:GetService("HttpService")

function sortedEncode(p)
	if Array.isArray(p) or typeof(p) ~= "table" then
		return HttpService:JSONEncode(p)
	end

	local mapped = Array.map(Array.sort(Object.keys(p)), function(p2)
		return HttpService:JSONEncode(p2) .. ":" .. sortedEncode(p[p2])
	end)

	return "{" .. Array.join(mapped, ",") .. "}"
end

return { sortedEncode = sortedEncode }
