local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Signals = require(parent.Signals)
require(parent.MomentsTypes)
local MomentsCommon = require(parent.MomentsCommon)

local CreationFlowState = require(MomentsCreation.Enums.CreationFlowState)
local createNavigationMachine = require(MomentsCreation.Stores.createNavigationMachine)
local createSelectionStore = require(MomentsCreation.Stores.createSelectionStore)
local createDescriptionStore = require(MomentsCreation.Stores.createDescriptionStore)
local createEditsStore = require(MomentsCreation.Stores.createEditsStore)
local FFlagMomentsTTSDraftRestore = require(MomentsCreation.Flags.FFlagMomentsTTSDraftRestore)

local createComputed = Signals.createComputed
local createSignal = Signals.createSignal
local FFlagMomentTextGenerationFilteredSignal = MomentsCommon.Flags.FFlagMomentTextGenerationFilteredSignal
local GetFFlagEnableMomentTextGeneration = MomentsCommon.Flags.GetFFlagEnableMomentTextGeneration

local function createCreationFlowStore()
	local navigationMachine = createNavigationMachine(CreationFlowState.Gallery)
	local selectionStore = createSelectionStore()
	local descriptionStore = createDescriptionStore()
	local editsStore = createEditsStore()

	local signal, v = createSignal(false)

	local signal2, v2 = createSignal({})

	local signal3, setActiveSession = createSignal(nil)

	local signal4, setIsGenerating = createSignal(false)

	local signal5, setActiveGeneration = createSignal(nil)

	local signal6, setTTSAudio = createSignal(nil)
	local signal7, v3 = createSignal(nil)

	local getTrimEdit = createComputed(function(p)
		return editsStore.getMap(p).trim
	end)

	local getMusicEdit = createComputed(function(p)
		return editsStore.getMap(p).music
	end)

	local getTextOverlayEdits = createComputed(function(p)
		return editsStore.getMap(p).text
	end)

	local function setPendingRestoredVoice(p) -- 1 equivalent call inferred from this helper
		v3(p)
	end

	return {
		getStep = navigationMachine.getStep,
		getCurrentState = navigationMachine.getStep,
		canNavigate = navigationMachine.canNavigate,
		navigate = navigationMachine.navigate,
		getActive = signal,
		getSelectedCapture = selectionStore.getSelectedCapture,
		getDescription = descriptionStore.getDescription,
		getGeneratedDescription = descriptionStore.getGeneratedDescription,
		getGenerationToken = descriptionStore.getGenerationToken,
		getGeneratedTextFeedback = descriptionStore.getGeneratedTextFeedback,
		getGeneratedSummary = descriptionStore.getGeneratedSummary,
		getCommentsEnabled = descriptionStore.getCommentsEnabled,
		getMusicList = signal2,
		getMusicEdit = getMusicEdit,
		getTextOverlayEdits = getTextOverlayEdits,
		getTrimEdit = getTrimEdit,
		getEditsMap = editsStore.getMap,
		getActiveSession = signal3,
		getIsGenerating = signal4,
		getActiveGeneration = signal5,
		getTTSAudio = signal6,
		getPendingRestoredVoice = signal7,
		updateCurrentState = function(p)
			navigationMachine.reset(p)
		end,
		onSelectedCaptureUpdated = function(p)
			selectionStore.setSelectedCapture(p)
		end,
		updateDescription = function(p: string)
			descriptionStore.setDescription(p)
		end,
		setGeneratedDescription = function(p: string?)
			descriptionStore.setGeneratedDescription(p)
		end,
		setGenerationToken = function(p: string?)
			descriptionStore.setGenerationToken(p)
		end,
		setGeneratedTextFeedback = function(p: string?)
			descriptionStore.setGeneratedTextFeedback(p)
		end,
		setGeneratedSummary = function(p: string?)
			descriptionStore.setGeneratedSummary(p)
		end,
		updateCommentsEnabled = function(flag: boolean)
			descriptionStore.setCommentsEnabled(flag)
		end,
		updateTrimEdit = function(p)
			editsStore.setCommitted("trim", p)
		end,
		updateMusicEdit = function(p)
			editsStore.setCommitted("music", p)
		end,
		updateTextOverlayEdits = function(p)
			editsStore.setCommitted("text", p)
		end,
		setCommittedEdit = editsStore.setCommitted,
		setActiveSession = setActiveSession,
		setIsGenerating = setIsGenerating,
		setActiveGeneration = setActiveGeneration,
		setTTSAudio = setTTSAudio,
		setPendingRestoredVoice = setPendingRestoredVoice,
		onMusicSearchRetrieved = function(p)
			v2(p)
		end,
		clearEdits = function(p)
			v(true)
			selectionStore.setSelectedCapture(nil)
			navigationMachine.reset(p)
			descriptionStore.setDescription("")
			descriptionStore.setCommentsEnabled(true)

			if FFlagMomentTextGenerationFilteredSignal or GetFFlagEnableMomentTextGeneration() then
				descriptionStore.setGeneratedDescription(nil)
				descriptionStore.setGenerationToken(nil)
				descriptionStore.setGeneratedTextFeedback(nil)
				descriptionStore.setGeneratedSummary(nil)
			end

			v2({})
			editsStore.clear()

			setActiveSession(nil)

			if FFlagMomentsTTSDraftRestore then
				setPendingRestoredVoice(nil) -- inferred equivalent call
			end
		end
	}
end

return createCreationFlowStore
