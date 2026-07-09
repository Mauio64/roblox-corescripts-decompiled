local Parent = script:FindFirstAncestor("UserSearch").Parent
local LocalizationService = game:GetService("LocalizationService")
local Enums = require(Parent.SocialLuaAnalytics).Analytics.Enums
local Contexts = Enums.Contexts
local EventTypes = Enums.EventTypes
local EventNames = require(script.Parent.EventNames)
local BtnValues = require(script.Parent.BtnValues)
local FFlagLuaAppSearchPeopleUnifiedSchemaFields = require(Parent.SharedFlags).FFlagLuaAppSearchPeopleUnifiedSchemaFields

local function concatToString(p1) -- line: 17
	if p1 then
		return (table.concat(p1, ","))
	end

	return ""
end
local function acceptAnyValue(p2) -- line: 21
	return p2
end

return {
	[EventNames.PlayerTileImpressions] = {
		context = Contexts.PlayerSearch,
		eventType = EventTypes.PlayerTileImpressions,
		formatRulesForAdditionalInfo = {
			tilePos = concatToString,
			playerId = concatToString,
			playerName = concatToString,
			rowInSort = concatToString
		}
	},
	[EventNames.NavigateToAddFriendsBtn] = {
		context = Contexts.PlayerSearch,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = BtnValues.NavigateToAddFriends
		}
	},
	[EventNames.PlayerFriendRequest] = {
		context = Contexts.PlayerSearch,
		eventType = EventTypes.PlayerFriendAdd,
		formatRulesForAdditionalInfo = {
			playerId = acceptAnyValue,
			tilePos = acceptAnyValue,
			contextualInfoType = acceptAnyValue,
			rowInSort = acceptAnyValue,
			positionInRow = if not FFlagLuaAppSearchPeopleUnifiedSchemaFields then nil else acceptAnyValue,
			feedRowNumber = if not FFlagLuaAppSearchPeopleUnifiedSchemaFields then nil else acceptAnyValue,
			interactionUuid = if not FFlagLuaAppSearchPeopleUnifiedSchemaFields then nil else acceptAnyValue,
			pageContext = if not FFlagLuaAppSearchPeopleUnifiedSchemaFields then nil else acceptAnyValue
		},
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId,
			contentType = if not FFlagLuaAppSearchPeopleUnifiedSchemaFields then nil else "User",
			actionType = if not FFlagLuaAppSearchPeopleUnifiedSchemaFields then nil else "RequestFriendship"
		}
	},
	[EventNames.PlayerFriendAccept] = {
		context = Contexts.PlayerSearch,
		eventType = EventTypes.PlayerFriendAccept,
		formatRulesForAdditionalInfo = {
			playerId = acceptAnyValue,
			tilePos = acceptAnyValue,
			contextualInfoType = acceptAnyValue,
			rowInSort = acceptAnyValue,
			positionInRow = if not FFlagLuaAppSearchPeopleUnifiedSchemaFields then nil else acceptAnyValue,
			feedRowNumber = if not FFlagLuaAppSearchPeopleUnifiedSchemaFields then nil else acceptAnyValue,
			interactionUuid = if not FFlagLuaAppSearchPeopleUnifiedSchemaFields then nil else acceptAnyValue,
			pageContext = if not FFlagLuaAppSearchPeopleUnifiedSchemaFields then nil else acceptAnyValue
		},
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId,
			contentType = if not FFlagLuaAppSearchPeopleUnifiedSchemaFields then nil else "User",
			actionType = if not FFlagLuaAppSearchPeopleUnifiedSchemaFields then nil else "AcceptFriendship"
		}
	},
	[EventNames.PlayerTileClick] = {
		context = Contexts.PlayerSearch,
		eventType = EventTypes.PlayerTileClick,
		formatRulesForAdditionalInfo = {
			playerId = acceptAnyValue,
			tilePos = acceptAnyValue,
			contextualInfoType = acceptAnyValue,
			rowInSort = acceptAnyValue,
			positionInRow = if not FFlagLuaAppSearchPeopleUnifiedSchemaFields then nil else acceptAnyValue,
			feedRowNumber = if not FFlagLuaAppSearchPeopleUnifiedSchemaFields then nil else acceptAnyValue,
			interactionUuid = if not FFlagLuaAppSearchPeopleUnifiedSchemaFields then nil else acceptAnyValue,
			pageContext = if not FFlagLuaAppSearchPeopleUnifiedSchemaFields then nil else acceptAnyValue
		},
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId,
			contentType = if not FFlagLuaAppSearchPeopleUnifiedSchemaFields then nil else "User",
			actionType = if not FFlagLuaAppSearchPeopleUnifiedSchemaFields then nil else "OpenProfile"
		}
	},
	[EventNames.UserSearchLoadingTime] = {
		context = Contexts.PlayerSearch,
		eventType = EventTypes.LoadingTime,
		formatRulesForAdditionalInfo = {
			status = acceptAnyValue,
			loadingTime = acceptAnyValue,
			loadingThreshold = acceptAnyValue,
			nextPage = acceptAnyValue
		},
		additionalInfo = {
			fetch = "userSearch",
			locale = LocalizationService.RobloxLocaleId
		}
	},
	[EventNames.UserSearchLoaded] = {
		context = Contexts.PlayerSearch,
		eventType = EventTypes.PageLoad,
		formatRulesForAdditionalInfo = {
			status = acceptAnyValue,
			nextPage = acceptAnyValue
		},
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		}
	},
	[EventNames.UserSearchBarOpen] = {
		context = Contexts.PlayerSearch,
		eventType = EventTypes.Search,
		formatRulesForAdditionalInfo = {
			kwd = acceptAnyValue,
			currentPage = acceptAnyValue
		},
		additionalInfo = {
			act = "open",
			locale = LocalizationService.RobloxLocaleId
		}
	},
	[EventNames.UserSearchBarCancel] = {
		context = Contexts.PlayerSearch,
		eventType = EventTypes.Search,
		formatRulesForAdditionalInfo = {
			kwd = acceptAnyValue,
			currentPage = acceptAnyValue
		},
		additionalInfo = {
			act = "cancel",
			locale = LocalizationService.RobloxLocaleId
		}
	},
	[EventNames.UserSearchBarSubmit] = {
		context = Contexts.PlayerSearch,
		eventType = EventTypes.Search,
		formatRulesForAdditionalInfo = {
			kwd = acceptAnyValue,
			currentPage = acceptAnyValue
		},
		additionalInfo = {
			act = "search",
			locale = LocalizationService.RobloxLocaleId
		}
	}
}
