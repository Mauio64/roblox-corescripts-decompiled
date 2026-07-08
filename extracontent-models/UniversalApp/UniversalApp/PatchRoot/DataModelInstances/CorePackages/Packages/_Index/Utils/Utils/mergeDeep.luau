local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local t1 = {}
local isSymbol = require(ParentParent.Utils.jsHelpers).isSymbol
local isObject = nil

local function mergeDeep(p1, b1: boolean?) -- line: 26
	-- upvalues: Boolean (copy), isObject (ref), isSymbol (copy), Array (copy), Object (copy), mergeDeep (copy)
	local v12 = b1 ~= nil and b1
	local v13 = if not Boolean.toJSBoolean(p1[1]) then {} else p1[1]
	local t2 = {}

	for _, v16 in p1 do
		local toJSBoolean = Boolean.toJSBoolean
		local v18 = isObject(v13)

		if toJSBoolean(if not Boolean.toJSBoolean(v18) then v18 else isObject(v16)) then
			for v19 in v16 do
				if not isSymbol(v19) then
					if Boolean.toJSBoolean(isObject(v16[tostring(v19)])) then
						if Array.indexOf(Object.keys(t2), (tostring(v19))) == -1 then
							Object.assign(t2, {
								[tostring(v19)] = v16[tostring(v19)]
							})
						else
							t2[v19] = mergeDeep({
								t2[v19],
								v16[v19]
							}, v12)
						end
					else
						Object.assign(t2, {
							[tostring(v19)] = v16[tostring(v19)]
						})
					end
				end
			end
		end
	end

	return t2
end

t1.mergeDeep = mergeDeep

function isObject(p2) -- line: 98
	-- upvalues: Boolean (copy), Array (copy)
	return Boolean.toJSBoolean(p2) and (typeof(p2) == "table" and not (Array.isArray(p2) and #p2 > 0))
end

return t1
