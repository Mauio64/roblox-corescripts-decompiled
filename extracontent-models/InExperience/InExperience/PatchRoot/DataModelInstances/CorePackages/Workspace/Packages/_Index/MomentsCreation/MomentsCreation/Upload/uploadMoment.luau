local CaptureService = game:GetService("CaptureService")
local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)

require(MomentsCreationParent.MomentsTypes)

local EventNames = MomentsCommon.Analytics.EventNames
local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local makeCreationEventFields = require(MomentsCreation.Analytics.makeCreationEventFields)
local normalizeMomentMetadata = require(MomentsCreation.Utils.normalizeMomentMetadata)
local completeMomentUpload = require(MomentsCreation.Upload.completeMomentUpload)
local Logger = require(MomentsCreation.Logger)
local GetFFlagMomentsCreationNormalizeMetadataEnums = require(MomentsCreation.Flags.GetFFlagMomentsCreationNormalizeMetadataEnums)
local GetFFlagMomentsUseBackendPostStatusNotification = require(MomentsCreation.Flags.GetFFlagMomentsUseBackendPostStatusNotification)
local GetFFlagMomentsAnalyticsProducerPrereqs = MomentsCommon.Flags.GetFFlagMomentsAnalyticsProducerPrereqs
local enumName = makeCreationEventFields.enumName
local _game = game
local EngineFeature = game:GetEngineFeature("CaptureServiceUploadUniverseIdOverride")
local EngineFeature2 = game:GetEngineFeature("CaptureServiceStartUploadCoreScriptBypass")

game:DefineFastString("MomentsUploadUniverseId", "8357232245")

local function logValue(p1) -- line: 74
	-- upvalues: enumName (copy)
	local v22 = enumName(p1) or "nil"
	local v23 = string.gsub(v22, "\r", "\\r")

	return (string.gsub(v23, "\n", "\\n"))
end
local function injectUniverseIdOverride(p2) -- line: 81
	-- upvalues: _game (copy)
	local GameId = _game.GameId

	if GameId ~= nil and GameId > 0 then
		return p2
	end

	local v26 = table.clone(p2)

	v26.universeIdOverride = tonumber(game:GetFastString("MomentsUploadUniverseId"))

	return v26
