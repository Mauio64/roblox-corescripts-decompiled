local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Signals = require(ParentParentParent.Signals)
local HttpSessionTracker = require(ParentParent.HttpSessionTracker)

require(ParentParentParent.InternalHttpStore)

local function createCancelRequestHandler(n1: number) -- line: 11
	-- upvalues: Signals (copy), HttpSessionTracker (copy)
	return function(p1) -- line: 12
		-- upvalues: Signals (copy), n1 (copy), HttpSessionTracker (copy)
		return Signals.createComputed(function(p2) -- line: 13
			-- upvalues: p1 (copy), n1 (copy), HttpSessionTracker (copy)
			local v9 = p1(p2)

			if n1 ~= HttpSessionTracker.currentSession() then
				return {
					status = "Failed",
					cancelled = true,
					config = v9.config
				}
			end

			return v9
		end)
	end
end

return createCancelRequestHandler
