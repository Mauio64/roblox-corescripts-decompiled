local parent = script.Parent.Parent

local parent2 = parent.Parent

local Signals = require(parent2.Signals)
local HttpSessionTracker = require(parent.HttpSessionTracker)
require(parent.HttpStoreTypes)

local function createCancelRequestHandler(callback)
	local currentSession = HttpSessionTracker.currentSession()
	return Signals.createComputed(function(p)
		local v = callback(p)

		if currentSession == HttpSessionTracker.currentSession() then
			return v
		end

		return { status = "Failed", config = v.config, cancelled = true }
	end)
end

return createCancelRequestHandler
