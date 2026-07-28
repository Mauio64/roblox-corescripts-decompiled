local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Logger = require(AppChatParent.Loggers).Logger
local React = require(AppChatParent.React)
local useLocalUserId = require(AppChatParent.RobloxAppHooks).useLocalUserId
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local Foundation = require(AppChatParent.Foundation)
local FFlagEnableBlackbirdCheck = require(AppChatParent.SharedFlags).FFlagEnableBlackbirdCheck
local useIsRobloxSubscriber = require(AppChatParent.UserProfiles).Hooks.useIsRobloxSubscriber
local UserTile = require(AppChatParent.UserTile).UserTile
local LayoutMode = require(AppChatParent.UserTile).LayoutMode
local RoduxPresence = require(AppChat.Http.RoduxPresence)
local FFlagAppChatPresenceStoreMigration = require(AppChat.Flags.FFlagAppChatPresenceStoreMigration)
local DataHydration = require(AppChatParent.DataHydration)
local Signals = require(AppChatParent.Signals)
local SignalsReact = require(AppChatParent.SignalsReact)
local v17 = Logger:new(script.Name)
local useFoundationPresence = require(AppChat.Hooks.useFoundationPresence)
local PresenceType = RoduxPresence.Enums.PresenceType
local UserPresence = Foundation.Enums.UserPresence
local v21 = if not FFlagAppChatPresenceStoreMigration then nil else DataHydration.Presence.PresenceEnums.PresenceType
local v22 = if not FFlagAppChatPresenceStoreMigration then nil else DataHydration.Presence.PresenceStore.get()

local function groupPresenceAggregateEquals(t1: {[any]: any}, t2: {[any]: any}) -- line: 41
	return t1.hasInExperienceUser == t2.hasInExperienceUser and t1.hasOnlineUser == t2.hasOnlineUser
end
local function getParticipantId(p1) -- line: 72
	if type(p1) == "table" then
		local v31 = p1.id or p1.userId

		if v31 ~= nil then
			return (tostring(v31))
		end

		return nil
	end

	if p1 ~= nil then
		return (tostring(p1))
	end

	return nil
end
local function getNonEmptyLocalUserId(p2) -- line: 81
	if p2 == nil or p2 == "" then
		return nil
	end

	return (tostring(p2))
