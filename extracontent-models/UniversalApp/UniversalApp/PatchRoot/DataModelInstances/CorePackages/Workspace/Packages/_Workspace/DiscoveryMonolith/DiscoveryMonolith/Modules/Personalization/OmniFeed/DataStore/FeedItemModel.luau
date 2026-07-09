local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local DiscoveryTypes = require(Parent.DiscoveryTypes)
local OmniFeedTypes = DiscoveryTypes.OmniFeedTypes
local FFlagLuaAppPropagateFriendsCarouselHeader = require(Parent.SharedFlags).FFlagLuaAppPropagateFriendsCarouselHeader
local FFlagSearchOmniAutocompletePage = require(Parent.SharedFlags).FFlagSearchOmniAutocompletePage
local FFlagLuaAppAddRequestIdToRfySignalApportioning = require(Parent.SharedFlags).FFlagLuaAppAddRequestIdToRfySignalApportioning
local FFlagLuaAppRfyRevealRows = require(Parent.SharedFlags).FFlagLuaAppRfyRevealRows
local FFlagEnableSduiV2HomeInterleave = require(Parent.SharedFlags).FFlagEnableSduiV2HomeInterleave
local t4 = {
	fromLocalData = function(n1: number?, s1: string, p1, n2: number?) -- line: 20
		-- upvalues: DiscoveryTypes (copy)
		return {
			orderHint = n1,
			treatmentType = s1,
			treatmentProps = p1,
			numberOfRows = n2 or 1,
			dataSource = DiscoveryTypes.DataSourceType.Local
		}
	end,
	fromGamesApi = function(n3: number, s2: string, t1: {[any]: any}?) -- line: 37
		-- upvalues: OmniFeedTypes (copy), DiscoveryTypes (copy)
		return {
			numberOfRows = 1,
			treatmentType = OmniFeedTypes.Carousel,
			itemId = {
				sortName = s2,
				sortIndex = n3
			},
			treatmentProps = {
				isOmni = false,
				sortIndex = n3,
				topicLayoutData = t1
			},
			dataSource = DiscoveryTypes.DataSourceType.GamesApi
		}
	end,
	fromExploreTopicInfo = function(n4: number, p2, p3) -- line: 56
		-- upvalues: DiscoveryTypes (copy), OmniFeedTypes (copy)
		local t2 = {
			numberOfRows = 1,
			treatmentType = p2.treatmentType,
			itemId = {
				sortName = p2.name,
				sortIndex = n4
			},
			dataSource = DiscoveryTypes.DataSourceType.ExploreApi,
			pageSection = p3
		}

		if p2.treatmentType == OmniFeedTypes.Pills then
			t2.treatmentProps = {
				isOmni = false,
				sortIndex = n4,
				gameSortId = p2.name,
				topicName = p2.displayName,
				topicLayoutData = p2.topicLayoutData
			}

			return t2
		end

		t2.treatmentProps = {
			isOmni = false,
			sortIndex = n4,
			topicLayoutData = p2.topicLayoutData
		}

		return t2
	end,
	fromDiscoveryApi = function(n5: number, p4, s3: string?) -- line: 91
		-- upvalues: DiscoveryTypes (copy), OmniFeedTypes (copy), FFlagLuaAppAddRequestIdToRfySignalApportioning (copy), FFlagLuaAppRfyRevealRows (copy), FFlagLuaAppPropagateFriendsCarouselHeader (copy), FFlagEnableSduiV2HomeInterleave (copy)
		local treatmentType = p4.treatmentType
		local t3 = {
			treatmentType = treatmentType,
			numberOfRows = p4.numberOfRows or 1,
			dataSource = DiscoveryTypes.DataSourceType.DiscoveryApi
		}

		if treatmentType == OmniFeedTypes.Carousel or treatmentType == OmniFeedTypes.AvatarCarousel then
			t3.itemId = {
				topicId = p4.topicId,
				sortIndex = n5
			}
			t3.treatmentProps = {
				isOmni = true,
				sortIndex = n5,
				topicLayoutData = p4.topicLayoutData
			}

			return t3
		end

		if treatmentType == OmniFeedTypes.HomeGameGrid then
			t3.actualRenderedRows = -1
			t3.itemId = {
				topicId = p4.topicId,
				sortIndex = n5
			}
			t3.treatmentProps = {
				sortIndex = n5,
				topicId = p4.topicId,
				topicName = p4.topic,
				topicLayoutData = p4.topicLayoutData,
				numberOfRows = p4.numberOfRows,
				recommendationsRequestId = if not FFlagLuaAppAddRequestIdToRfySignalApportioning and not FFlagLuaAppRfyRevealRows then nil else s3
			}

			return t3
		end

		if treatmentType == OmniFeedTypes.JoinYourFriendsCarousel then
			t3.treatmentProps = {
				topicId = p4.topicId,
				topicLayoutData = p4.topicLayoutData
			}

			return t3
		end

		if treatmentType == OmniFeedTypes.FriendCarousel then
			t3.treatmentProps = {
				topic = if not FFlagLuaAppPropagateFriendsCarouselHeader then nil else p4.topic,
				topicId = p4.topicId
			}

			return t3
		end

		if treatmentType == OmniFeedTypes.FriendRecommendationCarousel then
			t3.treatmentProps = {
				sortIndex = n5,
				carouselTitle = p4.topic,
				topicId = p4.topicId,
				topicLayoutData = p4.topicLayoutData
			}

			return t3
		end

		if treatmentType == OmniFeedTypes.ServerDrivenUi or FFlagEnableSduiV2HomeInterleave and treatmentType == OmniFeedTypes.ServerDrivenUiV2 then
			t3.treatmentProps = {
				sortIndex = n5,
				topicId = p4.topicId,
				numberOfRows = p4.numberOfRows,
				feedItemKey = p4.feedItemKey
			}
			t3.itemId = {
				topicId = p4.topicId,
				sortIndex = n5
			}
		end

		return t3
	end,
	getUniqueNameForAnalytics = function(p5) -- line: 166
		-- upvalues: OmniFeedTypes (copy), FFlagEnableSduiV2HomeInterleave (copy)
		if not p5 then
			return nil
		end

		if not p5.treatmentType then
			return nil
		end

		if p5.treatmentType == OmniFeedTypes.Carousel then
			local itemId = p5.itemId

			if itemId.topicId then
				return "topicId:" .. itemId.topicId .. "_" .. itemId.sortIndex
			end

			if itemId.sortName then
				return "sortId:" .. itemId.sortName .. "_" .. itemId.sortIndex
			end
		end

		if p5.treatmentType == OmniFeedTypes.HomeGameGrid then
			local itemId = p5.itemId

			if itemId.topicId then
				return "GameGrid_topicId:" .. itemId.topicId .. "_" .. itemId.sortIndex
			end
		end

		if p5.treatmentType == OmniFeedTypes.ServerDrivenUi then
			local itemId = p5.itemId

			if itemId.topicId then
				return "ServerDrivenUi_topicId:" .. itemId.topicId .. "_" .. itemId.sortIndex
			end
		end

		if FFlagEnableSduiV2HomeInterleave and p5.treatmentType == OmniFeedTypes.ServerDrivenUiV2 then
			local itemId = p5.itemId

			if itemId.topicId then
				return "ServerDrivenUiV2_topicId:" .. itemId.topicId .. "_" .. itemId.sortIndex
			end
		end

		return "type:" .. p5.treatmentType
	end
}

