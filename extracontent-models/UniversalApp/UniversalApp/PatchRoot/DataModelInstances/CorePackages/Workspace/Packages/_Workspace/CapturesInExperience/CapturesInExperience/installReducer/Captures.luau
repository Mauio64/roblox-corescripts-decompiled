local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)
local CapturesRetrieved = require(ParentParent.Actions.CapturesRetrieved)

require(ParentParent.Types)

return Rodux.createReducer({}, {
	[CapturesRetrieved.name] = function(_: {[any]: any}, p1) -- line: 14
		return p1.captures
	end
})
