local CaptureService = game:GetService("CaptureService")
local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)

require(MomentsCreationParent.MomentsTypes)

local EventNames = MomentsCommon.Analytics.EventNames
local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local GetFFlagMomentsAnalyticsProducerPrereqs = MomentsCommon.Flags.GetFFlagMomentsAnalyticsProducerPrereqs
local _game = game
local EngineFeature = game:GetEngineFeature("CaptureServiceUploadUniverseIdOverride")
local EngineFeature2 = game:GetEngineFeature("CaptureServiceStartUploadCoreScriptBypass")

game:DefineFastString("MomentsUploadUniverseId", "8357232245")

local function injectUniverseIdOverride(p1) -- line: 62
	-- upvalues: _game (copy)
	local GameId = _game.GameId

	if GameId ~= nil and GameId > 0 then
		return p1
	end

	local v15 = table.clone(p1)

	v15.universeIdOverride = tonumber(game:GetFastString("MomentsUploadUniverseId"))

	return v15
end
local function uploadMoment(p2, p3, p4, t1: {[any]: any}, t2: {[any]: any}, t3: {[any]: any}, t4: {[any]: any}?, t5: {[any]: any}?, s1: string?) -- line: 72
	-- upvalues: EngineFeature (copy), _game (copy), GetFFlagMomentsAnalyticsProducerPrereqs (copy), fireAnalyticsEvent (copy), EventNames (copy), EngineFeature2 (copy), CaptureService (copy)
	if EngineFeature then
		local GameId = _game.GameId

		if GameId ~= nil and GameId > 0 then
		else
			p3 = table.clone(p3)
			p3.universeIdOverride = tonumber(game:GetFastString("MomentsUploadUniverseId"))
		end
	end

	local v26 = p3

	t2.setUploading()
	t3.triggerToast({
		title = t1.publishingTitle,
		text = t1.publishingBody
	})

	local v27 = GetFFlagMomentsAnalyticsProducerPrereqs()

	local function publishFields(t6: {[any]: any}) -- line: 101
		-- upvalues: v27 (copy), s1 (copy)
		if v27 then
			t6.creationSessionId = s1
		end

		return t6
	end
	local function fireUploadFailed(t7: {[any]: any}, b1: boolean?) -- line: 109
		-- upvalues: v27 (copy), p2 (copy), s1 (copy), fireAnalyticsEvent (copy), EventNames (copy)
		if not v27 and not b1 then
			return
		end

		if v27 then
			t7.localId = tostring(p2.LocalId)
			t7.creationSessionId = s1
		end

		fireAnalyticsEvent(EventNames.UploadCaptureFailed, t7)
	end

	task.spawn(function() -- line: 120
		-- upvalues: EngineFeature2 (copy), CaptureService (copy), p2 (copy), v26 (copy), p4 (copy), fireAnalyticsEvent (copy), EventNames (copy), v27 (copy), s1 (copy), t2 (copy), t3 (copy), t1 (copy), t4 (copy), t5 (copy)
		if not EngineFeature2 then
			local ok, result = pcall(function() -- line: 123
				-- upvalues: CaptureService (copy), p2 (copy), v26 (copy), p4 (copy)
				CaptureService:UploadCaptureAndPostMoment(p2, v26, p4)
			end)
			local v35 = fireAnalyticsEvent
			local EditingFlowMomentPublished = EventNames.EditingFlowMomentPublished
			local t8 = {
				sourcePlaceId = tostring(p2.SourcePlaceId),
				localId = tostring(p2.LocalId),
				captureType = tostring(p2.CaptureType)
			}

			if v27 then
				t8.creationSessionId = s1
			end

			v35(EditingFlowMomentPublished, t8)

			if not ok then
				t2.setFailed("GenericFailure")
				t3.triggerToast({
					title = t1.failedTitle,
					text = t1.failedBody
				})

				local t9 = {
					error = tostring(result),
					captureType = tostring(p2.CaptureType)
				}
				local _ = v27

				if v27 then
					t9.localId = tostring(p2.LocalId)
					t9.creationSessionId = s1
				end

				fireAnalyticsEvent(EventNames.UploadCaptureFailed, t9)
			end

			return
		end

		local ok, result, v42 = pcall(function() -- line: 147
			-- upvalues: CaptureService (copy), p2 (copy)
			return CaptureService:StartUploadCaptureAsync(p2)
		end)

		if not ok then
			t2.setFailed("StartUploadFailed")
			t3.triggerToast({
				title = t1.failedTitle,
				text = t1.failedBody
			})

			local t10 = {
				status = tostring(result),
				captureType = tostring(p2.CaptureType)
			}
			local _ = v27

			if v27 then
				t10.localId = tostring(p2.LocalId)
				t10.creationSessionId = s1
			end

			fireAnalyticsEvent(EventNames.UploadCaptureFailed, t10)

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

			local t11 = {
				status = tostring(result),
				captureType = tostring(p2.CaptureType)
			}
			local _ = v27

			if v27 then
				t11.localId = tostring(p2.LocalId)
				t11.creationSessionId = s1
			end

			fireAnalyticsEvent(EventNames.UploadCaptureFailed, t11)

			return
		end

		pcall(function() -- line: 184
			-- upvalues: CaptureService (copy), p2 (copy), v26 (copy), p4 (copy)
			CaptureService:UploadCaptureAndPostMoment(p2, v26, p4)
		end)

		local v47 = fireAnalyticsEvent
		local EditingFlowMomentPublished = EventNames.EditingFlowMomentPublished
		local t12 = {
			sourcePlaceId = tostring(p2.SourcePlaceId),
			localId = tostring(p2.LocalId),
			captureType = tostring(p2.CaptureType)
		}

		if v27 then
			t12.creationSessionId = s1
		end

		v47(EditingFlowMomentPublished, t12)

		for _ = 1, 120 do
			task.wait(5)

			local ok2, result2, v53 = pcall(function() -- line: 201
				-- upvalues: CaptureService (copy), v42 (copy)
				return CaptureService:CheckUploadCaptureStatusAsync(v42)
			end)

			if not ok2 then
				t2.setFailed("PollError")
				t3.triggerToast({
					title = t1.failedTitle,
					text = t1.failedBody
				})

				local t13 = {
					status = "PollError",
					error = tostring(result2),
					captureType = tostring(p2.CaptureType)
				}

				if not v27 then
					return
				end

				if v27 then
					t13.localId = tostring(p2.LocalId)
					t13.creationSessionId = s1
				end

				fireAnalyticsEvent(EventNames.UploadCaptureFailed, t13)

				return
			end

			if result2 == Enum.UploadCaptureResult.Success then
				t2.setSuccess(v53)

				if t4 then
					t4.prependItem({
						assetId = v53
					})
				end

				if t5 then
					t5.prependItem({
						assetId = v53
					})
					t5.invalidateCount()
				end

				local v55 = fireAnalyticsEvent
				local EditingFlowMomentPostedToFeed = EventNames.EditingFlowMomentPostedToFeed
				local t14 = {
					assetId = tostring(v53),
					localId = tostring(p2.LocalId),
					captureType = tostring(p2.CaptureType)
				}

				if v27 then
					t14.creationSessionId = s1
				end

				v55(EditingFlowMomentPostedToFeed, t14)
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

					local t15 = {
						status = tostring(result2),
						captureType = tostring(p2.CaptureType)
					}

					if not v27 then
						return
					end

					if v27 then
						t15.localId = tostring(p2.LocalId)
						t15.creationSessionId = s1
					end

					fireAnalyticsEvent(EventNames.UploadCaptureFailed, t15)

					return
				end

				t2.setFailed((tostring(result2)))
				t3.triggerToast({
					title = t1.failedTitle,
					text = t1.failedBody
				})

				local t16 = {
					status = tostring(result2),
					captureType = tostring(p2.CaptureType)
				}

				if not v27 then
					return
				end

				if v27 then
					t16.localId = tostring(p2.LocalId)
					t16.creationSessionId = s1
				end

				fireAnalyticsEvent(EventNames.UploadCaptureFailed, t16)

				return
			end
		end

		t2.setFailed("Timeout")
		t3.triggerToast({
			title = t1.failedTitle,
			text = t1.failedBody
		})

		local t17 = {
			status = "Timeout",
			captureType = tostring(p2.CaptureType)
		}

		if not v27 then
			return
		end

		if v27 then
			t17.localId = tostring(p2.LocalId)
			t17.creationSessionId = s1
		end

		fireAnalyticsEvent(EventNames.UploadCaptureFailed, t17)
	end)
end

return uploadMoment
