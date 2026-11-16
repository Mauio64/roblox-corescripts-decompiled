local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/SignalsReact")

local array = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/LuauPolyfill").Array
local fFlagShareSheetFriendsSort = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/SharedFlags").FFlagShareSheetFriendsSort

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Localization").Hooks.useLocalization
local UserProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/DataHydration/UserProfile")
local ShareSheetConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/ShareSheetConstants")
local ConversationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Utils/ConversationUtils")
local filterConversationsByQuery = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Utils/filterConversationsByQuery")
local formatPeoplePickerUserInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Utils/formatPeoplePickerUserInfo")
local matchesQuery = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Utils/matchesQuery")
local Recipient = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/Recipient")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Types")

local Players = game:GetService("Players")

local function getUserInfoResult(p2)
	if p2 == nil or p2 == "" then
		return nil
	end

	return (UserProfile.getAndFetchUserInfo(p2))
end

local function readUserInfo(p2, p3)
	if p2 == nil then
		return nil, false
	end

	return p2.info(p3), p2.status(p3) == "NotReady"
end

local function getRowCount(list, list2)
	if fFlagShareSheetFriendsSort then
		return #list2
	end

	return #list
end

local function getRow(p2, p3, p4)
	local v5 = if not fFlagShareSheetFriendsSort then p2[p4] else nil
	local v6 = if fFlagShareSheetFriendsSort then p3[p4] else nil

	if fFlagShareSheetFriendsSort then
		return v5, v6, v6.id
	end

	return v5, v6, v5.id
end

local function getRowUserIds(p2, p3, p4)
	if not fFlagShareSheetFriendsSort then
		return ConversationUtils.getParticipantUserIds(p2, p4)
	end

	local participantIds = Recipient.getParticipantIds(p3, p4)
	return participantIds[1] or p4, participantIds[2]
end

local function filterRecipientsByQuery(p2, value, p3, p4)
	if value == "" then
		return p2
	end

	local v5 = string.lower(value)
	return array.filter(p2, function(p5)
		return matchesQuery(v5, p3[p5.id] or "", p4[p5.id] or "")
	end)
end

local function getDisplayNames(p2, list, list2, p3, p4)
	local v5 = {}
	local v6 = {}
	local v7 = false
	local idSet = {}
	local v9 = if fFlagShareSheetFriendsSort then #list2 else #list

	for i = 1, v9 do
		local v10 = if not fFlagShareSheetFriendsSort then list[i] else nil
		local v11 = if fFlagShareSheetFriendsSort then list2[i] else nil
		local id = if fFlagShareSheetFriendsSort then v11.id else v10.id
		local v12

		if fFlagShareSheetFriendsSort then
			v12 = Recipient.getName(v11, p2)
		else
			v12 = ConversationUtils.getDisplayName(v10)
		end

		local v13 = p3[id]

		if v13 then
			local primary = v13.primary
			local v14, v15

			if primary == nil then
				v14 = false
			else
				v15 = primary.info(p2)
				v14 = primary.status(p2) == "NotReady"
			end

			local second = v13.second
			local v16, v17

			if second == nil then
				v16 = false
			else
				v17 = second.info(p2)
				v16 = second.status(p2) == "NotReady"
			end

			local v18 = v14 or v16
			v7 = v18 and true or v7
			local v19 = { displayName = p4 }
			local v20 = {}

			if v15 then
				table.insert(v20, v15)
			else
				table.insert(v20, v19)
			end

			if v13.second ~= nil then
				if v17 then
					table.insert(v20, v17)
				else
					table.insert(v20, v19)
				end
			end

			if v12 == "" then
				if v18 then
					idSet[id] = true
				else
					v12 = formatPeoplePickerUserInfo.formatTitle(v20)
				end
			end

			if not v18 then
				v5[id] = formatPeoplePickerUserInfo.formatDescription(v20)
			end
		end

		v6[id] = v12
	end

	return {
		descriptionsByConversationId = v5,
		displayNamesByConversationId = v6,
		isLoading = v7,
		loadingConversationIds = idSet
	}
end

