local parent = script.Parent.Parent

local parent2 = parent.Parent

local Signals = require(parent2.Signals)
local HttpSessionTracker = require(parent.HttpSessionTracker)
require(parent2.InternalHttpStore)

local function createCancelRequestHandler(p: number)
	return function(callback)
		return Signals.createComputed(function(p2)
			local v = callback(p2)

			if p == HttpSessionTracker.currentSession() then
				return v
			end

			return { status = "Failed", config = v.config, cancelled = true }
		end)
	end
end

return createCancelRequestHandler
