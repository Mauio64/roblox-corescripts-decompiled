local DataHydrationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/DataHydration/DataHydrationUtils")
local Friends = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/DataHydration/Friends")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Signals")
local ListRecipientsStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/ListRecipientsStatus")
local Recipient = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/Recipient")
local ShareSheetConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/ShareSheetConstants")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Types")

local function validateUserId(p2)
	if (tonumber(p2) or 0) <= 0 then
		error(`Friends returned an invalid user id: {p2}`)
	end
end

local function areSameRecipients(list, list2): boolean
	if #list ~= #list2 then
		return false
	end

	for k, item in list do
		if list2[k] ~= item then
			return false
		end
	end

	return true
end

local function createFriendRecipientList(data)
	local v5 = {}

	local computed = Signals.createComputed(function(p2)
		local userIdSet = {}
		local result = {}

		for k, userId in data.getPage(p2).userIds do
			if (tonumber(userId) or 0) <= 0 then
				error(`Friends returned an invalid user id: {userId}`)
			end

			if userIdSet[userId] then
				error(`Duplicate user id in the friends page: {userId}`)
			end

			userIdSet[userId] = true
			local v6 = v5[userId] or Recipient.fromUserId(userId)
			v5[userId] = v6
			table.insert(result, v6)
		end

		return result
	end, areSameRecipients)

	local computed2 = Signals.createComputed(function(p2)
		local page = data.getPage(p2)
		return {
			recipients = computed(p2),
			status = page.status,
			nextPageToken = page.nextPageToken,
			isFetchingNextPage = page.isFetchingNextPage
		}
	end)

	return {
		getResult = computed2,
		refresh = data.refresh,
		search = data.search,
		loadMore = function(p2)
			local v6 = computed2(false)

			if v6.nextPageToken == p2 and not v6.isFetchingNextPage then
				data.fetchNextPage()
			end
		end
	}
end

local function createFriendsSearchRecipientList(p2)
	local localPlayerUserId = DataHydrationUtils.getLocalPlayerUserId()
	local signal, v5 = Signals.createSignal({
		userIds = {},
		status = ListRecipientsStatus.Loading,
		isFetchingNextPage = false
	})

	local function fetchPage(p3)
		local v6 = signal(false)
		local v8 = {
			userIds = v6.userIds,
			status = 0,
			nextPageToken = 0,
			isFetchingNextPage = 0
		}
		local v9 = if p3 or #v6.userIds > 0 then ListRecipientsStatus.Ready else ListRecipientsStatus.Loading
		v8.status = v9

		v8.nextPageToken = v6.nextPageToken
		v8.isFetchingNextPage = p3 ~= nil
		v5(v8)

		Friends.Requests.SearchFriendsByQuery(localPlayerUserId, {
			query = p2,
			limit = ShareSheetConstants.FIntShareSheetFriendsSearchPageSize,
			cursor = p3
		}):andThen(function(p4)
			local ids = not p3 and {} or table.clone(signal(false).userIds)

			local set = {}

			for k, v10 in ids do
				set[v10] = true
			end

			if p4 and p4.PageItems then
				for k, pageItem in p4.PageItems do
					local id = tostring(pageItem.id)

					if id == "-1" or set[id] then
						continue
					end

					set[id] = true
					table.insert(ids, id)
				end
			end

			local nextCursor = if p4 then p4.NextCursor else nil
			local v11 = {
				userIds = ids,
				status = ListRecipientsStatus.Ready,
				nextPageToken = 0,
				isFetchingNextPage = false
			}

			if nextCursor == "" then
				nextCursor = nil
			end

			v11.nextPageToken = nextCursor
			v5(v11)
		end):catch(function()
			local v10 = signal(false)
			v5({
				userIds = v10.userIds,
				status = ListRecipientsStatus.Failed,
				nextPageToken = v10.nextPageToken,
				isFetchingNextPage = false
			})
		end)
	end

	return createFriendRecipientList({
		getPage = signal,
		fetchNextPage = function()
			fetchPage(signal(false).nextPageToken)
		end,
		refresh = function()
			fetchPage(nil)
		end
	})
end

local function createOneToOneFriendsRecipientList()
	local v5 = Friends.FriendsStore.get()
	local allFriends = v5.GetAllFriends()
	local allFriendsStatus = v5.GetAllFriendsStatus()

	return createFriendRecipientList({
		getPage = Signals.createComputed(function(p2)
			local v6 = allFriends(p2)
			local v7 = allFriendsStatus(p2)
			local v8 = v7 == "Failed"
			local ids = {}

			if v6 ~= nil then
				for k, friend in v6.friends do
					if friend.id ~= "-1" then
						table.insert(ids, friend.id)
					end
				end
			end

			local v10 = if v8 then ListRecipientsStatus.Failed elseif v6 == nil then ListRecipientsStatus.Loading else ListRecipientsStatus.Ready
			local v11 = if v6 ~= nil and not not v6.hasMore then v6.nextCursor else nil
			return {
				userIds = ids,
				status = v10,
				nextPageToken = v11,
				isFetchingNextPage = v6 ~= nil and v7 == "NotReady"
			}
		end),
		fetchNextPage = v5.FetchMoreFriends,
		refresh = function() end,
		search = createFriendsSearchRecipientList
	})
end

return createOneToOneFriendsRecipientList
