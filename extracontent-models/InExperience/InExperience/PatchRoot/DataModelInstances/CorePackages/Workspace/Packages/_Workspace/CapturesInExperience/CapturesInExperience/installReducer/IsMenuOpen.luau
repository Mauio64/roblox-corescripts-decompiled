local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)
local MenuClosed = require(ParentParent.Actions.MenuClosed)
local MenuOpened = require(ParentParent.Actions.MenuOpened)

return Rodux.createReducer(false, {
	[MenuClosed.name] = function(_: boolean, _: {[any]: any}) -- line: 14
		return false
	end,
	[MenuOpened.name] = function(_: boolean, _: {[any]: any}) -- line: 18
		return true
	end
})