local function useConversationDisplayNames(conversations, recipients, userId, unknownUser)
	local v5 = React.useMemo(function()
		local result = {}
		local v7 = conversations
		local v8 = recipients
		local v9 = if fFlagShareSheetFriendsSort then #v8 else #v7

		for i = 1, v9 do
			local v10 = conversations
			local v11 = recipients
			local v12 = if not fFlagShareSheetFriendsSort then v10[i] else nil
			local v13 = if fFlagShareSheetFriendsSort then v11[i] else nil
			local id = if fFlagShareSheetFriendsSort then v13.id else v12.id

			local v14 = userId
			local v15, v16

			if fFlagShareSheetFriendsSort then
				local participantIds = Recipient.getParticipantIds(v13, v14)
				v15 = participantIds[1] or v14
				v16 = participantIds[2]
			else
				v15, v16 = ConversationUtils.getParticipantUserIds(v12, v14)
			end

			local v18 = if v15 ~= nil and v15 ~= "" then UserProfile.getAndFetchUserInfo(v15) else nil
			local v19 = if v16 ~= nil and v16 ~= "" then UserProfile.getAndFetchUserInfo(v16) else nil

			result[id] = { primary = v18, second = v19 }
		end

		return result
	end, { conversations, userId, recipients })

	local v6 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			return getDisplayNames(p2, conversations, recipients, v5, unknownUser)
		end)
	end, { conversations, recipients, unknownUser, v5 })

	return SignalsReact.useSignalState(v6)
end

local function usePeoplePickerListViewModel(data)
	local userId = tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0)
	local v5 = useLocalization({ unknownUser = "Feature.Chat.Label.UnknownUser" })

	local v6 = useConversationDisplayNames(data.conversations, data.recipients, userId, v5.unknownUser)
	local displayNamesByConversationId = v6.displayNamesByConversationId
	local v7 = React.useMemo(function()
		if fFlagShareSheetFriendsSort then
			return nil
		end

		return (filterConversationsByQuery(
			data.conversations,
			data.filterQuery,
			displayNamesByConversationId,
			v6.descriptionsByConversationId
		))
	end, {
		displayNamesByConversationId,
		v6.descriptionsByConversationId,
		data.conversations,
		data.filterQuery
	})

	local v8 = React.useMemo(function()
		if not fFlagShareSheetFriendsSort then
			return nil
		end

		local recipients = data.recipients
		local filterQuery = data.filterQuery
		local v9 = displayNamesByConversationId
		local descriptionsByConversationId = v6.descriptionsByConversationId

		if filterQuery == "" then
			return recipients
		end

		local v10 = string.lower(filterQuery)
		return (array.filter(recipients, function(p2)
			return matchesQuery(v10, v9[p2.id] or "", descriptionsByConversationId[p2.id] or "")
		end))
	end, {
		displayNamesByConversationId,
		v6.descriptionsByConversationId,
		data.filterQuery,
		data.recipients
	})

	local v9 = React.useMemo(function()
		local v10 = v7
		local v11 = v8
		local v12 = if fFlagShareSheetFriendsSort then #v11 else #v10

		local result = table.create(v12)

		for i = 1, v12 do
			local v13 = v7
			local v14 = v8
			local v15 = if not fFlagShareSheetFriendsSort then v13[i] else nil
			local v16 = if fFlagShareSheetFriendsSort then v14[i] else nil
			local id = if fFlagShareSheetFriendsSort then v16.id else v15.id

			local v17 = userId
			local v18, v19

			if fFlagShareSheetFriendsSort then
				local participantIds = Recipient.getParticipantIds(v16, v17)
				v18 = participantIds[1] or v17
				v19 = participantIds[2]
			else
				v18, v19 = ConversationUtils.getParticipantUserIds(v15, v17)
			end

			result[i] = {
				description = v6.descriptionsByConversationId[id],
				displayName = displayNamesByConversationId[id],
				id = id,
				isLoading = v6.loadingConversationIds[id] == true,
				isSelected = data.selectedConversationIds[id] == true,
				primaryUserId = v18,
				secondUserId = v19
			}
		end

		return result
	end, {
		v6.descriptionsByConversationId,
		v6.loadingConversationIds,
		displayNamesByConversationId,
		userId,
		data.selectedConversationIds,
		v7,
		v8
	})

	local isLoading = data.isLoading or v6.isLoading and #v9 == 0

	return {
		items = v9,
		shouldShowEmptyState = #v9 == 0 and not isLoading,
		skeletonCount = not isLoading and 0 or ShareSheetConstants.FIntShareSheetNumAvatarSkeletons
	}
end

return usePeoplePickerListViewModel
