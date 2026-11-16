local parent = script.Parent.Parent
local parent2 = parent.Parent

local Rodux = require(parent2.Rodux)

local MenuClosed = require(parent.Actions.MenuClosed)
local MenuOpened = require(parent.Actions.MenuOpened)

return Rodux.createReducer(false, {
	[MenuClosed.name] = function(_: boolean, _): boolean
		return false
	end,
	[MenuOpened.name] = function(_: boolean, _): boolean
		return true
	end
})
