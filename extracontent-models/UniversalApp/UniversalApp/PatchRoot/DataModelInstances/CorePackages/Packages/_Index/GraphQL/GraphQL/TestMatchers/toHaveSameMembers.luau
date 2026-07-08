local ParentParent = script.Parent.Parent.Parent
local inspect = require(ParentParent.LuauPolyfill).util.inspect
local arrayContains = require(script.Parent.Parent.luaUtils.arrayContains)

local function toHaveSameMembers(p1, p2, p3) -- line: 20
	-- upvalues: arrayContains (copy), inspect (copy)
	if #p1 ~= #p2 then
		return {
			pass = false,
			message = ("Received array length %s / expected length %s"):format(tostring(#p1), (tostring(#p2)))
		}
	end

	for _, v in ipairs(p2) do
		if not arrayContains(p1, v, p3) then
			return {
				pass = false,
				message = ("Expected item %s to be in Array %s"):format(inspect(v), inspect(p1))
			}
		end
	end

	return {
		pass = true,
		message = ""
	}
end

return toHaveSameMembers
