local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Dash = require(parent.Dash)
local MomentsCommon = require(parent.MomentsCommon)

local Constants = require(MomentsCreation.Constants)
require(MomentsCreation.Types.Music)

local FFlagMomentsCreationSkipRecordingCodeFilter = require(MomentsCreation.Flags.FFlagMomentsCreationSkipRecordingCodeFilter)

local FFlagMomentsCreationMusicSkipMetadataFetch = require(MomentsCreation.Flags.FFlagMomentsCreationMusicSkipMetadataFetch)

local FFlagMomentsCreationAudioSearchV2SortType = require(MomentsCreation.Flags.FFlagMomentsCreationAudioSearchV2SortType)

local reportMusicSearchCounts = MomentsCommon.Analytics.reportMusicSearchCounts

local function formatMusic(items)
	local result = {}

	for _, item in items do
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

	for _, item in items do
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

local function createMusicSource(p)
	local function getAssetService() -- 2 equivalent calls inferred from this helper
		return p or game:GetService("AssetService")
	end

	local function formatPage(assetService, currentPage)
		if FFlagMomentsCreationMusicSkipMetadataFetch and FFlagMomentsCreationSkipRecordingCodeFilter then
			return formatSearchResults(currentPage)
		end

		local ids = {}

		for _, item in currentPage do
			if not Dash.includes(Constants.SearchMusicCreatorDenylist, item.Creator.Id) then
				table.insert(ids, item.Id)
			end
		end

		local v = #ids == 0 and {} or assetService:GetAudioMetadataAsync(ids)
		return formatMusic(v), #v
	end

	return {
		searchMusic = function(searchKeyword: string, minDuration: number)
			local assetService = getAssetService() -- inferred equivalent call
			local audioSearchParams = Instance.new("AudioSearchParams")
			audioSearchParams.SearchKeyword = searchKeyword
			audioSearchParams.AudioSubType = Enum.AudioSubType.Music
			audioSearchParams.MinDuration = minDuration

			if FFlagMomentsCreationAudioSearchV2SortType then
				pcall(function()
					local audioSortType = Enum.AudioSortType
					local sortType

					if searchKeyword == "" then
						sortType = audioSortType.MostUsed
					else
						sortType = audioSortType.Relevance
					end

					audioSearchParams.SortType = sortType
				end)
			end

			local audio = assetService:SearchAudio(audioSearchParams)
			local v, v2 = formatPage(assetService, audio:GetCurrentPage())

			reportMusicSearchCounts(v2, #v, {
				queryPresent = searchKeyword ~= ""
			})

			return v, {
				isFinished = function(): boolean
					return audio.IsFinished == true
				end,
				nextPage = function()
					audio:AdvanceToNextPageAsync()
					return (formatPage(assetService, audio:GetCurrentPage()))
				end
			}
		end,
		getMetadata = function(p2)
			return formatMusic(getAssetService():GetAudioMetadataAsync(p2)) -- inferred equivalent call
		end
	}
end

return createMusicSource
