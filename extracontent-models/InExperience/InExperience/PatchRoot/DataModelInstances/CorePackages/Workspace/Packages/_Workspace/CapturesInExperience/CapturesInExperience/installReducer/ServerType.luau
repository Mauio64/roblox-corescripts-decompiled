local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ServerType = require(ParentParent.Enums.ServerType)
local Rodux = require(ParentParentParent.Rodux)
local ServerTypeDetected = require(ParentParent.Actions.ServerTypeDetected)
local StandardServer = ServerType.StandardServer

return Rodux.createReducer(StandardServer, {
	[ServerTypeDetected.name] = function(_, t1: {[any]: any}) -- line: 15
		return t1.serverType
	end
})
