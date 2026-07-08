local t1 = {}
local ParentParent = script.Parent.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local String = LuauPolyfill.String
local HttpService = game:GetService("HttpService")
local makeUniqueId = require(script.Parent.makeUniqueId).makeUniqueId

function replaceUndefined(p1, p2) -- line: 20
	-- upvalues: Array (copy)
	if not Array.isArray(p1) then
		return p1
	end

	local t2 = {}

	for i = 1, #p1 do
		if p1[i] == nil then
			table.insert(t2, p2)
		else
			table.insert(t2, p1[i])
		end
	end

	return t2
end
function t1.stringifyForDisplay(p3) -- line: 35
	-- upvalues: makeUniqueId (copy), Array (copy), String (copy), HttpService (copy)
	local v13 = makeUniqueId("stringifyForDisplay")

	return Array.join(String.split(HttpService:JSONEncode(replaceUndefined(p3, v13)), HttpService:JSONEncode(v13)), "<undefined>")
end

return t1
