local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Dash")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Constants")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/Music")

local FFlagMomentsCreationSkipRecordingCodeFilter = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsCreationSkipRecordingCodeFilter")

local FFlagMomentsCreationMusicSkipMetadataFetch = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsCreationMusicSkipMetadataFetch")

local FFlagMomentsCreationAudioSearchV2SortType = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsCreationAudioSearchV2SortType")

local reportMusicSearchCounts = MomentsCommon.Analytics.reportMusicSearchCounts

local function formatMusic(items)
	local result = {}

	for k, item in items do
		local assetId = tonumber(item.AssetId)

		if assetId ~= nil and (FFlagMomentsCreationSkipRecordingCodeFilter or item.RecordingCode ~= nil) then
			table.insert(result, {
				Artist = item.Artist,
				AssetId = assetId,
				AudioType = item.AudioType,
				Duration = item.Duration,
				RecordingCode = item.RecordingCode,
				Title = item.Title
			})
		end
	end

	return result
end

local function formatSearchResults(items)
	local count = 0
	local result = {}

	for k, item in items do
		local id = item.Id

		if id == nil or Dash.includes(Constants.SearchMusicCreatorDenylist, item.Creator.Id) then
			continue
		end

		count += 1

		if item.Purchasable ~= false then
			table.insert(result, {
				Artist = item.Artist,
				AssetId = id,
				AudioType = item.AudioType,
				Duration = item.Duration,
				Title = item.Title
			})
		end
	end

	return result, count
end

local function createMusicSource(p2)
	local function getAssetService()
		return p2 or game:GetService("AssetService")
	end

	local function formatPage(object, currentPage)
		if FFlagMomentsCreationMusicSkipMetadataFetch and FFlagMomentsCreationSkipRecordingCodeFilter then
			return formatSearchResults(currentPage)
		end

		local ids = {}

		for k, item in currentPage do
			if not Dash.includes(Constants.SearchMusicCreatorDenylist, item.Creator.Id) then
				table.insert(ids, item.Id)
			end
		end

		local v5 = #ids == 0 and {} or object:GetAudioMetadataAsync(ids)
		return formatMusic(v5), #v5
	end

	return {
		searchMusic = function(searchKeyword, minDuration)
			local v5 = p2 or game:GetService("AssetService")

			local audioSearchParams = Instance.new("AudioSearchParams")
			audioSearchParams.SearchKeyword = searchKeyword
			audioSearchParams.AudioSubType = Enum.AudioSubType.Music
			audioSearchParams.MinDuration = minDuration

			if FFlagMomentsCreationAudioSearchV2SortType then
				pcall(function()
					local audioSortType = Enum.AudioSortType
					local v6 = audioSearchParams
					local v7 = if searchKeyword == "" then audioSortType.MostUsed else audioSortType.Relevance
					v6.SortType = v7
				end)
			end

			local audio = v5:SearchAudio(audioSearchParams)
			local v6, v7 = formatPage(v5, audio:GetCurrentPage())

			reportMusicSearchCounts(v7, #v6, {
				queryPresent = searchKeyword ~= ""
			})

			return v6, {
				isFinished = function(): boolean
					return audio.IsFinished == true
				end,
				nextPage = function()
					audio:AdvanceToNextPageAsync()
					return (formatPage(v5, audio:GetCurrentPage()))
				end
			}
		end,
		getMetadata = function(p3)
			return formatMusic((p2 or game:GetService("AssetService")):GetAudioMetadataAsync(p3))
		end
	}
end

return createMusicSource
