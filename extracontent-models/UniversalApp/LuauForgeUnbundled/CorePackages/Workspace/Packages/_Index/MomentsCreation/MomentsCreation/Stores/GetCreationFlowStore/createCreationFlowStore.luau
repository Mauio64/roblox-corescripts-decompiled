local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsTypes")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")

local CreationFlowState = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Enums/CreationFlowState")
local createNavigationMachine = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Stores/createNavigationMachine")
local createSelectionStore = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Stores/createSelectionStore")
local createDescriptionStore = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Stores/createDescriptionStore")
local createEditsStore = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Stores/createEditsStore")
local FFlagMomentsTTSDraftRestore = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsTTSDraftRestore")

local createComputed = Signals.createComputed
local createSignal = Signals.createSignal
local fFlagMomentTextGenerationFilteredSignal = MomentsCommon.Flags.FFlagMomentTextGenerationFilteredSignal
local getFFlagEnableMomentTextGeneration = MomentsCommon.Flags.GetFFlagEnableMomentTextGeneration

local function createCreationFlowStore()
	local v5 = createNavigationMachine(CreationFlowState.Gallery)
	local v6 = createSelectionStore()
	local v7 = createDescriptionStore()
	local v8 = createEditsStore()

	local signal, v9 = createSignal(false)

	local signal2, v10 = createSignal({})

	local signal3, v11 = createSignal(nil)

	local signal4, v12 = createSignal(false)

	local signal5, v13 = createSignal(nil)

	local signal6, v14 = createSignal(nil)
	local signal7, v15 = createSignal(nil)

	local computed = createComputed(function(p2)
		return v8.getMap(p2).trim
	end)

	local computed2 = createComputed(function(p2)
		return v8.getMap(p2).music
	end)

	local computed3 = createComputed(function(p2)
		return v8.getMap(p2).text
	end)

	return {
		getStep = v5.getStep,
		getCurrentState = v5.getStep,
		canNavigate = v5.canNavigate,
		navigate = v5.navigate,
		getActive = signal,
		getSelectedCapture = v6.getSelectedCapture,
		getDescription = v7.getDescription,
		getGeneratedDescription = v7.getGeneratedDescription,
		getGenerationToken = v7.getGenerationToken,
		getGeneratedTextFeedback = v7.getGeneratedTextFeedback,
		getGeneratedSummary = v7.getGeneratedSummary,
		getCommentsEnabled = v7.getCommentsEnabled,
		getMusicList = signal2,
		getMusicEdit = computed2,
		getTextOverlayEdits = computed3,
		getTrimEdit = computed,
		getEditsMap = v8.getMap,
		getActiveSession = signal3,
		getIsGenerating = signal4,
		getActiveGeneration = signal5,
		getTTSAudio = signal6,
		getPendingRestoredVoice = signal7,
		updateCurrentState = function(p2)
			v5.reset(p2)
		end,
		onSelectedCaptureUpdated = function(p2)
			v6.setSelectedCapture(p2)
		end,
		updateDescription = function(p2)
			v7.setDescription(p2)
		end,
		setGeneratedDescription = function(p2)
			v7.setGeneratedDescription(p2)
		end,
		setGenerationToken = function(p2)
			v7.setGenerationToken(p2)
		end,
		setGeneratedTextFeedback = function(p2)
			v7.setGeneratedTextFeedback(p2)
		end,
		setGeneratedSummary = function(p2)
			v7.setGeneratedSummary(p2)
		end,
		updateCommentsEnabled = function(p2)
			v7.setCommentsEnabled(p2)
		end,
		updateTrimEdit = function(p2)
			v8.setCommitted("trim", p2)
		end,
		updateMusicEdit = function(p2)
			v8.setCommitted("music", p2)
		end,
		updateTextOverlayEdits = function(p2)
			v8.setCommitted("text", p2)
		end,
		setCommittedEdit = v8.setCommitted,
		setActiveSession = v11,
		setIsGenerating = v12,
		setActiveGeneration = v13,
		setTTSAudio = v14,
		setPendingRestoredVoice = function(p2)
			v15(p2)
		end,
		onMusicSearchRetrieved = function(p2)
			v10(p2)
		end,
		clearEdits = function(p2)
			v9(true)
			v6.setSelectedCapture(nil)
			v5.reset(p2)
			v7.setDescription("")
			v7.setCommentsEnabled(true)

			if fFlagMomentTextGenerationFilteredSignal or getFFlagEnableMomentTextGeneration() then
				v7.setGeneratedDescription(nil)
				v7.setGenerationToken(nil)
				v7.setGeneratedTextFeedback(nil)
				v7.setGeneratedSummary(nil)
			end

			v10({})
			v8.clear()

			v11(nil)

			if FFlagMomentsTTSDraftRestore then
				v15(nil)
			end
		end
	}
end

return createCreationFlowStore
