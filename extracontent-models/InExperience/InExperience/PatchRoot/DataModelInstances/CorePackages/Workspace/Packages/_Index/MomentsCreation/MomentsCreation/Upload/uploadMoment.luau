local CaptureService = game:GetService("CaptureService")
local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)

require(MomentsCreationParent.MomentsTypes)

local EventNames = MomentsCommon.Analytics.EventNames
local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local makeCreationEventFields = require(MomentsCreation.Analytics.makeCreationEventFields)
local GetFFlagMomentsAnalyticsProducerPrereqs = MomentsCommon.Flags.GetFFlagMomentsAnalyticsProducerPrereqs
local enumName = makeCreationEventFields.enumName
local _game = game
local EngineFeature = game:GetEngineFeature("CaptureServiceUploadUniverseIdOverride")
local EngineFeature2 = game:GetEngineFeature("CaptureServiceStartUploadCoreScriptBypass")

game:DefineFastString("MomentsUploadUniverseId", "8357232245")

local function injectUniverseIdOverride(p1) -- line: 65
	-- upvalues: _game (copy)
	local GameId = _game.GameId

	if GameId ~= nil and GameId > 0 then
		return p1
	end

	local v17 = table.clone(p1)

	v17.universeIdOverride = tonumber(game:GetFastString("MomentsUploadUniverseId"))

	return v17
