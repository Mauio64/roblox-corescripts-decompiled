local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local parent = MomentsCreationFlow.Parent

local AssetService = game:GetService("AssetService")

local Dash = require(parent.Dash)
require(parent.MomentsCommon)

local CreationFlowMusicInfoRetrieved = require(MomentsCreationFlow.Actions.CreationFlowMusicInfoRetrieved)
local MusicSearchRetrieved = require(MomentsCreationFlow.Actions.MusicSearchRetrieved)

local Constants = require(MomentsCreationFlow.Constants)

local function filterCreator(p): boolean
	return not Dash.includes(Constants.SearchMusicCreatorFilter, p.Creator.Id)
end

local function filterRecordingCode(p): boolean
	return p.RecordingCode ~= nil
end

local function formatMusic(filtered)
	local result = {}

	for _, item in ipairs(filtered) do
		if item.Id ~= nil then
			result[item.Id] = {
				Artist = item.Artist,
				AssetId = item.Id,
				AudioType = item.AudioType,
				Duration = item.Duration,
				RecordingCode = item.RecordingCode,
				Title = item.Title
			}
		end
	end

	return result
end

local function SearchMusic(searchKeyword, value)
	return function(object)
		local audioSearchParams = Instance.new("AudioSearchParams")
		audioSearchParams.SearchKeyword = searchKeyword
		audioSearchParams.AudioSubType = Enum.AudioSubType.Music
		audioSearchParams.MinDuration = value or 30

		task.spawn(function()
			local success, result = pcall(function()
				return AssetService:SearchAudio(audioSearchParams)
			end)

			if not success then
				warn("Failed to retrieve musics: " .. result)
				return
			end

			local currentPage = result:GetCurrentPage()

			local filtered = Dash.filter(currentPage, filterCreator)
			local audioMetadataAsync = AssetService:GetAudioMetadataAsync((Dash.map(filtered, function(p)
				return p.Id
			end)))
			local filtered2 = Dash.filter(audioMetadataAsync, filterRecordingCode)
			object:dispatch(CreationFlowMusicInfoRetrieved(formatMusic(filtered2)))
			object:dispatch(MusicSearchRetrieved(Dash.map(filtered2, function(p)
				return (tonumber(p.AssetId))
			end)))
		end)
	end
end

return SearchMusic
