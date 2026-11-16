local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local inspect = LuauPolyfill.util.inspect
local arrayContains = require(script.Parent.Parent.luaUtils.arrayContains)

local function toHaveSameMembers(list, list2, p)
	if #list ~= #list2 then
		return {
			pass = false,
			message = ("Received array length %s / expected length %s"):format(tostring(#list), (tostring(#list2)))
		}
	end

	for _, item in ipairs(list2) do
		if not arrayContains(list, item, p) then
			return {
				pass = false,
				message = ("Expected item %s to be in Array %s"):format(inspect(item), inspect(list))
			}
		end
	end

	return { pass = true, message = "" }
end

return toHaveSameMembers
