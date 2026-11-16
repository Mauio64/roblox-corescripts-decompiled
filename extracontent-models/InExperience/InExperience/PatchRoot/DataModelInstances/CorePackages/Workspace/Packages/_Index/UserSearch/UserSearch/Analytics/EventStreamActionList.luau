local parent = script:FindFirstAncestor("UserSearch").Parent

local LocalizationService = game:GetService("LocalizationService")

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local Enums = SocialLuaAnalytics.Analytics.Enums
local Contexts = Enums.Contexts
local EventTypes = Enums.EventTypes

local EventNames = require(script.Parent.EventNames)
local BtnValues = require(script.Parent.BtnValues)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppSearchPeopleUnifiedSchemaFields = SharedFlags.FFlagLuaAppSearchPeopleUnifiedSchemaFields

local function concatToString(list)
	if list then
		return (table.concat(list, ","))
	end

	return ""
end

local function acceptAnyValue(p)
	return p
end

local EventStreamActionList = {
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
		additionalInfo = { btn = BtnValues.NavigateToAddFriends }
	}
}

local PlayerFriendRequest = EventNames.PlayerFriendRequest
local v = {
	context = Contexts.PlayerSearch,
	eventType = EventTypes.PlayerFriendAdd,
	formatRulesForAdditionalInfo = 0,
	additionalInfo = 0
}
local positionInRow

if FFlagLuaAppSearchPeopleUnifiedSchemaFields then
	positionInRow = acceptAnyValue
end

local feedRowNumber

if FFlagLuaAppSearchPeopleUnifiedSchemaFields then
	feedRowNumber = acceptAnyValue
end

local interactionUuid

if FFlagLuaAppSearchPeopleUnifiedSchemaFields then
	interactionUuid = acceptAnyValue
end

local pageContext

if FFlagLuaAppSearchPeopleUnifiedSchemaFields then
	pageContext = acceptAnyValue
end

v.formatRulesForAdditionalInfo = {
	playerId = acceptAnyValue,
	tilePos = acceptAnyValue,
	contextualInfoType = acceptAnyValue,
	rowInSort = acceptAnyValue,
	positionInRow = positionInRow,
	feedRowNumber = feedRowNumber,
	interactionUuid = interactionUuid,
	pageContext = pageContext
}

v.additionalInfo = {
	locale = LocalizationService.RobloxLocaleId,
	contentType = FFlagLuaAppSearchPeopleUnifiedSchemaFields and "User" or nil,
	actionType = FFlagLuaAppSearchPeopleUnifiedSchemaFields and "RequestFriendship" or nil
}
EventStreamActionList[PlayerFriendRequest] = v

local PlayerFriendAccept = EventNames.PlayerFriendAccept
local v2 = {
	context = Contexts.PlayerSearch,
	eventType = EventTypes.PlayerFriendAccept,
	formatRulesForAdditionalInfo = 0,
	additionalInfo = 0
}
local positionInRow2

if FFlagLuaAppSearchPeopleUnifiedSchemaFields then
	positionInRow2 = acceptAnyValue
end

local feedRowNumber2

if FFlagLuaAppSearchPeopleUnifiedSchemaFields then
	feedRowNumber2 = acceptAnyValue
end

local interactionUuid2

if FFlagLuaAppSearchPeopleUnifiedSchemaFields then
	interactionUuid2 = acceptAnyValue
end

local pageContext2

if FFlagLuaAppSearchPeopleUnifiedSchemaFields then
	pageContext2 = acceptAnyValue
end

v2.formatRulesForAdditionalInfo = {
	playerId = acceptAnyValue,
	tilePos = acceptAnyValue,
	contextualInfoType = acceptAnyValue,
	rowInSort = acceptAnyValue,
	positionInRow = positionInRow2,
	feedRowNumber = feedRowNumber2,
	interactionUuid = interactionUuid2,
	pageContext = pageContext2
}

