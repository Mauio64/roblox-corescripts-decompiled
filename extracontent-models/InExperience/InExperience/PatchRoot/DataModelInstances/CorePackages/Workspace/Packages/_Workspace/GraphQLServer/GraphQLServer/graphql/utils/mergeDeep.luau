local Parent = script:FindFirstAncestor("GraphQLServer").Parent
local LuauPolyfill = require(Parent.LuauPolyfill)
local Object = LuauPolyfill.Object
local Array = LuauPolyfill.Array

local function isObject(p1) -- line: 9
	-- upvalues: Array (copy)
	return typeof(p1) == "table" and not (Array.isArray(p1) and #p1 > 0)
end
local function mergeDeep(p2, b1: boolean?) -- line: 13
	-- upvalues: Array (copy), Object (copy), mergeDeep (copy)
	local v10 = p2[1] or {}
	local t1 = {}

	for _, v13 in p2 do
		if typeof(v10) == "table" and not (Array.isArray(v10) and #v10 > 0) and (typeof(v13) == "table" and not (Array.isArray(v13) and #v13 > 0)) then
			for v14, v15 in v13 do
				if type(v15) == "table" then
					if t1[v14] == nil then
						Object.assign(t1, {
							[v14] = v15
						})
					else
						t1[v14] = mergeDeep({
							t1[v14],
							v15
						}, b1)
					end
				else
					Object.assign(t1, {
						[v14] = v15
					})
				end
			end
		end
	end

	return t1
end

return mergeDeep
