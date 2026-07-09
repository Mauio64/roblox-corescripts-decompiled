local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Signals = require(ParentParentParent.Signals)

require(ParentParentParent.InternalHttpStore)
require(ParentParent.Types)

local function createErrorStatusHandler(p1) -- line: 11
	-- upvalues: Signals (copy)
	return function(p2) -- line: 12
		-- upvalues: Signals (copy), p1 (copy)
		return Signals.createComputed(function(p3) -- line: 13
			-- upvalues: p2 (copy), p1 (copy)
			local v8 = p2(p3)

			if v8.status == "Success" then
				local StatusCode = v8.response.StatusCode

				if p1[StatusCode] ~= nil then
					p1[StatusCode](v8)
				end
			end

			return v8
		end)
	end
end

return createErrorStatusHandler
