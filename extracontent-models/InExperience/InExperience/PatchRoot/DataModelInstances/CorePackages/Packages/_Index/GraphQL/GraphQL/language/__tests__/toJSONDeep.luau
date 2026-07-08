local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Array = require(ParentParentParent.LuauPolyfill).Array
local isObjectLike = require(ParentParent.jsutils.isObjectLike).isObjectLike

local function toJSONDeep(p1) -- line: 18
	-- upvalues: isObjectLike (copy), Array (copy), toJSONDeep (copy)
	if not isObjectLike(p1) then
		return p1
	end

	if type(p1.toJSON) == "function" then
		return p1:toJSON()
	end

	if Array.isArray(p1) then
		return Array.map(p1, toJSONDeep)
	end

	local t1 = {}

	for k, v in pairs(p1) do
		t1[k] = toJSONDeep(v)
	end

	return t1
end

return {
	toJSONDeep = toJSONDeep
}
