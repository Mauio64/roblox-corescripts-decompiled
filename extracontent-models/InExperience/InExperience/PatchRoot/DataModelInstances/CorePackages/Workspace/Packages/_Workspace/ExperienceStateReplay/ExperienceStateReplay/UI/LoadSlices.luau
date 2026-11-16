local TeleportService = game:GetService("TeleportService")
local ExperienceStateRecordingService = game:GetService("ExperienceStateRecordingService")
local HttpService = game:GetService("HttpService")

local LoadSlices = {}

function debugPrint(_) end

function LoadSlices:SetLoadedState(data)
	debugPrint("playResult minFrameNumber " .. tostring(data.minFrameNumber) .. " maxFrameNumber " .. tostring(data.maxFrameNumber) .. " minEpoch " .. tostring(data.minEpoch) .. " - " .. tostring(DateTime.fromUnixTimestampMillis(data.minEpoch):ToIsoDate()) .. " maxEpoch " .. tostring(data.maxEpoch) .. " - " .. tostring(DateTime.fromUnixTimestampMillis(data.maxEpoch):ToIsoDate()))

	self.minLoadedFrameNumber = data.minFrameNumber
	self.maxLoadedFrameNumber = data.maxFrameNumber
	self.minLoadedEpoch = data.minEpoch
	self.maxLoadedEpoch = data.maxEpoch

	if self.minOverallEpoch == nil then
		self.minOverallEpoch = self.minLoadedEpoch
		self.maxOverallEpoch = self.maxLoadedEpoch
	elseif self.sourceType == Enum.ExperienceStateRecordingLoadSourceType.File then
		self.minOverallEpoch = math.min(self.minLoadedEpoch, self.minOverallEpoch)
		self.maxOverallEpoch = math.max(self.maxLoadedEpoch, self.maxOverallEpoch)
	end

	self.loadedLengthSeconds = (self.maxLoadedEpoch - self.minLoadedEpoch) / 1000

	self.overallLengthSeconds = (self.maxOverallEpoch - self.minOverallEpoch) / 1000

	self.replayToLoadedStartSeconds = (self.minLoadedEpoch - self.minOverallEpoch) / 1000

	debugPrint("minOverallEpoch " .. tostring(self.minOverallEpoch) .. " maxOverallEpoch " .. tostring(self.maxOverallEpoch) .. " overallLengthSeconds " .. tostring(self.overallLengthSeconds) .. " loadedLengthSeconds " .. tostring(self.loadedLengthSeconds))

	local v = self.loadedLengthSeconds / self.overallLengthSeconds
	self.ScrubberLoadProgress.Size = UDim2.new(v, 0, 1, 0)
	local v2 = self.replayToLoadedStartSeconds / self.overallLengthSeconds
	self.ScrubberLoadProgress.Position = UDim2.new(v2, 0, 0, 0)
	debugPrint("loadedPercent " .. tostring(v) .. " loadedStartPercent " .. tostring(v2))
end

function _getMetadataForUser(p)
	local listRecordingsAsync = ExperienceStateRecordingService:ListRecordingsAsync(p, "")

	print(listRecordingsAsync)
end

function getMetadataForGuid(engineContextGuid, callback)
	return HttpService:RequestInternal({
		Url = "https://apis.roblox.com/data-model-capture-service/v1/GetCaptureMetadataByEngineContextGuid",
		Method = "POST",
		Body = HttpService:JSONEncode({ engineContextGuid = engineContextGuid }),
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
	}):Start(function(p, p2): nil
		if p then
			print(p2.Body)
			local metadata = HttpService:JSONDecode(p2.Body).metadata

			callback(tonumber(metadata.placeId), (tonumber(metadata.placeVersion)))

			return nil
		end

		warn("Failed to get metadata for GUID: " .. tostring(engineContextGuid) .. " Error: " .. tostring(p2.Status))

		for k, v in pairs(p2) do
			print(k, v)
		end

		return nil
	end)
