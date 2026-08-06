local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Logger = require(AppChatParent.Loggers).Logger
local React = require(AppChatParent.React)
local useLocalUserId = require(AppChatParent.RobloxAppHooks).useLocalUserId
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local Foundation = require(AppChatParent.Foundation)
local FFlagEnableBlackbirdCheck = require(AppChatParent.SharedFlags).FFlagEnableBlackbirdCheck
local FFlagAppChatSanitizeConversationTitleRichText = require(AppChatParent.SharedFlags).FFlagAppChatSanitizeConversationTitleRichText
local escapeRichFormatting = require(AppChatParent.InlineRichText).escapeRichFormatting
local useIsRobloxSubscriber = require(AppChatParent.UserProfiles).Hooks.useIsRobloxSubscriber
local UserTile = require(AppChatParent.UserTile).UserTile
local LayoutMode = require(AppChatParent.UserTile).LayoutMode
local RoduxPresence = require(AppChat.Http.RoduxPresence)
local FFlagAppChatPresenceStoreMigration = require(AppChat.Flags.FFlagAppChatPresenceStoreMigration)
local DataHydration = require(AppChatParent.DataHydration)
local Signals = require(AppChatParent.Signals)
local SignalsReact = require(AppChatParent.SignalsReact)
local v19 = Logger:new(script.Name)
local useFoundationPresence = require(AppChat.Hooks.useFoundationPresence)
local PresenceType = RoduxPresence.Enums.PresenceType
local UserPresence = Foundation.Enums.UserPresence
local v23 = if not FFlagAppChatPresenceStoreMigration then nil else DataHydration.Presence.PresenceEnums.PresenceType
local v24 = if not FFlagAppChatPresenceStoreMigration then nil else DataHydration.Presence.PresenceStore.get()

local function groupPresenceAggregateEquals(t1: {[any]: any}, t2: {[any]: any}) -- line: 44
	return t1.hasInExperienceUser == t2.hasInExperienceUser and t1.hasOnlineUser == t2.hasOnlineUser
end
local function getParticipantId(p1) -- line: 75
	if type(p1) == "table" then
		local v33 = p1.id or p1.userId

		if v33 ~= nil then
			return (tostring(v33))
		end

		return nil
	end

	if p1 ~= nil then
		return (tostring(p1))
	end

	return nil
end
local function getNonEmptyLocalUserId(p2) -- line: 84
	if p2 == nil or p2 == "" then
		return nil
	end

	return (tostring(p2))
