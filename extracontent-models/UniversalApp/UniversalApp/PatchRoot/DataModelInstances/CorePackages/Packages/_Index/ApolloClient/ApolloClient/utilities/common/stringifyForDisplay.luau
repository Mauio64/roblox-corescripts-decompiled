local StringifyForDisplay = {}
local parent = script.Parent.Parent.Parent.Parent

local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local String = LuauPolyfill.String

local HttpService = game:GetService("HttpService")

local makeUniqueId = require(script.Parent.makeUniqueId)
local makeUniqueId2 = makeUniqueId.makeUniqueId

function replaceUndefined(list, p)
	if not Array.isArray(list) then
		return list
	end

	local result = {}

	for i = 1, #list do
		if list[i] == nil then
			table.insert(result, p)
		else
			table.insert(result, list[i])
		end
	end

	return result
end

function StringifyForDisplay.stringifyForDisplay(p)
	local uniqueId = makeUniqueId2("stringifyForDisplay")

	return Array.join(
		String.split(HttpService:JSONEncode(replaceUndefined(p, uniqueId)), HttpService:JSONEncode(uniqueId)),
		"<undefined>"
	)
end

return StringifyForDisplay
