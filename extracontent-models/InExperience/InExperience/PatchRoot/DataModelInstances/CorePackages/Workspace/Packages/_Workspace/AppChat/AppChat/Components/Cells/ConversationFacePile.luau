local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Loggers = require(parent.Loggers)
local Logger = Loggers.Logger
local React = require(parent.React)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local Foundation = require(parent.Foundation)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local SharedFlags2 = require(parent.SharedFlags)
local FFlagUserTileUnfilteredChatIndicator = SharedFlags2.FFlagUserTileUnfilteredChatIndicator
local InlineRichText = require(parent.InlineRichText)
local escapeRichFormatting = InlineRichText.escapeRichFormatting
local UserProfiles = require(parent.UserProfiles)
local useIsRobloxSubscriber = UserProfiles.Hooks.useIsRobloxSubscriber
local UserTile = require(parent.UserTile)
local userTile = UserTile.UserTile
local UserTile2 = require(parent.UserTile)
local LayoutMode = UserTile2.LayoutMode
local RoduxPresence = require(AppChat.Http.RoduxPresence)
local FFlagAppChatPresenceStoreMigration = require(AppChat.Flags.FFlagAppChatPresenceStoreMigration)
local DataHydration = require(parent.DataHydration)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local v = Logger:new(script.Name)

local useFoundationPresence = require(AppChat.Hooks.useFoundationPresence)

local PresenceType = RoduxPresence.Enums.PresenceType
local UserPresence = Foundation.Enums.UserPresence
local presenceType

if FFlagAppChatPresenceStoreMigration then
	presenceType = DataHydration.Presence.PresenceEnums.PresenceType
else
	presenceType = nil
end

local v2

if FFlagAppChatPresenceStoreMigration then
	v2 = DataHydration.Presence.PresenceStore.get()
else
	v2 = nil
end

local function groupPresenceAggregateEquals(p, p2): boolean
	return p.hasInExperienceUser == p2.hasInExperienceUser and p.hasOnlineUser == p2.hasOnlineUser
end

local function getParticipantId(participant) -- 2 equivalent calls inferred from this helper
	if type(participant) == "table" then
		local id = participant.id or participant.userId

		if id == nil then
			return nil
		end

		return (tostring(id))
	elseif participant == nil then
		return nil
	else
		return (tostring(participant))
	end
end

local function getNonEmptyLocalUserId(p) -- 2 equivalent calls inferred from this helper
	if p == nil or p == "" then
		return nil
	end

	return (tostring(p))
end

