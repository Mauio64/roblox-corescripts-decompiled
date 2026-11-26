local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/SignalsReact")

local array = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/LuauPolyfill").Array

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Localization").Hooks.useLocalization
local UserProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/DataHydration/UserProfile")
local ShareSheetConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/ShareSheetConstants")
local formatPeoplePickerUserInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Utils/formatPeoplePickerUserInfo")
local matchesQuery = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Utils/matchesQuery")
local Recipient = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/Recipient")

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

local function getRowUserIds(p2, p3)
	local participantIds = Recipient.getParticipantIds(p2, p3)
	return participantIds[1] or p3, participantIds[2]
end

local function filterRecipientsByQuery(recipients, filterQuery, displayNamesByConversationId, descriptionsByConversationId)
	if filterQuery == "" then
		return recipients
	end

	local v5 = string.lower(filterQuery)
	return array.filter(recipients, function(p2)
		return matchesQuery(
			v5,
			displayNamesByConversationId[p2.id] or "",
			descriptionsByConversationId[p2.id] or ""
		)
	end)
end

local function getDisplayNames(p2, items, p3, p4)
	local v5 = {}

	local idSet = {}
	local v6 = {}
	local v7 = false

	for k, item in items do
		local id = item.id
		local v8 = Recipient.getName(item, p2)
		local v9 = p3[id]

		if v9 then
			local primary = v9.primary
			local v10, v11

			if primary == nil then
				v10 = false
			else
				v11 = primary.info(p2)
				v10 = primary.status(p2) == "NotReady"
			end

			local second = v9.second
			local v12, v13

			if second == nil then
				v12 = false
			else
				v13 = second.info(p2)
				v12 = second.status(p2) == "NotReady"
			end

			local v14 = v10 or v12
			v7 = v14 and true or v7
			local v15 = { displayName = p4 }
			local v16 = {}

			if v11 then
				table.insert(v16, v11)
			else
				table.insert(v16, v15)
			end

			if v9.second ~= nil then
				if v13 then
					table.insert(v16, v13)
				else
					table.insert(v16, v15)
				end
			end

			if v8 == "" then
				if v14 then
					idSet[id] = true
				else
					v8 = formatPeoplePickerUserInfo.formatTitle(v16)
				end
			end

			if not v14 then
				v6[id] = formatPeoplePickerUserInfo.formatDescription(v16)
			end
		end

		v5[id] = v8
	end

	return {
		descriptionsByConversationId = v6,
		displayNamesByConversationId = v5,
		isLoading = v7,
		loadingConversationIds = idSet
	}
end

local function useConversationDisplayNames(recipients, userId, unknownUser)
	local v5 = React.useMemo(function()
		local result = {}

		for k, item in recipients do
			local v6 = userId
			local participantIds = Recipient.getParticipantIds(item, v6)
			local v7 = participantIds[1] or v6
			local participantId = participantIds[2]

			local id = item.id
			local v9 = if v7 ~= nil and v7 ~= "" then UserProfile.getAndFetchUserInfo(v7) else nil
			local v10 = if participantId ~= nil and participantId ~= "" then UserProfile.getAndFetchUserInfo(participantId) else nil

			result[id] = { primary = v9, second = v10 }
		end

		return result
	end, { userId, recipients })

	local v6 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			return getDisplayNames(p2, recipients, v5, unknownUser)
		end)
	end, { recipients, unknownUser, v5 })

	return SignalsReact.useSignalState(v6)
end

local function usePeoplePickerListViewModel(data)
	local userId = tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0)
	local v5 = useLocalization({ unknownUser = "Feature.Chat.Label.UnknownUser" })

	local v6 = useConversationDisplayNames(data.recipients, userId, v5.unknownUser)
	local displayNamesByConversationId = v6.displayNamesByConversationId
	local v7 = React.useMemo(function()
		return filterRecipientsByQuery(
			data.recipients,
			data.filterQuery,
			displayNamesByConversationId,
			v6.descriptionsByConversationId
		)
	end, {
		displayNamesByConversationId,
		v6.descriptionsByConversationId,
		data.filterQuery,
		data.recipients
	})

	local v8 = React.useMemo(function()
		local result = table.create(#v7)

		for k, v9 in v7 do
			local id = v9.id
			local v10 = userId
			local participantIds = Recipient.getParticipantIds(v9, v10)
			local v11 = participantIds[1] or v10
			local participantId = participantIds[2]

			result[k] = {
				description = v6.descriptionsByConversationId[id],
				displayName = displayNamesByConversationId[id],
				id = id,
				isLoading = v6.loadingConversationIds[id] == true,
				isSelected = data.selectedConversationIds[id] == true,
				primaryUserId = v11,
				secondUserId = participantId
			}
		end

		return result
	end, {
		v6.descriptionsByConversationId,
		v6.loadingConversationIds,
		displayNamesByConversationId,
		userId,
		data.selectedConversationIds,
		v7
	})

	local isLoading = data.isLoading or v6.isLoading and #v8 == 0

	return {
		items = v8,
		shouldShowEmptyState = #v8 == 0 and not isLoading,
		skeletonCount = not isLoading and 0 or ShareSheetConstants.FIntShareSheetNumAvatarSkeletons
	}
end

return usePeoplePickerListViewModel
