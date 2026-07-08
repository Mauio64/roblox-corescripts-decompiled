local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local MomentsCreationFlowParent = MomentsCreationFlow.Parent
local Cryo = require(MomentsCreationFlowParent.Cryo)

require(MomentsCreationFlowParent.MomentsCommon)

local Rodux = require(MomentsCreationFlowParent.Rodux)
local ClearEdits = require(MomentsCreationFlow.Actions.ClearEdits)
local CreationFlowState = require(MomentsCreationFlow.Enums.CreationFlowState)
local CreationFlowStateUpdated = require(MomentsCreationFlow.Actions.CreationFlowStateUpdated)
local DescriptionUpdated = require(MomentsCreationFlow.Actions.DescriptionUpdated)
local MusicEditUpdated = require(MomentsCreationFlow.Actions.MusicEditUpdated)
local MusicSearchRetrieved = require(MomentsCreationFlow.Actions.MusicSearchRetrieved)
local SelectedCaptureUpdated = require(MomentsCreationFlow.Actions.SelectedCaptureUpdated)
local TextOverlayEditsUpdated = require(MomentsCreationFlow.Actions.TextOverlayEditsUpdated)
local TrimEditUpdated = require(MomentsCreationFlow.Actions.TrimEditUpdated)
local t1 = {
	active = false,
	capture = nil,
	description = "",
	musicEdit = nil,
	textOverlayEdits = nil,
	trimEdit = nil,
	currentState = CreationFlowState.Gallery,
	musicList = {}
}

return Rodux.createReducer(t1, {
	[CreationFlowStateUpdated.name] = function(t2: {[any]: any}, p1) -- line: 45
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.union(t2, {
			currentState = p1.currentState
		})
	end,
	[MusicSearchRetrieved.name] = function(t3: {[any]: any}, p2) -- line: 51
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.union(t3, {
			musicList = p2.musics
		})
	end,
	[SelectedCaptureUpdated.name] = function(t4: {[any]: any}, p3) -- line: 57
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.union(t4, {
			capture = p3.capture
		})
	end,
	[TextOverlayEditsUpdated.name] = function(t5: {[any]: any}, p4) -- line: 63
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.union(t5, {
			textOverlayEdits = p4.textOverlayEdits
		})
	end,
	[TrimEditUpdated.name] = function(t6: {[any]: any}, p5) -- line: 69
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.union(t6, {
			trimEdit = p5.trimEdit
		})
	end,
	[MusicEditUpdated.name] = function(t7: {[any]: any}, p6) -- line: 75
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.union(t7, {
			musicEdit = p6.musicEdit
		})
	end,
	[DescriptionUpdated.name] = function(t8: {[any]: any}, p7) -- line: 81
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.union(t8, {
			description = p7.description
		})
	end,
	[ClearEdits.name] = function(_: {[any]: any}, p8) -- line: 87
		return {
			active = true,
			capture = nil,
			description = "",
			musicEdit = nil,
			textOverlayEdits = nil,
			trimEdit = nil,
			currentState = p8.newState,
			musicList = {}
		}
	end
})
