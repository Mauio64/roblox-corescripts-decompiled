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

local function createCreationFlowStore() -- line: 74
	-- upvalues: createNavigationMachine (copy), CreationFlowState (copy), createSelectionStore (copy), createDescriptionStore (copy), createEditsStore (copy), createSignal (copy), createComputed (copy)
	local v12 = createNavigationMachine(CreationFlowState.Gallery)
	local v13 = createSelectionStore()
	local v14 = createDescriptionStore()
	local v15 = createEditsStore()
	local v16, v17 = createSignal(false)
	local v18, v19 = createSignal({})
	local v20, v21 = createSignal(nil)
	local v22 = createComputed(function(p1) -- line: 92
		-- upvalues: v15 (copy)
		return v15.getMap(p1).trim
	end)
	local v23 = createComputed(function(p2) -- line: 95
		-- upvalues: v15 (copy)
		return v15.getMap(p2).music
	end)
	local v24 = createComputed(function(p3) -- line: 98
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
		getMusicEdit = v23,
		getTextOverlayEdits = v24,
		getTrimEdit = v22,
		getEditsMap = v15.getMap,
		getActiveSession = v20,
		updateCurrentState = function(p4) -- line: 104
			-- upvalues: v12 (copy)
			v12.reset(p4)
		end,
		onSelectedCaptureUpdated = function(p5) -- line: 109
			-- upvalues: v13 (copy)
			v13.setSelectedCapture(p5)
		end,
		updateDescription = function(s1: string) -- line: 114
			-- upvalues: v14 (copy)
			v14.setDescription(s1)
		end,
		updateTrimEdit = function(p6) -- line: 119
			-- upvalues: v15 (copy)
			v15.setCommitted("trim", p6)
		end,
		updateMusicEdit = function(p7) -- line: 124
			-- upvalues: v15 (copy)
			v15.setCommitted("music", p7)
		end,
		updateTextOverlayEdits = function(t1: {[any]: any}?) -- line: 129
			-- upvalues: v15 (copy)
			v15.setCommitted("text", t1)
		end,
		setCommittedEdit = v15.setCommitted,
		setActiveSession = v21,
		onMusicSearchRetrieved = function(t2: {[any]: any}) -- line: 134
			-- upvalues: v19 (copy)
			v19(t2)
		end,
		clearEdits = function(p8) -- line: 139
			-- upvalues: v17 (copy), v13 (copy), v12 (copy), v14 (copy), v19 (copy), v15 (copy), v21 (copy)
			v17(true)
			v13.setSelectedCapture(nil)
			v12.reset(p8)
			v14.setDescription("")
			v19({})
			v15.clear()
			v21(nil)
		end
	}
end

return createCreationFlowStore
