local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local Cryo = require(Parent.Cryo)
local GameInfoModel = require(Parent.GameModels).GameInfoModel
local parseAndAddGameInfos = require(Parent.GameInfosRodux).parseAndAddGameInfos
local TopicContentsRodux = require(Parent.TopicContentsRodux)
local TopicContentsEntryModel = TopicContentsRodux.TopicContentsEntryModel
local TopicContentsModel = TopicContentsRodux.TopicContentsModel
local AddTopicContents = TopicContentsRodux.AddTopicContents

return function(p1, p2, p3, p4) -- line: 12
	-- upvalues: TopicContentsEntryModel (copy), Cryo (copy), parseAndAddGameInfos (copy), GameInfoModel (copy), TopicContentsModel (copy), AddTopicContents (copy)
	local t1 = {}
	local games = p3.games

	if #games == 0 then
		warn("Found no games in this sort:", p3.sortDisplayName)
	end

	local function forEachGameInfo(p5, p6) -- line: 21
		-- upvalues: TopicContentsEntryModel (copy), Cryo (copy), t1 (copy)
		TopicContentsEntryModel.fromExploreApiData(p5):match(function(p7) -- line: 25
			-- upvalues: Cryo (copy), p6 (copy), t1 (copy)
			local v21 = Cryo.Dictionary.join(p6, p7)

			table.insert(t1, v21)
		end):matchError(function(p8) -- line: 29
			warn(p8)
		end)
	end

	parseAndAddGameInfos(p1, p2, games, GameInfoModel.fromOmniApi, forEachGameInfo)

	local t2 = {
		nextPageExclusiveStartId = 0,
		rowsRequested = 0,
		entries = t1,
		hasMoreRows = p3.nextPageToken ~= nil and p3.nextPageToken ~= "",
		nextPageToken = p3.nextPageToken
	}

	if not p4 then
		t2.updatedTimestamp = tick()
	end

	local v17 = TopicContentsModel.fromData(t2)

	p2:dispatch(AddTopicContents(p3.sortId, v17, p4))
end
