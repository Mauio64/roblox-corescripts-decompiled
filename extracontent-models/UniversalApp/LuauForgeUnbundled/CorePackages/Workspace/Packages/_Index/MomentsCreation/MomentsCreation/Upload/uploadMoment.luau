local CaptureService = game:GetService("CaptureService")

local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsTypes")

local eventNames = MomentsCommon.Analytics.EventNames
local fireAnalyticsEvent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/fireAnalyticsEvent")
local makeCreationEventFields = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/makeCreationEventFields")
local normalizeMomentMetadata = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/normalizeMomentMetadata")
local completeMomentUpload = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Upload/completeMomentUpload")
local Logger = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Logger")
local fFlagMomentsTextOverlayV2Redesign = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon").Flags.FFlagMomentsTextOverlayV2Redesign
local getFFlagMomentsUseUploadPostAsync = MomentsCommon.Flags.GetFFlagMomentsUseUploadPostAsync
local defineFastFlag = game:DefineFastFlag("MomentsPostUploadFailureReasons", false)
local getFFlagMomentsUseMomentsServiceForUpload = MomentsCommon.Flags.GetFFlagMomentsUseMomentsServiceForUpload
local makePostMetadata = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/makePostMetadata")
local FFlagMomentsCreationSessionId = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsCreationSessionId")

local enumName = makeCreationEventFields.enumName

local game2 = game

local engineFeature = game:GetEngineFeature("CaptureServiceUploadUniverseIdOverride")

local engineFeature2 = game:GetEngineFeature("CaptureServiceStartUploadCoreScriptBypass")

game:DefineFastString("MomentsUploadUniverseId", "8357232245")
game:DefineFastInt("MomentsUploadPollIntervalSeconds", 5)
game:DefineFastInt("MomentsUploadMaxPollAttempts", 120)

local function logValue(p2)
	local v5 = enumName(p2) or "nil"
	local v6 = string.gsub(v5, "\r", "\\r")
	return (string.gsub(v6, "\n", "\\n"))
end

local function injectUniverseIdOverride(p2)
	local gameId = game2.GameId

	if gameId ~= nil and gameId > 0 then
		return p2
	end

	local clone = table.clone(p2)
	clone.universeIdOverride = tonumber(game:GetFastString("MomentsUploadUniverseId"))
	return clone
end

