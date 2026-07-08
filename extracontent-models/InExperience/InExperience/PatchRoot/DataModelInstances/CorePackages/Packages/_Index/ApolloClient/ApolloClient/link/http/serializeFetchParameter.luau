local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Error = LuauPolyfill.Error
local Array = LuauPolyfill.Array
local HttpService = game:GetService("HttpService")
local t1 = {}
local InvariantError = require(ParentParent.jsutils.invariant).InvariantError

function t1.serializeFetchParameter(p1, s1: string, b1: boolean?) -- line: 27
	-- upvalues: Array (copy), HttpService (copy), InvariantError (copy), Error (copy)
	local s2 = nil
	local ok, result = pcall(function() -- line: 29
		-- upvalues: Array (copy), p1 (copy), b1 (copy), s2 (ref), HttpService (copy)
		if Array.isArray(p1) and (#p1 == 0 and b1) then
			s2 = "{}"

			return
		end

		s2 = HttpService:JSONEncode(p1)
	end)

	if not ok then
		local v15 = InvariantError.new(("Network request failed. %s is not serializable: %s"):format(s1, result))

		v15.parseError = Error.new(result)
		error(v15)
	end

	return s2
end

return t1
