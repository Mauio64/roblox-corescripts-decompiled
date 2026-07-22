local CaptureService = game:GetService("CaptureService")
local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)

require(MomentsCreationParent.MomentsTypes)

local EventNames = MomentsCommon.Analytics.EventNames
local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local makeCreationEventFields = require(MomentsCreation.Analytics.makeCreationEventFields)
local completeMomentUpload = require(MomentsCreation.Upload.completeMomentUpload)
local Logger = require(MomentsCreation.Logger)
local GetFFlagMomentsUseBackendPostStatusNotification = require(MomentsCreation.Flags.GetFFlagMomentsUseBackendPostStatusNotification)
local GetFFlagMomentsAnalyticsProducerPrereqs = MomentsCommon.Flags.GetFFlagMomentsAnalyticsProducerPrereqs
local enumName = makeCreationEventFields.enumName
local _game = game
local EngineFeature = game:GetEngineFeature("CaptureServiceUploadUniverseIdOverride")
local EngineFeature2 = game:GetEngineFeature("CaptureServiceStartUploadCoreScriptBypass")

game:DefineFastString("MomentsUploadUniverseId", "8357232245")

local function logValue(p1) -- line: 71
	-- upvalues: enumName (copy)
	local v20 = enumName(p1) or "nil"
	local v21 = string.gsub(v20, "\r", "\\r")

	return (string.gsub(v21, "\n", "\\n"))
end
local function injectUniverseIdOverride(p2) -- line: 78
	-- upvalues: _game (copy)
	local GameId = _game.GameId

	if GameId ~= nil and GameId > 0 then
		return p2
	end

	local v24 = table.clone(p2)

	v24.universeIdOverride = tonumber(game:GetFastString("MomentsUploadUniverseId"))

	return v24