local function uploadMoment(data, p2, p3, data2, p4, p5, p6, p7, creationSessionId, p8, p9)
	local v5 = p8 or CaptureService

	if engineFeature then
		local gameId = game2.GameId

		if gameId == nil or not (gameId > 0) then
			p2 = table.clone(p2)
			p2.universeIdOverride = tonumber(game:GetFastString("MomentsUploadUniverseId"))
		end
	end

	local v6 = normalizeMomentMetadata(p2)
	local v8 = enumName(engineFeature2) or "nil"
	local v9 = string.gsub(v8, "\r", "\\r")
	local v10 = string.gsub(v9, "\n", "\\n")
	local v11 = enumName(true) or "nil"
	local v12 = string.gsub(v11, "\r", "\\r")
	local v13 = string.gsub(v12, "\n", "\\n")
	local v14 = enumName(data.LocalId) or "nil"
	local v15 = string.gsub(v14, "\r", "\\r")
	local v16 = string.gsub(v15, "\n", "\\n")
	local v17 = enumName(data.CaptureType) or "nil"
	local v18 = string.gsub(v17, "\r", "\\r")
	local v19 = string.gsub(v18, "\n", "\\n")
	local v20 = enumName(data.SourcePlaceId) or "nil"
	local v21 = string.gsub(v20, "\r", "\\r")
	local v22 = string.gsub(v21, "\n", "\\n")
	local v23 = enumName(data.SourceUniverseId) or "nil"
	local v24 = string.gsub(v23, "\r", "\\r")
	Logger:debug(
		"event=upload_start CaptureServiceStartUploadCoreScriptBypass={} MomentsUseBackendPostStatusNotification={} localId={} captureType={} sourcePlaceId={} sourceUniverseId={}",
		v10,
		v13,
		v16,
		v19,
		v22,
		(string.gsub(v24, "\n", "\\n"))
	)

	p4.setUploading()

	p5.triggerToast({ title = data2.publishingTitle, text = data2.publishingBody })

	local function publishFields(p10)
		p10.creationSessionId = creationSessionId
		return p10
	end

	local function fireUploadFailed(p10, p11)
		MomentsCommon.Analytics.reportMomentsCreationStep("upload", "failed", p11)
		p10.localId = tostring(data.LocalId)
		p10.creationSessionId = creationSessionId
		fireAnalyticsEvent(eventNames.UploadCaptureFailed, p10)
	end

	task.spawn(function()
		if getFFlagMomentsUseUploadPostAsync() then
			local v26 = enumName(data.LocalId) or "nil"
			local v27 = string.gsub(v26, "\r", "\\r")
			Logger:debug(
				"event=path_selected path=post_upload localId={}",
				(string.gsub(v27, "\n", "\\n"))
			)
			local v29 = if fFlagMomentsTextOverlayV2Redesign then p2 else v6
			local v30 = if getFFlagMomentsUseMomentsServiceForUpload() then data else nil
			local v31 = makePostMetadata(v29, v30, creationSessionId)

			local editingFlowMomentPublished = eventNames.EditingFlowMomentPublished
			local captureDescriptorFields = makeCreationEventFields.makeCaptureDescriptorFields(data)
			captureDescriptorFields.creationSessionId = creationSessionId

			fireAnalyticsEvent(editingFlowMomentPublished, captureDescriptorFields)

			local success, result = pcall(function()
				if getFFlagMomentsUseMomentsServiceForUpload() then
					return (p9 or game:GetService("MomentsService")):CreatePostAsync(v31)
				end

				return v5:UploadPostAsync(data, v31)
			end)

			if success then
				local v34 = enumName(data.LocalId) or "nil"
				local v35 = string.gsub(v34, "\r", "\\r")
				local v36 = string.gsub(v35, "\n", "\\n")
				local v37 = enumName(result.assetId) or "nil"
				local v38 = string.gsub(v37, "\r", "\\r")
				Logger:debug(
					"event=post_upload_success localId={} assetId={}",
					v36,
					(string.gsub(v38, "\n", "\\n"))
				)

				completeMomentUpload(result.assetId, {
					uploadStore = p4,
					toastStore = p5,
					feedStore = p6,
					myCreationsStore = p7,
					localizations = data2,
					onPostedToFeed = function()
						local v39 = {
							assetId = tostring(result.assetId),
							localId = tostring(data.LocalId),
							captureType = enumName(data.CaptureType)
						}

						if FFlagMomentsCreationSessionId and result.operationId ~= nil and result.operationId ~= "" then
							v39.correlationId = result.operationId
						end

						local editingFlowMomentPostedToFeed = eventNames.EditingFlowMomentPostedToFeed
						v39.creationSessionId = creationSessionId

						fireAnalyticsEvent(editingFlowMomentPostedToFeed, v39)
					end
				})
			else
				local v34 = enumName(data.LocalId) or "nil"
				local v35 = string.gsub(v34, "\r", "\\r")
				local v36 = string.gsub(v35, "\n", "\\n")
				local v37 = enumName(result) or "nil"
				local v38 = string.gsub(v37, "\r", "\\r")
				Logger:debug(
					"event=post_upload_failed localId={} error={}",
					v36,
					(string.gsub(v38, "\n", "\\n"))
				)

				p4.setFailed("GenericFailure")
				p5.triggerToast({ title = data2.failedTitle, text = data2.failedBody })

				local v39 = {
					status = "GenericFailure",
					error = tostring(result),
					captureType = enumName(data.CaptureType)
				}

				local v40 = not defineFastFlag and "GenericFailure" or require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Upload/classifyPostUploadError")(result)
				MomentsCommon.Analytics.reportMomentsCreationStep("upload", "failed", v40)
				v39.localId = tostring(data.LocalId)
				v39.creationSessionId = creationSessionId
				fireAnalyticsEvent(eventNames.UploadCaptureFailed, v39)
			end
		elseif engineFeature2 then
			local v26 = enumName(data.LocalId) or "nil"
			local v27 = string.gsub(v26, "\r", "\\r")
			Logger:debug("event=path_selected path=two_phase localId={}", (string.gsub(v27, "\n", "\\n")))

			local success, result, v28 = pcall(function()
				return v5:StartUploadCaptureAsync(data)
			end)

			if success then
				local v30 = enumName(data.LocalId) or "nil"
				local v31 = string.gsub(v30, "\r", "\\r")
				local v32 = string.gsub(v31, "\n", "\\n")
				local v33 = enumName(result) or "nil"
				local v34 = string.gsub(v33, "\r", "\\r")
				Logger:debug(
					"event=start_upload localId={} pcallSuccess=true status={}",
					v32,
					(string.gsub(v34, "\n", "\\n"))
				)
			else
				local v30 = enumName(data.LocalId) or "nil"
				local v31 = string.gsub(v30, "\r", "\\r")
				Logger:debug(
					"event=start_upload localId={} pcallSuccess=false status=pcall_error errorClass={}",
					string.gsub(v31, "\n", "\\n"),
					(typeof(result))
				)
			end

			if success then
				if result == Enum.UploadCaptureResult.Success then
					local success2, result2 = pcall(function()
						v5:UploadCaptureAndPostMoment(data, v6, p3)
					end)
					local v30 = enumName(data.LocalId) or "nil"
					local v31 = string.gsub(v30, "\r", "\\r")
					Logger:debug(
						"event=registration localId={} pcallSuccess={} errorClass={}",
						string.gsub(v31, "\n", "\\n"),
						tostring(success2),
						success2 and "none" or typeof(result2)
					)

					if success2 then
						local editingFlowMomentPublished = eventNames.EditingFlowMomentPublished
						local captureDescriptorFields = makeCreationEventFields.makeCaptureDescriptorFields(data)
						captureDescriptorFields.creationSessionId = creationSessionId

						fireAnalyticsEvent(editingFlowMomentPublished, captureDescriptorFields)

						local fastInt = game:GetFastInt("MomentsUploadPollIntervalSeconds")
						local fastInt2 = game:GetFastInt("MomentsUploadMaxPollAttempts")
						local v33 = false
						local v34 = nil

						for i = 1, fastInt2 do
							task.wait(fastInt)

							local success3, result3, v35 = pcall(function()
								return v5:CheckUploadCaptureStatusAsync(v28)
							end)
							local v36 = not v33 or success3 and result3 ~= v34
							local v37 = not success3 or result3 ~= Enum.UploadCaptureResult.UploadPending
							local v38 = i % 6 == 0

							if success3 then
								v34 = result3
								v33 = true
							end

							if i == 1 or v36 or v37 or v38 then
								if success3 then
									local v40 = enumName(data.LocalId) or "nil"
									local v41 = string.gsub(v40, "\r", "\\r")
									local v42 = string.gsub(v41, "\n", "\\n")

									local v43 = tostring(i)
									local v44 = enumName(result3) or "nil"
									local v45 = string.gsub(v44, "\r", "\\r")
									local v46 = string.gsub(v45, "\n", "\\n")
									local v47 = enumName(v35) or "nil"
									local v48 = string.gsub(v47, "\r", "\\r")
									Logger:debug(
										"event=poll localId={} attempt={} pcallSuccess=true status={} assetId={} heartbeat={}",
										v42,
										v43,
										v46,
										string.gsub(v48, "\n", "\\n"),
										(tostring(v38 and not v36))
									)
								else
									local v40 = enumName(data.LocalId) or "nil"
									local v41 = string.gsub(v40, "\r", "\\r")
									Logger:debug(
										"event=poll localId={} attempt={} pcallSuccess=false status=pcall_error errorClass={}",
										string.gsub(v41, "\n", "\\n"),
										tostring(i),
										(typeof(result3))
									)
								end
							end

							if success3 then
								if result3 == Enum.UploadCaptureResult.Success then
									completeMomentUpload(v35, {
										uploadStore = p4,
										toastStore = p5,
										feedStore = p6,
										myCreationsStore = p7,
										localizations = data2,
										onPostedToFeed = function()
											local editingFlowMomentPostedToFeed = eventNames.EditingFlowMomentPostedToFeed
											local v40 = {
												assetId = tostring(v35),
												localId = tostring(data.LocalId),
												captureType = enumName(data.CaptureType)
											}
											v40.creationSessionId = creationSessionId

											fireAnalyticsEvent(editingFlowMomentPostedToFeed, v40)
										end
									})

									return
								end

								if result3 ~= Enum.UploadCaptureResult.UploadPending then
									if result3 == Enum.UploadCaptureResult.CaptureModerated then
										p4.setFailed("Moderated")
										p5.triggerToast({
											title = data2.removedTitle,
											text = data2.removedBody
										})
									else
										p4.setFailed((tostring(result3)))
										p5.triggerToast({
											title = data2.failedTitle,
											text = data2.failedBody
										})
									end

									local v39 = {
										status = enumName(result3),
										captureType = enumName(data.CaptureType)
									}
									local v40 = enumName(result3)
									MomentsCommon.Analytics.reportMomentsCreationStep("upload", "failed", v40)
									v39.localId = tostring(data.LocalId)
									v39.creationSessionId = creationSessionId
									fireAnalyticsEvent(eventNames.UploadCaptureFailed, v39)

									return
								end
							else
								p4.setFailed("PollError")
								p5.triggerToast({
									title = data2.failedTitle,
									text = data2.failedBody
								})

								local v39 = {
									status = "PollError",
									error = tostring(result3),
									captureType = enumName(data.CaptureType)
								}
								MomentsCommon.Analytics.reportMomentsCreationStep("upload", "failed", "PollError")
								v39.localId = tostring(data.LocalId)
								v39.creationSessionId = creationSessionId
								fireAnalyticsEvent(eventNames.UploadCaptureFailed, v39)

								return
							end
						end

						local v36 = enumName(data.LocalId) or "nil"
						local v37 = string.gsub(v36, "\r", "\\r")
						Logger:debug(
							"event=poll_timeout localId={} attempts={}",
							string.gsub(v37, "\n", "\\n"),
							(tostring(fastInt2))
						)

						p4.setFailed("Timeout")
						p5.triggerToast({
							title = data2.failedTitle,
							text = data2.failedBody
						})
						local v38 = {
							status = "Timeout",
							captureType = enumName(data.CaptureType)
						}
						MomentsCommon.Analytics.reportMomentsCreationStep("upload", "failed", "Timeout")
						v38.localId = tostring(data.LocalId)
						v38.creationSessionId = creationSessionId
						fireAnalyticsEvent(eventNames.UploadCaptureFailed, v38)
					else
						p4.setFailed("RegistrationFailed")
						p5.triggerToast({
							title = data2.failedTitle,
							text = data2.failedBody
						})
						local v32 = {
							status = "RegistrationFailed",
							error = tostring(result2),
							captureType = enumName(data.CaptureType)
						}
						MomentsCommon.Analytics.reportMomentsCreationStep("upload", "failed", "RegistrationFailed")
						v32.localId = tostring(data.LocalId)
						v32.creationSessionId = creationSessionId
						fireAnalyticsEvent(eventNames.UploadCaptureFailed, v32)
					end
				else
					if result == Enum.UploadCaptureResult.CaptureModerated then
						p5.triggerToast({
							title = data2.removedTitle,
							text = data2.removedBody
						})
					elseif result == Enum.UploadCaptureResult.UploadQuotaReached then
						p5.triggerToast({
							title = data2.failedTitle,
							text = data2.uploadQuotaReachedBody
						})
					else
						p5.triggerToast({
							title = data2.failedTitle,
							text = data2.failedBody
						})
					end

					p4.setFailed((tostring(result)))
					local v29 = {
						status = enumName(result),
						captureType = enumName(data.CaptureType)
					}
					local v30 = enumName(result)
					MomentsCommon.Analytics.reportMomentsCreationStep("upload", "failed", v30)
					v29.localId = tostring(data.LocalId)
					v29.creationSessionId = creationSessionId
					fireAnalyticsEvent(eventNames.UploadCaptureFailed, v29)
				end
			else
				p4.setFailed("StartUploadFailed")
				p5.triggerToast({ title = data2.failedTitle, text = data2.failedBody })

				local v29 = {
					status = enumName(result),
					captureType = enumName(data.CaptureType)
				}

				v29.status = "StartUploadFailed"
				v29.error = tostring(result)
				MomentsCommon.Analytics.reportMomentsCreationStep("upload", "failed", "StartUploadFailed")
				v29.localId = tostring(data.LocalId)
				v29.creationSessionId = creationSessionId
				fireAnalyticsEvent(eventNames.UploadCaptureFailed, v29)
			end
		else
			local v26 = enumName(data.LocalId) or "nil"
			local v27 = string.gsub(v26, "\r", "\\r")
			Logger:debug("event=path_selected path=fallback localId={}", (string.gsub(v27, "\n", "\\n")))

			local success, result = pcall(function()
				v5:UploadCaptureAndPostMoment(data, v6, p3)
			end)

			if success then
				local editingFlowMomentPublished = eventNames.EditingFlowMomentPublished
				local captureDescriptorFields = makeCreationEventFields.makeCaptureDescriptorFields(data)
				captureDescriptorFields.creationSessionId = creationSessionId

				fireAnalyticsEvent(editingFlowMomentPublished, captureDescriptorFields)
			end

			if success then
				MomentsCommon.Analytics.reportMomentsCreationStep("upload", "success")

				return
			end

			p4.setFailed("GenericFailure")
			p5.triggerToast({ title = data2.failedTitle, text = data2.failedBody })
			local v28 = {
				error = tostring(result),
				captureType = enumName(data.CaptureType)
			}

			v28.status = "GenericFailure"
			MomentsCommon.Analytics.reportMomentsCreationStep("upload", "failed", "GenericFailure")
			v28.localId = tostring(data.LocalId)
			v28.creationSessionId = creationSessionId
			fireAnalyticsEvent(eventNames.UploadCaptureFailed, v28)
		end
	end)
end

return uploadMoment
