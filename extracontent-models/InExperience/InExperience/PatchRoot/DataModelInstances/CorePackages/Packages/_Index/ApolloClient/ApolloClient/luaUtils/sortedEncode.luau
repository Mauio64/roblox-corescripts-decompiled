local ParentParent = script.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local HttpService = game:GetService("HttpService")

function sortedEncode(p1) -- line: 14
	-- upvalues: Array (copy), Object (copy), HttpService (copy)
	if not Array.isArray(p1) and typeof(p1) == "table" then
		local v7 = Array.map(Array.sort(Object.keys(p1)), function(p2) -- line: 16
			-- upvalues: HttpService (copy), p1 (copy)
			return HttpService:JSONEncode(p2) .. ":" .. sortedEncode(p1[p2])
		end)

		return "{" .. Array.join(v7, ",") .. "}"
	end

	return HttpService:JSONEncode(p1)
end

return {
	sortedEncode = sortedEncode
}