v2.additionalInfo = {
	locale = LocalizationService.RobloxLocaleId,
	contentType = FFlagLuaAppSearchPeopleUnifiedSchemaFields and "User" or nil,
	actionType = FFlagLuaAppSearchPeopleUnifiedSchemaFields and "AcceptFriendship" or nil
}
EventStreamActionList[PlayerFriendAccept] = v2

local PlayerTileClick = EventNames.PlayerTileClick
local v3 = {
	context = Contexts.PlayerSearch,
	eventType = EventTypes.PlayerTileClick,
	formatRulesForAdditionalInfo = 0,
	additionalInfo = 0
}
local positionInRow3

if FFlagLuaAppSearchPeopleUnifiedSchemaFields then
	positionInRow3 = acceptAnyValue
end

local feedRowNumber3

if FFlagLuaAppSearchPeopleUnifiedSchemaFields then
	feedRowNumber3 = acceptAnyValue
end

local interactionUuid3

if FFlagLuaAppSearchPeopleUnifiedSchemaFields then
	interactionUuid3 = acceptAnyValue
end

local pageContext3

if FFlagLuaAppSearchPeopleUnifiedSchemaFields then
	pageContext3 = acceptAnyValue
end

v3.formatRulesForAdditionalInfo = {
	playerId = acceptAnyValue,
	tilePos = acceptAnyValue,
	contextualInfoType = acceptAnyValue,
	rowInSort = acceptAnyValue,
	positionInRow = positionInRow3,
	feedRowNumber = feedRowNumber3,
	interactionUuid = interactionUuid3,
	pageContext = pageContext3
}

v3.additionalInfo = {
	locale = LocalizationService.RobloxLocaleId,
	contentType = FFlagLuaAppSearchPeopleUnifiedSchemaFields and "User" or nil,
	actionType = FFlagLuaAppSearchPeopleUnifiedSchemaFields and "OpenProfile" or nil
}
EventStreamActionList[PlayerTileClick] = v3

EventStreamActionList[EventNames.UserSearchLoadingTime] = {
	context = Contexts.PlayerSearch,
	eventType = EventTypes.LoadingTime,
	formatRulesForAdditionalInfo = {
		status = acceptAnyValue,
		loadingTime = acceptAnyValue,
		loadingThreshold = acceptAnyValue,
		nextPage = acceptAnyValue
	},
	additionalInfo = { fetch = "userSearch", locale = LocalizationService.RobloxLocaleId }
}

EventStreamActionList[EventNames.UserSearchLoaded] = {
	context = Contexts.PlayerSearch,
	eventType = EventTypes.PageLoad,
	formatRulesForAdditionalInfo = { status = acceptAnyValue, nextPage = acceptAnyValue },
	additionalInfo = { locale = LocalizationService.RobloxLocaleId }
}

EventStreamActionList[EventNames.UserSearchBarOpen] = {
	context = Contexts.PlayerSearch,
	eventType = EventTypes.Search,
	formatRulesForAdditionalInfo = { kwd = acceptAnyValue, currentPage = acceptAnyValue },
	additionalInfo = { act = "open", locale = LocalizationService.RobloxLocaleId }
}

EventStreamActionList[EventNames.UserSearchBarCancel] = {
	context = Contexts.PlayerSearch,
	eventType = EventTypes.Search,
	formatRulesForAdditionalInfo = { kwd = acceptAnyValue, currentPage = acceptAnyValue },
	additionalInfo = { act = "cancel", locale = LocalizationService.RobloxLocaleId }
}

EventStreamActionList[EventNames.UserSearchBarSubmit] = {
	context = Contexts.PlayerSearch,
	eventType = EventTypes.Search,
	formatRulesForAdditionalInfo = { kwd = acceptAnyValue, currentPage = acceptAnyValue },
	additionalInfo = { act = "search", locale = LocalizationService.RobloxLocaleId }
}

return EventStreamActionList
