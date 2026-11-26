local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Loggers").Logger
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppHooks").useLocalUserId
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local fFlagEnableBlackbirdCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagEnableBlackbirdCheck
local fFlagUserTileUnfilteredChatIndicator = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagUserTileUnfilteredChatIndicator
local escapeRichFormatting = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/InlineRichText").escapeRichFormatting
local useIsRobloxSubscriber = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserProfiles").Hooks.useIsRobloxSubscriber
local userTile = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserTile").UserTile
local layoutMode = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserTile").LayoutMode
local RoduxPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/RoduxPresence")
local FFlagAppChatPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPresenceStoreMigration")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact")

local v5 = logger:new("ConversationFacePile")

local useFoundationPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useFoundationPresence")

local presenceType = RoduxPresence.Enums.PresenceType
local userPresence = Foundation.Enums.UserPresence

local presenceType2 = if FFlagAppChatPresenceStoreMigration then DataHydration.Presence.PresenceEnums.PresenceType else nil

local v6 = if FFlagAppChatPresenceStoreMigration then DataHydration.Presence.PresenceStore.get() else nil

local function groupPresenceAggregateEquals(p2, p3): boolean
	return p2.hasInExperienceUser == p3.hasInExperienceUser and p2.hasOnlineUser == p3.hasOnlineUser
end

local function getParticipantId(p2)
	if type(p2) == "table" then
		local id = p2.id or p2.userId

		if id == nil then
			return nil
		end

		return (tostring(id))
	elseif p2 == nil then
		return nil
	else
		return (tostring(p2))
	end
end

local function getNonEmptyLocalUserId(p2)
	if p2 == nil or p2 == "" then
		return nil
	end

	return (tostring(p2))
end

local function ConversationFacePileInner(props)
	local conversationId = props.conversationId
	local v7 = useLocalUserId()
	local localUserId = props.localUserId
	local v8 = if not (localUserId == nil or localUserId == "") then tostring(localUserId) else nil

	if not v8 then
		v8 = (if v7 ~= nil and v7 ~= "" then tostring(v7) else nil) or ""
	end

	local v10 = useSelector((React.useCallback(function(p2)
		if p2 and p2.ChatAppReducer and p2.ChatAppReducer.Conversations then
			return p2.ChatAppReducer.Conversations[conversationId]
		end

		return nil
	end, { conversationId })))
	local v11

	if not FFlagAppChatPresenceStoreMigration then
		v11 = useSelector(function(p2)
			if p2 and p2.ChatAppReducer and p2.ChatAppReducer.Presence then
				return p2.ChatAppReducer.Presence.byUserId
			end

			return nil
		end)
	end

	local participants = props.participants or not (v10 and v10.participants) and {} or v10.participants

	local v12 = {}

	if #participants == 1 then
		table.insert(v12, v8)
	else
		for k, participant in participants do
			local v13

			if type(participant) == "table" then
				local id = participant.id or participant.userId

				if id ~= nil then
					v13 = tostring(id)
				end
			elseif participant ~= nil then
				v13 = tostring(participant)
			end

			if v13 and tostring(v13) ~= tostring(v8) then
				table.insert(v12, v13)
			end
		end
	end

	local v13

	if FFlagAppChatPresenceStoreMigration then
		v13 = React.useMemo(function()
			return Signals.createComputed(function(p2)
				local v14 = false
				local v15 = false

				for k, v16 in v12 do
					local data = v6.GetPresenceByUserId(v16).data(p2)

					if not data then
						continue
					end

					local userPresenceType = data.userPresenceType

					if
						userPresenceType == presenceType2.InGame
						or userPresenceType == presenceType2.InStudio
					then
						v14 = true
					elseif userPresenceType == presenceType2.Online then
						v15 = true
					end
				end

				return { hasInExperienceUser = v14, hasOnlineUser = v15 }
			end, groupPresenceAggregateEquals)
		end, { table.concat(v12, ",") })
	end

	local v14 = if FFlagAppChatPresenceStoreMigration then SignalsReact.useSignalState(v13) else nil

	local v15 = v12[1] or v8
	local v16 = useFoundationPresence(v15)

	local v17 = userPresence.None

	if #v12 >= 2 then
		local v18 = false
		local v19 = false

		if FFlagAppChatPresenceStoreMigration then
			v18 = if v14 then v14.hasInExperienceUser else false
			v19 = if v14 then v14.hasOnlineUser else false
		else
			for k, v20 in v12 do
				if not (v11 and v11[v20]) then
					continue
				end

				local userPresenceType = v11[v20].userPresenceType

				if userPresenceType == presenceType.InGame or userPresenceType == presenceType.InStudio then
					v18 = true
				elseif userPresenceType == presenceType.Online then
					v19 = true
				end
			end
		end

		if v18 then
			v17 = userPresence.InExperience
		elseif v19 then
			v17 = userPresence.Active
		end
	else
		v17 = v16.presence
	end

	local v18 = nil

	if fFlagEnableBlackbirdCheck and #participants == 2 then
		for k, participant in participants do
			local v20

			if type(participant) == "table" then
				local id = participant.id or participant.userId

				if id ~= nil then
					v20 = tostring(id)
				end
			elseif participant ~= nil then
				v20 = tostring(participant)
			end

			if v20 and tostring(v20) ~= tostring(v8) then
				v18 = tostring(v20)
				break
			end
		end
	end

	local v19 = useIsRobloxSubscriber(v18)

	local createElement = React.createElement
	local v21 = {
		userId = v15,
		facePileSecondUserId = v12[2] or nil,
		layoutMode = layoutMode.wide,
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
	local v22 = if props.titleText then escapeRichFormatting(props.titleText) else props.titleText
	v21.title = v22
	local v23 = if props.subtitleText then escapeRichFormatting(props.subtitleText) else props.subtitleText
	v21.subtitle = v23
	v21.titleStyle = props.titleStyle
	v21.subtitleStyle = props.subtitleStyle
	v21.userPresenceType = v17
	v21.onActivated = props.onActivated
	v21.selectable = props.selectable
	v21.customTextTruncation = Enum.TextTruncate.SplitWord
	v21.trustedConnectionIndicatorEnabled = props.trustedConnectionIndicatorEnabled

	if not fFlagEnableBlackbirdCheck then
		v19 = nil
	end

	v21.isRobloxSubscriber = v19

	local v24 = if fFlagUserTileUnfilteredChatIndicator then props.shouldShowUnfilteredChatIndicator else nil
	v21.shouldShowUnfilteredChatIndicator = v24
	return createElement(userTile, v21)
end

local function ConversationFacePile(p2)
	local conversationId = p2.conversationId

	if not conversationId or conversationId == "" then
		v5:warning("conversationId cannot be nil nor an empty string")
		return nil
	end

	local clone = table.clone(p2)
	clone.conversationId = conversationId
	return React.createElement(ConversationFacePileInner, clone)
end

return ConversationFacePile
