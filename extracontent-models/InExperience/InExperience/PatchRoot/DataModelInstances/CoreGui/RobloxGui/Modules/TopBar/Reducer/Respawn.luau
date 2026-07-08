local CorePackages = game:GetService("CorePackages")
local ParentParent = script.Parent.Parent

if require(ParentParent.Flags.FFlagTopBarDeprecateRespawnRodux) then
	return nil
end

local Rodux = require(CorePackages.Packages.Rodux)
local Actions = script.Parent.Parent.Actions
local SetRespawnBehaviour = require(Actions.SetRespawnBehaviour)

return Rodux.createReducer({
	enabled = true,
	customCallback = nil
}, {
	[SetRespawnBehaviour.name] = function(_, p2) -- line: 20
		return {
			enabled = p2.respawnEnabled,
			customCallback = p2.customCallback
		}
	end
})
