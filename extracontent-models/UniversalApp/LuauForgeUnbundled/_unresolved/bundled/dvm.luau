local module = require("@luauforge/bundled/dqn")
local omniFeedTypes = module.OmniFeedTypes

local fFlagLuaAppPropagateFriendsCarouselHeader = require("@luauforge/bundled/dqB").FFlagLuaAppPropagateFriendsCarouselHeader

local fFlagLuaAppAddRequestIdToRfySignalApportioning = require("@luauforge/bundled/dqB").FFlagLuaAppAddRequestIdToRfySignalApportioning
local fFlagLuaAppRfyRevealRows = require("@luauforge/bundled/dqB").FFlagLuaAppRfyRevealRows
local fFlagLuaAppFriendsSortHeaderByPosition = require("@luauforge/bundled/dqB").FFlagLuaAppFriendsSortHeaderByPosition

local v5 = {}

function v5.fromLocalData(p2, p3, p4, value)
	return {
		orderHint = p2,
		treatmentType = p3,
		treatmentProps = p4,
		numberOfRows = value or 1,
		dataSource = module.DataSourceType.Local
	}
end

function v5.fromGamesApi(p2, p3, p4)
	return {
		treatmentType = omniFeedTypes.Carousel,
		numberOfRows = 1,
		itemId = { sortName = p3, sortIndex = p2 },
		treatmentProps = { sortIndex = p2, isOmni = false, topicLayoutData = p4 },
		dataSource = module.DataSourceType.GamesApi
	}
end

function v5.fromExploreTopicInfo(p2, data, p3)
	local v6 = {
		treatmentType = data.treatmentType,
		numberOfRows = 1,
		itemId = { sortName = data.name, sortIndex = p2 },
		dataSource = module.DataSourceType.ExploreApi,
		pageSection = p3
	}

	if data.treatmentType == omniFeedTypes.Pills then
		v6.treatmentProps = {
			sortIndex = p2,
			gameSortId = data.name,
			topicName = data.displayName,
			isOmni = false,
			topicLayoutData = data.topicLayoutData
		}
		return v6
	end

	v6.treatmentProps = {
		sortIndex = p2,
		isOmni = false,
		topicLayoutData = data.topicLayoutData
	}

	return v6
end

function v5.fromDiscoveryApi(sortIndex, data, recommendationsRequestId)
	local treatmentType = data.treatmentType
	local v6 = {
		treatmentType = treatmentType,
		numberOfRows = data.numberOfRows or 1,
		dataSource = module.DataSourceType.DiscoveryApi
	}

	if treatmentType == omniFeedTypes.Carousel or treatmentType == omniFeedTypes.AvatarCarousel then
		v6.itemId = { topicId = data.topicId, sortIndex = sortIndex }

		v6.treatmentProps = {
			sortIndex = sortIndex,
			topicLayoutData = data.topicLayoutData,
			isOmni = true
		}
		return v6
	elseif treatmentType == omniFeedTypes.HomeGameGrid then
		v6.actualRenderedRows = -1
		v6.itemId = { topicId = data.topicId, sortIndex = sortIndex }

		local v7 = {
			sortIndex = sortIndex,
			topicId = data.topicId,
			topicName = data.topic,
			topicLayoutData = data.topicLayoutData,
			numberOfRows = data.numberOfRows,
			recommendationsRequestId = 0
		}

		if not (fFlagLuaAppAddRequestIdToRfySignalApportioning or fFlagLuaAppRfyRevealRows) then
			recommendationsRequestId = nil
		end

		v7.recommendationsRequestId = recommendationsRequestId
		v6.treatmentProps = v7
		return v6
	else
		if treatmentType == omniFeedTypes.JoinYourFriendsCarousel then
			v6.treatmentProps = {
				topicId = data.topicId,
				topicLayoutData = data.topicLayoutData
			}
			return v6
		end

		if treatmentType == omniFeedTypes.FriendCarousel then
			local v8 = if fFlagLuaAppPropagateFriendsCarouselHeader then data.topic else nil
			local v7 = { topic = v8, topicId = data.topicId, sortIndex = 0 }

			if not fFlagLuaAppFriendsSortHeaderByPosition then
				sortIndex = nil
			end

			v7.sortIndex = sortIndex
			v6.treatmentProps = v7
			return v6
		end

		if treatmentType == omniFeedTypes.FriendRecommendationCarousel then
			v6.treatmentProps = {
				sortIndex = sortIndex,
				carouselTitle = data.topic,
				topicId = data.topicId,
				topicLayoutData = data.topicLayoutData
			}
			return v6
		end

		if
			treatmentType == omniFeedTypes.ServerDrivenUi
			or treatmentType == omniFeedTypes.ServerDrivenUiV2
		then
			v6.treatmentProps = {
				sortIndex = sortIndex,
				topicId = data.topicId,
				numberOfRows = data.numberOfRows,
				feedItemKey = data.feedItemKey
			}

			v6.itemId = { topicId = data.topicId, sortIndex = sortIndex }
		end

		return v6
	end
