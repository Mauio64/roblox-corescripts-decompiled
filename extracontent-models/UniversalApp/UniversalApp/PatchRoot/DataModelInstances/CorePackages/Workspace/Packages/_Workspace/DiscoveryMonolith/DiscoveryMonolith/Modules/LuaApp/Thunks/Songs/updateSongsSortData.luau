local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local AddSongs = require(Parent.SongInfosRodux).AddSongs

require(Parent.DiscoveryTypes)

local TopicContentsRodux = require(Parent.TopicContentsRodux)
local TopicContentsEntryModel = TopicContentsRodux.TopicContentsEntryModel
local TopicContentsModel = TopicContentsRodux.TopicContentsModel
local AddTopicContents = TopicContentsRodux.AddTopicContents
local SongInfoModel = require(Parent.SongModels).SongInfoModel
local FFlagEnableTopSongsSort = require(Parent.SharedFlags).FFlagEnableTopSongsSort

return function(p1, p2, p3, _) -- line: 12
	-- upvalues: FFlagEnableTopSongsSort (copy), TopicContentsEntryModel (copy), SongInfoModel (copy), AddSongs (copy), TopicContentsModel (copy), AddTopicContents (copy)
	assert(FFlagEnableTopSongsSort, "Songs sort is not enabled")

	local t1 = {}
	local t2 = {}
	local songs = p2.songs

	if #songs == 0 then
		warn(`Found no songs in this sort: { p2.sortDisplayName }`)
	end

	local function forEachSongInfo(p5) -- line: 22
		-- upvalues: TopicContentsEntryModel (copy), t1 (copy), SongInfoModel (copy), t2 (copy)
		TopicContentsEntryModel.songFromExploreApiData(p5):match(function(p6) -- line: 24
			-- upvalues: t1 (copy)
			table.insert(t1, p6)
		end):matchError(function(p7) -- line: 27
			warn(p7)
		end)
		SongInfoModel.fromExploreApi(p5):match(function(p8) -- line: 32
			-- upvalues: t2 (copy)
			t2[p8.assetId] = p8
		end):matchError(function(p9) -- line: 35
			warn(p9)
		end)
	end

	for _, v in ipairs(songs) do
		forEachSongInfo(v)
	end

	p1:dispatch(AddSongs(t2))

	local t3 = {
		nextPageExclusiveStartId = 0,
		rowsRequested = 0,
		entries = t1,
		hasMoreRows = p2.nextPageToken ~= nil and p2.nextPageToken ~= "",
		nextPageToken = p2.nextPageToken
	}

	if not p3 then
		t3.updatedTimestamp = tick()
	end

	local v20 = TopicContentsModel.fromData(t3)

	p1:dispatch(AddTopicContents(p2.sortId, v20, p3))
end
