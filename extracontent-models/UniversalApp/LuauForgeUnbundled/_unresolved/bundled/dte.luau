local module = require("@luauforge/bundled/dtf")
local module2 = require("@luauforge/bundled/dtg")
local gameInfoModel = require("@luauforge/bundled/dth").GameInfoModel
local parseAndAddGameInfos = require("@luauforge/bundled/dto").parseAndAddGameInfos
local omniFeedConstants = require("@luauforge/bundled/dtp").OmniFeedConstants
local reportWarning = require("@luauforge/bundled/dtq").Points.reportWarning
local module3 = require("@luauforge/bundled/dtr")
local module4 = require("@luauforge/bundled/dts")
local module5 = require("@luauforge/bundled/dtt")
local addTopicInfos = module5.AddTopicInfos
local topicInfoModel = module5.TopicInfoModel
local module6 = require("@luauforge/bundled/dtu")
local addTopicContents = module6.AddTopicContents
local topicContentsModel = module6.TopicContentsModel

local module7 = require("@luauforge/bundled/dtv")
local EnumNetworkStatus = require("@game/CorePackages/Packages/_Index/RoduxNetworking/RoduxNetworking/NetworkStatus/EnumNetworkStatus")
local module9 = require("@luauforge/bundled/dty")
local module10 = require("@luauforge/bundled/dtz")
local module11 = require("@luauforge/bundled/dtA")
local module12 = require("@luauforge/bundled/dtE")
local module13 = require("@luauforge/bundled/dtI")
local module14 = require("@luauforge/bundled/dtJ")
local module15 = require("@luauforge/bundled/dtK")
local module16 = require("@luauforge/bundled/dtN")
local module17 = require("@luauforge/bundled/dtO")

return function(p2, data, p3)
	return function(object)
		local v5 = {}

		local responseBody = p3.responseBody

		if object:getState().RequestsStatus.SearchesInGamesStatus[data.searchUuid] == EnumNetworkStatus.Removed then
			return module2.resolve("Search with Uuid " .. data.searchUuid .. " has been terminated")
		end

		local universeId = nil
		local v6 = false
		local contents = {}
		local v7 = 1

		local topicLayoutDatasByTopicId = {}

		if responseBody.sorts then
			for k, sort in responseBody.sorts do
				if sort.topicId and sort.topicLayoutData then
					topicLayoutDatasByTopicId[sort.topicId] = sort.topicLayoutData
				end
			end
		end

		local topicIdSet = {}
		local v8 = {}

		for k, searchResult in pairs(responseBody.searchResults) do
			local content = searchResult.contents[1]
			local topicId = searchResult.topicId
			local v9 = topicLayoutDatasByTopicId[topicId] or {}

			local contentGroupType = searchResult.contentGroupType
			local v10 = module13(searchResult.contentGroupType)

			if contentGroupType == omniFeedConstants.ContentGroupType.Game then
				local rootPlaceId = tostring(content.rootPlaceId)

				table.insert(contents, content)

				local joined = module.Dictionary.join(content, {
					topicId = topicId,
					placeId = rootPlaceId
				})

				module11.fromJsonData(joined, true):match(function(p4)
					v5[v7] = p4

					object:dispatch(module14(data.searchUuid, topicId, v10, v7, v9))

					if v7 == 1 and content.emphasis then
						universeId = content.universeId
						v6 = true
					end

					v7 += 1
				end):matchError(function(p4)
					reportWarning(module4.default, "GameSearchEntryParseError", p4)
				end)
			else
				local v11 = contentGroupType == omniFeedConstants.ContentGroupType.Text
					and module15(searchResult.contents)

				if v11 then
					object:dispatch(module14(data.searchUuid, topicId, v10, k, v9))

					object:dispatch(module16({
						searchUuid = data.searchUuid,
						topicId = topicId,
						entry = v11
					}))
				end
			end

			if topicIdSet[topicId] then
				continue
			end

			topicIdSet[topicId] = true
			table.insert(
				v8,
				(topicInfoModel.fromSearchApi(
					{
						topicId = topicId,
						treatmentType = module13(searchResult.contentGroupType),
						topicLayoutData = v9
					},
					data.searchUuid
				))
			)
		end

		object:dispatch(addTopicInfos(v8))

		parseAndAddGameInfos(p2, object, contents, gameInfoModel.fromSearchApi, nil)

		local fromOmniSearch = module12.fromOmniSearch
		local searchKeyword = data.searchKeyword

		local v9 = v6
		local v10 = fromOmniSearch(
			searchKeyword,
			v5,
			v9,
			responseBody.nextPageToken,
			responseBody.paginationMethod
		)

		if module17 then
			v10.viewportSize = data.viewportSize
		end

		if data.isAppend then
			object:dispatch(module10(data.searchUuid, v10))
		else
			object:dispatch(module9(data.searchUuid, v10))
		end

		object:dispatch(addTopicContents(data.searchUuid, topicContentsModel.fromData(v10), data.isAppend))

		object:dispatch(module7(data.searchUuid, EnumNetworkStatus.Done))

		if universeId then
			module3.Game.getGameIconStore(false).getAndFetchGameIcons(
				{ universeId },
				module3.Game.GameIconSize.Large
			)
		end

		return module2.resolve()
	end
end
