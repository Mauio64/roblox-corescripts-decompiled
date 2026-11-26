local LocalizationService = game:GetService("LocalizationService")

local enums = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SocialLuaAnalytics").Analytics.Enums
local contexts = enums.Contexts
local eventTypes = enums.EventTypes

local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Analytics/EventNames")
local BtnValues = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Analytics/BtnValues")

local fFlagLuaAppSearchPeopleUnifiedSchemaFields = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SharedFlags").FFlagLuaAppSearchPeopleUnifiedSchemaFields

local function concatToString(list)
	if list then
		return (table.concat(list, ","))
	end

	return ""
end

local function acceptAnyValue(p2)
	return p2
end

local v5 = {
	[EventNames.PlayerTileImpressions] = {
		context = contexts.PlayerSearch,
		eventType = eventTypes.PlayerTileImpressions,
		formatRulesForAdditionalInfo = {
			tilePos = concatToString,
			playerId = concatToString,
			playerName = concatToString,
			rowInSort = concatToString
		}
	},
	[EventNames.NavigateToAddFriendsBtn] = {
		context = contexts.PlayerSearch,
		eventType = eventTypes.ButtonClick,
		additionalInfo = { btn = BtnValues.NavigateToAddFriends }
	}
}

local playerFriendRequest = EventNames.PlayerFriendRequest
v5[playerFriendRequest] = {
	context = contexts.PlayerSearch,
	eventType = eventTypes.PlayerFriendAdd,
	formatRulesForAdditionalInfo = {
		playerId = acceptAnyValue,
		tilePos = acceptAnyValue,
		contextualInfoType = acceptAnyValue,
		rowInSort = acceptAnyValue,
		positionInRow = if fFlagLuaAppSearchPeopleUnifiedSchemaFields then acceptAnyValue else nil,
		feedRowNumber = if fFlagLuaAppSearchPeopleUnifiedSchemaFields then acceptAnyValue else nil,
		interactionUuid = if fFlagLuaAppSearchPeopleUnifiedSchemaFields then acceptAnyValue else nil,
		pageContext = if fFlagLuaAppSearchPeopleUnifiedSchemaFields then acceptAnyValue else nil
	},
	additionalInfo = {
		locale = LocalizationService.RobloxLocaleId,
		contentType = fFlagLuaAppSearchPeopleUnifiedSchemaFields and "User" or nil,
		actionType = fFlagLuaAppSearchPeopleUnifiedSchemaFields and "RequestFriendship" or nil
	}
}

local playerFriendAccept = EventNames.PlayerFriendAccept
v5[playerFriendAccept] = {
	context = contexts.PlayerSearch,
	eventType = eventTypes.PlayerFriendAccept,
	formatRulesForAdditionalInfo = {
		playerId = acceptAnyValue,
		tilePos = acceptAnyValue,
		contextualInfoType = acceptAnyValue,
		rowInSort = acceptAnyValue,
		positionInRow = if fFlagLuaAppSearchPeopleUnifiedSchemaFields then acceptAnyValue else nil,
		feedRowNumber = if fFlagLuaAppSearchPeopleUnifiedSchemaFields then acceptAnyValue else nil,
		interactionUuid = if fFlagLuaAppSearchPeopleUnifiedSchemaFields then acceptAnyValue else nil,
		pageContext = if fFlagLuaAppSearchPeopleUnifiedSchemaFields then acceptAnyValue else nil
	},
	additionalInfo = {
		locale = LocalizationService.RobloxLocaleId,
		contentType = fFlagLuaAppSearchPeopleUnifiedSchemaFields and "User" or nil,
		actionType = fFlagLuaAppSearchPeopleUnifiedSchemaFields and "AcceptFriendship" or nil
	}
}

local playerTileClick = EventNames.PlayerTileClick
v5[playerTileClick] = {
	context = contexts.PlayerSearch,
	eventType = eventTypes.PlayerTileClick,
	formatRulesForAdditionalInfo = {
		playerId = acceptAnyValue,
		tilePos = acceptAnyValue,
		contextualInfoType = acceptAnyValue,
		rowInSort = acceptAnyValue,
		positionInRow = if fFlagLuaAppSearchPeopleUnifiedSchemaFields then acceptAnyValue else nil,
		feedRowNumber = if fFlagLuaAppSearchPeopleUnifiedSchemaFields then acceptAnyValue else nil,
		interactionUuid = if fFlagLuaAppSearchPeopleUnifiedSchemaFields then acceptAnyValue else nil,
		pageContext = if fFlagLuaAppSearchPeopleUnifiedSchemaFields then acceptAnyValue else nil
	},
	additionalInfo = {
		locale = LocalizationService.RobloxLocaleId,
		contentType = fFlagLuaAppSearchPeopleUnifiedSchemaFields and "User" or nil,
		actionType = fFlagLuaAppSearchPeopleUnifiedSchemaFields and "OpenProfile" or nil
	}
}

v5[EventNames.UserSearchLoadingTime] = {
	context = contexts.PlayerSearch,
	eventType = eventTypes.LoadingTime,
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
}

v5[EventNames.UserSearchLoaded] = {
	context = contexts.PlayerSearch,
	eventType = eventTypes.PageLoad,
	formatRulesForAdditionalInfo = {
		status = acceptAnyValue,
		nextPage = acceptAnyValue
	},
	additionalInfo = { locale = LocalizationService.RobloxLocaleId }
}

v5[EventNames.UserSearchBarOpen] = {
	context = contexts.PlayerSearch,
	eventType = eventTypes.Search,
	formatRulesForAdditionalInfo = {
		kwd = acceptAnyValue,
		currentPage = acceptAnyValue
	},
	additionalInfo = { act = "open", locale = LocalizationService.RobloxLocaleId }
}

v5[EventNames.UserSearchBarCancel] = {
	context = contexts.PlayerSearch,
	eventType = eventTypes.Search,
	formatRulesForAdditionalInfo = {
		kwd = acceptAnyValue,
		currentPage = acceptAnyValue
	},
	additionalInfo = { act = "cancel", locale = LocalizationService.RobloxLocaleId }
}

v5[EventNames.UserSearchBarSubmit] = {
	context = contexts.PlayerSearch,
	eventType = eventTypes.Search,
	formatRulesForAdditionalInfo = {
		kwd = acceptAnyValue,
		currentPage = acceptAnyValue
	},
	additionalInfo = { act = "search", locale = LocalizationService.RobloxLocaleId }
}

return v5