end
local function uploadMoment(p3, p4, p5, t1: {[any]: any}, t2: {[any]: any}, t3: {[any]: any}, t4: {[any]: any}?, t5: {[any]: any}?, s1: string?) -- line: 91
	-- upvalues: EngineFeature (copy), _game (copy), GetFFlagMomentsCreationNormalizeMetadataEnums (copy), normalizeMomentMetadata (copy), Logger (copy), EngineFeature2 (copy), enumName (copy), GetFFlagMomentsUseBackendPostStatusNotification (copy), GetFFlagMomentsAnalyticsProducerPrereqs (copy), fireAnalyticsEvent (copy), EventNames (copy), CaptureService (copy), makeCreationEventFields (copy), completeMomentUpload (copy)
	local u37

	if EngineFeature then
		local GameId = _game.GameId

		if GameId ~= nil and GameId > 0 then
			u37 = p4
		else
			local v38 = table.clone(p4)

			v38.universeIdOverride = tonumber(game:GetFastString("MomentsUploadUniverseId"))
			u37 = v38
		end
	else
		u37 = p4
	end

	if GetFFlagMomentsCreationNormalizeMetadataEnums() then
		u37 = normalizeMomentMetadata(u37)
	end

	local v39 = Logger
	local v40 = EngineFeature2
	local v41 = enumName(v40) or "nil"
	local v42 = string.gsub(v41, "\r", "\\r")
	local v43 = string.gsub(v42, "\n", "\\n")
	local v44 = GetFFlagMomentsUseBackendPostStatusNotification()
	local v45 = enumName(v44) or "nil"
	local v46 = string.gsub(v45, "\r", "\\r")
	local v47 = string.gsub(v46, "\n", "\\n")
	local LocalId = p3.LocalId
	local v49 = enumName(LocalId) or "nil"
	local v50 = string.gsub(v49, "\r", "\\r")
	local v51 = string.gsub(v50, "\n", "\\n")
	local CaptureType = p3.CaptureType
	local v53 = enumName(CaptureType) or "nil"
	local v54 = string.gsub(v53, "\r", "\\r")
	local v55 = string.gsub(v54, "\n", "\\n")
	local SourcePlaceId = p3.SourcePlaceId
	local v57 = enumName(SourcePlaceId) or "nil"
	local v58 = string.gsub(v57, "\r", "\\r")
	local v59 = string.gsub(v58, "\n", "\\n")
	local SourceUniverseId = p3.SourceUniverseId
	local v61 = enumName(SourceUniverseId) or "nil"
	local v62 = string.gsub(v61, "\r", "\\r")

	v39:debug("event=upload_start CaptureServiceStartUploadCoreScriptBypass={} MomentsUseBackendPostStatusNotification={} localId={} captureType={} sourcePlaceId={} sourceUniverseId={}", v43, v47, v51, v55, v59, (string.gsub(v62, "\n", "\\n")))
	t2.setUploading()
	t3.triggerToast({
		title = t1.publishingTitle,
		text = t1.publishingBody
	})

	local v63 = GetFFlagMomentsAnalyticsProducerPrereqs()

	local function publishFields(t6: {[any]: any}) -- line: 136
		-- upvalues: v63 (copy), s1 (copy)
		if v63 then
			t6.creationSessionId = s1
		end

		return t6
	end
	local function fireUploadFailed(t7: {[any]: any}, b1: boolean?) -- line: 144
		-- upvalues: v63 (copy), p3 (copy), s1 (copy), fireAnalyticsEvent (copy), EventNames (copy)
		if not v63 and not b1 then
			return
		end

		if v63 then
			t7.localId = tostring(p3.LocalId)
			t7.creationSessionId = s1
		end

		fireAnalyticsEvent(EventNames.UploadCaptureFailed, t7)
	end

	task.spawn(function() -- line: 155
		-- upvalues: EngineFeature2 (copy), Logger (copy), p3 (copy), enumName (copy), CaptureService (copy), u37 (ref), p5 (copy), v63 (copy), fireAnalyticsEvent (copy), EventNames (copy), makeCreationEventFields (copy), s1 (copy), t2 (copy), t3 (copy), t1 (copy), completeMomentUpload (copy), t4 (copy), t5 (copy)
		if not EngineFeature2 then
			local v69 = Logger
			local LocalId2 = p3.LocalId
			local v71 = enumName(LocalId2) or "nil"
			local v72 = string.gsub(v71, "\r", "\\r")

			v69:debug("event=path_selected path=fallback localId={}", (string.gsub(v72, "\n", "\\n")))

			local ok, result = pcall(function() -- line: 160
				-- upvalues: CaptureService (copy), p3 (copy), u37 (ref), p5 (copy)
				CaptureService:UploadCaptureAndPostMoment(p3, u37, p5)
			end)

			if ok or not v63 then
				local v75 = fireAnalyticsEvent
				local EditingFlowMomentPublished = EventNames.EditingFlowMomentPublished
				local v77 = makeCreationEventFields.makeCaptureDescriptorFields(p3)

				if v63 then
					v77.creationSessionId = s1
				end

				v75(EditingFlowMomentPublished, v77)
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

				if v63 then
					t8.status = "GenericFailure"
				end

				local _ = v63

				if v63 then
					t8.localId = tostring(p3.LocalId)
					t8.creationSessionId = s1
				end

				fireAnalyticsEvent(EventNames.UploadCaptureFailed, t8)
			end

			return
		end

		local v80 = Logger
		local LocalId3 = p3.LocalId
		local v82 = enumName(LocalId3) or "nil"
		local v83 = string.gsub(v82, "\r", "\\r")

		v80:debug("event=path_selected path=two_phase localId={}", (string.gsub(v83, "\n", "\\n")))

		local ok, result, v86 = pcall(function() -- line: 192
			-- upvalues: CaptureService (copy), p3 (copy)
			return CaptureService:StartUploadCaptureAsync(p3)
		end)

		if ok then
			local v87 = Logger
			local LocalId4 = p3.LocalId
			local v89 = enumName(LocalId4) or "nil"
			local v90 = string.gsub(v89, "\r", "\\r")
			local v91 = string.gsub(v90, "\n", "\\n")
			local v92 = enumName(result) or "nil"
			local v93 = string.gsub(v92, "\r", "\\r")

			v87:debug("event=start_upload localId={} pcallSuccess=true status={}", v91, (string.gsub(v93, "\n", "\\n")))
		else
			local v94 = Logger
			local LocalId5 = p3.LocalId
			local v96 = enumName(LocalId5) or "nil"
			local v97 = string.gsub(v96, "\r", "\\r")

			v94:debug("event=start_upload localId={} pcallSuccess=false status=pcall_error errorClass={}", string.gsub(v97, "\n", "\\n"), (typeof(result)))
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

			if v63 then
				t9.status = "StartUploadFailed"
				t9.error = tostring(result)
			end

			local _ = v63

			if v63 then
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
			local _ = v63

			if v63 then
				t10.localId = tostring(p3.LocalId)
				t10.creationSessionId = s1
			end

			fireAnalyticsEvent(EventNames.UploadCaptureFailed, t10)

			return
		end

		local ok2, result2 = pcall(function() -- line: 251
			-- upvalues: CaptureService (copy), p3 (copy), u37 (ref), p5 (copy)
			CaptureService:UploadCaptureAndPostMoment(p3, u37, p5)
		end)
		local v104 = Logger
		local LocalId6 = p3.LocalId
		local v106 = enumName(LocalId6) or "nil"
		local v107 = string.gsub(v106, "\r", "\\r")

		v104:debug("event=registration localId={} pcallSuccess={} errorClass={}", string.gsub(v107, "\n", "\\n"), tostring(ok2), if not ok2 then typeof(result2) else "none")

		if v63 and not ok2 then
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

			if not v63 then
				return
			end

			if v63 then
				t11.localId = tostring(p3.LocalId)
				t11.creationSessionId = s1
			end

			fireAnalyticsEvent(EventNames.UploadCaptureFailed, t11)

			return
		end

		local v109 = fireAnalyticsEvent
		local EditingFlowMomentPublished = EventNames.EditingFlowMomentPublished
		local v111 = makeCreationEventFields.makeCaptureDescriptorFields(p3)

		if v63 then
			v111.creationSessionId = s1
		end

		v109(EditingFlowMomentPublished, v111)

		local v112 = false
		local v113 = nil

		for i = 1, 120 do
			task.wait(5)

			local ok3, result3, v117 = pcall(function() -- line: 290
				-- upvalues: CaptureService (copy), v86 (copy)
				return CaptureService:CheckUploadCaptureStatusAsync(v86)
			end)
			local v118 = not v112 or ok3 and result3 ~= v113
			local v119 = not ok3 or result3 ~= Enum.UploadCaptureResult.UploadPending
			local v120 = i % 6 == 0

			if ok3 then
				v112 = true
				v113 = result3
			end

			if i == 1 or v118 or v119 or v120 then
				if ok3 then
					local v121 = Logger
					local LocalId7 = p3.LocalId
					local v123 = enumName(LocalId7) or "nil"
					local v124 = string.gsub(v123, "\r", "\\r")
					local v125 = string.gsub(v124, "\n", "\\n")
					local str = tostring(i)
					local v127 = enumName(result3) or "nil"
					local v128 = string.gsub(v127, "\r", "\\r")
					local v129 = string.gsub(v128, "\n", "\\n")
					local v130 = enumName(v117) or "nil"
					local v131 = string.gsub(v130, "\r", "\\r")

					v121:debug("event=poll localId={} attempt={} pcallSuccess=true status={} assetId={} heartbeat={}", v125, str, v129, string.gsub(v131, "\n", "\\n"), (tostring(v120 and not v118)))
				else
					local v132 = Logger
					local LocalId8 = p3.LocalId
					local v134 = enumName(LocalId8) or "nil"
					local v135 = string.gsub(v134, "\r", "\\r")

					v132:debug("event=poll localId={} attempt={} pcallSuccess=false status=pcall_error errorClass={}", string.gsub(v135, "\n", "\\n"), tostring(i), (typeof(result3)))
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

				if not v63 then
					return
				end

				if v63 then
					t12.localId = tostring(p3.LocalId)
					t12.creationSessionId = s1
				end

				fireAnalyticsEvent(EventNames.UploadCaptureFailed, t12)

				return
			end

			if result3 == Enum.UploadCaptureResult.Success then
				completeMomentUpload(v117, {
					uploadStore = t2,
					toastStore = t3,
					feedStore = t4,
					myCreationsStore = t5,
					localizations = t1,
					onPostedToFeed = function() -- line: 343
						-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), v117 (copy), p3 (copy), enumName (copy), v63 (copy), s1 (copy)
						local v144 = fireAnalyticsEvent
						local EditingFlowMomentPostedToFeed = EventNames.EditingFlowMomentPostedToFeed
						local t13 = {
							assetId = tostring(v117),
							localId = tostring(p3.LocalId),
							captureType = enumName(p3.CaptureType)
						}

						if v63 then
							t13.creationSessionId = s1
						end

						v144(EditingFlowMomentPostedToFeed, t13)
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

					if not v63 then
						return
					end

					if v63 then
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

				if not v63 then
					return
				end

				if v63 then
					t15.localId = tostring(p3.LocalId)
					t15.creationSessionId = s1
				end

				fireAnalyticsEvent(EventNames.UploadCaptureFailed, t15)

				return
			end
		end

		local v139 = Logger
		local LocalId9 = p3.LocalId
		local v141 = enumName(LocalId9) or "nil"
		local v142 = string.gsub(v141, "\r", "\\r")

		v139:debug("event=poll_timeout localId={} attempts={}", string.gsub(v142, "\n", "\\n"), (tostring(120)))
		t2.setFailed("Timeout")
		t3.triggerToast({
			title = t1.failedTitle,
			text = t1.failedBody
		})

		local t16 = {
			status = "Timeout",
			captureType = enumName(p3.CaptureType)
		}

		if not v63 then
			return
		end

		if v63 then
			t16.localId = tostring(p3.LocalId)
			t16.creationSessionId = s1
		end

		fireAnalyticsEvent(EventNames.UploadCaptureFailed, t16)
	end)
end

return uploadMoment
