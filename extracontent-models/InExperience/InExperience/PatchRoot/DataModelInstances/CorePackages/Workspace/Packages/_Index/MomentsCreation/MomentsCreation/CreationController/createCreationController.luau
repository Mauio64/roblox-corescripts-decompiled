local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local Cryo = require(MomentsCreationParent.Cryo)
local Signals = require(MomentsCreationParent.Signals)
local CreationFlowState = require(MomentsCreation.Enums.CreationFlowState)
local DialogType = require(MomentsCreation.Enums.DialogType)

require(MomentsCreation.Types.CreationFlowTypes)
require(MomentsCreationParent.MomentsTypes)

local creationToolRegistry = require(MomentsCreation.Tools.creationToolRegistry)
local defaultCreationTools = require(MomentsCreation.Tools.defaultCreationTools)
local createCapturePreviewController = require(MomentsCreation.Preview.createCapturePreviewController)
local createEditSession = require(MomentsCreation.Stores.createEditSession)
local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local makeCreationEventFields = require(MomentsCreation.Analytics.makeCreationEventFields)
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)
local EventNames = MomentsCommon.Analytics.EventNames
local SessionManager = MomentsCommon.Analytics.SessionManager
local FunnelEventNames = MomentsCommon.Analytics.FunnelEventNames
local GetFFlagMomentsAnalyticsProducerPrereqs = MomentsCommon.Flags.GetFFlagMomentsAnalyticsProducerPrereqs
local createComputed = Signals.createComputed
local createSignal = Signals.createSignal

