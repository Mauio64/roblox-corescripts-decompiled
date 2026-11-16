local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local SharedFlags = require(parent.SharedFlags)
local FFlagShareSheetFriendsSort = SharedFlags.FFlagShareSheetFriendsSort

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local UserProfile = require(parent.DataHydration.UserProfile)
local ShareSheetConstants = require(ShareSheet.ShareSheetConstants)
local ConversationUtils = require(ShareSheet.Utils.ConversationUtils)
local filterConversationsByQuery = require(ShareSheet.Utils.filterConversationsByQuery)
local formatPeoplePickerUserInfo = require(ShareSheet.Utils.formatPeoplePickerUserInfo)
local matchesQuery = require(ShareSheet.Utils.matchesQuery)
local Recipient = require(ShareSheet.Recipients.Recipient)
require(ShareSheet.Types)

local Players = game:GetService("Players")

local function getUserInfoResult(p: string?) -- 2 equivalent calls inferred from this helper
	if p == nil or p == "" then
		return nil
	end

	return (UserProfile.getAndFetchUserInfo(p))
end

local function readUserInfo(p, p2) -- 2 equivalent calls inferred from this helper
	if p == nil then
		return nil, false
	end

	return p.info(p2), p.status(p2) == "NotReady"
end

local function getRowCount(list, list2) -- 3 equivalent calls inferred from this helper
	if FFlagShareSheetFriendsSort then
		return #list2
	end

	return #list
end

local function getRow(p, p2, p3: number)
	local v

	if not FFlagShareSheetFriendsSort then
		v = p[p3]
	end

	local selected

	if FFlagShareSheetFriendsSort then
		selected = p2[p3]
	end

	if FFlagShareSheetFriendsSort then
		return v, selected, selected.id
	end

	return v, selected, v.id
end

local function getRowUserIds(p, p2, p3: string)
	if not FFlagShareSheetFriendsSort then
		return ConversationUtils.getParticipantUserIds(p, p3)
	end

	local participantIds = Recipient.getParticipantIds(p2, p3)
	return participantIds[1] or p3, participantIds[2]
end

local function filterRecipientsByQuery(p, value: string, p2, p3)
	if value == "" then
		return p
	end

	local v = string.lower(value)
	return Array.filter(p, function(p4)
		return matchesQuery(v, p2[p4.id] or "", p3[p4.id] or "")
	end)
end

local function getDisplayNames(p, list, list2, p2, displayName: string)
	local descriptionsByConversationId = {}
	local displayNamesByConversationId = {}
	local isLoading = false
	local idSet = {}
	local rowCount = getRowCount(list, list2) -- inferred equivalent call

	for i = 1, rowCount do
		local v

		if not FFlagShareSheetFriendsSort then
			v = list[i]
		end

		local v2

		if FFlagShareSheetFriendsSort then
			v2 = list2[i]
		end

		local id = if FFlagShareSheetFriendsSort then v2.id else v.id
		local v3

		if FFlagShareSheetFriendsSort then
			v3 = Recipient.getName(v2, p)
		else
			v3 = ConversationUtils.getDisplayName(v)
		end

		local v4 = p2[id]

		if v4 then
			local userInfo, v5 = readUserInfo(v4.primary, p) -- inferred equivalent call
			local userInfo2, v6 = readUserInfo(v4.second, p) -- inferred equivalent call
			local v7 = v5 or v6
			isLoading = v7 and true or isLoading
			local v8 = { displayName = displayName }
			local v9 = {}

			if userInfo then
				table.insert(v9, userInfo)
			else
				table.insert(v9, v8)
			end

			if v4.second ~= nil then
				if userInfo2 then
					table.insert(v9, userInfo2)
				else
					table.insert(v9, v8)
				end
			end

			if v3 == "" then
				if v7 then
					idSet[id] = true
				else
					v3 = formatPeoplePickerUserInfo.formatTitle(v9)
				end
			end

			if not v7 then
				descriptionsByConversationId[id] = formatPeoplePickerUserInfo.formatDescription(v9)
			end
		end

		displayNamesByConversationId[id] = v3
	end

	return {
		descriptionsByConversationId = descriptionsByConversationId,
		displayNamesByConversationId = displayNamesByConversationId,
		isLoading = isLoading,
		loadingConversationIds = idSet
	}
end

