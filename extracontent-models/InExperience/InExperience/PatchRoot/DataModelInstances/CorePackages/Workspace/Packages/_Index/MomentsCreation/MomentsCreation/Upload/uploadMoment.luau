local CaptureService = game:GetService("CaptureService")

local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local MomentsCommon = require(parent.MomentsCommon)
require(parent.MomentsTypes)

local EventNames = MomentsCommon.Analytics.EventNames
local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local makeCreationEventFields = require(MomentsCreation.Analytics.makeCreationEventFields)
local normalizeMomentMetadata = require(MomentsCreation.Utils.normalizeMomentMetadata)
local completeMomentUpload = require(MomentsCreation.Upload.completeMomentUpload)
local Logger = require(MomentsCreation.Logger)
local MomentsCommon2 = require(parent.MomentsCommon)
local FFlagMomentsTextOverlayV2Redesign = MomentsCommon2.Flags.FFlagMomentsTextOverlayV2Redesign
local GetFFlagMomentsUseUploadPostAsync = MomentsCommon.Flags.GetFFlagMomentsUseUploadPostAsync
local defineFastFlag = game:DefineFastFlag("MomentsPostUploadFailureReasons", false)
local GetFFlagMomentsUseMomentsServiceForUpload = MomentsCommon.Flags.GetFFlagMomentsUseMomentsServiceForUpload
local makePostMetadata = require(MomentsCreation.Utils.makePostMetadata)
local FFlagMomentsCreationSessionId = require(MomentsCreation.Flags.FFlagMomentsCreationSessionId)

local enumName = makeCreationEventFields.enumName

local game2 = game

local engineFeature = game:GetEngineFeature("CaptureServiceUploadUniverseIdOverride")

local engineFeature2 = game:GetEngineFeature("CaptureServiceStartUploadCoreScriptBypass")

game:DefineFastString("MomentsUploadUniverseId", "8357232245")
game:DefineFastInt("MomentsUploadPollIntervalSeconds", 5)
game:DefineFastInt("MomentsUploadMaxPollAttempts", 120)

local function logValue(p) -- 22 equivalent calls inferred from this helper
	local v = enumName(p) or "nil"
	local v2 = string.gsub(v, "\r", "\\r")
	return (string.gsub(v2, "\n", "\\n"))
end

local function injectUniverseIdOverride(p)
	local gameId = game2.GameId

	if gameId ~= nil and gameId > 0 then
		return p
	end

	local clone = table.clone(p)
	clone.universeIdOverride = tonumber(game:GetFastString("MomentsUploadUniverseId"))
	return clone
end

