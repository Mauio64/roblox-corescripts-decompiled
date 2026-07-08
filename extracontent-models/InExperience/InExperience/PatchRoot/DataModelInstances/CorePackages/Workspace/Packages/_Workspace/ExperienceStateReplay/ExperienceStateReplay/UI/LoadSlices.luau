local TeleportService = game:GetService("TeleportService")
local ExperienceStateRecordingService = game:GetService("ExperienceStateRecordingService")
local HttpService = game:GetService("HttpService")
local t1 = {}

function debugPrint(_) -- line: 10
end
function t1.SetLoadedState(p2, p3) -- line: 16
	debugPrint("playResult minFrameNumber " .. tostring(p3.minFrameNumber) .. " maxFrameNumber " .. tostring(p3.maxFrameNumber) .. " minEpoch " .. tostring(p3.minEpoch) .. " - " .. tostring(DateTime.fromUnixTimestampMillis(p3.minEpoch):ToIsoDate()) .. " maxEpoch " .. tostring(p3.maxEpoch) .. " - " .. tostring(DateTime.fromUnixTimestampMillis(p3.maxEpoch):ToIsoDate()))
	p2.minLoadedFrameNumber = p3.minFrameNumber
	p2.maxLoadedFrameNumber = p3.maxFrameNumber
	p2.minLoadedEpoch = p3.minEpoch
	p2.maxLoadedEpoch = p3.maxEpoch

	if p2.minOverallEpoch == nil then
		p2.minOverallEpoch = p2.minLoadedEpoch
		p2.maxOverallEpoch = p2.maxLoadedEpoch
	elseif p2.sourceType == Enum.ExperienceStateRecordingLoadSourceType.File then
		p2.minOverallEpoch = math.min(p2.minLoadedEpoch, p2.minOverallEpoch)
		p2.maxOverallEpoch = math.max(p2.maxLoadedEpoch, p2.maxOverallEpoch)
	end

	p2.loadedLengthSeconds = (p2.maxLoadedEpoch - p2.minLoadedEpoch) / 1000
	p2.overallLengthSeconds = (p2.maxOverallEpoch - p2.minOverallEpoch) / 1000
	p2.replayToLoadedStartSeconds = (p2.minLoadedEpoch - p2.minOverallEpoch) / 1000
	debugPrint("minOverallEpoch " .. tostring(p2.minOverallEpoch) .. " maxOverallEpoch " .. tostring(p2.maxOverallEpoch) .. " overallLengthSeconds " .. tostring(p2.overallLengthSeconds) .. " loadedLengthSeconds " .. tostring(p2.loadedLengthSeconds))

	local v8 = p2.loadedLengthSeconds / p2.overallLengthSeconds

	p2.ScrubberLoadProgress.Size = UDim2.new(v8, 0, 1, 0)

	local v9 = p2.replayToLoadedStartSeconds / p2.overallLengthSeconds

	p2.ScrubberLoadProgress.Position = UDim2.new(v9, 0, 0, 0)
	debugPrint("loadedPercent " .. tostring(v8) .. " loadedStartPercent " .. tostring(v9))
end
function _getMetadataForUser(p4) -- line: 74
	-- upvalues: ExperienceStateRecordingService (copy)
	local v11 = ExperienceStateRecordingService:ListRecordingsAsync(p4, "")

	print(v11)
end
function getMetadataForGuid(p5, p6) -- line: 81
	-- upvalues: HttpService (copy)
	local t2 = {
		Url = "https://apis.roblox.com/data-model-capture-service/v1/GetCaptureMetadataByEngineContextGuid",
		Method = "POST",
		Body = HttpService:JSONEncode({
			engineContextGuid = p5
		}),
		Headers = {
			["Content-Type"] = "application/json",
			Accept = "application/json"
		}
	}

	return HttpService:RequestInternal(t2):Start(function(p7, p8) -- line: 94
		-- upvalues: HttpService (copy), p6 (copy), p5 (copy)
		if p7 then
			print(p8.Body)

			local metadata = HttpService:JSONDecode(p8.Body).metadata

			p6(tonumber(metadata.placeId), (tonumber(metadata.placeVersion)))

			return nil
		end

		warn("Failed to get metadata for GUID: " .. tostring(p5) .. " Error: " .. tostring(p8.Status))

		for k, v in pairs(p8) do
			print(k, v)
		end

		return nil
	end)
end
function t1.loadGUIDSlices(_, p10, _, _) -- line: 116
	local v19 = getMetadataForGuid(p10)

	print(v19)
