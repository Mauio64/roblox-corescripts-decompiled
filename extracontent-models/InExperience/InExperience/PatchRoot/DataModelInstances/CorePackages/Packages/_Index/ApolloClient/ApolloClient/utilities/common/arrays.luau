local parent = script.Parent.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
return {
	isNonEmptyArray = function(list)
		return (function()
			if Array.isArray(list) then
				return #list > 0
			end

			return Array.isArray(list)
		end)()
	end
}
