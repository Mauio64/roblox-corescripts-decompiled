local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local SocialLibraries = require(AppChat.SocialLibraries)
local Cryo = require(parent.Cryo)
local DataHydration = require(parent.DataHydration)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local UserLib = require(parent.UserLib)
local UserModel = UserLib.Models.UserModel
local memo = React.memo
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local Logger = require(script.Parent.Logger)
local presenceSortComparator = SocialLibraries.Utils.presenceSortComparator

local SortedList = SocialLibraries.Components.SortedList
local ParticipantEntryRightFrame = require(script.Parent.ParticipantEntryRightFrame)
local ParticipantEntry = require(script.Parent.ParticipantEntry)
local FFlagAppChatPresenceStoreMigration = require(AppChat.Flags.FFlagAppChatPresenceStoreMigration)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local DomLocators = require(AppChat.Utils.DomLocators)
local presenceType

if FFlagAppChatPresenceStoreMigration then
	presenceType = DataHydration.Presence.PresenceEnums.PresenceType
end

local v

if FFlagAppChatPresenceStoreMigration then
	v = DataHydration.Presence.PresenceStore.get()
else
	v = nil
end

local v2

if FFlagAppChatPresenceStoreMigration then
	v2 = {}
	v2[presenceType.Offline] = UserModel.PresenceType.OFFLINE
	v2[presenceType.Online] = UserModel.PresenceType.ONLINE
	v2[presenceType.InGame] = UserModel.PresenceType.IN_GAME
	v2[presenceType.InStudio] = UserModel.PresenceType.IN_STUDIO
else
	v2 = nil
end

local v3 = {
	entries = {},
	entryHeight = 64,
	onEntryActivated = function(_, _)
		Logger:warning("onEntryActivated was not passed to ParticipantList")
	end,
	pendingKey = "Feature.Chat.Label.Pending",
	invitedKey = "Feature.SettingsHub.Label.Invited",
	sortComparator = presenceSortComparator,
	LayoutOrder = 0
}

function ParticipantList(p)
	local joined = Cryo.Dictionary.join(v3, p)
	local onEntryActivated = joined.onEntryActivated or v3.onEntryActivated
	local ref = React.useRef({})

	local v4 = useLocalization({
		pendingLabelText = joined.pendingKey,
		invitedLabelText = joined.invitedKey
	})
	local v5

	if FFlagAppChatPresenceStoreMigration then
		local v6 = React.useMemo(function()
			return Signals.createComputed(function(p2)
				local result = {}

				for _, entry in pairs(joined.entries) do
					local id = tostring(entry.id)
					local data = v.GetPresenceByUserId(id).data(p2)

					if data then
						result[id] = v2[data.userPresenceType]
					end
				end

				return result
			end)
		end, { joined.entries })

		v5 = SignalsReact.useSignalState(v6)
	end

	local function fn(id: string) -- 2 equivalent calls inferred from this helper
		if ref.current[id] == nil then
			ref.current[id] = React.createRef()
		end

		return ref.current[id]
	end

	local function fn2(props, _)
		local isInvited = props.metadata and props.metadata.isInvited
		local id = tostring(props.id)
		local v6 = { userId = props.id, statusText = 0 }
		local statusText

		if isInvited then
			statusText = v4.invitedLabelText
		end

		v6.statusText = statusText
		local v7 = fn(id) -- inferred equivalent call
		local v8 = joined.activeParticipantId == id
		function v6.onActivated()
			if not v8 then
				onEntryActivated(props, v7)
			end
		end

		return React.createElement(ParticipantEntry, v6, props.children)
	end

	local values = {}

	for _, entry in pairs(joined.entries) do
		local v6 = {}

		if FFlagAppChatPresenceStoreMigration then
			local presence

			if v5 then
				presence = v5[tostring(entry.id)] or nil
			end

			v6.presence = presence
		end

		local shouldShowDots = not entry.isLocalUser
		local isPending = entry.metadata and entry.metadata.isPending

		if shouldShowDots or isPending then
			local labelText

			if isPending then
				labelText = v4.pendingLabelText
			end

			local testId

			if FFlagDebugAppChatEnableDomLocators and shouldShowDots then
				testId = DomLocators.chatDetailsParticipantMoreButton(entry.displayName)
			end

			local v7 = { labelText = labelText, shouldShowDots = shouldShowDots, testId = testId }

			if shouldShowDots then
				local dotsRef = fn(tostring(entry.id)) -- inferred equivalent call
				v7.dotsRef = dotsRef
				function v7.onDotsActivated()
					onEntryActivated(entry, dotsRef)
				end
			else
				v7.dotsRef = nil
				v7.onDotsActivated = nil
			end

			v6.children = {
				rightFrame = React.createElement(ParticipantEntryRightFrame, v7)
			}
		end

		table.insert(values, Cryo.Dictionary.join(v6, entry))
	end

	return React.createElement(SortedList, {
		entries = values,
		entryHeight = joined.entryHeight,
		renderEntry = fn2,
		sortComparator = joined.sortComparator,
		LayoutOrder = joined.LayoutOrder
	})
end

return memo(ParticipantList)
