local parent = script.Parent.Parent
local Signals = require(parent.Signals)
local createComputed = Signals.createComputed

local function createReducer(callback, callback2)
	local v = false
	local v2 = nil

	local function ensureInitialized() -- 1 equivalent call inferred from this helper
		if not v then
			v = true
			local v3

			if typeof(callback2) == "function" then
				v3 = callback2()
			else
				v3 = callback2
			end

			v2 = v3
		end
	end

	return createComputed(function(p)
		ensureInitialized() -- inferred equivalent call
		v2 = callback(p, v2)
		return v2
	end)
end

return createReducer