end

function LoadSlices.loadGUIDSlices(_, p, _, _)
	local metadataForGuid = getMetadataForGuid(p)
	print(metadataForGuid)
end

function LoadSlices:loadGUID(p)
	debugPrint("Loading slices for GUID: " .. tostring(p))

	getMetadataForGuid(p, function(p2, p3)
		debugPrint("Received metadata - PlaceId: " .. tostring(p2) .. " PlaceVersion: " .. tostring(p3))

		local listCaptureURLsAsync = ExperienceStateRecordingService:ListCaptureURLsAsync(
			p,
			"2024-12-10T00:20:14.556Z",
			"2026-12-18T00:25:59.412Z"
		)
		local placeFileURLAsync = ExperienceStateRecordingService:GetPlaceFileURLAsync(p3, p2)

		self.LoadingOverlay.Visible = true
		self.state.Loading = true

		self.minLoadedFrameNumber = 0
		self.maxLoadedFrameNumber = 0
		self.minLoadedEpoch = 0
		self.maxLoadedEpoch = 0
		self.minOverallEpoch = nil
		self.maxOverallEpoch = nil

		self.nextSliceToLoad = nil
		self.noncontiguousSliceToLoad = nil

		self.recordingsToPlayback = listCaptureURLsAsync.urls

		self.placeURL = placeFileURLAsync

		self.sourceType = Enum.ExperienceStateRecordingLoadSourceType.S3Url

		for k, v in self.recordingsToPlayback do
			debugPrint("Recording " .. tostring(k) .. " " .. v)
		end

		task.spawn(function()
			local success, result = pcall(function()
				local playbackAsync = ExperienceStateRecordingService:LoadPlaybackAsync(
					self.recordingsToPlayback[1],
					self.placeURL,
					Enum.ExperienceStateRecordingLoadMode.NewReplay,
					self.sourceType
				)

				LoadSlices.SetLoadedState(self, playbackAsync)
				self.nextSliceToLoad = 2
				self.LoadingOverlay.Visible = false
				self.state.Loading = false
				self.ControlButtons(self.PlayButton)

				task.spawn(LoadSlices.loadSlicesAfterFirst, self)
			end)

			if not success then
				self.LoadingLabel.Text = "Failed To Load Initial Slice, See Logs"
				warn("Failed to load initial slice because " .. tostring(result))
			end
		end)
	end)
end

function LoadSlices.experienceCallback(p)
	local localPlayerTeleportData = TeleportService:GetLocalPlayerTeleportData()

	if localPlayerTeleportData then
		if localPlayerTeleportData.directGuid then
			LoadSlices.loadGUID(p, localPlayerTeleportData.directGuid)
		else
			debugPrint("No direct GUID found in teleport data, falling back to loading slices")
			LoadSlices.loadSlices(p)
		end
	end
end

