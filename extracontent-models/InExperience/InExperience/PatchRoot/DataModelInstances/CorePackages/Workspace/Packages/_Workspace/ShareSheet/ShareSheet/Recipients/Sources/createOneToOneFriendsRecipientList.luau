local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local DataHydrationUtils = require(parent.DataHydration.DataHydrationUtils)
local Friends = require(parent.DataHydration.Friends)
local Signals = require(parent.Signals)
local ListRecipientsStatus = require(ShareSheet.Recipients.ListRecipientsStatus)
local Recipient = require(ShareSheet.Recipients.Recipient)
local ShareSheetConstants = require(ShareSheet.ShareSheetConstants)
require(ShareSheet.Types)

local function validateUserId(userId: string) -- 1 equivalent call inferred from this helper
	if (tonumber(userId) or 0) <= 0 then
		error(`Friends returned an invalid user id: {userId}`)
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
	local v = {}

	local computed = Signals.createComputed(function(p)
		local userIdSet = {}
		local result = {}

		for _, userId in data.getPage(p).userIds do
			validateUserId(userId) -- inferred equivalent call

			if userIdSet[userId] then
				error(`Duplicate user id in the friends page: {userId}`)
			end

			userIdSet[userId] = true
			local v2 = v[userId] or Recipient.fromUserId(userId)
			v[userId] = v2
			table.insert(result, v2)
		end

		return result
	end, areSameRecipients)

	local getResult = Signals.createComputed(function(p)
		local page = data.getPage(p)
		return {
			recipients = computed(p),
			status = page.status,
			nextPageToken = page.nextPageToken,
			isFetchingNextPage = page.isFetchingNextPage
		}
	end)

	return {
		getResult = getResult,
		refresh = data.refresh,
		search = data.search,
		loadMore = function(p: string)
			local v2 = getResult(false)

			if v2.nextPageToken == p and not v2.isFetchingNextPage then
				data.fetchNextPage()
			end
		end
	}
end

local function createFriendsSearchRecipientList(query: string)
	local localPlayerUserId = DataHydrationUtils.getLocalPlayerUserId()
	local signal, v = Signals.createSignal({
		userIds = {},
		status = ListRecipientsStatus.Loading,
		isFetchingNextPage = false
	})

	local function fetchPage(cursor: string?)
		local v2 = signal(false)
		local v3 = { userIds = v2.userIds, status = 0, nextPageToken = 0, isFetchingNextPage = 0 }
		local status

		if cursor or #v2.userIds > 0 then
			status = ListRecipientsStatus.Ready
		else
			status = ListRecipientsStatus.Loading
		end

		v3.status = status

		v3.nextPageToken = v2.nextPageToken
		v3.isFetchingNextPage = cursor ~= nil
		v(v3)

		Friends.Requests.SearchFriendsByQuery(localPlayerUserId, {
			query = query,
			limit = ShareSheetConstants.FIntShareSheetFriendsSearchPageSize,
			cursor = cursor
		}):andThen(function(p)
			local ids = not cursor and {} or table.clone(signal(false).userIds)

			local set = {}

			for _, v4 in ids do
				set[v4] = true
			end

			if p and p.PageItems then
				for _, pageItem in p.PageItems do
					local id = tostring(pageItem.id)

					if id == "-1" or set[id] then
						continue
					end

					set[id] = true
					table.insert(ids, id)
				end
			end

			local nextCursor

			if p then
				nextCursor = p.NextCursor
			end

			local v4 = {
				userIds = ids,
				status = ListRecipientsStatus.Ready,
				nextPageToken = 0,
				isFetchingNextPage = false
			}

			if nextCursor == "" then
				nextCursor = nil
			end

			v4.nextPageToken = nextCursor
			v(v4)
		end):catch(function()
			local v4 = signal(false)
			v({
				userIds = v4.userIds,
				status = ListRecipientsStatus.Failed,
				nextPageToken = v4.nextPageToken,
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
	local v = Friends.FriendsStore.get()
	local allFriends = v.GetAllFriends()
	local allFriendsStatus = v.GetAllFriendsStatus()

	return createFriendRecipientList({
		getPage = Signals.createComputed(function(p)
			local v2 = allFriends(p)
			local v3 = allFriendsStatus(p)
			local v4 = v3 == "Failed"
			local ids = {}

			if v2 ~= nil then
				for _, friend in v2.friends do
					if friend.id ~= "-1" then
						table.insert(ids, friend.id)
					end
				end
			end

			local status

			if v4 then
				status = ListRecipientsStatus.Failed
			elseif v2 == nil then
				status = ListRecipientsStatus.Loading
			else
				status = ListRecipientsStatus.Ready
			end

			local nextPageToken

			if not (v2 == nil or not v2.hasMore) then
				nextPageToken = v2.nextCursor
			end

			return {
				userIds = ids,
				status = status,
				nextPageToken = nextPageToken,
				isFetchingNextPage = v2 ~= nil and v3 == "NotReady"
			}
		end),
		fetchNextPage = v.FetchMoreFriends,
		refresh = function() end,
		search = createFriendsSearchRecipientList
	})
end

return createOneToOneFriendsRecipientList