end
function t1.loadGUID(p13, p14) -- line: 121
	-- upvalues: ExperienceStateRecordingService (copy), t1 (copy)
	debugPrint("Loading slices for GUID: " .. tostring(p14))
	getMetadataForGuid(p14, function(p15, p16) -- line: 125
		-- upvalues: ExperienceStateRecordingService (copy), p14 (copy), p13 (copy), t1 (copy)
		debugPrint("Received metadata - PlaceId: " .. tostring(p15) .. " PlaceVersion: " .. tostring(p16))

		local v42 = ExperienceStateRecordingService:ListCaptureURLsAsync(p14, "2024-12-10T00:20:14.556Z", "2026-12-18T00:25:59.412Z")
		local PlaceFileURLAsync = ExperienceStateRecordingService:GetPlaceFileURLAsync(p16, p15)

		p13.LoadingOverlay.Visible = true
		p13.state.Loading = true
		p13.minLoadedFrameNumber = 0
		p13.maxLoadedFrameNumber = 0
		p13.minLoadedEpoch = 0
		p13.maxLoadedEpoch = 0
		p13.minOverallEpoch = nil
		p13.maxOverallEpoch = nil
		p13.nextSliceToLoad = nil
		p13.noncontiguousSliceToLoad = nil
		p13.recordingsToPlayback = v42.urls
		p13.placeURL = PlaceFileURLAsync
		p13.sourceType = Enum.ExperienceStateRecordingLoadSourceType.S3Url

		for v44, v45 in p13.recordingsToPlayback do
			debugPrint("Recording " .. tostring(v44) .. " " .. v45)
		end

		task.spawn(function() -- line: 155
			-- upvalues: ExperienceStateRecordingService (copy), p13 (copy), t1 (copy)
			local ok, result = pcall(function() -- line: 156
				-- upvalues: ExperienceStateRecordingService (copy), p13 (copy), t1 (copy)
				local v58 = ExperienceStateRecordingService:LoadPlaybackAsync(p13.recordingsToPlayback[1], p13.placeURL, Enum.ExperienceStateRecordingLoadMode.NewReplay, p13.sourceType)

				t1.SetLoadedState(p13, v58)
				p13.nextSliceToLoad = 2
				p13.LoadingOverlay.Visible = false
				p13.state.Loading = false
				p13.ControlButtons(p13.PlayButton)
				task.spawn(t1.loadSlicesAfterFirst, p13)
			end)

			if not ok then
				p13.LoadingLabel.Text = "Failed To Load Initial Slice, See Logs"
				warn("Failed to load initial slice because " .. tostring(result))
			end
		end)
	end)
end
function t1.experienceCallback(p17) -- line: 182
	-- upvalues: TeleportService (copy), t1 (copy)
	local LocalPlayerTeleportData = TeleportService:GetLocalPlayerTeleportData()

	if LocalPlayerTeleportData then
		if LocalPlayerTeleportData.directGuid then
			t1.loadGUID(p17, LocalPlayerTeleportData.directGuid)

			return
		end

		debugPrint("No direct GUID found in teleport data, falling back to loading slices")
		t1.loadSlices(p17)
	end
