local module = require("@luauforge/bundled/dtf")
local gameInfoModel = require("@luauforge/bundled/dth").GameInfoModel
local parseAndAddGameInfos = require("@luauforge/bundled/dto").parseAndAddGameInfos
local module2 = require("@luauforge/bundled/dtu")
local topicContentsEntryModel = module2.TopicContentsEntryModel
local topicContentsModel = module2.TopicContentsModel
local addTopicContents = module2.AddTopicContents

return function(p2, object, data, p3)
	local values = {}

	local games = data.games

	if #games == 0 then
		warn("Found no games in this sort:", data.sortDisplayName)
	end

	local function forEachGameInfo(p4, p5)
		topicContentsEntryModel.fromExploreApiData(p4):match(function(p6)
			local joined = module.Dictionary.join(p5, p6)
			table.insert(values, joined)
		end):matchError(function(p6)
			warn(p6)
		end)
	end

	parseAndAddGameInfos(p2, object, games, gameInfoModel.fromOmniApi, forEachGameInfo)

	local v5 = {
		entries = values,
		hasMoreRows = data.nextPageToken ~= nil and data.nextPageToken ~= "",
		nextPageToken = data.nextPageToken,
		nextPageExclusiveStartId = 0,
		rowsRequested = 0
	}

	if not p3 then
		v5.updatedTimestamp = tick()
	end

	local v7 = topicContentsModel.fromData(v5)

	object:dispatch(addTopicContents(data.sortId, v7, p3))
end
