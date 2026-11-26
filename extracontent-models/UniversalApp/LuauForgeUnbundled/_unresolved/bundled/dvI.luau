local addSongs = require("@luauforge/bundled/dvJ").AddSongs
require("@luauforge/bundled/dtp")
local module = require("@luauforge/bundled/dtu")
local topicContentsEntryModel = module.TopicContentsEntryModel
local topicContentsModel = module.TopicContentsModel
local addTopicContents = module.AddTopicContents
local songInfoModel = require("@luauforge/bundled/dvV").SongInfoModel
local fFlagEnableTopSongsSort = require("@luauforge/bundled/dtD").FFlagEnableTopSongsSort

return function(object, data, p2, p3)
	assert(fFlagEnableTopSongsSort, "Songs sort is not enabled")
	local v5 = {}
	local v6 = {}
	local songs = data.songs

	if #songs == 0 then
		warn(`Found no songs in this sort: {data.sortDisplayName}`)
	end

	local function forEachSongInfo(song)
		topicContentsEntryModel.songFromExploreApiData(song):match(function(p4)
			table.insert(v5, p4)
		end):matchError(function(p4)
			warn(p4)
		end)

		songInfoModel.fromExploreApi(song):match(function(p4)
			v6[p4.assetId] = p4
		end):matchError(function(p4)
			warn(p4)
		end)
	end

	for i, song in ipairs(songs) do
		forEachSongInfo(song)
	end

	object:dispatch(addSongs(v6))

	local v7 = {
		entries = v5,
		hasMoreRows = data.nextPageToken ~= nil and data.nextPageToken ~= "",
		nextPageToken = data.nextPageToken,
		nextPageExclusiveStartId = 0,
		rowsRequested = 0
	}

	if not p2 then
		v7.updatedTimestamp = tick()
	end

	local v9 = topicContentsModel.fromData(v7)
	object:dispatch(addTopicContents(data.sortId, v9, p2))
end