end
local function ConversationFacePileInner(t3: {[any]: any}) -- line: 89
	-- upvalues: useLocalUserId (copy), React (copy), useSelector (copy), FFlagAppChatPresenceStoreMigration (copy), Signals (copy), v22 (copy), v21 (copy), groupPresenceAggregateEquals (copy), SignalsReact (copy), useFoundationPresence (copy), UserPresence (copy), PresenceType (copy), FFlagEnableBlackbirdCheck (copy), useIsRobloxSubscriber (copy), UserTile (copy), LayoutMode (copy)
	local conversationId = t3.conversationId
	local v35 = useLocalUserId()
	local localUserId = t3.localUserId
	local v37 = ((if localUserId ~= nil and localUserId ~= "" then tostring(localUserId) else nil)) or (((if v35 ~= nil and v35 ~= "" then tostring(v35) else nil)) or "")
	local v38 = React.useCallback(function(p3) -- line: 94
		-- upvalues: conversationId (copy)
		if p3 and (p3.ChatAppReducer and p3.ChatAppReducer.Conversations) then
			return p3.ChatAppReducer.Conversations[conversationId]
		end

		return nil
	end, { conversationId })
	local v39 = useSelector(v38)
	local v40 = if FFlagAppChatPresenceStoreMigration then nil else useSelector(function(p4) -- line: 103
		if p4 and (p4.ChatAppReducer and p4.ChatAppReducer.Presence) then
			return p4.ChatAppReducer.Presence.byUserId
		end

		return nil
	end)
	local v41 = t3.participants or if not v39 or not v39.participants then {} else v39.participants
	local t4 = {}

	if #v41 == 1 then
		table.insert(t4, v37)
	else
		for _, v44 in v41 do
			local v46

			if type(v44) == "table" then
				local v45 = v44.id or v44.userId

				v46 = if v45 == nil then nil else tostring(v45)
			else
				v46 = if v44 == nil then nil else tostring(v44)
			end

			if v46 and tostring(v46) ~= tostring(v37) then
				table.insert(t4, v46)
			end
		end
	end

	local v47 = if not FFlagAppChatPresenceStoreMigration then nil else React.useMemo(function() -- line: 127
		-- upvalues: Signals (copy), t4 (copy), v22 (copy), v21 (copy), groupPresenceAggregateEquals (copy)
		return Signals.createComputed(function(p5) -- line: 128
			-- upvalues: t4 (copy), v22 (copy), v21 (copy)
			local v69 = false
			local v70 = false

			for _, v72 in t4 do
				local v73 = v22.GetPresenceByUserId(v72).data(p5)

				if v73 then
					local userPresenceType = v73.userPresenceType

					if userPresenceType == v21.InGame or userPresenceType == v21.InStudio then
						v69 = true
					elseif userPresenceType == v21.Online then
						v70 = true
					end
				end
			end

			return {
				hasInExperienceUser = v69,
				hasOnlineUser = v70
			}
		end, groupPresenceAggregateEquals)
	end, { table.concat(t4, ",") })
	local v48 = if not FFlagAppChatPresenceStoreMigration then nil else SignalsReact.useSignalState(v47)
	local v49 = t4[1] or v37
	local v50 = useFoundationPresence(v49)
	local None = UserPresence.None

	if #t4 >= 2 then
		local v52 = false
		local v53 = false

		if FFlagAppChatPresenceStoreMigration then
			v52 = not not v48 and v48.hasInExperienceUser
			v53 = not not v48 and v48.hasOnlineUser
		else
			for _, v55 in t4 do
				if v40 and v40[v55] then
					local userPresenceType = v40[v55].userPresenceType

					if userPresenceType == PresenceType.InGame or userPresenceType == PresenceType.InStudio then
						v52 = true
					elseif userPresenceType == PresenceType.Online then
						v53 = true
					end
				end
			end
		end

		if v52 then
			None = UserPresence.InExperience
		elseif v53 then
			None = UserPresence.Active
		end
	else
		None = v50.presence
	end

	local str = nil

	if FFlagEnableBlackbirdCheck and #v41 == 2 then
		for _, v59 in v41 do
			local v61

			if type(v59) == "table" then
				local v60 = v59.id or v59.userId

				v61 = if v60 == nil then nil else tostring(v60)
			else
				v61 = if v59 == nil then nil else tostring(v59)
			end

			if v61 and tostring(v61) ~= tostring(v37) then
				str = tostring(v61)

				break
			end
		end
	end

	local v62 = useIsRobloxSubscriber(str)

	return React.createElement(UserTile, {
		userId = v49,
		facePileSecondUserId = t4[2] or nil,
		layoutMode = LayoutMode.wide,
		title = t3.titleText,
		subtitle = t3.subtitleText,
		titleStyle = t3.titleStyle,
		subtitleStyle = t3.subtitleStyle,
		userPresenceType = None,
		onActivated = t3.onActivated,
		selectable = t3.selectable,
		customTextTruncation = Enum.TextTruncate.SplitWord,
		trustedConnectionIndicatorEnabled = t3.trustedConnectionIndicatorEnabled,
		isRobloxSubscriber = if not FFlagEnableBlackbirdCheck then nil else v62
	})
end
local function ConversationFacePile(t5: {[any]: any}) -- line: 224
	-- upvalues: v17 (copy), React (copy), ConversationFacePileInner (copy)
	local conversationId = t5.conversationId

	if not conversationId or conversationId == "" then
		v17:warning("conversationId cannot be nil nor an empty string")

		return nil
	end

	local v65 = table.clone(t5)

	v65.conversationId = conversationId

	return React.createElement(ConversationFacePileInner, v65)
end

return ConversationFacePile
