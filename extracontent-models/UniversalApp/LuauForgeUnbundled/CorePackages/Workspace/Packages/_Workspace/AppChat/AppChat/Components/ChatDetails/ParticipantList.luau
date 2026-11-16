local SocialLibraries = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/SocialLibraries")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact")
local userModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserLib").Models.UserModel
local memo = React.memo
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization

local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/Logger")
local presenceSortComparator = SocialLibraries.Utils.presenceSortComparator

local sortedList = SocialLibraries.Components.SortedList
local ParticipantEntryRightFrame = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/ParticipantEntryRightFrame")
local ParticipantEntry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/ParticipantEntry")
local FFlagAppChatPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPresenceStoreMigration")
local FFlagDebugAppChatEnableDomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagDebugAppChatEnableDomLocators")
local DomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/DomLocators")

local presenceType = if FFlagAppChatPresenceStoreMigration then DataHydration.Presence.PresenceEnums.PresenceType else nil

local v5 = if FFlagAppChatPresenceStoreMigration then DataHydration.Presence.PresenceStore.get() else nil
local v6

if FFlagAppChatPresenceStoreMigration then
	v6 = {}
	v6[presenceType.Offline] = userModel.PresenceType.OFFLINE
	v6[presenceType.Online] = userModel.PresenceType.ONLINE
	v6[presenceType.InGame] = userModel.PresenceType.IN_GAME
	v6[presenceType.InStudio] = userModel.PresenceType.IN_STUDIO
else
	v6 = nil
end

local v7 = {
	entries = {},
	entryHeight = 64,
	onEntryActivated = function(p2, p3)
		Logger:warning("onEntryActivated was not passed to ParticipantList")
	end,
	pendingKey = "Feature.Chat.Label.Pending",
	invitedKey = "Feature.SettingsHub.Label.Invited",
	sortComparator = presenceSortComparator,
	LayoutOrder = 0
}

function LUAUFORGE_MODULE_GLOBALS_hsL_ParticipantList(p2)
	local joined = Cryo.Dictionary.join(v7, p2)
	local onEntryActivated = joined.onEntryActivated or v7.onEntryActivated
	local ref = React.useRef({})

	local v8 = useLocalization({
		pendingLabelText = joined.pendingKey,
		invitedLabelText = joined.invitedKey
	})
	local v9

	if FFlagAppChatPresenceStoreMigration then
		local v10 = React.useMemo(function()
			return Signals.createComputed(function(p3)
				local result = {}

				for k, entry in pairs(joined.entries) do
					local id = tostring(entry.id)
					local data = v5.GetPresenceByUserId(id).data(p3)

					if data then
						result[id] = v6[data.userPresenceType]
					end
				end

				return result
			end)
		end, { joined.entries })

		v9 = SignalsReact.useSignalState(v10)
	end

	local function fn(props, p3)
		local isInvited = props.metadata and props.metadata.isInvited
		local id = tostring(props.id)
		local v10 = { userId = props.id, statusText = 0 }
		local v11 = if isInvited then v8.invitedLabelText else nil
		v10.statusText = v11

		if ref.current[id] == nil then
			ref.current[id] = React.createRef()
		end

		local v12 = ref.current[id]

		local v13 = joined.activeParticipantId == id
		function v10.onActivated()
			if not v13 then
				onEntryActivated(props, v12)
			end
		end

		return React.createElement(ParticipantEntry, v10, props.children)
	end

	local values = {}

	for k, entry in pairs(joined.entries) do
		local v10 = {}

		if FFlagAppChatPresenceStoreMigration then
			local v11 = if v9 then v9[tostring(entry.id)] or nil else nil
			v10.presence = v11
		end

		local v11 = not entry.isLocalUser
		local isPending = entry.metadata and entry.metadata.isPending

		if v11 or isPending then
			local v13 = if isPending then v8.pendingLabelText else nil

			local v14 = if FFlagDebugAppChatEnableDomLocators and v11 then DomLocators.chatDetailsParticipantMoreButton(entry.displayName) else nil
			local v12 = { labelText = v13, shouldShowDots = v11, testId = v14 }

			if v11 then
				local id = tostring(entry.id)

				if ref.current[id] == nil then
					ref.current[id] = React.createRef()
				end

				local v15 = ref.current[id]

				v12.dotsRef = v15
				function v12.onDotsActivated()
					onEntryActivated(entry, v15)
				end
			else
				v12.dotsRef = nil
				v12.onDotsActivated = nil
			end

			v10.children = {
				rightFrame = React.createElement(ParticipantEntryRightFrame, v12)
			}
		end

		table.insert(values, Cryo.Dictionary.join(v10, entry))
	end

	return React.createElement(sortedList, {
		entries = values,
		entryHeight = joined.entryHeight,
		renderEntry = fn,
		sortComparator = joined.sortComparator,
		LayoutOrder = joined.LayoutOrder
	})
end

return memo(LUAUFORGE_MODULE_GLOBALS_hsL_ParticipantList)
