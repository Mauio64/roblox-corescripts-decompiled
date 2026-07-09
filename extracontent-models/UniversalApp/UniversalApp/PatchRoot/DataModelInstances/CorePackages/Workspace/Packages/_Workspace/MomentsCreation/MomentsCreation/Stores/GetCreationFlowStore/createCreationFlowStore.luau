local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local Signals = require(MomentsCreationParent.Signals)

require(MomentsCreationParent.MomentsTypes)

local CreationFlowState = require(MomentsCreation.Enums.CreationFlowState)
local createNavigationMachine = require(MomentsCreation.Stores.createNavigationMachine)
local createSelectionStore = require(MomentsCreation.Stores.createSelectionStore)
local createDescriptionStore = require(MomentsCreation.Stores.createDescriptionStore)
local createEditsStore = require(MomentsCreation.Stores.createEditsStore)
local createComputed = Signals.createComputed
local createSignal = Signals.createSignal

local function createCreationFlowStore() -- line: 69
	-- upvalues: createNavigationMachine (copy), CreationFlowState (copy), createSelectionStore (copy), createDescriptionStore (copy), createEditsStore (copy), createSignal (copy), createComputed (copy)
	local v12 = createNavigationMachine(CreationFlowState.Gallery)
	local v13 = createSelectionStore()
	local v14 = createDescriptionStore()
	local v15 = createEditsStore()
	local v16, v17 = createSignal(false)
	local v18, v19 = createSignal({})
	local v20 = createComputed(function(p1) -- line: 83
		-- upvalues: v15 (copy)
		return v15.getMap(p1).trim
	end)
	local v21 = createComputed(function(p2) -- line: 86
		-- upvalues: v15 (copy)
		return v15.getMap(p2).music
	end)
	local v22 = createComputed(function(p3) -- line: 89
		-- upvalues: v15 (copy)
		return v15.getMap(p3).text
	end)

	return {
		getStep = v12.getStep,
		getCurrentState = v12.getStep,
		canNavigate = v12.canNavigate,
		navigate = v12.navigate,
		getActive = v16,
		getSelectedCapture = v13.getSelectedCapture,
		getDescription = v14.getDescription,
		getMusicList = v18,
		getMusicEdit = v21,
		getTextOverlayEdits = v22,
		getTrimEdit = v20,
		getEditsMap = v15.getMap,
		updateCurrentState = function(p4) -- line: 95
			-- upvalues: v12 (copy)
			v12.reset(p4)
		end,
		onSelectedCaptureUpdated = function(p5) -- line: 100
			-- upvalues: v13 (copy)
			v13.setSelectedCapture(p5)
		end,
		updateDescription = function(s1: string) -- line: 105
			-- upvalues: v14 (copy)
			v14.setDescription(s1)
		end,
		updateTrimEdit = function(p6) -- line: 110
			-- upvalues: v15 (copy)
			v15.setCommitted("trim", p6)
		end,
		updateMusicEdit = function(p7) -- line: 115
			-- upvalues: v15 (copy)
			v15.setCommitted("music", p7)
		end,
		updateTextOverlayEdits = function(t1: {[any]: any}?) -- line: 120
			-- upvalues: v15 (copy)
			v15.setCommitted("text", t1)
		end,
		setCommittedEdit = v15.setCommitted,
		onMusicSearchRetrieved = function(t2: {[any]: any}) -- line: 125
			-- upvalues: v19 (copy)
			v19(t2)
		end,
		clearEdits = function(p8) -- line: 130
			-- upvalues: v17 (copy), v13 (copy), v12 (copy), v14 (copy), v19 (copy), v15 (copy)
			v17(true)
			v13.setSelectedCapture(nil)
			v12.reset(p8)
			v14.setDescription("")
			v19({})
			v15.clear()
		end
	}
end

return createCreationFlowStore