function t4.getUniqueNameForFeed(p6) -- line: 211
	-- upvalues: t4 (copy)
	return t4.getUniqueNameForAnalytics(p6)
end
function t4.fromSearchApi(s4: string, s5: string, s6: string?, n6: number?, t5: {[any]: any}?) -- line: 215
	-- upvalues: DiscoveryTypes (copy), OmniFeedTypes (copy)
	local t6 = {
		treatmentType = s6,
		itemId = {
			topicId = s5,
			sortIndex = n6
		},
		treatmentProps = {
			searchUuid = s4,
			topicId = s5,
			topicLayoutData = t5,
			sortIndex = n6
		},
		dataSource = DiscoveryTypes.DataSourceType.SearchApi,
		numberOfRows = t5 and t5.numOfRows or 1
	}

	if s6 == OmniFeedTypes.SearchGameGrid or s6 == OmniFeedTypes.UserSearchGrid then
		t6.actualRenderedRows = -1
	end

	return t6
end

if FFlagSearchOmniAutocompletePage then
	function t4.fromOmniAutocompleteApi(n7: number, p7) -- line: 247
		-- upvalues: DiscoveryTypes (copy), OmniFeedTypes (copy)
		local treatmentType = p7.treatmentType
		local t7 = {
			treatmentType = treatmentType,
			dataSource = DiscoveryTypes.DataSourceType.OmniAutocompleteApi,
			itemId = {
				topicId = p7.sortId,
				sortIndex = n7
			},
			numberOfRows = p7.numberOfRows or 1
		}

		if treatmentType == OmniFeedTypes.Carousel then
			t7.treatmentProps = {
				isOmni = false,
				sortIndex = n7,
				sortName = p7.sortId,
				topicLayoutData = p7.topicLayoutData
			}

			return t7
		end

		if treatmentType == OmniFeedTypes.SearchPillCarousel then
			t7.treatmentProps = {
				isOmni = false,
				sortIndex = n7,
				sortName = p7.sortId,
				topicLayoutData = p7.topicLayoutData
			}
		end

		return t7
	end
end

function t4.getNumberOfRows(p8) -- line: 282
	if not p8 then
		return nil
	end

	if not p8.actualRenderedRows then
		return p8.numberOfRows
	end

	if p8.actualRenderedRows >= 0 then
		return p8.actualRenderedRows
	end

	return nil
end

return t4
