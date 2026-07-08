local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local MomentsCreationFlowParent = MomentsCreationFlow.Parent
local AssetService = game:GetService("AssetService")
local Dash = require(MomentsCreationFlowParent.Dash)

require(MomentsCreationFlowParent.MomentsCommon)

local CreationFlowMusicInfoRetrieved = require(MomentsCreationFlow.Actions.CreationFlowMusicInfoRetrieved)
local MusicSearchRetrieved = require(MomentsCreationFlow.Actions.MusicSearchRetrieved)
local Constants = require(MomentsCreationFlow.Constants)

local function filterCreator(p1) -- line: 18
	-- upvalues: Dash (copy), Constants (copy)
	return not Dash.includes(Constants.SearchMusicCreatorFilter, p1.Creator.Id)
end
local function filterRecordingCode(p2) -- line: 22
	return p2.RecordingCode ~= nil
end
local function formatMusic(t1: {[any]: any}) -- line: 26
	local t2 = {}

	for _, v in ipairs(t1) do
		if v.Id ~= nil then
			t2[v.Id] = {
				Artist = v.Artist,
				AssetId = v.Id,
				AudioType = v.AudioType,
				Duration = v.Duration,
				RecordingCode = v.RecordingCode,
				Title = v.Title
			}
		end
	end

	return t2
end
local function SearchMusic(p3, p4) -- line: 45
	-- upvalues: AssetService (copy), Dash (copy), filterCreator (copy), filterRecordingCode (copy), CreationFlowMusicInfoRetrieved (copy), formatMusic (copy), MusicSearchRetrieved (copy)
	return function(p5) -- line: 46
		-- upvalues: p3 (copy), p4 (copy), AssetService (copy), Dash (copy), filterCreator (copy), filterRecordingCode (copy), CreationFlowMusicInfoRetrieved (copy), formatMusic (copy), MusicSearchRetrieved (copy)
		local AudioSearchParams = Instance.new("AudioSearchParams")

		AudioSearchParams.SearchKeyword = p3
		AudioSearchParams.AudioSubType = Enum.AudioSubType.Music
		AudioSearchParams.MinDuration = p4 or 30
		task.spawn(function() -- line: 52
			-- upvalues: AssetService (copy), AudioSearchParams (copy), Dash (copy), filterCreator (copy), filterRecordingCode (copy), p5 (copy), CreationFlowMusicInfoRetrieved (copy), formatMusic (copy), MusicSearchRetrieved (copy)
			local ok, result = pcall(function() -- line: 53
				-- upvalues: AssetService (copy), AudioSearchParams (copy)
				return AssetService:SearchAudio(AudioSearchParams)
			end)

			if not ok then
				warn("Failed to retrieve musics: " .. result)

				return
			end

			local CurrentPage = result:GetCurrentPage()
			local v25 = Dash.filter(CurrentPage, filterCreator)
			local v26 = Dash.map(v25, function(p6) -- line: 65
				return p6.Id
			end)
			local AudioMetadataAsync = AssetService:GetAudioMetadataAsync(v26)
			local v28 = Dash.filter(AudioMetadataAsync, filterRecordingCode)

			p5:dispatch(CreationFlowMusicInfoRetrieved((formatMusic(v28))))
			p5:dispatch(MusicSearchRetrieved(Dash.map(v28, function(p7) -- line: 72
				return (tonumber(p7.AssetId))
			end)))
		end)
	end
end

return SearchMusic
