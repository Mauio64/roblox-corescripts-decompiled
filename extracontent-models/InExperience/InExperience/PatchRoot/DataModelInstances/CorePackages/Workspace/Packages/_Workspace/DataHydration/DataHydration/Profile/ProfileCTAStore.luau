local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createProfileCTAStore = require(script.Parent.createProfileCTAStore)

local SharedFlags = require(parent.SharedFlags)
local v

if SharedFlags.FFlagJoinabilityCTARefactor then
	v = Signals.createComputed(function()
		return createProfileCTAStore()
	end)
else
	v = Signals.createComputed(createProfileCTAStore)
end

return {
	get = function()
		return v(false)
	end
}
