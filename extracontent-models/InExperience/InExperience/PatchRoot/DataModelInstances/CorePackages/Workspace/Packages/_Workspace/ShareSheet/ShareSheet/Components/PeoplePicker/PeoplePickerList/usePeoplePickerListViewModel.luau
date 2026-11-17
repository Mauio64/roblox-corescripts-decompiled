local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local UserProfile = require(parent.DataHydration.UserProfile)
local ShareSheetConstants = require(ShareSheet.ShareSheetConstants)
local formatPeoplePickerUserInfo = require(ShareSheet.Utils.formatPeoplePickerUserInfo)
local matchesQuery = require(ShareSheet.Utils.matchesQuery)
local Recipient = require(ShareSheet.Recipients.Recipient)

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

local function getRowUserIds(p, p2: string) -- 2 equivalent calls inferred from this helper
	local participantIds = Recipient.getParticipantIds(p, p2)
	return participantIds[1] or p2, participantIds[2]
end

local function filterRecipientsByQuery(recipients, filterQuery: string, displayNamesByConversationId, descriptionsByConversationId)
	if filterQuery == "" then
		return recipients
	end

	local v = string.lower(filterQuery)
	return Array.filter(recipients, function(p)
		return matchesQuery(v, displayNamesByConversationId[p.id] or "", descriptionsByConversationId[p.id] or "")
	end)
end

local function getDisplayNames(p, items, p2, displayName: string)
	local displayNamesByConversationId = {}

	local idSet = {}
	local descriptionsByConversationId = {}
	local isLoading = false

	for _, item in items do
		local id = item.id
		local v = Recipient.getName(item, p)
		local v2 = p2[id]

		if v2 then
			local userInfo, v3 = readUserInfo(v2.primary, p) -- inferred equivalent call
			local userInfo2, v4 = readUserInfo(v2.second, p) -- inferred equivalent call
			local v5 = v3 or v4
			isLoading = v5 and true or isLoading
			local v6 = { displayName = displayName }
			local v7 = {}

			if userInfo then
				table.insert(v7, userInfo)
			else
				table.insert(v7, v6)
			end

			if v2.second ~= nil then
				if userInfo2 then
					table.insert(v7, userInfo2)
				else
					table.insert(v7, v6)
				end
			end

			if v == "" then
				if v5 then
					idSet[id] = true
				else
					v = formatPeoplePickerUserInfo.formatTitle(v7)
				end
			end

			if not v5 then
				descriptionsByConversationId[id] = formatPeoplePickerUserInfo.formatDescription(v7)
			end
		end

		displayNamesByConversationId[id] = v
	end

	return {
		descriptionsByConversationId = descriptionsByConversationId,
		displayNamesByConversationId = displayNamesByConversationId,
		isLoading = isLoading,
		loadingConversationIds = idSet
	}
end

local function useConversationDisplayNames(recipients, userId: string, unknownUser: string)
	local v = React.useMemo(function()
		local result = {}

		for _, item in recipients do
			local rowUserIds, v = getRowUserIds(item, userId) -- inferred equivalent call
			local id = item.id
			result[id] = { primary = getUserInfoResult(rowUserIds), second = getUserInfoResult(v) } -- inferred equivalent call
		end

		return result
	end, { userId, recipients })

	local v2 = React.useMemo(function()
		return Signals.createComputed(function(p)
			return getDisplayNames(p, recipients, v, unknownUser)
		end)
	end, { recipients, unknownUser, v })

	return SignalsReact.useSignalState(v2)
end

local function usePeoplePickerListViewModel(data)
	local userId = tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0)
	local v = useLocalization({ unknownUser = "Feature.Chat.Label.UnknownUser" })

	local v2 = useConversationDisplayNames(data.recipients, userId, v.unknownUser)
	local displayNamesByConversationId = v2.displayNamesByConversationId
	local v3 = React.useMemo(function()
		return filterRecipientsByQuery(
			data.recipients,
			data.filterQuery,
			displayNamesByConversationId,
			v2.descriptionsByConversationId
		)
	end, {
		displayNamesByConversationId,
		v2.descriptionsByConversationId,
		data.filterQuery,
		data.recipients
	})

	local items = React.useMemo(function()
		local result = table.create(#v3)

		for k, v4 in v3 do
			local id = v4.id
			local rowUserIds, secondUserId = getRowUserIds(v4, userId) -- inferred equivalent call
			result[k] = {
				description = v2.descriptionsByConversationId[id],
				displayName = displayNamesByConversationId[id],
				id = id,
				isLoading = v2.loadingConversationIds[id] == true,
				isSelected = data.selectedConversationIds[id] == true,
				primaryUserId = rowUserIds,
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
		v3
	})

	local isLoading = data.isLoading or v2.isLoading and #items == 0

	return {
		items = items,
		shouldShowEmptyState = #items == 0 and not isLoading,
		skeletonCount = not isLoading and 0 or ShareSheetConstants.FIntShareSheetNumAvatarSkeletons
	}
end

return usePeoplePickerListViewModel
