local parent = script.Parent.Parent.Parent
require(parent.LuauPolyfill)

require(script.Parent.ObjMap)

return {
	keyMap = function(list, callback)
		local result = {}

		for _, item in ipairs(list) do
			result[callback(item)] = item
		end

		return result
	end
}