end
function t1.loadSlices(p18) -- line: 196
	-- upvalues: TeleportService (copy), ExperienceStateRecordingService (copy), t1 (copy)
	p18.LoadingOverlay.Visible = true
	p18.state.Loading = true
	p18.minLoadedFrameNumber = 0
	p18.maxLoadedFrameNumber = 0
	p18.minLoadedEpoch = 0
	p18.maxLoadedEpoch = 0
	p18.minOverallEpoch = nil
	p18.maxOverallEpoch = nil
	p18.nextSliceToLoad = nil
	p18.noncontiguousSliceToLoad = nil

	local LocalPlayerTeleportData = TeleportService:GetLocalPlayerTeleportData()

	p18.recordingsToPlayback = { "/path/to/default/file" }
	p18.sourceType = Enum.ExperienceStateRecordingLoadSourceType.File

	if LocalPlayerTeleportData then
		p18.recordingsToPlayback = LocalPlayerTeleportData.captureURLs

		if LocalPlayerTeleportData.startTime then
			p18.minOverallEpoch = LocalPlayerTeleportData.startTime.UnixTimestampMillis
		end

		if LocalPlayerTeleportData.endTime then
			p18.maxOverallEpoch = LocalPlayerTeleportData.endTime.UnixTimestampMillis
		end

		p18.sourceType = Enum.ExperienceStateRecordingLoadSourceType:FromValue(LocalPlayerTeleportData.sourceType)
		p18.placeURL = LocalPlayerTeleportData.placeURL
	end

	for v26, v27 in p18.recordingsToPlayback do
		debugPrint("Recording " .. tostring(v26) .. " " .. v27)
	end

	task.spawn(function() -- line: 238
		-- upvalues: ExperienceStateRecordingService (copy), p18 (copy), t1 (copy)
		local ok, result = pcall(function() -- line: 239
			-- upvalues: ExperienceStateRecordingService (copy), p18 (copy), t1 (copy)
			local v57 = ExperienceStateRecordingService:LoadPlaybackAsync(p18.recordingsToPlayback[1], p18.placeURL, Enum.ExperienceStateRecordingLoadMode.NewReplay, p18.sourceType)

			t1.SetLoadedState(p18, v57)
			p18.nextSliceToLoad = 2
			p18.LoadingOverlay.Visible = false
			p18.state.Loading = false
			p18.ControlButtons(p18.PlayButton)
			task.spawn(t1.loadSlicesAfterFirst, p18)
		end)

		if not ok then
			p18.LoadingLabel.Text = "Failed To Load Initial Slice, See Logs"
			warn("Failed to load initial slice because " .. tostring(result))
		end
	end)
end
function t1.loadSlicesAfterFirst(p19) -- line: 262
	-- upvalues: ExperienceStateRecordingService (copy), t1 (copy)
	local ok, result = pcall(function() -- line: 263
		-- upvalues: p19 (copy), ExperienceStateRecordingService (copy), t1 (copy)
		local n1 = 0

		while true do
			task.wait(1)

			if p19.noncontiguousSliceToLoad ~= nil then
				local v49 = p19.recordingsToPlayback[p19.noncontiguousSliceToLoad]

				debugPrint("loading noncontiguous " .. tostring(p19.noncontiguousSliceToLoad) .. " url " .. v49)

				local v50 = ExperienceStateRecordingService:LoadPlaybackAsync(v49, nil, Enum.ExperienceStateRecordingLoadMode.NoncontiguousSlice, p19.sourceType)

				t1.SetLoadedState(p19, v50)

				local v51 = (p19.playbackSecondToFetch - p19.replayToLoadedStartSeconds) / p19.loadedLengthSeconds

				ExperienceStateRecordingService:SetPlaybackPercentage(v51)
				p19.LoadingOverlay.Visible = false
				p19.state.Loading = false
				n1 = 0
				p19.nextSliceToLoad = p19.noncontiguousSliceToLoad + 1
				p19.noncontiguousSliceToLoad = nil
			elseif p19.nextSliceToLoad <= #p19.recordingsToPlayback and n1 >= 4 then
				local v52 = p19.recordingsToPlayback[p19.nextSliceToLoad]

				debugPrint("loading contiguous " .. tostring(p19.nextSliceToLoad) .. " url " .. v52)

				local v53 = ExperienceStateRecordingService:LoadPlaybackAsync(v52, nil, Enum.ExperienceStateRecordingLoadMode.ContiguousSlice, p19.sourceType)

				t1.SetLoadedState(p19, v53)

				local v54 = p19

				v54.nextSliceToLoad = v54.nextSliceToLoad + 1
				n1 = 0
			else
				n1 += 1
			end
		end
	end)

	if not ok then
		p19.LoadingLabel.Text = "Failed To Load Later Slice, See Logs"
		warn("Failed to load later slice because " .. tostring(result))
	end
end
function t1.loadNoncontiguousSlice(p20, p21) -- line: 335
	if p20.noncontiguousSliceToLoad ~= nil then
		warn("skipping non-contiguous slice load as still waiting for last jump")
	end

	p20.LoadingOverlay.Visible = true
	p20.state.Loading = true

	local v33 = p21 * p20.overallLengthSeconds
	local v34 = math.floor(v33 / 60)

	p20.noncontiguousSliceToLoad = math.min(v34 + 1, #p20.recordingsToPlayback)
	p20.playbackSecondToFetch = v33
	debugPrint("percentOverallLength " .. tostring(p21) .. " playbackSecondToFetch " .. tostring(v33) .. " playbackMinuteToFetch " .. tostring(v34) .. " nextSliceToLoad " .. tostring(p20.nextSliceToLoad))
end

return t1
