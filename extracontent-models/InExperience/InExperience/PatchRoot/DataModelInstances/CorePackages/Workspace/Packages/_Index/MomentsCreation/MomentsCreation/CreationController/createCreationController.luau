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
local makeDefaultTextOverlayEdit = require(MomentsCreation.Utils.makeDefaultTextOverlayEdit)
local GetFFlagMomentsCreationPersistEditSession = require(MomentsCreation.Flags.GetFFlagMomentsCreationPersistEditSession)
local makeCreationEventFields = require(MomentsCreation.Analytics.makeCreationEventFields)
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)
local EventNames = MomentsCommon.Analytics.EventNames
local SessionManager = MomentsCommon.Analytics.SessionManager
local FunnelEventNames = MomentsCommon.Analytics.FunnelEventNames
local GetFFlagMomentsAnalyticsProducerPrereqs = MomentsCommon.Flags.GetFFlagMomentsAnalyticsProducerPrereqs
local createComputed = Signals.createComputed
local createSignal = Signals.createSignal

local function createCreationController(t1: {[any]: any}) -- line: 62
	-- upvalues: creationToolRegistry (copy), defaultCreationTools (copy), GetFFlagMomentsAnalyticsProducerPrereqs (copy), SessionManager (copy), FunnelEventNames (copy), GetFFlagMomentsCreationPersistEditSession (copy), createSignal (copy), createComputed (copy), createCapturePreviewController (copy), Cryo (copy), makeCreationEventFields (copy), CreationFlowState (copy), fireAnalyticsEvent (copy), EventNames (copy), createEditSession (copy), DialogType (copy), makeDefaultTextOverlayEdit (copy)
	local store = t1.store
	local v25 = t1.host or {}
	local v26 = t1.registry or creationToolRegistry(defaultCreationTools)

	if GetFFlagMomentsAnalyticsProducerPrereqs() and SessionManager.getSessionId(FunnelEventNames.FunnelTypes.CreationFlow) == nil then
		SessionManager.startSession(FunnelEventNames.FunnelTypes.CreationFlow)
	end

	local t6 = nil
	local getActiveSession, setActiveSession

	if GetFFlagMomentsCreationPersistEditSession() then
		getActiveSession = store.getActiveSession
		setActiveSession = store.setActiveSession
	else
		local v30, v31 = createSignal(nil)

		getActiveSession = v30

		local u32 = v31

		function setActiveSession(p1) -- line: 91
			-- upvalues: u32 (ref)
			u32(p1)
		end
	end

	local v33, v34 = createSignal(nil)
	local v35 = createComputed(function(p2) -- line: 100
		-- upvalues: store (copy), v26 (copy)
		local t2 = {}

		for v49, v50 in (store.getEditsMap(p2)) do
			if v50 ~= nil then
				local v51 = v26.get(v49)

				if v51 ~= nil and v51.toEdits ~= nil then
					for v52, v53 in v51.toEdits(v50) do
						t2[v52] = v53
					end
				else
					t2[v49] = v50
				end
			end
		end

		return t2
	end)
	local v36, v37 = createSignal(false)
	local v38 = createComputed(function(p3) -- line: 122
		-- upvalues: store (copy), v25 (copy), v35 (copy), v26 (copy)
		local v55 = store.getSelectedCapture(p3)
		local v56 = if v55 == nil then nil else v55.CaptureType
		local t3 = {
			canGenerateText = v25.generateMomentText ~= nil,
			captureType = v56,
			getComposedEdits = v35
		}
		local t4 = {}

		for _, v60 in v26.getAll() do
			if (v60.supportedCaptureTypes == nil or v56 ~= nil and table.find(v60.supportedCaptureTypes, v56) ~= nil) and (v60.isAvailable == nil or v60.isAvailable(t3)) then
				table.insert(t4, v60)
			end
		end

		return t4
	end)
	local v39 = createComputed(function(p4) -- line: 144
		-- upvalues: store (copy), v26 (copy)
		local v62 = store.getStep(p4)

		for _, v64 in v26.getAll() do
			if v62 == v64.step then
				return v64
			end
		end

		return nil
	end)
	local v40 = createComputed(function(p5) -- line: 158
		-- upvalues: v39 (copy), getActiveSession (ref), v35 (copy)
		local v66 = v39(p5)

		if v66 ~= nil and v66.kind == "trim" then
			local v67 = getActiveSession(p5)
			local v68 = if v67 == nil then nil else v67.getDraft(p5)

			if v68 ~= nil and v68.startTime ~= nil and v68.endTime ~= nil then
				return {
					startTime = v68.startTime,
					endTime = v68.endTime
				}
			end
		end

		local trim = v35(p5).trim

		if trim ~= nil and trim.startTime ~= nil and trim.endTime ~= nil then
			return {
				startTime = trim.startTime,
				endTime = trim.endTime
			}
		end

		return nil
	end)
	local v41 = createComputed(function(p6) -- line: 177
		-- upvalues: v39 (copy), getActiveSession (ref), v35 (copy)
		local v71 = v39(p6)

		if v71 ~= nil and v71.kind == "music" then
			local v72 = getActiveSession(p6)
			local v73 = if v72 == nil then nil else v72.getDraft(p6)

			if v73 ~= nil and v73.assetId ~= nil then
				return v73
			end
		end

		return v35(p6).music
	end)
	local v42 = t1.preview or createCapturePreviewController(store, v40, v41)

	local function dismissModal() -- line: 195
		-- upvalues: v34 (copy)
		v34(nil)
	end
	local function withCreationSession(t5: {[any]: any}) -- line: 203
		-- upvalues: SessionManager (copy), FunnelEventNames (copy), Cryo (copy), makeCreationEventFields (copy)
		local v76 = SessionManager.getSessionId(FunnelEventNames.FunnelTypes.CreationFlow)

		return Cryo.Dictionary.join(t5, makeCreationEventFields.makeCreationBaseFields(v76))
	end
	local function dismiss() -- line: 322
		-- upvalues: v34 (copy), store (copy), t1 (copy), CreationFlowState (copy), v25 (copy)
		v34(nil)
		store.clearEdits(if not t1.excludeGallery then CreationFlowState.Gallery else CreationFlowState.Preview)

		if v25.exitCreationFlow ~= nil then
			v25.exitCreationFlow()
		end
	end

	t6 = {
		getStep = store.getStep,
		navigate = function(p7) -- line: 208
			-- upvalues: store (copy)
			store.navigate(p7)
		end,
		returnToGallery = function() -- line: 213
			-- upvalues: store (copy), CreationFlowState (copy), setActiveSession (ref)
			store.clearEdits(CreationFlowState.Gallery)
			setActiveSession(nil)
		end,
		getSelectedCapture = store.getSelectedCapture,
		selectCapture = function(p8) -- line: 218
			-- upvalues: store (copy), fireAnalyticsEvent (copy), EventNames (copy), withCreationSession (copy), makeCreationEventFields (copy)
			store.onSelectedCaptureUpdated(p8)

			if p8 ~= nil then
				fireAnalyticsEvent(EventNames.EditingFlowGalleryItemSelected, withCreationSession(makeCreationEventFields.makeToolFieldFromKind("gallery")))
			end
		end,
		getDescription = store.getDescription,
		setDescription = function(s1: string) -- line: 231
			-- upvalues: store (copy)
			store.updateDescription(s1)
		end,
		getAvailableTools = v38,
		getActiveTool = v39,
		getActiveSession = getActiveSession,
		getComposedEdits = v35,
		beginTool = function(s2: string) -- line: 235
			-- upvalues: v26 (copy), fireAnalyticsEvent (copy), withCreationSession (copy), makeCreationEventFields (copy), t6 (ref), createEditSession (copy), store (copy), setActiveSession (ref)
			local v81 = v26.get(s2)

			if v81 == nil then
				return
			end

			if v81.cta.analyticsEvent ~= nil then
				fireAnalyticsEvent(v81.cta.analyticsEvent, withCreationSession(makeCreationEventFields.makeToolField(v81)))
			end

			if v81.presentation == "InstantAction" then
				if v81.apply ~= nil then
					v81.apply(t6)
				end

				return
			end

			local createSession = v81.createSession
			local v83 = if createSession == nil then createEditSession() else createSession()

			if v81.step ~= nil and not store.navigate(v81.step) then
				return
			end

			v83.begin(store.getEditsMap(false)[s2])
			setActiveSession(v83)
		end,
		commitActiveTool = function() -- line: 273
			-- upvalues: getActiveSession (ref), v39 (copy), store (copy), CreationFlowState (copy), t6 (ref), fireAnalyticsEvent (copy), withCreationSession (copy), makeCreationEventFields (copy), setActiveSession (ref)
			local v84 = getActiveSession(false)
			local v85 = v39(false)

			if v84 == nil or v85 == nil then
				store.navigate(CreationFlowState.Preview)

				return
			end

			local v86 = v84.commit()

			if v85.onCommit ~= nil and v85.onCommit(v86, t6) == false then
				return
			end

			store.setCommittedEdit(v85.kind, v86)

			if v85.cta.commitAnalyticsEvent ~= nil then
				fireAnalyticsEvent(v85.cta.commitAnalyticsEvent, withCreationSession(makeCreationEventFields.makeToolField(v85)))
			end

			setActiveSession(nil)
			store.navigate(CreationFlowState.Preview)
		end,
		discardActiveTool = function() -- line: 298
			-- upvalues: getActiveSession (ref), v39 (copy), fireAnalyticsEvent (copy), withCreationSession (copy), makeCreationEventFields (copy), setActiveSession (ref), store (copy), CreationFlowState (copy)
			local v87 = getActiveSession(false)
			local v88 = v39(false)

			if v87 ~= nil then
				v87.discard()
			end

			if v88 ~= nil and v88.cta.cancelAnalyticsEvent ~= nil then
				fireAnalyticsEvent(v88.cta.cancelAnalyticsEvent, withCreationSession(makeCreationEventFields.makeToolField(v88)))
			end

			setActiveSession(nil)
			store.navigate(CreationFlowState.Preview)
		end,
		updateCommittedEdit = function(s3: string, p9) -- line: 318
			-- upvalues: store (copy)
			store.setCommittedEdit(s3, p9)
		end,
		getActiveModal = v33,
		showModal = function(p10) -- line: 191
			-- upvalues: v34 (copy)
			v34(p10)
		end,
		dismissModal = dismissModal,
		publish = function() -- line: 330
			-- upvalues: store (copy), v25 (copy), v34 (copy), DialogType (copy), dismissModal (copy), GetFFlagMomentsAnalyticsProducerPrereqs (copy), SessionManager (copy), FunnelEventNames (copy), v42 (copy), v35 (copy), fireAnalyticsEvent (copy), EventNames (copy), Cryo (copy), makeCreationEventFields (copy), t1 (copy), CreationFlowState (copy)
			local v91 = store.getDescription(false)

			if v25.isTextFiltered ~= nil and v25.isTextFiltered(v91) then
				v34({
					modalType = DialogType.TextFiltered,
					modalProps = {
						onConfirm = dismissModal
					}
				})

				return
			end

			local v92 = if not GetFFlagMomentsAnalyticsProducerPrereqs() then nil else SessionManager.getSessionId(FunnelEventNames.FunnelTypes.CreationFlow)

			if v25.createMoment ~= nil then
				local v93 = v42.playback.getTimeLength(false)

				v25.createMoment(store.getSelectedCapture(false), v35(false), v91, v92, v93)
			end

			fireAnalyticsEvent(EventNames.MomentsEditingFlowPublished, Cryo.Dictionary.join(makeCreationEventFields.makeStepField(EventNames.MomentsEditingFlowPublished), makeCreationEventFields.makeCreationBaseFields(v92)))
			v34(nil)
			store.clearEdits(if not t1.excludeGallery then CreationFlowState.Gallery else CreationFlowState.Preview)

			if v25.exitCreationFlow ~= nil then
				v25.exitCreationFlow()
			end
		end,
		exit = function() -- line: 428
			-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), withCreationSession (copy), makeCreationEventFields (copy), v34 (copy), store (copy), t1 (copy), CreationFlowState (copy), v25 (copy)
			fireAnalyticsEvent(EventNames.MomentsEditingFlowExited, withCreationSession(makeCreationEventFields.makeStepField(EventNames.MomentsEditingFlowExited)))
			v34(nil)
			store.clearEdits(if not t1.excludeGallery then CreationFlowState.Gallery else CreationFlowState.Preview)

			if v25.exitCreationFlow ~= nil then
				v25.exitCreationFlow()
			end
		end,
		generateText = function() -- line: 371
			-- upvalues: v36 (copy), v25 (copy), store (copy), v37 (copy), fireAnalyticsEvent (copy), EventNames (copy), withCreationSession (copy), makeDefaultTextOverlayEdit (copy)
			if v36(false) then
				return
			end

			if v25.generateMomentText == nil then
				return
			end

			local v94 = store.getSelectedCapture(false)

			if v94 == nil then
				return
			end

			v37(true)

			local v95 = v25.generateMomentText(v94)

			if v95 == nil then
				v37(false)

				return
			end

			v95:andThen(function(p11) -- line: 389
				-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), withCreationSession (copy), v25 (copy), v37 (copy), makeDefaultTextOverlayEdit (copy), store (copy)
				if p11 == nil or p11.error ~= nil then
					fireAnalyticsEvent(EventNames.EditingFlowGenerateTextFailed, withCreationSession({}))

					if v25.onGenerateTextFailure ~= nil then
						v25.onGenerateTextFailure()
					end

					v37(false)

					return
				end

				if p11.summary ~= nil and p11.summary ~= "" then
					local v97 = makeDefaultTextOverlayEdit()

					v97.text = p11.summary

					local v98 = store.getTextOverlayEdits(false)

					if v98 == nil or #v98 == 0 then
						store.updateTextOverlayEdits({ v97 })
					else
						local v99 = table.clone(v98)

						v99[1] = v97
						store.updateTextOverlayEdits(v99)
					end
				end

				if p11.description ~= nil and p11.description ~= "" then
					store.updateDescription(p11.description)
				end

				fireAnalyticsEvent(EventNames.EditingFlowGenerateTextSucceeded, withCreationSession({}))

				if v25.onGenerateTextSuccess ~= nil then
					v25.onGenerateTextSuccess()
				end

				v37(false)
			end):catch(function() -- line: 419
				-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), withCreationSession (copy), v25 (copy), v37 (copy)
				fireAnalyticsEvent(EventNames.EditingFlowGenerateTextFailed, withCreationSession({}))

				if v25.onGenerateTextFailure ~= nil then
					v25.onGenerateTextFailure()
				end

				v37(false)
			end)
		end,
		getIsGenerating = v36,
		preview = v42
	}

	return t6
end

return createCreationController
