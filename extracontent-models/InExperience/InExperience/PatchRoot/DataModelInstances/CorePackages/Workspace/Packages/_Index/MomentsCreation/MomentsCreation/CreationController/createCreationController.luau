local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
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
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)
local EventNames = MomentsCommon.Analytics.EventNames
local SessionManager = MomentsCommon.Analytics.SessionManager
local FunnelEventNames = MomentsCommon.Analytics.FunnelEventNames
local GetFFlagMomentsAnalyticsProducerPrereqs = MomentsCommon.Flags.GetFFlagMomentsAnalyticsProducerPrereqs
local createComputed = Signals.createComputed
local createSignal = Signals.createSignal

local function createCreationController(t1: {[any]: any}) -- line: 56
	-- upvalues: creationToolRegistry (copy), defaultCreationTools (copy), createSignal (copy), createComputed (copy), createCapturePreviewController (copy), CreationFlowState (copy), fireAnalyticsEvent (copy), EventNames (copy), createEditSession (copy), DialogType (copy), GetFFlagMomentsAnalyticsProducerPrereqs (copy), SessionManager (copy), FunnelEventNames (copy)
	local store = t1.store
	local v21 = t1.host or {}
	local v22 = t1.registry or creationToolRegistry(defaultCreationTools)
	local t5 = nil
	local v24, v25 = createSignal(nil)

	local function setActiveSession(p1) -- line: 65
		-- upvalues: v25 (copy)
		v25(p1)
	end

	local v27, v28 = createSignal(nil)
	local v29 = createComputed(function(p2) -- line: 73
		-- upvalues: store (copy), v22 (copy)
		local t2 = {}

		for v40, v41 in (store.getEditsMap(p2)) do
			if v41 ~= nil then
				local v42 = v22.get(v40)

				if v42 ~= nil and v42.toEdits ~= nil then
					for v43, v44 in v42.toEdits(v41) do
						t2[v43] = v44
					end
				else
					t2[v40] = v41
				end
			end
		end

		return t2
	end)
	local v30 = createComputed(function(p3) -- line: 92
		-- upvalues: store (copy), v29 (copy), v22 (copy)
		local v46 = store.getSelectedCapture(p3)
		local v47 = if v46 == nil then nil else v46.CaptureType
		local t3 = {
			captureType = v47,
			getComposedEdits = v29
		}
		local t4 = {}

		for _, v51 in v22.getAll() do
			if (v51.supportedCaptureTypes == nil or v47 ~= nil and table.find(v51.supportedCaptureTypes, v47) ~= nil) and (v51.isAvailable == nil or v51.isAvailable(t3)) then
				table.insert(t4, v51)
			end
		end

		return t4
	end)
	local v31 = createComputed(function(p4) -- line: 113
		-- upvalues: store (copy), v22 (copy)
		local v53 = store.getStep(p4)

		for _, v55 in v22.getAll() do
			if v53 == v55.step then
				return v55
			end
		end

		return nil
	end)
	local v32 = createComputed(function(p5) -- line: 127
		-- upvalues: v31 (copy), v24 (copy), v29 (copy)
		local v57 = v31(p5)

		if v57 ~= nil and v57.kind == "trim" then
			local v58 = v24(p5)
			local v59 = if v58 == nil then nil else v58.getDraft(p5)

			if v59 ~= nil and v59.startTime ~= nil and v59.endTime ~= nil then
				return {
					startTime = v59.startTime,
					endTime = v59.endTime
				}
			end
		end

		local trim = v29(p5).trim

		if trim ~= nil and trim.startTime ~= nil and trim.endTime ~= nil then
			return {
				startTime = trim.startTime,
				endTime = trim.endTime
			}
		end

		return nil
	end)
	local v33 = createComputed(function(p6) -- line: 146
		-- upvalues: v31 (copy), v24 (copy), v29 (copy)
		local v62 = v31(p6)

		if v62 ~= nil and v62.kind == "music" then
			local v63 = v24(p6)
			local v64 = if v63 == nil then nil else v63.getDraft(p6)

			if v64 ~= nil and v64.assetId ~= nil then
				return v64
			end
		end

		return v29(p6).music
	end)
	local v34 = t1.preview or createCapturePreviewController(store, v32, v33)

	local function dismissModal() -- line: 164
		-- upvalues: v28 (copy)
		v28(nil)
	end
	local function dismiss() -- line: 261
		-- upvalues: v28 (copy), store (copy), t1 (copy), CreationFlowState (copy), v21 (copy)
		v28(nil)
		store.clearEdits(if not t1.excludeGallery then CreationFlowState.Gallery else CreationFlowState.Preview)

		if v21.exitCreationFlow ~= nil then
			v21.exitCreationFlow()
		end
	end

	t5 = {
		getStep = store.getStep,
		navigate = function(p7) -- line: 168
			-- upvalues: store (copy)
			store.navigate(p7)
		end,
		returnToGallery = function() -- line: 173
			-- upvalues: store (copy), CreationFlowState (copy), v25 (copy)
			store.clearEdits(CreationFlowState.Gallery)
			v25(nil)
		end,
		getSelectedCapture = store.getSelectedCapture,
		selectCapture = function(p8) -- line: 178
			-- upvalues: store (copy), fireAnalyticsEvent (copy), EventNames (copy)
			store.onSelectedCaptureUpdated(p8)

			if p8 ~= nil then
				fireAnalyticsEvent(EventNames.EditingFlowGalleryItemSelected)
			end
		end,
		getDescription = store.getDescription,
		setDescription = function(s1: string) -- line: 185
			-- upvalues: store (copy)
			store.updateDescription(s1)
		end,
		getAvailableTools = v30,
		getActiveTool = v31,
		getActiveSession = v24,
		getComposedEdits = v29,
		beginTool = function(s2: string) -- line: 189
			-- upvalues: v22 (copy), fireAnalyticsEvent (copy), t5 (ref), createEditSession (copy), store (copy), v25 (copy)
			local v70 = v22.get(s2)

			if v70 == nil then
				return
			end

			if v70.cta.analyticsEvent ~= nil then
				fireAnalyticsEvent(v70.cta.analyticsEvent)
			end

			if v70.presentation == "InstantAction" then
				if v70.apply ~= nil then
					v70.apply(t5)
				end

				return
			end

			local createSession = v70.createSession
			local v72 = if createSession == nil then createEditSession() else createSession()

			if v70.step ~= nil and not store.navigate(v70.step) then
				return
			end

			v72.begin(store.getEditsMap(false)[s2])
			v25(v72)
		end,
		commitActiveTool = function() -- line: 222
			-- upvalues: v24 (copy), v31 (copy), store (copy), CreationFlowState (copy), t5 (ref), fireAnalyticsEvent (copy), v25 (copy)
			local v73 = v24(false)
			local v74 = v31(false)

			if v73 == nil or v74 == nil then
				store.navigate(CreationFlowState.Preview)

				return
			end

			local v75 = v73.commit()

			if v74.onCommit ~= nil and v74.onCommit(v75, t5) == false then
				return
			end

			store.setCommittedEdit(v74.kind, v75)

			if v74.cta.commitAnalyticsEvent ~= nil then
				fireAnalyticsEvent(v74.cta.commitAnalyticsEvent)
			end

			v25(nil)
			store.navigate(CreationFlowState.Preview)
		end,
		discardActiveTool = function() -- line: 242
			-- upvalues: v24 (copy), v31 (copy), fireAnalyticsEvent (copy), v25 (copy), store (copy), CreationFlowState (copy)
			local v76 = v24(false)
			local v77 = v31(false)

			if v76 ~= nil then
				v76.discard()
			end

			if v77 ~= nil and v77.cta.cancelAnalyticsEvent ~= nil then
				fireAnalyticsEvent(v77.cta.cancelAnalyticsEvent)
			end

			v25(nil)
			store.navigate(CreationFlowState.Preview)
		end,
		updateCommittedEdit = function(s3: string, p9) -- line: 257
			-- upvalues: store (copy)
			store.setCommittedEdit(s3, p9)
		end,
		getActiveModal = v27,
		showModal = function(p10) -- line: 160
			-- upvalues: v28 (copy)
			v28(p10)
		end,
		dismissModal = dismissModal,
		publish = function() -- line: 269
			-- upvalues: store (copy), v21 (copy), v28 (copy), DialogType (copy), dismissModal (copy), GetFFlagMomentsAnalyticsProducerPrereqs (copy), SessionManager (copy), FunnelEventNames (copy), v29 (copy), fireAnalyticsEvent (copy), EventNames (copy), t1 (copy), CreationFlowState (copy)
			local v80 = store.getDescription(false)

			if v21.isTextFiltered ~= nil and v21.isTextFiltered(v80) then
				v28({
					modalType = DialogType.TextFiltered,
					modalProps = {
						onConfirm = dismissModal
					}
				})

				return
			end

			local v81 = if not GetFFlagMomentsAnalyticsProducerPrereqs() then nil else SessionManager.getSessionId(FunnelEventNames.FunnelTypes.CreationFlow)

			if v21.createMoment ~= nil then
				v21.createMoment(store.getSelectedCapture(false), v29(false), v80, v81)
			end

			fireAnalyticsEvent(EventNames.MomentsEditingFlowPublished)
			v28(nil)
			store.clearEdits(if not t1.excludeGallery then CreationFlowState.Gallery else CreationFlowState.Preview)

			if v21.exitCreationFlow ~= nil then
				v21.exitCreationFlow()
			end
		end,
		exit = function() -- line: 292
			-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), v28 (copy), store (copy), t1 (copy), CreationFlowState (copy), v21 (copy)
			fireAnalyticsEvent(EventNames.MomentsEditingFlowExited)
			v28(nil)
			store.clearEdits(if not t1.excludeGallery then CreationFlowState.Gallery else CreationFlowState.Preview)

			if v21.exitCreationFlow ~= nil then
				v21.exitCreationFlow()
			end
		end,
		preview = v34
	}

	return t5
end

return createCreationController