local function uploadMoment(data, p, p2, data2, uploadStore, toastStore, feedStore, myCreationsStore, creationSessionId: string?, p3, p4)
	local v = p3 or CaptureService

	if engineFeature then
		local gameId = game2.GameId

		if gameId == nil or not (gameId > 0) then
			p = table.clone(p)
			p.universeIdOverride = tonumber(game:GetFastString("MomentsUploadUniverseId"))
		end
	end

	local momentMetadata = normalizeMomentMetadata(p)

	Logger:debug(
		"event=upload_start CaptureServiceStartUploadCoreScriptBypass={} MomentsUseBackendPostStatusNotification={} localId={} captureType={} sourcePlaceId={} sourceUniverseId={}",
		logValue(engineFeature2), -- inferred equivalent call
		logValue(true), -- inferred equivalent call
		logValue(data.LocalId), -- inferred equivalent call
		logValue(data.CaptureType), -- inferred equivalent call
		logValue(data.SourcePlaceId), -- inferred equivalent call
		logValue(data.SourceUniverseId) -- inferred equivalent call
	)

	uploadStore.setUploading()

	toastStore.triggerToast({ title = data2.publishingTitle, text = data2.publishingBody })

	local function publishFields(p5) -- 5 equivalent calls inferred from this helper
		p5.creationSessionId = creationSessionId
		return p5
	end

	local function fireUploadFailed(p5, p6: string?) -- 8 equivalent calls inferred from this helper
		MomentsCommon.Analytics.reportMomentsCreationStep("upload", "failed", p6)
		p5.localId = tostring(data.LocalId)
		p5.creationSessionId = creationSessionId
		fireAnalyticsEvent(EventNames.UploadCaptureFailed, p5)
	end

	task.spawn(function()
		if GetFFlagMomentsUseUploadPostAsync() then
			Logger:debug("event=path_selected path=post_upload localId={}", logValue(data.LocalId)) -- inferred equivalent call
			local v2

			if FFlagMomentsTextOverlayV2Redesign then
				v2 = p
			else
				v2 = momentMetadata
			end

			local v3

			if GetFFlagMomentsUseMomentsServiceForUpload() then
				v3 = data
			end

			local postMetadata = makePostMetadata(v2, v3, creationSessionId)

			fireAnalyticsEvent(
				EventNames.EditingFlowMomentPublished,
				publishFields(makeCreationEventFields.makeCaptureDescriptorFields(data)) -- inferred equivalent call
			)

			local success, result = pcall(function()
				if GetFFlagMomentsUseMomentsServiceForUpload() then
					return (p4 or game:GetService("MomentsService")):CreatePostAsync(postMetadata)
				end

				return v:UploadPostAsync(data, postMetadata)
			end)

			if success then
				Logger:debug(
					"event=post_upload_success localId={} assetId={}",
					logValue(data.LocalId), -- inferred equivalent call
					logValue(result.assetId) -- inferred equivalent call
				)

				completeMomentUpload(result.assetId, {
					uploadStore = uploadStore,
					toastStore = toastStore,
					feedStore = feedStore,
					myCreationsStore = myCreationsStore,
					localizations = data2,
					onPostedToFeed = function()
						local v4 = {
							assetId = tostring(result.assetId),
							localId = tostring(data.LocalId),
							captureType = enumName(data.CaptureType)
						}

						if FFlagMomentsCreationSessionId and result.operationId ~= nil and result.operationId ~= "" then
							v4.correlationId = result.operationId
						end

						fireAnalyticsEvent(EventNames.EditingFlowMomentPostedToFeed, publishFields(v4)) -- inferred equivalent call
					end
				})
			else
				Logger:debug("event=post_upload_failed localId={} error={}", logValue(data.LocalId), logValue(result)) -- inferred equivalent call

				uploadStore.setFailed("GenericFailure")
				toastStore.triggerToast({ title = data2.failedTitle, text = data2.failedBody })

				local v4 = {
					status = "GenericFailure",
					error = tostring(result),
					captureType = enumName(data.CaptureType)
				}
				local v5

				if defineFastFlag then
					local classifyPostUploadError = require(MomentsCreation.Upload.classifyPostUploadError)
					v5 = classifyPostUploadError(result)
				else
					v5 = "GenericFailure"
				end

				fireUploadFailed(v4, v5) -- inferred equivalent call
			end
		elseif engineFeature2 then
			Logger:debug("event=path_selected path=two_phase localId={}", logValue(data.LocalId)) -- inferred equivalent call

			local success, result, v2 = pcall(function()
				return v:StartUploadCaptureAsync(data)
			end)

			if success then
				Logger:debug(
					"event=start_upload localId={} pcallSuccess=true status={}",
					logValue(data.LocalId), -- inferred equivalent call
					logValue(result) -- inferred equivalent call
				)
			else
				Logger:debug(
					"event=start_upload localId={} pcallSuccess=false status=pcall_error errorClass={}",
					logValue(data.LocalId), -- inferred equivalent call
					(typeof(result))
				)
			end

			if success then
				if result == Enum.UploadCaptureResult.Success then
					local success2, result2 = pcall(function()
						v:UploadCaptureAndPostMoment(data, momentMetadata, p2)
					end)

					Logger:debug(
						"event=registration localId={} pcallSuccess={} errorClass={}",
						logValue(data.LocalId), -- inferred equivalent call
						tostring(success2),
						success2 and "none" or typeof(result2)
					)

					if success2 then
						fireAnalyticsEvent(
							EventNames.EditingFlowMomentPublished,
							publishFields(makeCreationEventFields.makeCaptureDescriptorFields(data)) -- inferred equivalent call
						)

						local fastInt = game:GetFastInt("MomentsUploadPollIntervalSeconds")
						local fastInt2 = game:GetFastInt("MomentsUploadMaxPollAttempts")
						local v3 = false
						local v4 = nil

						for i = 1, fastInt2 do
							task.wait(fastInt)

							local success3, result3, v5 = pcall(function()
								return v:CheckUploadCaptureStatusAsync(v2)
							end)
							local v6 = not v3 or success3 and result3 ~= v4
							local v7 = not success3 or result3 ~= Enum.UploadCaptureResult.UploadPending
							local v8 = i % 6 == 0

							if success3 then
								v4 = result3
								v3 = true
							end

							if i == 1 or v6 or v7 or v8 then
								if success3 then
									local v9 = logValue(data.LocalId) -- inferred equivalent call
									Logger:debug(
										"event=poll localId={} attempt={} pcallSuccess=true status={} assetId={} heartbeat={}",
										v9,
										tostring(i),
										logValue(result3), -- inferred equivalent call
										logValue(v5), -- inferred equivalent call
										(tostring(v8 and not v6))
									)
								else
									Logger:debug(
										"event=poll localId={} attempt={} pcallSuccess=false status=pcall_error errorClass={}",
										logValue(data.LocalId), -- inferred equivalent call
										tostring(i),
										(typeof(result3))
									)
								end
							end

							if success3 then
								if result3 == Enum.UploadCaptureResult.Success then
									completeMomentUpload(v5, {
										uploadStore = uploadStore,
										toastStore = toastStore,
										feedStore = feedStore,
										myCreationsStore = myCreationsStore,
										localizations = data2,
										onPostedToFeed = function()
											fireAnalyticsEvent(
												EventNames.EditingFlowMomentPostedToFeed,
												publishFields({ -- inferred equivalent call
													assetId = tostring(v5),
													localId = tostring(data.LocalId),
													captureType = enumName(data.CaptureType)
												})
											)
										end
									})

									return
								end

								if result3 ~= Enum.UploadCaptureResult.UploadPending then
									if result3 == Enum.UploadCaptureResult.CaptureModerated then
										uploadStore.setFailed("Moderated")
										toastStore.triggerToast({
											title = data2.removedTitle,
											text = data2.removedBody
										})
									else
										uploadStore.setFailed((tostring(result3)))
										toastStore.triggerToast({
											title = data2.failedTitle,
											text = data2.failedBody
										})
									end

									fireUploadFailed( -- inferred equivalent call
										{
											status = enumName(result3),
											captureType = enumName(data.CaptureType)
										},
										enumName(result3)
									)
									return
								end
							else
								uploadStore.setFailed("PollError")
								toastStore.triggerToast({
									title = data2.failedTitle,
									text = data2.failedBody
								})

								fireUploadFailed( -- inferred equivalent call
									{
										status = "PollError",
										error = tostring(result3),
										captureType = enumName(data.CaptureType)
									},
									"PollError"
								)

								return
							end
						end

						Logger:debug(
							"event=poll_timeout localId={} attempts={}",
							logValue(data.LocalId), -- inferred equivalent call
							(tostring(fastInt2))
						)

						uploadStore.setFailed("Timeout")
						toastStore.triggerToast({
							title = data2.failedTitle,
							text = data2.failedBody
						})
						fireUploadFailed({ -- inferred equivalent call
							status = "Timeout",
							captureType = enumName(data.CaptureType)
						}, "Timeout")
					else
						uploadStore.setFailed("RegistrationFailed")
						toastStore.triggerToast({
							title = data2.failedTitle,
							text = data2.failedBody
						})
						fireUploadFailed( -- inferred equivalent call
							{
								status = "RegistrationFailed",
								error = tostring(result2),
								captureType = enumName(data.CaptureType)
							},
							"RegistrationFailed"
						)
					end
				else
					if result == Enum.UploadCaptureResult.CaptureModerated then
						toastStore.triggerToast({
							title = data2.removedTitle,
							text = data2.removedBody
						})
					elseif result == Enum.UploadCaptureResult.UploadQuotaReached then
						toastStore.triggerToast({
							title = data2.failedTitle,
							text = data2.uploadQuotaReachedBody
						})
					else
						toastStore.triggerToast({
							title = data2.failedTitle,
							text = data2.failedBody
						})
					end

					uploadStore.setFailed((tostring(result)))
					fireUploadFailed( -- inferred equivalent call
						{ status = enumName(result), captureType = enumName(data.CaptureType) },
						enumName(result)
					)
				end
			else
				uploadStore.setFailed("StartUploadFailed")
				toastStore.triggerToast({ title = data2.failedTitle, text = data2.failedBody })

				local v3 = { status = enumName(result), captureType = enumName(data.CaptureType) }

				v3.status = "StartUploadFailed"
				v3.error = tostring(result)
				fireUploadFailed(v3, "StartUploadFailed") -- inferred equivalent call
			end
		else
			Logger:debug("event=path_selected path=fallback localId={}", logValue(data.LocalId)) -- inferred equivalent call

			local success, result = pcall(function()
				v:UploadCaptureAndPostMoment(data, momentMetadata, p2)
			end)

			if success then
				fireAnalyticsEvent(
					EventNames.EditingFlowMomentPublished,
					publishFields(makeCreationEventFields.makeCaptureDescriptorFields(data)) -- inferred equivalent call
				)
			end

			if success then
				MomentsCommon.Analytics.reportMomentsCreationStep("upload", "success")

				return
			end

			uploadStore.setFailed("GenericFailure")
			toastStore.triggerToast({ title = data2.failedTitle, text = data2.failedBody })
			local v2 = { error = tostring(result), captureType = enumName(data.CaptureType) }

			v2.status = "GenericFailure"
			fireUploadFailed(v2, "GenericFailure") -- inferred equivalent call
		end
	end)
end

return uploadMoment
