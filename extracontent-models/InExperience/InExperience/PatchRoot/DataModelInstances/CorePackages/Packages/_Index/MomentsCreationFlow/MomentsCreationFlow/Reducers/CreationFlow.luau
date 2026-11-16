local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local parent = MomentsCreationFlow.Parent

local Cryo = require(parent.Cryo)
require(parent.MomentsCommon)
local Rodux = require(parent.Rodux)

local ClearEdits = require(MomentsCreationFlow.Actions.ClearEdits)
local CreationFlowState = require(MomentsCreationFlow.Enums.CreationFlowState)
local CreationFlowStateUpdated = require(MomentsCreationFlow.Actions.CreationFlowStateUpdated)
local DescriptionUpdated = require(MomentsCreationFlow.Actions.DescriptionUpdated)
local MusicEditUpdated = require(MomentsCreationFlow.Actions.MusicEditUpdated)
local MusicSearchRetrieved = require(MomentsCreationFlow.Actions.MusicSearchRetrieved)
local SelectedCaptureUpdated = require(MomentsCreationFlow.Actions.SelectedCaptureUpdated)
local TextOverlayEditsUpdated = require(MomentsCreationFlow.Actions.TextOverlayEditsUpdated)
local TrimEditUpdated = require(MomentsCreationFlow.Actions.TrimEditUpdated)

local v = {
	active = false,
	capture = nil,
	currentState = CreationFlowState.Gallery,
	description = "",
	musicList = {},
	musicEdit = nil,
	textOverlayEdits = nil,
	trimEdit = nil
}

return Rodux.createReducer(v, {
	[CreationFlowStateUpdated.name] = function(p, p2)
		return Cryo.Dictionary.union(p, { currentState = p2.currentState })
	end,
	[MusicSearchRetrieved.name] = function(p, p2)
		return Cryo.Dictionary.union(p, { musicList = p2.musics })
	end,
	[SelectedCaptureUpdated.name] = function(p, p2)
		return Cryo.Dictionary.union(p, { capture = p2.capture })
	end,
	[TextOverlayEditsUpdated.name] = function(p, p2)
		return Cryo.Dictionary.union(p, { textOverlayEdits = p2.textOverlayEdits })
	end,
	[TrimEditUpdated.name] = function(p, p2)
		return Cryo.Dictionary.union(p, { trimEdit = p2.trimEdit })
	end,
	[MusicEditUpdated.name] = function(p, p2)
		return Cryo.Dictionary.union(p, { musicEdit = p2.musicEdit })
	end,
	[DescriptionUpdated.name] = function(p, p2)
		return Cryo.Dictionary.union(p, { description = p2.description })
	end,
	[ClearEdits.name] = function(_, p)
		return {
			active = true,
			capture = nil,
			currentState = p.newState,
			description = "",
			musicList = {},
			musicEdit = nil,
			textOverlayEdits = nil,
			trimEdit = nil
		}
	end
})