local function createCreationController(t1: {[any]: any}) -- line: 59
	-- upvalues: creationToolRegistry (copy), defaultCreationTools (copy), createSignal (copy), createComputed (copy), createCapturePreviewController (copy), SessionManager (copy), FunnelEventNames (copy), Cryo (copy), makeCreationEventFields (copy), CreationFlowState (copy), fireAnalyticsEvent (copy), EventNames (copy), createEditSession (copy), DialogType (copy), GetFFlagMomentsAnalyticsProducerPrereqs (copy)
	local store = t1.store
	local v23 = t1.host or {}
	local v24 = t1.registry or creationToolRegistry(defaultCreationTools)
	local t6 = nil
	local v26, v27 = createSignal(nil)

	local function setActiveSession(p1) -- line: 68
		-- upvalues: v27 (copy)
		v27(p1)
	end

	local v29, v30 = createSignal(nil)
	local v31 = createComputed(function(p2) -- line: 76
		-- upvalues: store (copy), v24 (copy)
		local t2 = {}

		for v43, v44 in (store.getEditsMap(p2)) do
			if v44 ~= nil then
				local v45 = v24.get(v43)

				if v45 ~= nil and v45.toEdits ~= nil then
					for v46, v47 in v45.toEdits(v44) do
						t2[v46] = v47
					end
				else
					t2[v43] = v44
				end
			end
		end

		return t2
	end)
	local v32 = createComputed(function(p3) -- line: 95
		-- upvalues: store (copy), v31 (copy), v24 (copy)
		local v49 = store.getSelectedCapture(p3)
		local v50 = if v49 == nil then nil else v49.CaptureType
		local t3 = {
			captureType = v50,
			getComposedEdits = v31
		}
		local t4 = {}

		for _, v54 in v24.getAll() do
			if (v54.supportedCaptureTypes == nil or v50 ~= nil and table.find(v54.supportedCaptureTypes, v50) ~= nil) and (v54.isAvailable == nil or v54.isAvailable(t3)) then
				table.insert(t4, v54)
			end
		end

		return t4
	end)
	local v33 = createComputed(function(p4) -- line: 116
		-- upvalues: store (copy), v24 (copy)
		local v56 = store.getStep(p4)

		for _, v58 in v24.getAll() do
			if v56 == v58.step then
				return v58
			end
		end

		return nil
	end)
	local v34 = createComputed(function(p5) -- line: 130
		-- upvalues: v33 (copy), v26 (copy), v31 (copy)
		local v60 = v33(p5)

		if v60 ~= nil and v60.kind == "trim" then
			local v61 = v26(p5)
			local v62 = if v61 == nil then nil else v61.getDraft(p5)

			if v62 ~= nil and v62.startTime ~= nil and v62.endTime ~= nil then
				return {
					startTime = v62.startTime,
					endTime = v62.endTime
				}
			end
		end

		local trim = v31(p5).trim

		if trim ~= nil and trim.startTime ~= nil and trim.endTime ~= nil then
			return {
				startTime = trim.startTime,
				endTime = trim.endTime
			}
		end

		return nil
	end)
	local v35 = createComputed(function(p6) -- line: 149
		-- upvalues: v33 (copy), v26 (copy), v31 (copy)
		local v65 = v33(p6)

		if v65 ~= nil and v65.kind == "music" then
			local v66 = v26(p6)
			local v67 = if v66 == nil then nil else v66.getDraft(p6)

			if v67 ~= nil and v67.assetId ~= nil then
				return v67
			end
		end

		return v31(p6).music
	end)
	local v36 = t1.preview or createCapturePreviewController(store, v34, v35)

	local function dismissModal() -- line: 167
		-- upvalues: v30 (copy)
		v30(nil)
	end
	local function withCreationSession(t5: {[any]: any}) -- line: 175
		-- upvalues: SessionManager (copy), FunnelEventNames (copy), Cryo (copy), makeCreationEventFields (copy)
		local v70 = SessionManager.getSessionId(FunnelEventNames.FunnelTypes.CreationFlow)

		return Cryo.Dictionary.join(t5, makeCreationEventFields.makeCreationBaseFields(v70))
	end
	local function dismiss() -- line: 294
		-- upvalues: v30 (copy), store (copy), t1 (copy), CreationFlowState (copy), v23 (copy)
		v30(nil)
		store.clearEdits(if not t1.excludeGallery then CreationFlowState.Gallery else CreationFlowState.Preview)

		if v23.exitCreationFlow ~= nil then
			v23.exitCreationFlow()
		end
	end

	t6 = {
		getStep = store.getStep,
		navigate = function(p7) -- line: 180
			-- upvalues: store (copy)
			store.navigate(p7)
		end,
		returnToGallery = function() -- line: 185
			-- upvalues: store (copy), CreationFlowState (copy), v27 (copy)
			store.clearEdits(CreationFlowState.Gallery)
			v27(nil)
		end,
		getSelectedCapture = store.getSelectedCapture,
		selectCapture = function(p8) -- line: 190
			-- upvalues: store (copy), fireAnalyticsEvent (copy), EventNames (copy), withCreationSession (copy), makeCreationEventFields (copy)
			store.onSelectedCaptureUpdated(p8)

			if p8 ~= nil then
				fireAnalyticsEvent(EventNames.EditingFlowGalleryItemSelected, withCreationSession(makeCreationEventFields.makeToolFieldFromKind("gallery")))
			end
		end,
		getDescription = store.getDescription,
		setDescription = function(s1: string) -- line: 203
			-- upvalues: store (copy)
			store.updateDescription(s1)
		end,
		getAvailableTools = v32,
		getActiveTool = v33,
		getActiveSession = v26,
		getComposedEdits = v31,
		beginTool = function(s2: string) -- line: 207
			-- upvalues: v24 (copy), fireAnalyticsEvent (copy), withCreationSession (copy), makeCreationEventFields (copy), t6 (ref), createEditSession (copy), store (copy), v27 (copy)
			local v75 = v24.get(s2)

			if v75 == nil then
				return
			end

			if v75.cta.analyticsEvent ~= nil then
				fireAnalyticsEvent(v75.cta.analyticsEvent, withCreationSession(makeCreationEventFields.makeToolField(v75)))
			end

			if v75.presentation == "InstantAction" then
				if v75.apply ~= nil then
					v75.apply(t6)
				end

				return
			end

			local createSession = v75.createSession
			local v77 = if createSession == nil then createEditSession() else createSession()

			if v75.step ~= nil and not store.navigate(v75.step) then
				return
			end

			v77.begin(store.getEditsMap(false)[s2])
			v27(v77)
		end,
		commitActiveTool = function() -- line: 245
			-- upvalues: v26 (copy), v33 (copy), store (copy), CreationFlowState (copy), t6 (ref), fireAnalyticsEvent (copy), withCreationSession (copy), makeCreationEventFields (copy), v27 (copy)
			local v78 = v26(false)
			local v79 = v33(false)

			if v78 == nil or v79 == nil then
				store.navigate(CreationFlowState.Preview)

				return
			end

			local v80 = v78.commit()

			if v79.onCommit ~= nil and v79.onCommit(v80, t6) == false then
				return
			end

			store.setCommittedEdit(v79.kind, v80)

			if v79.cta.commitAnalyticsEvent ~= nil then
				fireAnalyticsEvent(v79.cta.commitAnalyticsEvent, withCreationSession(makeCreationEventFields.makeToolField(v79)))
			end

			v27(nil)
			store.navigate(CreationFlowState.Preview)
		end,
		discardActiveTool = function() -- line: 270
			-- upvalues: v26 (copy), v33 (copy), fireAnalyticsEvent (copy), withCreationSession (copy), makeCreationEventFields (copy), v27 (copy), store (copy), CreationFlowState (copy)
			local v81 = v26(false)
			local v82 = v33(false)

			if v81 ~= nil then
				v81.discard()
			end

			if v82 ~= nil and v82.cta.cancelAnalyticsEvent ~= nil then
				fireAnalyticsEvent(v82.cta.cancelAnalyticsEvent, withCreationSession(makeCreationEventFields.makeToolField(v82)))
			end

			v27(nil)
			store.navigate(CreationFlowState.Preview)
		end,
		updateCommittedEdit = function(s3: string, p9) -- line: 290
			-- upvalues: store (copy)
			store.setCommittedEdit(s3, p9)
		end,
		getActiveModal = v29,
		showModal = function(p10) -- line: 163
			-- upvalues: v30 (copy)
			v30(p10)
		end,
		dismissModal = dismissModal,
		publish = function() -- line: 302
			-- upvalues: store (copy), v23 (copy), v30 (copy), DialogType (copy), dismissModal (copy), GetFFlagMomentsAnalyticsProducerPrereqs (copy), SessionManager (copy), FunnelEventNames (copy), v31 (copy), fireAnalyticsEvent (copy), EventNames (copy), Cryo (copy), makeCreationEventFields (copy), t1 (copy), CreationFlowState (copy)
			local v85 = store.getDescription(false)

			if v23.isTextFiltered ~= nil and v23.isTextFiltered(v85) then
				v30({
					modalType = DialogType.TextFiltered,
					modalProps = {
						onConfirm = dismissModal
					}
				})

				return
			end

			local v86 = if not GetFFlagMomentsAnalyticsProducerPrereqs() then nil else SessionManager.getSessionId(FunnelEventNames.FunnelTypes.CreationFlow)

			if v23.createMoment ~= nil then
				v23.createMoment(store.getSelectedCapture(false), v31(false), v85, v86)
			end

			fireAnalyticsEvent(EventNames.MomentsEditingFlowPublished, Cryo.Dictionary.join(makeCreationEventFields.makeStepField(EventNames.MomentsEditingFlowPublished), makeCreationEventFields.makeCreationBaseFields(v86)))
			v30(nil)
			store.clearEdits(if not t1.excludeGallery then CreationFlowState.Gallery else CreationFlowState.Preview)

			if v23.exitCreationFlow ~= nil then
				v23.exitCreationFlow()
			end
		end,
		exit = function() -- line: 334
			-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), withCreationSession (copy), makeCreationEventFields (copy), v30 (copy), store (copy), t1 (copy), CreationFlowState (copy), v23 (copy)
			fireAnalyticsEvent(EventNames.MomentsEditingFlowExited, withCreationSession(makeCreationEventFields.makeStepField(EventNames.MomentsEditingFlowExited)))
			v30(nil)
			store.clearEdits(if not t1.excludeGallery then CreationFlowState.Gallery else CreationFlowState.Preview)

			if v23.exitCreationFlow ~= nil then
				v23.exitCreationFlow()
			end
		end,
		preview = v36
	}

	return t6
end

return createCreationController