end
local function uploadMoment(p3, p4, p5, t1: {[any]: any}, t2: {[any]: any}, t3: {[any]: any}, t4: {[any]: any}?, t5: {[any]: any}?, s1: string?) -- line: 88
	-- upvalues: EngineFeature (copy), _game (copy), Logger (copy), EngineFeature2 (copy), enumName (copy), GetFFlagMomentsUseBackendPostStatusNotification (copy), GetFFlagMomentsAnalyticsProducerPrereqs (copy), fireAnalyticsEvent (copy), EventNames (copy), CaptureService (copy), makeCreationEventFields (copy), completeMomentUpload (copy)
	if EngineFeature then
		local GameId = _game.GameId

		if GameId ~= nil and GameId > 0 then
		else
			p4 = table.clone(p4)
			p4.universeIdOverride = tonumber(game:GetFastString("MomentsUploadUniverseId"))
		end
	end

	local v35 = p4
	local v36 = Logger
	local v37 = EngineFeature2
	local v38 = enumName(v37) or "nil"
	local v39 = string.gsub(v38, "\r", "\\r")
	local v40 = string.gsub(v39, "\n", "\\n")
	local v41 = GetFFlagMomentsUseBackendPostStatusNotification()
	local v42 = enumName(v41) or "nil"
	local v43 = string.gsub(v42, "\r", "\\r")
	local v44 = string.gsub(v43, "\n", "\\n")
	local LocalId = p3.LocalId
	local v46 = enumName(LocalId) or "nil"
	local v47 = string.gsub(v46, "\r", "\\r")
	local v48 = string.gsub(v47, "\n", "\\n")
	local CaptureType = p3.CaptureType
	local v50 = enumName(CaptureType) or "nil"
	local v51 = string.gsub(v50, "\r", "\\r")
	local v52 = string.gsub(v51, "\n", "\\n")
	local SourcePlaceId = p3.SourcePlaceId
	local v54 = enumName(SourcePlaceId) or "nil"
	local v55 = string.gsub(v54, "\r", "\\r")
	local v56 = string.gsub(v55, "\n", "\\n")
	local SourceUniverseId = p3.SourceUniverseId
	local v58 = enumName(SourceUniverseId) or "nil"
	local v59 = string.gsub(v58, "\r", "\\r")

	v36:debug("event=upload_start CaptureServiceStartUploadCoreScriptBypass={} MomentsUseBackendPostStatusNotification={} localId={} captureType={} sourcePlaceId={} sourceUniverseId={}", v40, v44, v48, v52, v56, (string.gsub(v59, "\n", "\\n")))
	t2.setUploading()
	t3.triggerToast({
		title = t1.publishingTitle,
		text = t1.publishingBody
	})

	local v60 = GetFFlagMomentsAnalyticsProducerPrereqs()

	local function publishFields(t6: {[any]: any}) -- line: 130
		-- upvalues: v60 (copy), s1 (copy)
		if v60 then
			t6.creationSessionId = s1
		end

		return t6
	end
	local function fireUploadFailed(t7: {[any]: any}, b1: boolean?) -- line: 138
		-- upvalues: v60 (copy), p3 (copy), s1 (copy), fireAnalyticsEvent (copy), EventNames (copy)
		if not v60 and not b1 then
			return
		end

		if v60 then
			t7.localId = tostring(p3.LocalId)
			t7.creationSessionId = s1
		end

		fireAnalyticsEvent(EventNames.UploadCaptureFailed, t7)
	end

	task.spawn(function() -- line: 149
		-- upvalues: EngineFeature2 (copy), Logger (copy), p3 (copy), enumName (copy), CaptureService (copy), v35 (copy), p5 (copy), v60 (copy), fireAnalyticsEvent (copy), EventNames (copy), makeCreationEventFields (copy), s1 (copy), t2 (copy), t3 (copy), t1 (copy), completeMomentUpload (copy), t4 (copy), t5 (copy)
		if not EngineFeature2 then
			local v66 = Logger
			local LocalId2 = p3.LocalId
			local v68 = enumName(LocalId2) or "nil"
			local v69 = string.gsub(v68, "\r", "\\r")

			v66:debug("event=path_selected path=fallback localId={}", (string.gsub(v69, "\n", "\\n")))

			local ok, result = pcall(function() -- line: 154
				-- upvalues: CaptureService (copy), p3 (copy), v35 (copy), p5 (copy)
				CaptureService:UploadCaptureAndPostMoment(p3, v35, p5)
			end)

			if ok or not v60 then
				local v72 = fireAnalyticsEvent
				local EditingFlowMomentPublished = EventNames.EditingFlowMomentPublished
				local v74 = makeCreationEventFields.makeCaptureDescriptorFields(p3)

				if v60 then
					v74.creationSessionId = s1
				end

				v72(EditingFlowMomentPublished, v74)
			end

			if not ok then
				t2.setFailed("GenericFailure")
				t3.triggerToast({
					title = t1.failedTitle,
					text = t1.failedBody
				})

				local t8 = {
					error = tostring(result),
					captureType = enumName(p3.CaptureType)
				}

				if v60 then
					t8.status = "GenericFailure"
				end

				local _ = v60

				if v60 then
					t8.localId = tostring(p3.LocalId)
					t8.creationSessionId = s1
				end

				fireAnalyticsEvent(EventNames.UploadCaptureFailed, t8)
			end

			return
		end

		local v77 = Logger
		local LocalId3 = p3.LocalId
		local v79 = enumName(LocalId3) or "nil"
		local v80 = string.gsub(v79, "\r", "\\r")

		v77:debug("event=path_selected path=two_phase localId={}", (string.gsub(v80, "\n", "\\n")))

		local ok, result, v83 = pcall(function() -- line: 186
			-- upvalues: CaptureService (copy), p3 (copy)
			return CaptureService:StartUploadCaptureAsync(p3)
		end)

		if ok then
			local v84 = Logger
			local LocalId4 = p3.LocalId
			local v86 = enumName(LocalId4) or "nil"
			local v87 = string.gsub(v86, "\r", "\\r")
			local v88 = string.gsub(v87, "\n", "\\n")
			local v89 = enumName(result) or "nil"
			local v90 = string.gsub(v89, "\r", "\\r")

			v84:debug("event=start_upload localId={} pcallSuccess=true status={}", v88, (string.gsub(v90, "\n", "\\n")))
		else
			local v91 = Logger
			local LocalId5 = p3.LocalId
			local v93 = enumName(LocalId5) or "nil"
			local v94 = string.gsub(v93, "\r", "\\r")

			v91:debug("event=start_upload localId={} pcallSuccess=false status=pcall_error errorClass={}", string.gsub(v94, "\n", "\\n"), (typeof(result)))
		end

		if not ok then
			t2.setFailed("StartUploadFailed")
			t3.triggerToast({
				title = t1.failedTitle,
				text = t1.failedBody
			})

			local t9 = {
				status = enumName(result),
				captureType = enumName(p3.CaptureType)
			}

			if v60 then
				t9.status = "StartUploadFailed"
				t9.error = tostring(result)
			end

			local _ = v60

			if v60 then
				t9.localId = tostring(p3.LocalId)
				t9.creationSessionId = s1
			end

			fireAnalyticsEvent(EventNames.UploadCaptureFailed, t9)

			return
		end

		if result ~= Enum.UploadCaptureResult.Success then
			if result == Enum.UploadCaptureResult.CaptureModerated then
				t3.triggerToast({
					title = t1.removedTitle,
					text = t1.removedBody
				})
			elseif result == Enum.UploadCaptureResult.UploadQuotaReached then
				t3.triggerToast({
					title = t1.failedTitle,
					text = t1.uploadQuotaReachedBody
				})
			else
				t3.triggerToast({
					title = t1.failedTitle,
					text = t1.failedBody
				})
			end

			t2.setFailed((tostring(result)))

			local t10 = {
				status = enumName(result),
				captureType = enumName(p3.CaptureType)
			}
			local _ = v60

			if v60 then
				t10.localId = tostring(p3.LocalId)
				t10.creationSessionId = s1
			end

			fireAnalyticsEvent(EventNames.UploadCaptureFailed, t10)

			return
		end

		local ok2, result2 = pcall(function() -- line: 245
			-- upvalues: CaptureService (copy), p3 (copy), v35 (copy), p5 (copy)
			CaptureService:UploadCaptureAndPostMoment(p3, v35, p5)
		end)
		local v101 = Logger
		local LocalId6 = p3.LocalId
		local v103 = enumName(LocalId6) or "nil"
		local v104 = string.gsub(v103, "\r", "\\r")

		v101:debug("event=registration localId={} pcallSuccess={} errorClass={}", string.gsub(v104, "\n", "\\n"), tostring(ok2), if not ok2 then typeof(result2) else "none")

		if v60 and not ok2 then
			t2.setFailed("RegistrationFailed")
			t3.triggerToast({
				title = t1.failedTitle,
				text = t1.failedBody
			})

			local t11 = {
				status = "RegistrationFailed",
				error = tostring(result2),
				captureType = enumName(p3.CaptureType)
			}

			if not v60 then
				return
			end

			if v60 then
				t11.localId = tostring(p3.LocalId)
				t11.creationSessionId = s1
			end

			fireAnalyticsEvent(EventNames.UploadCaptureFailed, t11)

			return
		end

		local v106 = fireAnalyticsEvent
		local EditingFlowMomentPublished = EventNames.EditingFlowMomentPublished
		local v108 = makeCreationEventFields.makeCaptureDescriptorFields(p3)

		if v60 then
			v108.creationSessionId = s1
		end

		v106(EditingFlowMomentPublished, v108)

		local v109 = false
		local v110 = nil

		for i = 1, 120 do
			task.wait(5)

			local ok3, result3, v114 = pcall(function() -- line: 284
				-- upvalues: CaptureService (copy), v83 (copy)
				return CaptureService:CheckUploadCaptureStatusAsync(v83)
			end)
			local v115 = not v109 or ok3 and result3 ~= v110
			local v116 = not ok3 or result3 ~= Enum.UploadCaptureResult.UploadPending
			local v117 = i % 6 == 0

			if ok3 then
				v109 = true
				v110 = result3
			end

			if i == 1 or v115 or v116 or v117 then
				if ok3 then
					local v118 = Logger
					local LocalId7 = p3.LocalId
					local v120 = enumName(LocalId7) or "nil"
					local v121 = string.gsub(v120, "\r", "\\r")
					local v122 = string.gsub(v121, "\n", "\\n")
					local str = tostring(i)
					local v124 = enumName(result3) or "nil"
					local v125 = string.gsub(v124, "\r", "\\r")
					local v126 = string.gsub(v125, "\n", "\\n")
					local v127 = enumName(v114) or "nil"
					local v128 = string.gsub(v127, "\r", "\\r")

					v118:debug("event=poll localId={} attempt={} pcallSuccess=true status={} assetId={} heartbeat={}", v122, str, v126, string.gsub(v128, "\n", "\\n"), (tostring(v117 and not v115)))
				else
					local v129 = Logger
					local LocalId8 = p3.LocalId
					local v131 = enumName(LocalId8) or "nil"
					local v132 = string.gsub(v131, "\r", "\\r")

					v129:debug("event=poll localId={} attempt={} pcallSuccess=false status=pcall_error errorClass={}", string.gsub(v132, "\n", "\\n"), tostring(i), (typeof(result3)))
				end
			end

			if not ok3 then
				t2.setFailed("PollError")
				t3.triggerToast({
					title = t1.failedTitle,
					text = t1.failedBody
				})

				local t12 = {
					status = "PollError",
					error = tostring(result3),
					captureType = enumName(p3.CaptureType)
				}

				if not v60 then
					return
				end

				if v60 then
					t12.localId = tostring(p3.LocalId)
					t12.creationSessionId = s1
				end

				fireAnalyticsEvent(EventNames.UploadCaptureFailed, t12)

				return
			end

			if result3 == Enum.UploadCaptureResult.Success then
				completeMomentUpload(v114, {
					uploadStore = t2,
					toastStore = t3,
					feedStore = t4,
					myCreationsStore = t5,
					localizations = t1,
					onPostedToFeed = function() -- line: 337
						-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), v114 (copy), p3 (copy), enumName (copy), v60 (copy), s1 (copy)
						local v141 = fireAnalyticsEvent
						local EditingFlowMomentPostedToFeed = EventNames.EditingFlowMomentPostedToFeed
						local t13 = {
							assetId = tostring(v114),
							localId = tostring(p3.LocalId),
							captureType = enumName(p3.CaptureType)
						}

						if v60 then
							t13.creationSessionId = s1
						end

						v141(EditingFlowMomentPostedToFeed, t13)
					end
				})

				return
			end

			if result3 ~= Enum.UploadCaptureResult.UploadPending then
				if result3 == Enum.UploadCaptureResult.CaptureModerated then
					t2.setFailed("Moderated")
					t3.triggerToast({
						title = t1.removedTitle,
						text = t1.removedBody
					})

					local t14 = {
						status = enumName(result3),
						captureType = enumName(p3.CaptureType)
					}

					if not v60 then
						return
					end

					if v60 then
						t14.localId = tostring(p3.LocalId)
						t14.creationSessionId = s1
					end

					fireAnalyticsEvent(EventNames.UploadCaptureFailed, t14)

					return
				end

				t2.setFailed((tostring(result3)))
				t3.triggerToast({
					title = t1.failedTitle,
					text = t1.failedBody
				})

				local t15 = {
					status = enumName(result3),
					captureType = enumName(p3.CaptureType)
				}

				if not v60 then
					return
				end

				if v60 then
					t15.localId = tostring(p3.LocalId)
					t15.creationSessionId = s1
				end

				fireAnalyticsEvent(EventNames.UploadCaptureFailed, t15)

				return
			end
		end

		local v136 = Logger
		local LocalId9 = p3.LocalId
		local v138 = enumName(LocalId9) or "nil"
		local v139 = string.gsub(v138, "\r", "\\r")

		v136:debug("event=poll_timeout localId={} attempts={}", string.gsub(v139, "\n", "\\n"), (tostring(120)))
		t2.setFailed("Timeout")
		t3.triggerToast({
			title = t1.failedTitle,
			text = t1.failedBody
		})

		local t16 = {
			status = "Timeout",
			captureType = enumName(p3.CaptureType)
		}

		if not v60 then
			return
		end

		if v60 then
			t16.localId = tostring(p3.LocalId)
			t16.creationSessionId = s1
		end

		fireAnalyticsEvent(EventNames.UploadCaptureFailed, t16)
	end)
end

return uploadMoment
