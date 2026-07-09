local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Signals = require(ParentParentParent.Signals)
local HttpSessionTracker = require(ParentParent.HttpSessionTracker)

require(ParentParent.HttpStoreTypes)

local function createCancelRequestHandler(p1) -- line: 11
	-- upvalues: HttpSessionTracker (copy), Signals (copy)
	local v7 = HttpSessionTracker.currentSession()

	return Signals.createComputed(function(p2) -- line: 13
		-- upvalues: p1 (copy), v7 (copy), HttpSessionTracker (copy)
		local v9 = p1(p2)

		if v7 ~= HttpSessionTracker.currentSession() then
			return {
				status = "Failed",
				cancelled = true,
				config = v9.config
			}
		end

		return v9
	end)
end

return createCancelRequestHandler