end
local function ConversationFacePileInner(t3: {[any]: any}) -- line: 92
	-- upvalues: useLocalUserId (copy), React (copy), useSelector (copy), FFlagAppChatPresenceStoreMigration (copy), Signals (copy), v24 (copy), v23 (copy), groupPresenceAggregateEquals (copy), SignalsReact (copy), useFoundationPresence (copy), UserPresence (copy), PresenceType (copy), FFlagEnableBlackbirdCheck (copy), useIsRobloxSubscriber (copy), UserTile (copy), LayoutMode (copy), FFlagAppChatSanitizeConversationTitleRichText (copy), escapeRichFormatting (copy)
	local conversationId = t3.conversationId
	local v37 = useLocalUserId()
	local localUserId = t3.localUserId
	local v39 = ((if localUserId ~= nil and localUserId ~= "" then tostring(localUserId) else nil)) or (((if v37 ~= nil and v37 ~= "" then tostring(v37) else nil)) or "")
	local v40 = React.useCallback(function(p3) -- line: 97
		-- upvalues: conversationId (copy)
		if p3 and (p3.ChatAppReducer and p3.ChatAppReducer.Conversations) then
			return p3.ChatAppReducer.Conversations[conversationId]
		end

		return nil
	end, { conversationId })
	local v41 = useSelector(v40)
	local v42 = if FFlagAppChatPresenceStoreMigration then nil else useSelector(function(p4) -- line: 106
		if p4 and (p4.ChatAppReducer and p4.ChatAppReducer.Presence) then
			return p4.ChatAppReducer.Presence.byUserId
		end

		return nil
	end)
	local v43 = t3.participants or if not v41 or not v41.participants then {} else v41.participants
	local t4 = {}

	if #v43 == 1 then
		table.insert(t4, v39)
	else
		for _, v46 in v43 do
			local v48

			if type(v46) == "table" then
				local v47 = v46.id or v46.userId

				v48 = if v47 == nil then nil else tostring(v47)
			else
				v48 = if v46 == nil then nil else tostring(v46)
			end

			if v48 and tostring(v48) ~= tostring(v39) then
				table.insert(t4, v48)
			end
		end
	end

	local v49 = if not FFlagAppChatPresenceStoreMigration then nil else React.useMemo(function() -- line: 130
		-- upvalues: Signals (copy), t4 (copy), v24 (copy), v23 (copy), groupPresenceAggregateEquals (copy)
		return Signals.createComputed(function(p5) -- line: 131
			-- upvalues: t4 (copy), v24 (copy), v23 (copy)
			local v71 = false
			local v72 = false

			for _, v74 in t4 do
				local v75 = v24.GetPresenceByUserId(v74).data(p5)

				if v75 then
					local userPresenceType = v75.userPresenceType

					if userPresenceType == v23.InGame or userPresenceType == v23.InStudio then
						v71 = true
					elseif userPresenceType == v23.Online then
						v72 = true
					end
				end
			end

			return {
				hasInExperienceUser = v71,
				hasOnlineUser = v72
			}
		end, groupPresenceAggregateEquals)
	end, { table.concat(t4, ",") })
	local v50 = if not FFlagAppChatPresenceStoreMigration then nil else SignalsReact.useSignalState(v49)
	local v51 = t4[1] or v39
	local v52 = useFoundationPresence(v51)
	local None = UserPresence.None

	if #t4 >= 2 then
		local v54 = false
		local v55 = false

		if FFlagAppChatPresenceStoreMigration then
			v54 = not not v50 and v50.hasInExperienceUser
			v55 = not not v50 and v50.hasOnlineUser
		else
			for _, v57 in t4 do
				if v42 and v42[v57] then
					local userPresenceType = v42[v57].userPresenceType

					if userPresenceType == PresenceType.InGame or userPresenceType == PresenceType.InStudio then
						v54 = true
					elseif userPresenceType == PresenceType.Online then
						v55 = true
					end
				end
			end
		end

		if v54 then
			None = UserPresence.InExperience
		elseif v55 then
			None = UserPresence.Active
		end
	else
		None = v52.presence
	end

	local str = nil

	if FFlagEnableBlackbirdCheck and #v43 == 2 then
		for _, v61 in v43 do
			local v63

			if type(v61) == "table" then
				local v62 = v61.id or v61.userId

				v63 = if v62 == nil then nil else tostring(v62)
			else
				v63 = if v61 == nil then nil else tostring(v61)
			end

			if v63 and tostring(v63) ~= tostring(v39) then
				str = tostring(v63)

				break
			end
		end
	end

	local v64 = useIsRobloxSubscriber(str)

	return React.createElement(UserTile, {
		userId = v51,
		facePileSecondUserId = t4[2] or nil,
		layoutMode = LayoutMode.wide,
		title = if not FFlagAppChatSanitizeConversationTitleRichText or not t3.titleText then t3.titleText else escapeRichFormatting(t3.titleText),
		subtitle = if not FFlagAppChatSanitizeConversationTitleRichText or not t3.subtitleText then t3.subtitleText else escapeRichFormatting(t3.subtitleText),
		titleStyle = t3.titleStyle,
		subtitleStyle = t3.subtitleStyle,
		userPresenceType = None,
		onActivated = t3.onActivated,
		selectable = t3.selectable,
		customTextTruncation = Enum.TextTruncate.SplitWord,
		trustedConnectionIndicatorEnabled = t3.trustedConnectionIndicatorEnabled,
		isRobloxSubscriber = if not FFlagEnableBlackbirdCheck then nil else v64
	})
end
local function ConversationFacePile(t5: {[any]: any}) -- line: 231
	-- upvalues: v19 (copy), React (copy), ConversationFacePileInner (copy)
	local conversationId = t5.conversationId

	if not conversationId or conversationId == "" then
		v19:warning("conversationId cannot be nil nor an empty string")

		return nil
	end

	local v67 = table.clone(t5)

	v67.conversationId = conversationId

	return React.createElement(ConversationFacePileInner, v67)
end

return ConversationFacePile
