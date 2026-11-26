local module = require("@luauforge/deferred/ekz")
local module2 = require("@luauforge/deferred/ela")
local module3 = require("@luauforge/deferred/ekt")

local batch = module2.batch

local module4 = require("@luauforge/deferred/elb")
local module5 = require("@luauforge/deferred/eku")
require("@luauforge/deferred/ekr")
local module6 = require("@luauforge/deferred/elc")
local module7 = require("@luauforge/deferred/eld")

local createDataCache = module3.createDataCache
local createDataResolver = module3.createDataResolver

local PAGE_LIMIT = module5.MemberList.PAGE_LIMIT

local function createSchoolMembersSignalStore()
	local dataCache = createDataCache()

	local signal, v5 = module.createSignal(false)
	local signal2, v6 = module.createSignal(false)
	local signal3, v7 = module.createSignal({})

	local v8 = nil
	local v9 = {}
	local ids = {}
	local v10 = {}
	local v11 = ""
	local v12 = nil

	local function parseSchoolMembersFromPage(p2, p3)
		local userIdSet = {}
		local schoolMembersFromPage = {}

		for k, v13 in p2.data or {} do
			local userId = tostring(v13.user.userId)

			if userIdSet[userId] then
				continue
			end

			userIdSet[userId] = true
			table.insert(schoolMembersFromPage, { userId = userId, graduationYear = p3 })
		end

		return schoolMembersFromPage
	end

	local function appendMembers(p2, items)
		local data = dataCache.getItem(p2).data(false)

		if data then
			local v13 = {}

			for k, member in data.members do
				v13[member.userId] = k
			end

			local clone = table.clone(data.members)

			for k, item in items do
				local v14 = v13[item.userId]

				if v14 == nil then
					table.insert(clone, item)
					v13[item.userId] = #clone
				elseif clone[v14].graduationYear == nil and item.graduationYear ~= nil then
					clone[v14] = item
				end
			end

			dataCache.replaceItem(p2, {
				members = clone,
				years = data.years,
				yearMemberCounts = data.yearMemberCounts,
				yearToRoleId = data.yearToRoleId
			})
		end
	end

	local function setRoleHasMoreState(p2, p3)
		local clone = table.clone(signal3(false))
		clone[p2] = p3
		v7(clone)
	end

	local function cancelActiveRequest()
		if v12 then
			v12()
			v12 = nil
		end
	end

	local function loadMoreForRole(p2, p3)
		if signal3(false)[p3] == false then
			return
		end

		v5(true)

		local v13, v14 = module7(p3, v10[p3], PAGE_LIMIT)
		v12 = v14

		v13:andThen(function(p4)
			v12 = nil

			if p2 ~= v11 then
				return
			end

			appendMembers(p2, parseSchoolMembersFromPage(p4, v9[p3]))

			local nextPageCursor = p4.nextPageCursor
			local v15 = p4.data and #p4.data or 0
			local v16 = v10

			if not nextPageCursor or nextPageCursor == "" or not (PAGE_LIMIT <= v15) then
				nextPageCursor = nil
			end

			v16[p3] = nextPageCursor

			batch(function()
				local v19 = v10[p3] ~= nil
				local clone = table.clone(signal3(false))
				clone[p3] = v19
				v7(clone)

				v5(false)
			end)
		end):catch(function()
			v12 = nil

			if p2 ~= v11 then
				return
			end

			batch(function()
				v5(false)
				local clone = table.clone(signal3(false))
				clone[p3] = false
				v7(clone)
			end)
		end)
	end

	local function loadMoreAllMembers(p2)
		if not signal2(false) or v8 == nil then
			return
		end

		v5(true)

		local v13, v14 = module7(nil, v8, PAGE_LIMIT)
		v12 = v14

		v13:andThen(function(p3)
			v12 = nil

			if p2 ~= v11 then
				return
			end

			appendMembers(p2, parseSchoolMembersFromPage(p3, nil))

			local nextPageCursor = p3.nextPageCursor
			local v15 = p3.data and #p3.data or 0

			if not nextPageCursor or nextPageCursor == "" or not (PAGE_LIMIT <= v15) then
				nextPageCursor = nil
			end

			v8 = nextPageCursor
			batch(function()
				v6(v8 ~= nil)
				v5(false)
			end)
		end):catch(function()
			v12 = nil

			if p2 ~= v11 then
				return
			end

			v8 = nil
			batch(function()
				v5(false)
				v6(false)
			end)
		end)
	end

	local dataResolver = createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(p2, p3)
			v11 = p2
			v8 = nil
			v9 = {}
			ids = {}
			v10 = {}
			batch(function()
				v6(false)
				v5(false)
				v7({})
			end)

			return module6():andThen(function(p4)
				local v13 = {}
				local memberCounts = {}

				for k, role in p4.roles do
					local v14 = module4(role.name)

					if not v14 then
						continue
					end

					v9[role.id] = v14
					ids[v14] = role.id

					if role.memberCount ~= nil then
						memberCounts[v14] = role.memberCount
					end

					table.insert(v13, v14)
				end

				table.sort(v13)

				return module7(nil, nil, PAGE_LIMIT):andThen(function(p5)
					local v14 = parseSchoolMembersFromPage(p5, nil)

					local nextPageCursor = p5.nextPageCursor
					local v15 = p5.data and #p5.data or 0

					if not nextPageCursor or nextPageCursor == "" or not (PAGE_LIMIT <= v15) then
						nextPageCursor = nil
					end

					v8 = nextPageCursor
					v6(v8 ~= nil)

					return {
						members = v14,
						years = v13,
						yearMemberCounts = memberCounts,
						yearToRoleId = ids
					}
				end)
			end)
		end,
		queueProcessDelaySec = 0
	})

	return {
		getMembers = function(p2, p3)
			local fn = p3 ~= nil and p3 > 0 and function(p4): boolean
				return p4 ~= nil and #p4.members == 0
			end or nil

			return dataResolver.getAndFetchItem(p2, fn)
		end,
		loadMore = function(p2, p3)
			if signal(false) or (p2 == "" or p2 ~= v11) then
				return
			end

			if p3 == nil then
				loadMoreAllMembers(p2)
			else
				loadMoreForRole(p2, p3)
			end
		end,
		getIsLoadingMore = signal,
		getHasMore = signal2,
		getRoleHasMore = signal3,
		refresh = function(p2)
			if v12 then
				v12()
				v12 = nil
			end

			v8 = nil
			v10 = {}
			batch(function()
				v6(false)
				v5(false)
				v7({})
			end)
			dataResolver.fetchItem(p2)
		end,
		clear = function()
			if v12 then
				v12()
				v12 = nil
			end

			v8 = nil
			v9 = {}
			ids = {}
			v10 = {}
			v11 = ""
			batch(function()
				v6(false)
				v5(false)
				v7({})
			end)
			dataResolver.clear()
		end,
		dispose = dataResolver.dispose
	}
end

return createSchoolMembersSignalStore