local function ConversationFacePileInner(props)
	local conversationId = props.conversationId
	local v3 = useLocalUserId()
	local v4 = getNonEmptyLocalUserId(props.localUserId) or getNonEmptyLocalUserId(v3) or "" -- inferred equivalent call

	local v5 = useSelector((React.useCallback(function(p)
		if p and p.ChatAppReducer and p.ChatAppReducer.Conversations then
			return p.ChatAppReducer.Conversations[conversationId]
		end

		return nil
	end, { conversationId })))
	local v6

	if not FFlagAppChatPresenceStoreMigration then
		v6 = useSelector(function(p)
			if p and p.ChatAppReducer and p.ChatAppReducer.Presence then
				return p.ChatAppReducer.Presence.byUserId
			end

			return nil
		end)
	end

	local participants = props.participants or not (v5 and v5.participants) and {} or v5.participants

	local v7 = {}

	if #participants == 1 then
		table.insert(v7, v4)
	else
		for _, participant in participants do
			local participantId = getParticipantId(participant) -- inferred equivalent call

			if participantId and tostring(participantId) ~= tostring(v4) then
				table.insert(v7, participantId)
			end
		end
	end

	local v8

	if FFlagAppChatPresenceStoreMigration then
		v8 = React.useMemo(function()
			return Signals.createComputed(function(p)
				local hasInExperienceUser = false
				local hasOnlineUser = false

				for _, v9 in v7 do
					local data = v2.GetPresenceByUserId(v9).data(p)

					if not data then
						continue
					end

					local userPresenceType = data.userPresenceType

					if userPresenceType == presenceType.InGame or userPresenceType == presenceType.InStudio then
						hasInExperienceUser = true
					elseif userPresenceType == presenceType.Online then
						hasOnlineUser = true
					end
				end

				return { hasInExperienceUser = hasInExperienceUser, hasOnlineUser = hasOnlineUser }
			end, groupPresenceAggregateEquals)
		end, { table.concat(v7, ",") })
	end

	local v9

	if FFlagAppChatPresenceStoreMigration then
		v9 = SignalsReact.useSignalState(v8)
	end

	local userId = v7[1] or v4
	local v10 = useFoundationPresence(userId)

	local userPresenceType2 = UserPresence.None

	if #v7 >= 2 then
		local v11 = false
		local v12 = false

		if FFlagAppChatPresenceStoreMigration then
			v11 = if v9 then v9.hasInExperienceUser else false
			v12 = if v9 then v9.hasOnlineUser else false
		else
			for _, v13 in v7 do
				if not (v6 and v6[v13]) then
					continue
				end

				local userPresenceType = v6[v13].userPresenceType

				if userPresenceType == PresenceType.InGame or userPresenceType == PresenceType.InStudio then
					v11 = true
				elseif userPresenceType == PresenceType.Online then
					v12 = true
				end
			end
		end

		if v11 then
			userPresenceType2 = UserPresence.InExperience
		elseif v12 then
			userPresenceType2 = UserPresence.Active
		end
	else
		userPresenceType2 = v10.presence
	end

	local v11 = nil

	if FFlagEnableBlackbirdCheck and #participants == 2 then
		for _, participant in participants do
			local participantId = getParticipantId(participant) -- inferred equivalent call

			if participantId and tostring(participantId) ~= tostring(v4) then
				v11 = tostring(participantId)
				break
			end
		end
	end

	local isRobloxSubscriber = useIsRobloxSubscriber(v11)

	local createElement = React.createElement
	local v12 = {
		userId = userId,
		facePileSecondUserId = v7[2] or nil,
		layoutMode = LayoutMode.wide,
		title = 0,
		subtitle = 0,
		titleStyle = 0,
		subtitleStyle = 0,
		userPresenceType = 0,
		onActivated = 0,
		selectable = 0,
		customTextTruncation = 0,
		trustedConnectionIndicatorEnabled = 0,
		isRobloxSubscriber = 0,
		shouldShowUnfilteredChatIndicator = 0
	}
	local title

	if props.titleText then
		title = escapeRichFormatting(props.titleText)
	else
		title = props.titleText
	end

	v12.title = title
	local subtitle

	if props.subtitleText then
		subtitle = escapeRichFormatting(props.subtitleText)
	else
		subtitle = props.subtitleText
	end

	v12.subtitle = subtitle
	v12.titleStyle = props.titleStyle
	v12.subtitleStyle = props.subtitleStyle
	v12.userPresenceType = userPresenceType2
	v12.onActivated = props.onActivated
	v12.selectable = props.selectable
	v12.customTextTruncation = Enum.TextTruncate.SplitWord
	v12.trustedConnectionIndicatorEnabled = props.trustedConnectionIndicatorEnabled

	if not FFlagEnableBlackbirdCheck then
		isRobloxSubscriber = nil
	end

	v12.isRobloxSubscriber = isRobloxSubscriber
	local shouldShowUnfilteredChatIndicator

	if FFlagUserTileUnfilteredChatIndicator then
		shouldShowUnfilteredChatIndicator = props.shouldShowUnfilteredChatIndicator
	end

	v12.shouldShowUnfilteredChatIndicator = shouldShowUnfilteredChatIndicator
	return createElement(userTile, v12)
end

local function ConversationFacePile(p)
	local conversationId = p.conversationId

	if not conversationId or conversationId == "" then
		v:warning("conversationId cannot be nil nor an empty string")
		return nil
	end

	local clone = table.clone(p)
	clone.conversationId = conversationId
	return React.createElement(ConversationFacePileInner, clone)
end

return ConversationFacePile
