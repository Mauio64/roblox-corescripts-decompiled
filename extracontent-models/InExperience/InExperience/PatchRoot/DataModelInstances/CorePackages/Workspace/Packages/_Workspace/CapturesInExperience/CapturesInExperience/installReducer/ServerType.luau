local parent = script.Parent.Parent
local parent2 = parent.Parent

local ServerType = require(parent.Enums.ServerType)

local Rodux = require(parent2.Rodux)

local ServerTypeDetected = require(parent.Actions.ServerTypeDetected)

local StandardServer = ServerType.StandardServer

return Rodux.createReducer(StandardServer, {
	[ServerTypeDetected.name] = function(_, p)
		return p.serverType
	end
})