end
local function uploadMoment(p2, p3, p4, t1: {[any]: any}, t2: {[any]: any}, t3: {[any]: any}, t4: {[any]: any}?, t5: {[any]: any}?, s1: string?) -- line: 75
	-- upvalues: EngineFeature (copy), _game (copy), GetFFlagMomentsAnalyticsProducerPrereqs (copy), fireAnalyticsEvent (copy), EventNames (copy), EngineFeature2 (copy), CaptureService (copy), makeCreationEventFields (copy), enumName (copy)
	if EngineFeature then
		local GameId = _game.GameId

		if GameId ~= nil and GameId > 0 then
		else
			p3 = table.clone(p3)
			p3.universeIdOverride = tonumber(game:GetFastString("MomentsUploadUniverseId"))
		end
	end

	local v28 = p3

	t2.setUploading()
	t3.triggerToast({
		title = t1.publishingTitle,
		text = t1.publishingBody
	})

	local v29 = GetFFlagMomentsAnalyticsProducerPrereqs()

	local function publishFields(t6: {[any]: any}) -- line: 108
		-- upvalues: v29 (copy), s1 (copy)
		if v29 then
			t6.creationSessionId = s1
		end

		return t6
	end
	local function fireUploadFailed(t7: {[any]: any}, b1: boolean?) -- line: 116
		-- upvalues: v29 (copy), p2 (copy), s1 (copy), fireAnalyticsEvent (copy), EventNames (copy)
		if not v29 and not b1 then
			return
		end

		if v29 then
			t7.localId = tostring(p2.LocalId)
			t7.creationSessionId = s1
		end

		fireAnalyticsEvent(EventNames.UploadCaptureFailed, t7)
	end

	task.spawn(function() -- line: 127
		-- upvalues: EngineFeature2 (copy), CaptureService (copy), p2 (copy), v28 (copy), p4 (copy), fireAnalyticsEvent (copy), EventNames (copy), makeCreationEventFields (copy), v29 (copy), s1 (copy), t2 (copy), t3 (copy), t1 (copy), enumName (copy), t4 (copy), t5 (copy)
		if not EngineFeature2 then
			local ok, result = pcall(function() -- line: 130
				-- upvalues: CaptureService (copy), p2 (copy), v28 (copy), p4 (copy)
				CaptureService:UploadCaptureAndPostMoment(p2, v28, p4)
			end)
			local v37 = fireAnalyticsEvent
			local EditingFlowMomentPublished = EventNames.EditingFlowMomentPublished
			local v39 = makeCreationEventFields.makeCaptureDescriptorFields(p2)

			if v29 then
				v39.creationSessionId = s1
			end

			v37(EditingFlowMomentPublished, v39)

			if not ok then
				t2.setFailed("GenericFailure")
				t3.triggerToast({
					title = t1.failedTitle,
					text = t1.failedBody
				})

				local t8 = {
					error = tostring(result),
					captureType = enumName(p2.CaptureType)
				}
				local _ = v29

				if v29 then
					t8.localId = tostring(p2.LocalId)
					t8.creationSessionId = s1
				end

				fireAnalyticsEvent(EventNames.UploadCaptureFailed, t8)
			end

			return
		end

		local ok, result, v44 = pcall(function() -- line: 150
			-- upvalues: CaptureService (copy), p2 (copy)
			return CaptureService:StartUploadCaptureAsync(p2)
		end)

		if not ok then
			t2.setFailed("StartUploadFailed")
			t3.triggerToast({
				title = t1.failedTitle,
				text = t1.failedBody
			})

			local t9 = {
				status = enumName(result),
				captureType = enumName(p2.CaptureType)
			}
			local _ = v29

			if v29 then
				t9.localId = tostring(p2.LocalId)
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
				captureType = enumName(p2.CaptureType)
			}
			local _ = v29

			if v29 then
				t10.localId = tostring(p2.LocalId)
				t10.creationSessionId = s1
			end

			fireAnalyticsEvent(EventNames.UploadCaptureFailed, t10)

			return
		end

		pcall(function() -- line: 187
			-- upvalues: CaptureService (copy), p2 (copy), v28 (copy), p4 (copy)
			CaptureService:UploadCaptureAndPostMoment(p2, v28, p4)
		end)

		local v49 = fireAnalyticsEvent
		local EditingFlowMomentPublished = EventNames.EditingFlowMomentPublished
		local v51 = makeCreationEventFields.makeCaptureDescriptorFields(p2)

		if v29 then
			v51.creationSessionId = s1
		end

		v49(EditingFlowMomentPublished, v51)

		for _ = 1, 120 do
			task.wait(5)

			local ok2, result2, v55 = pcall(function() -- line: 200
				-- upvalues: CaptureService (copy), v44 (copy)
				return CaptureService:CheckUploadCaptureStatusAsync(v44)
			end)

			if not ok2 then
				t2.setFailed("PollError")
				t3.triggerToast({
					title = t1.failedTitle,
					text = t1.failedBody
				})

				local t11 = {
					status = "PollError",
					error = tostring(result2),
					captureType = enumName(p2.CaptureType)
				}

				if not v29 then
					return
				end

				if v29 then
					t11.localId = tostring(p2.LocalId)
					t11.creationSessionId = s1
				end

				fireAnalyticsEvent(EventNames.UploadCaptureFailed, t11)

				return
			end

			if result2 == Enum.UploadCaptureResult.Success then
				t2.setSuccess(v55)

				if t4 then
					t4.prependItem({
						assetId = v55
					})
				end

				if t5 then
					t5.prependItem({
						assetId = v55
					})
					t5.invalidateCount()
				end

				local v57 = fireAnalyticsEvent
				local EditingFlowMomentPostedToFeed = EventNames.EditingFlowMomentPostedToFeed
				local t12 = {
					assetId = tostring(v55),
					localId = tostring(p2.LocalId),
					captureType = enumName(p2.CaptureType)
				}

				if v29 then
					t12.creationSessionId = s1
				end

				v57(EditingFlowMomentPostedToFeed, t12)
				t3.triggerToast({
					title = t1.publishedTitle,
					text = t1.publishedBody
				})

				return
			end

			if result2 ~= Enum.UploadCaptureResult.UploadPending then
				if result2 == Enum.UploadCaptureResult.CaptureModerated then
					t2.setFailed("Moderated")
					t3.triggerToast({
						title = t1.removedTitle,
						text = t1.removedBody
					})

					local t13 = {
						status = enumName(result2),
						captureType = enumName(p2.CaptureType)
					}

					if not v29 then
						return
					end

					if v29 then
						t13.localId = tostring(p2.LocalId)
						t13.creationSessionId = s1
					end

					fireAnalyticsEvent(EventNames.UploadCaptureFailed, t13)

					return
				end

				t2.setFailed((tostring(result2)))
				t3.triggerToast({
					title = t1.failedTitle,
					text = t1.failedBody
				})

				local t14 = {
					status = enumName(result2),
					captureType = enumName(p2.CaptureType)
				}

				if not v29 then
					return
				end

				if v29 then
					t14.localId = tostring(p2.LocalId)
					t14.creationSessionId = s1
				end

				fireAnalyticsEvent(EventNames.UploadCaptureFailed, t14)

				return
			end
		end

		t2.setFailed("Timeout")
		t3.triggerToast({
			title = t1.failedTitle,
			text = t1.failedBody
		})

		local t15 = {
			status = "Timeout",
			captureType = enumName(p2.CaptureType)
		}

		if not v29 then
			return
		end

		if v29 then
			t15.localId = tostring(p2.LocalId)
			t15.creationSessionId = s1
		end

		fireAnalyticsEvent(EventNames.UploadCaptureFailed, t15)
	end)
end

return uploadMoment
