local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array

local isObjectLike = require(parent.jsutils.isObjectLike)
local isObjectLike2 = isObjectLike.isObjectLike
local function toJSONDeep(p)
	if not isObjectLike2(p) then
		return p
	end

	if type(p.toJSON) == "function" then
		return p:toJSON()
	end

	if Array.isArray(p) then
		return Array.map(p, toJSONDeep)
	end

	local result = {}

	for k, v in pairs(p) do
		result[k] = toJSONDeep(v)
	end

	return result
end

return { toJSONDeep = toJSONDeep }