local function useConversationDisplayNames(conversations, recipients, userId: string, unknownUser: string)
	local v = React.useMemo(function()
		local result = {}
		local rowCount = getRowCount(conversations, recipients) -- inferred equivalent call

		for i = 1, rowCount do
			local v

			if not FFlagShareSheetFriendsSort then
				v = conversations[i]
			end

			local v2

			if FFlagShareSheetFriendsSort then
				v2 = recipients[i]
			end

			local id

			if FFlagShareSheetFriendsSort then
				id = v2.id
			else
				id = v.id
			end

			local v3 = userId
			local v4, v5

			if FFlagShareSheetFriendsSort then
				local participantIds = Recipient.getParticipantIds(v2, v3)
				v4 = participantIds[1] or v3
				v5 = participantIds[2]
			else
				v4, v5 = ConversationUtils.getParticipantUserIds(v, v3)
			end

			result[id] = { primary = getUserInfoResult(v4), second = getUserInfoResult(v5) } -- inferred equivalent call
		end

		return result
	end, { conversations, userId, recipients })

	local v2 = React.useMemo(function()
		return Signals.createComputed(function(p)
			return getDisplayNames(p, conversations, recipients, v, unknownUser)
		end)
	end, { conversations, recipients, unknownUser, v })

	return SignalsReact.useSignalState(v2)
end

local function usePeoplePickerListViewModel(data)
	local userId = tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0)
	local v = useLocalization({ unknownUser = "Feature.Chat.Label.UnknownUser" })

	local v2 = useConversationDisplayNames(data.conversations, data.recipients, userId, v.unknownUser)
	local displayNamesByConversationId = v2.displayNamesByConversationId
	local v3 = React.useMemo(function()
		if FFlagShareSheetFriendsSort then
			return nil
		end

		return (filterConversationsByQuery(
			data.conversations,
			data.filterQuery,
			displayNamesByConversationId,
			v2.descriptionsByConversationId
		))
	end, {
		displayNamesByConversationId,
		v2.descriptionsByConversationId,
		data.conversations,
		data.filterQuery
	})

	local v4 = React.useMemo(function()
		if not FFlagShareSheetFriendsSort then
			return nil
		end

		local recipients = data.recipients
		local filterQuery = data.filterQuery
		local displayNamesByConversationId2 = displayNamesByConversationId
		local descriptionsByConversationId = v2.descriptionsByConversationId

		if filterQuery == "" then
			return recipients
		end

		local v4 = string.lower(filterQuery)
		return (Array.filter(recipients, function(p)
			return matchesQuery(v4, displayNamesByConversationId2[p.id] or "", descriptionsByConversationId[p.id] or "")
		end))
	end, {
		displayNamesByConversationId,
		v2.descriptionsByConversationId,
		data.filterQuery,
		data.recipients
	})

	local items = React.useMemo(function()
		local rowCount = getRowCount(v3, v4) -- inferred equivalent call
		local result = table.create(rowCount)

		for i = 1, rowCount do
			local v5

			if not FFlagShareSheetFriendsSort then
				v5 = v3[i]
			end

			local v6

			if FFlagShareSheetFriendsSort then
				v6 = v4[i]
			end

			local id

			if FFlagShareSheetFriendsSort then
				id = v6.id
			else
				id = v5.id
			end

			local v7 = userId
			local primaryUserId, secondUserId

			if FFlagShareSheetFriendsSort then
				local participantIds = Recipient.getParticipantIds(v6, v7)
				primaryUserId = participantIds[1] or v7
				secondUserId = participantIds[2]
			else
				primaryUserId, secondUserId = ConversationUtils.getParticipantUserIds(v5, v7)
			end

			result[i] = {
				description = v2.descriptionsByConversationId[id],
				displayName = displayNamesByConversationId[id],
				id = id,
				isLoading = v2.loadingConversationIds[id] == true,
				isSelected = data.selectedConversationIds[id] == true,
				primaryUserId = primaryUserId,
				secondUserId = secondUserId
			}
		end

		return result
	end, {
		v2.descriptionsByConversationId,
		v2.loadingConversationIds,
		displayNamesByConversationId,
		userId,
		data.selectedConversationIds,
		v3,
		v4
	})

	local isLoading = data.isLoading or v2.isLoading and #items == 0

	return {
		items = items,
		shouldShowEmptyState = #items == 0 and not isLoading,
		skeletonCount = not isLoading and 0 or ShareSheetConstants.FIntShareSheetNumAvatarSkeletons
	}
end

return usePeoplePickerListViewModel
