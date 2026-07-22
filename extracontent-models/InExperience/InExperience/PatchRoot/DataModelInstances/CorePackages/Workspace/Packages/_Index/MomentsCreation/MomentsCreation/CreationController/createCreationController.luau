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
local GetFFlagMomentsCreationPersistEditSession = require(MomentsCreation.Flags.GetFFlagMomentsCreationPersistEditSession)
local makeCreationEventFields = require(MomentsCreation.Analytics.makeCreationEventFields)
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)
local EventNames = MomentsCommon.Analytics.EventNames
local SessionManager = MomentsCommon.Analytics.SessionManager
local FunnelEventNames = MomentsCommon.Analytics.FunnelEventNames
local GetFFlagMomentsAnalyticsProducerPrereqs = MomentsCommon.Flags.GetFFlagMomentsAnalyticsProducerPrereqs
local createComputed = Signals.createComputed
local createSignal = Signals.createSignal

local function createCreationController(t1: {[any]: any}) -- line: 61
	-- upvalues: creationToolRegistry (copy), defaultCreationTools (copy), GetFFlagMomentsCreationPersistEditSession (copy), createSignal (copy), createComputed (copy), createCapturePreviewController (copy), SessionManager (copy), FunnelEventNames (copy), Cryo (copy), makeCreationEventFields (copy), CreationFlowState (copy), fireAnalyticsEvent (copy), EventNames (copy), createEditSession (copy), DialogType (copy), GetFFlagMomentsAnalyticsProducerPrereqs (copy)
	local store = t1.store
	local v24 = t1.host or {}
	local v25 = t1.registry or creationToolRegistry(defaultCreationTools)
	local t6 = nil
	local getActiveSession, setActiveSession

	if GetFFlagMomentsCreationPersistEditSession() then
		getActiveSession = store.getActiveSession
		setActiveSession = store.setActiveSession
	else
		local v29, v30 = createSignal(nil)

		getActiveSession = v29

		local u31 = v30

		function setActiveSession(p1) -- line: 81
			-- upvalues: u31 (ref)
			u31(p1)
		end
	end

	local v32, v33 = createSignal(nil)
	local v34 = createComputed(function(p2) -- line: 90
		-- upvalues: store (copy), v25 (copy)
		local t2 = {}

		for v46, v47 in (store.getEditsMap(p2)) do
			if v47 ~= nil then
				local v48 = v25.get(v46)

				if v48 ~= nil and v48.toEdits ~= nil then
					for v49, v50 in v48.toEdits(v47) do
						t2[v49] = v50
					end
				else
					t2[v46] = v47
				end
			end
		end

		return t2
	end)
	local v35 = createComputed(function(p3) -- line: 109
		-- upvalues: store (copy), v34 (copy), v25 (copy)
		local v52 = store.getSelectedCapture(p3)
		local v53 = if v52 == nil then nil else v52.CaptureType
		local t3 = {
			captureType = v53,
			getComposedEdits = v34
		}
		local t4 = {}

		for _, v57 in v25.getAll() do
			if (v57.supportedCaptureTypes == nil or v53 ~= nil and table.find(v57.supportedCaptureTypes, v53) ~= nil) and (v57.isAvailable == nil or v57.isAvailable(t3)) then
				table.insert(t4, v57)
			end
		end

		return t4
	end)
	local v36 = createComputed(function(p4) -- line: 130
		-- upvalues: store (copy), v25 (copy)
		local v59 = store.getStep(p4)

		for _, v61 in v25.getAll() do
			if v59 == v61.step then
				return v61
			end
		end

		return nil
	end)
	local v37 = createComputed(function(p5) -- line: 144
		-- upvalues: v36 (copy), getActiveSession (ref), v34 (copy)
		local v63 = v36(p5)

		if v63 ~= nil and v63.kind == "trim" then
			local v64 = getActiveSession(p5)
			local v65 = if v64 == nil then nil else v64.getDraft(p5)

			if v65 ~= nil and v65.startTime ~= nil and v65.endTime ~= nil then
				return {
					startTime = v65.startTime,
					endTime = v65.endTime
				}
			end
		end

		local trim = v34(p5).trim

		if trim ~= nil and trim.startTime ~= nil and trim.endTime ~= nil then
			return {
				startTime = trim.startTime,
				endTime = trim.endTime
			}
		end

		return nil
	end)
	local v38 = createComputed(function(p6) -- line: 163
		-- upvalues: v36 (copy), getActiveSession (ref), v34 (copy)
		local v68 = v36(p6)

		if v68 ~= nil and v68.kind == "music" then
			local v69 = getActiveSession(p6)
			local v70 = if v69 == nil then nil else v69.getDraft(p6)

			if v70 ~= nil and v70.assetId ~= nil then
				return v70
			end
		end

		return v34(p6).music
	end)
	local v39 = t1.preview or createCapturePreviewController(store, v37, v38)

	local function dismissModal() -- line: 181
		-- upvalues: v33 (copy)
		v33(nil)
	end
	local function withCreationSession(t5: {[any]: any}) -- line: 189
		-- upvalues: SessionManager (copy), FunnelEventNames (copy), Cryo (copy), makeCreationEventFields (copy)
		local v73 = SessionManager.getSessionId(FunnelEventNames.FunnelTypes.CreationFlow)

		return Cryo.Dictionary.join(t5, makeCreationEventFields.makeCreationBaseFields(v73))
	end
	local function dismiss() -- line: 308
		-- upvalues: v33 (copy), store (copy), t1 (copy), CreationFlowState (copy), v24 (copy)
		v33(nil)
		store.clearEdits(if not t1.excludeGallery then CreationFlowState.Gallery else CreationFlowState.Preview)

		if v24.exitCreationFlow ~= nil then
			v24.exitCreationFlow()
		end
	end

	t6 = {
		getStep = store.getStep,
		navigate = function(p7) -- line: 194
			-- upvalues: store (copy)
			store.navigate(p7)
		end,
		returnToGallery = function() -- line: 199
			-- upvalues: store (copy), CreationFlowState (copy), setActiveSession (ref)
			store.clearEdits(CreationFlowState.Gallery)
			setActiveSession(nil)
		end,
		getSelectedCapture = store.getSelectedCapture,
		selectCapture = function(p8) -- line: 204
			-- upvalues: store (copy), fireAnalyticsEvent (copy), EventNames (copy), withCreationSession (copy), makeCreationEventFields (copy)
			store.onSelectedCaptureUpdated(p8)

			if p8 ~= nil then
				fireAnalyticsEvent(EventNames.EditingFlowGalleryItemSelected, withCreationSession(makeCreationEventFields.makeToolFieldFromKind("gallery")))
			end
		end,
		getDescription = store.getDescription,
		setDescription = function(s1: string) -- line: 217
			-- upvalues: store (copy)
			store.updateDescription(s1)
		end,
		getAvailableTools = v35,
		getActiveTool = v36,
		getActiveSession = getActiveSession,
		getComposedEdits = v34,
		beginTool = function(s2: string) -- line: 221
			-- upvalues: v25 (copy), fireAnalyticsEvent (copy), withCreationSession (copy), makeCreationEventFields (copy), t6 (ref), createEditSession (copy), store (copy), setActiveSession (ref)
			local v78 = v25.get(s2)

			if v78 == nil then
				return
			end

			if v78.cta.analyticsEvent ~= nil then
				fireAnalyticsEvent(v78.cta.analyticsEvent, withCreationSession(makeCreationEventFields.makeToolField(v78)))
			end

			if v78.presentation == "InstantAction" then
				if v78.apply ~= nil then
					v78.apply(t6)
				end

				return
			end

			local createSession = v78.createSession
			local v80 = if createSession == nil then createEditSession() else createSession()

			if v78.step ~= nil and not store.navigate(v78.step) then
				return
			end

			v80.begin(store.getEditsMap(false)[s2])
			setActiveSession(v80)
		end,
		commitActiveTool = function() -- line: 259
			-- upvalues: getActiveSession (ref), v36 (copy), store (copy), CreationFlowState (copy), t6 (ref), fireAnalyticsEvent (copy), withCreationSession (copy), makeCreationEventFields (copy), setActiveSession (ref)
			local v81 = getActiveSession(false)
			local v82 = v36(false)

			if v81 == nil or v82 == nil then
				store.navigate(CreationFlowState.Preview)

				return
			end

			local v83 = v81.commit()

			if v82.onCommit ~= nil and v82.onCommit(v83, t6) == false then
				return
			end

			store.setCommittedEdit(v82.kind, v83)

			if v82.cta.commitAnalyticsEvent ~= nil then
				fireAnalyticsEvent(v82.cta.commitAnalyticsEvent, withCreationSession(makeCreationEventFields.makeToolField(v82)))
			end

			setActiveSession(nil)
			store.navigate(CreationFlowState.Preview)
		end,
		discardActiveTool = function() -- line: 284
			-- upvalues: getActiveSession (ref), v36 (copy), fireAnalyticsEvent (copy), withCreationSession (copy), makeCreationEventFields (copy), setActiveSession (ref), store (copy), CreationFlowState (copy)
			local v84 = getActiveSession(false)
			local v85 = v36(false)

			if v84 ~= nil then
				v84.discard()
			end

			if v85 ~= nil and v85.cta.cancelAnalyticsEvent ~= nil then
				fireAnalyticsEvent(v85.cta.cancelAnalyticsEvent, withCreationSession(makeCreationEventFields.makeToolField(v85)))
			end

			setActiveSession(nil)
			store.navigate(CreationFlowState.Preview)
		end,
		updateCommittedEdit = function(s3: string, p9) -- line: 304
			-- upvalues: store (copy)
			store.setCommittedEdit(s3, p9)
		end,
		getActiveModal = v32,
		showModal = function(p10) -- line: 177
			-- upvalues: v33 (copy)
			v33(p10)
		end,
		dismissModal = dismissModal,
		publish = function() -- line: 316
			-- upvalues: store (copy), v24 (copy), v33 (copy), DialogType (copy), dismissModal (copy), GetFFlagMomentsAnalyticsProducerPrereqs (copy), SessionManager (copy), FunnelEventNames (copy), v39 (copy), v34 (copy), fireAnalyticsEvent (copy), EventNames (copy), Cryo (copy), makeCreationEventFields (copy), t1 (copy), CreationFlowState (copy)
			local v88 = store.getDescription(false)

			if v24.isTextFiltered ~= nil and v24.isTextFiltered(v88) then
				v33({
					modalType = DialogType.TextFiltered,
					modalProps = {
						onConfirm = dismissModal
					}
				})

				return
			end

			local v89 = if not GetFFlagMomentsAnalyticsProducerPrereqs() then nil else SessionManager.getSessionId(FunnelEventNames.FunnelTypes.CreationFlow)

			if v24.createMoment ~= nil then
				local v90 = v39.playback.getTimeLength(false)

				v24.createMoment(store.getSelectedCapture(false), v34(false), v88, v89, v90)
			end

			fireAnalyticsEvent(EventNames.MomentsEditingFlowPublished, Cryo.Dictionary.join(makeCreationEventFields.makeStepField(EventNames.MomentsEditingFlowPublished), makeCreationEventFields.makeCreationBaseFields(v89)))
			v33(nil)
			store.clearEdits(if not t1.excludeGallery then CreationFlowState.Gallery else CreationFlowState.Preview)

			if v24.exitCreationFlow ~= nil then
				v24.exitCreationFlow()
			end
		end,
		exit = function() -- line: 357
			-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), withCreationSession (copy), makeCreationEventFields (copy), v33 (copy), store (copy), t1 (copy), CreationFlowState (copy), v24 (copy)
			fireAnalyticsEvent(EventNames.MomentsEditingFlowExited, withCreationSession(makeCreationEventFields.makeStepField(EventNames.MomentsEditingFlowExited)))
			v33(nil)
			store.clearEdits(if not t1.excludeGallery then CreationFlowState.Gallery else CreationFlowState.Preview)

			if v24.exitCreationFlow ~= nil then
				v24.exitCreationFlow()
			end
		end,
		preview = v39
	}

	return t6
end

return createCreationController
