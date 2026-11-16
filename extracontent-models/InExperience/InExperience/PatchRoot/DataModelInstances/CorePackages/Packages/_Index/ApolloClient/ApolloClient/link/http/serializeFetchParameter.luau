local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Error = LuauPolyfill.Error
local Array = LuauPolyfill.Array

local HttpService = game:GetService("HttpService")

local invariant = require(parent.jsutils.invariant)
local invariantError = invariant.InvariantError
return {
	serializeFetchParameter = function(list, p: string, flag: boolean?)
		local v = nil
		local success, result = pcall(function()
			if Array.isArray(list) and #list == 0 and flag then
				v = "{}"
			else
				v = HttpService:JSONEncode(list)
			end
		end)

		if not success then
			local v2 = invariantError.new(("Network request failed. %s is not serializable: %s"):format(p, result))

			v2.parseError = Error.new(result)
			error(v2)
		end

		return v
	end
}