end

function v5.getUniqueNameForAnalytics(p2)
	if not (p2 and p2.treatmentType) then
		return nil
	end

	if p2.treatmentType == omniFeedTypes.Carousel then
		local itemId = p2.itemId

		if itemId.topicId then
			return "topicId:" .. itemId.topicId .. "_" .. itemId.sortIndex
		end

		if itemId.sortName then
			return "sortId:" .. itemId.sortName .. "_" .. itemId.sortIndex
		end
	end

	if p2.treatmentType == omniFeedTypes.HomeGameGrid then
		local itemId = p2.itemId

		if itemId.topicId then
			return "GameGrid_topicId:" .. itemId.topicId .. "_" .. itemId.sortIndex
		end
	end

	if p2.treatmentType == omniFeedTypes.ServerDrivenUi then
		local itemId = p2.itemId

		if itemId.topicId then
			return "ServerDrivenUi_topicId:" .. itemId.topicId .. "_" .. itemId.sortIndex
		end
	end

	if p2.treatmentType == omniFeedTypes.ServerDrivenUiV2 then
		local itemId = p2.itemId

		if itemId.topicId then
			return "ServerDrivenUiV2_topicId:" .. itemId.topicId .. "_" .. itemId.sortIndex
		end
	end

	return "type:" .. p2.treatmentType
end

function v5.getUniqueNameForFeed(p2)
	return v5.getUniqueNameForAnalytics(p2)
end

function v5.fromSearchApi(p2, p3, p4, p5, p6)
	local v6 = {
		treatmentType = p4,
		itemId = { topicId = p3, sortIndex = p5 },
		treatmentProps = {
			searchUuid = p2,
			topicId = p3,
			topicLayoutData = p6,
			sortIndex = p5
		},
		dataSource = module.DataSourceType.SearchApi,
		numberOfRows = p6 and p6.numOfRows or 1
	}

	if p4 == omniFeedTypes.SearchGameGrid or p4 == omniFeedTypes.UserSearchGrid then
		v6.actualRenderedRows = -1
	end

	return v6
end

function v5.fromOmniAutocompleteApi(p2, data)
	local treatmentType = data.treatmentType
	local v6 = {
		treatmentType = treatmentType,
		dataSource = module.DataSourceType.OmniAutocompleteApi,
		itemId = { topicId = data.sortId, sortIndex = p2 },
		numberOfRows = data.numberOfRows or 1
	}

	if treatmentType == omniFeedTypes.Carousel then
		v6.treatmentProps = {
			sortIndex = p2,
			sortName = data.sortId,
			topicLayoutData = data.topicLayoutData,
			isOmni = false
		}
		return v6
	end

	if treatmentType == omniFeedTypes.SearchPillCarousel then
		v6.treatmentProps = {
			sortIndex = p2,
			sortName = data.sortId,
			topicLayoutData = data.topicLayoutData,
			isOmni = false
		}
	end

	return v6
end

function v5.getNumberOfRows(p2)
	if not p2 then
		return nil
	end

	if not p2.actualRenderedRows then
		return p2.numberOfRows
	end

	if p2.actualRenderedRows >= 0 then
		return p2.actualRenderedRows
	end

	return nil
end

return v5