function LoadSlices:loadSlices()
	self.LoadingOverlay.Visible = true
	self.state.Loading = true

	self.minLoadedFrameNumber = 0
	self.maxLoadedFrameNumber = 0
	self.minLoadedEpoch = 0
	self.maxLoadedEpoch = 0
	self.minOverallEpoch = nil
	self.maxOverallEpoch = nil

	self.nextSliceToLoad = nil
	self.noncontiguousSliceToLoad = nil

	local localPlayerTeleportData = TeleportService:GetLocalPlayerTeleportData()
	self.recordingsToPlayback = { "/path/to/default/file" }

	self.sourceType = Enum.ExperienceStateRecordingLoadSourceType.File

	if localPlayerTeleportData then
		self.recordingsToPlayback = localPlayerTeleportData.captureURLs

		if localPlayerTeleportData.startTime then
			self.minOverallEpoch = localPlayerTeleportData.startTime.UnixTimestampMillis
		end

		if localPlayerTeleportData.endTime then
			self.maxOverallEpoch = localPlayerTeleportData.endTime.UnixTimestampMillis
		end

		self.sourceType = Enum.ExperienceStateRecordingLoadSourceType:FromValue(localPlayerTeleportData.sourceType)
		self.placeURL = localPlayerTeleportData.placeURL
	end

	for k, v in self.recordingsToPlayback do
		debugPrint("Recording " .. tostring(k) .. " " .. v)
	end

	task.spawn(function()
		local success, result = pcall(function()
			local playbackAsync = ExperienceStateRecordingService:LoadPlaybackAsync(
				self.recordingsToPlayback[1],
				self.placeURL,
				Enum.ExperienceStateRecordingLoadMode.NewReplay,
				self.sourceType
			)

			LoadSlices.SetLoadedState(self, playbackAsync)
			self.nextSliceToLoad = 2
			self.LoadingOverlay.Visible = false
			self.state.Loading = false
			self.ControlButtons(self.PlayButton)

			task.spawn(LoadSlices.loadSlicesAfterFirst, self)
		end)

		if not success then
			self.LoadingLabel.Text = "Failed To Load Initial Slice, See Logs"
			warn("Failed to load initial slice because " .. tostring(result))
		end
	end)
end

function LoadSlices:loadSlicesAfterFirst()
	local success, result = pcall(function()
		local count = 0

		while true do
			task.wait(1)

			if self.noncontiguousSliceToLoad == nil then
				if self.nextSliceToLoad <= #self.recordingsToPlayback and count >= 4 then
					local v = self.recordingsToPlayback[self.nextSliceToLoad]
					debugPrint("loading contiguous " .. tostring(self.nextSliceToLoad) .. " url " .. v)

					local playbackAsync = ExperienceStateRecordingService:LoadPlaybackAsync(
						v,
						nil,
						Enum.ExperienceStateRecordingLoadMode.ContiguousSlice,
						self.sourceType
					)

					LoadSlices.SetLoadedState(self, playbackAsync)

					self.nextSliceToLoad += 1
					count = 0
				else
					count += 1
				end
			else
				local v = self.recordingsToPlayback[self.noncontiguousSliceToLoad]
				debugPrint("loading noncontiguous " .. tostring(self.noncontiguousSliceToLoad) .. " url " .. v)

				local playbackAsync = ExperienceStateRecordingService:LoadPlaybackAsync(
					v,
					nil,
					Enum.ExperienceStateRecordingLoadMode.NoncontiguousSlice,
					self.sourceType
				)

				LoadSlices.SetLoadedState(self, playbackAsync)

				ExperienceStateRecordingService:SetPlaybackPercentage((self.playbackSecondToFetch - self.replayToLoadedStartSeconds) / self.loadedLengthSeconds)

				self.LoadingOverlay.Visible = false
				self.state.Loading = false

				self.nextSliceToLoad = self.noncontiguousSliceToLoad + 1
				self.noncontiguousSliceToLoad = nil
				count = 0
			end
		end
	end)

	if not success then
		self.LoadingLabel.Text = "Failed To Load Later Slice, See Logs"
		warn("Failed to load later slice because " .. tostring(result))
	end
end

function LoadSlices:loadNoncontiguousSlice(p)
	if self.noncontiguousSliceToLoad ~= nil then
		warn("skipping non-contiguous slice load as still waiting for last jump")
	end

	self.LoadingOverlay.Visible = true
	self.state.Loading = true

	local playbackSecondToFetch = p * self.overallLengthSeconds
	local v = math.floor(playbackSecondToFetch / 60)
	self.noncontiguousSliceToLoad = math.min(v + 1, #self.recordingsToPlayback)
	self.playbackSecondToFetch = playbackSecondToFetch
	debugPrint("percentOverallLength " .. tostring(p) .. " playbackSecondToFetch " .. tostring(playbackSecondToFetch) .. " playbackMinuteToFetch " .. tostring(v) .. " nextSliceToLoad " .. tostring(self.nextSliceToLoad))
end

return LoadSlices
