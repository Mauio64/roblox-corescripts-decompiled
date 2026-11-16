local CorePackages = game:GetService("CorePackages")

local parent = script.Parent.Parent
local FFlagTopBarDeprecateRespawnRodux = require(parent.Flags.FFlagTopBarDeprecateRespawnRodux)

if FFlagTopBarDeprecateRespawnRodux then
	return nil
end

local Rodux = require(CorePackages.Packages.Rodux)

local Actions = script.Parent.Parent.Actions

local SetRespawnBehaviour = require(Actions.SetRespawnBehaviour)

return Rodux.createReducer({ enabled = true, customCallback = nil }, {
	[SetRespawnBehaviour.name] = function(_, p)
		return { enabled = p.respawnEnabled, customCallback = p.customCallback }
	end
})
