local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Cryo = require(ParentParentParent.Cryo)
local Rodux = require(ParentParentParent.Rodux)

require(ParentParent.Types)

local MomentsCreationFlowClosed = require(ParentParent.Actions.MomentsCreationFlowClosed)
local MomentsCreationFlowOpened = require(ParentParent.Actions.MomentsCreationFlowOpened)
local t1 = {
	IsOpen = false,
	Capture = nil
}

return Rodux.createReducer(t1, {
	[MomentsCreationFlowOpened.name] = function(t2: {[any]: any}, p1) -- line: 23
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(t2, {
			IsOpen = true,
			Capture = p1.capture
		})
	end,
	[MomentsCreationFlowClosed.name] = function(_: {[any]: any}, _: {[any]: any}) -- line: 30
		-- upvalues: t1 (copy)
		return t1
	end
})
