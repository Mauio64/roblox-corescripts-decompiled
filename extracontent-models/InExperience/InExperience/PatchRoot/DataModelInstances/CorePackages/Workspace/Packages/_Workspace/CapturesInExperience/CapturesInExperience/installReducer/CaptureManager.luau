local parent = script.Parent.Parent
local parent2 = parent.Parent

local Rodux = require(parent2.Rodux)
local Cryo = require(parent2.Cryo)
require(parent.Types)

local CapturesRetrieved = require(parent.Actions.CapturesRetrieved)
local CaptureManagerClosed = require(parent.Actions.CaptureManagerClosed)
local CaptureManagerOpened = require(parent.Actions.CaptureManagerOpened)
local UpdateSelectedCaptures = require(parent.Actions.UpdateSelectedCaptures)

return Rodux.createReducer({ IsOpen = false, SelectedCaptures = {} }, {
	[CaptureManagerClosed.name] = function(p, _)
		return Cryo.Dictionary.join(p, { IsOpen = false, SelectedCaptures = {} })
	end,
	[CaptureManagerOpened.name] = function(p, _)
		return Cryo.Dictionary.join(p, { IsOpen = true })
	end,
	[CapturesRetrieved.name] = function(p, p2)
		return Cryo.Dictionary.join(p, {
			IsOpen = p.IsOpen and #p2.captures > 0,
			SelectedCaptures = {}
		})
	end,
	[UpdateSelectedCaptures.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { SelectedCaptures = p2.selectedCaptures })
	end
})
