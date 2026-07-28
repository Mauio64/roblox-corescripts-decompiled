local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local SocialLibraries = require(AppChat.SocialLibraries)
local Cryo = require(AppChatParent.Cryo)
local DataHydration = require(AppChatParent.DataHydration)
local React = require(AppChatParent.React)
local Signals = require(AppChatParent.Signals)
local SignalsReact = require(AppChatParent.SignalsReact)
local UserModel = require(AppChatParent.UserLib).Models.UserModel
local memo = React.memo
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization
local Logger = require(script.Parent.Logger)
local presenceSortComparator = SocialLibraries.Utils.presenceSortComparator
local SortedList = SocialLibraries.Components.SortedList
local ParticipantEntryRightFrame = require(script.Parent.ParticipantEntryRightFrame)
local ParticipantEntry = require(script.Parent.ParticipantEntry)
local FFlagAppChatPresenceStoreMigration = require(AppChat.Flags.FFlagAppChatPresenceStoreMigration)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local DomLocators = require(AppChat.Utils.DomLocators)
local getFFlagAppChatParticipantDialogFoundationMenu = require(AppChat.Flags.getFFlagAppChatParticipantDialogFoundationMenu)
local v21 = if not FFlagAppChatPresenceStoreMigration then nil else DataHydration.Presence.PresenceEnums.PresenceType
local v22 = if not FFlagAppChatPresenceStoreMigration then nil else DataHydration.Presence.PresenceStore.get()
local v23 = if not FFlagAppChatPresenceStoreMigration then nil else {
	[v21.Offline] = UserModel.PresenceType.OFFLINE,
	[v21.Online] = UserModel.PresenceType.ONLINE,
	[v21.InGame] = UserModel.PresenceType.IN_GAME,
	[v21.InStudio] = UserModel.PresenceType.IN_STUDIO
}
local t1 = {
	entryHeight = 64,
	pendingKey = "Feature.Chat.Label.Pending",
	invitedKey = "Feature.SettingsHub.Label.Invited",
	LayoutOrder = 0,
	entries = {},
	onEntryActivated = function(_, _) -- line: 61
		-- upvalues: Logger (copy)
		Logger:warning("onEntryActivated was not passed to ParticipantList")
	end,
	sortComparator = presenceSortComparator
}

function ParticipantList(t2: {[any]: any}) -- line: 74
	-- upvalues: Cryo (copy), t1 (copy), getFFlagAppChatParticipantDialogFoundationMenu (copy), React (copy), useLocalization (copy), FFlagAppChatPresenceStoreMigration (copy), Signals (copy), v22 (copy), v23 (copy), SignalsReact (copy), ParticipantEntry (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), ParticipantEntryRightFrame (copy), SortedList (copy)
	local v28 = Cryo.Dictionary.join(t1, t2)
	local v29 = v28.onEntryActivated or t1.onEntryActivated
	local v30 = getFFlagAppChatParticipantDialogFoundationMenu()
	local u31 = nil

	if v30 then
		u31 = React.useRef({})
	end

	local v32 = useLocalization({
		pendingLabelText = v28.pendingKey,
		invitedLabelText = v28.invitedKey
	})
	local v33 = nil

	if FFlagAppChatPresenceStoreMigration then
		local v34 = React.useMemo(function() -- line: 91
			-- upvalues: Signals (copy), v28 (copy), v22 (copy), v23 (copy)
			return Signals.createComputed(function(p3) -- line: 92
				-- upvalues: v28 (copy), v22 (copy), v23 (copy)
				local t3 = {}

				for _, v in pairs(v28.entries) do
					local str = tostring(v.id)
					local v58 = v22.GetPresenceByUserId(str).data(p3)

					if v58 then
						t3[str] = v23[v58.userPresenceType]
					end
				end

				return t3
			end)
		end, { v28.entries })

		v33 = SignalsReact.useSignalState(v34)
	end

	local t4 = {}

	for _, v in pairs(v28.entries) do
		local t5 = {}

		if FFlagAppChatPresenceStoreMigration then
			t5.presence = v33 and v33[tostring(v.id)] or nil
		end

		local v39 = not v.isLocalUser
		local v40 = v.metadata and v.metadata.isPending

		if v39 or v40 then
			local t6 = {
				labelText = if not v40 then nil else v32.pendingLabelText,
				shouldShowDots = v39,
				testId = if not FFlagDebugAppChatEnableDomLocators or not v39 then nil else DomLocators.chatDetailsParticipantMoreButton(v.displayName)
			}

			if v30 and v39 then
				local str = tostring(v.id)
				local v43

				if u31 == nil then
					v43 = nil
				else
					if u31.current[str] == nil then
						u31.current[str] = React.createRef()
					end

					v43 = u31.current[str]
				end

				local v44 = v43

				t6.dotsRef = v44

				function t6.onDotsActivated() -- line: 166
					-- upvalues: v29 (copy), v (copy), v44 (copy)
					v29(v, v44)
				end
			else
				t6.dotsRef = nil
				t6.onDotsActivated = nil
			end

			t5.children = {
				rightFrame = React.createElement(ParticipantEntryRightFrame, t6)
			}
		end

		table.insert(t4, Cryo.Dictionary.join(t5, v))
	end

	return React.createElement(SortedList, {
		entries = t4,
		entryHeight = v28.entryHeight,
		renderEntry = function(p4, _) -- line: 120
			-- upvalues: v32 (copy), v30 (copy), u31 (ref), React (copy), v28 (copy), v29 (copy), ParticipantEntry (copy)
			local v48 = p4.metadata and p4.metadata.isInvited
			local str = tostring(p4.id)
			local t7 = {
				userId = p4.id,
				statusText = if not v48 then nil else v32.invitedLabelText
			}

			if v30 then
				local v51

				if u31 == nil then
					v51 = nil
				else
					if u31.current[str] == nil then
						u31.current[str] = React.createRef()
					end

					v51 = u31.current[str]
				end

				local v52 = v51

				t7.onActivated = str ~= v28.activeParticipantId and function() -- line: 133
					-- upvalues: v29 (copy), p4 (copy), v52 (copy)
					v29(p4, v52)
				end or nil
			else
				function t7.onActivated() -- line: 137
					-- upvalues: v29 (copy), p4 (copy)
					v29(p4, nil)
				end
			end

			return React.createElement(ParticipantEntry, t7, p4.children)
		end,
		sortComparator = v28.sortComparator,
		LayoutOrder = v28.LayoutOrder
	})
end

return memo(ParticipantList)
