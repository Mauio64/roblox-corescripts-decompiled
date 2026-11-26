local module = require("@luauforge/deferred/enC")
local module2 = require("@luauforge/deferred/eop")

local module3 = require("@luauforge/bundled/enl")
local module4 = require("@luauforge/deferred/eoq")

local createSignal = module.createSignal
local feedStatus = module3.FeedStatus
local loadMoreStatus = module3.LoadMoreStatus

local function createFriendsActivityFeedStore(p2)
	local signal, v5 = createSignal({})

	local signal2, v6 = createSignal(feedStatus.Loading)

	local signal3, v7 = createSignal(nil)
	local signal4, v8 = createSignal(false)

	local signal5, v9 = createSignal(loadMoreStatus.Idle)

	local flag = false
	local count = 0
	local nextPage = nil

	local function runFetch()
		if flag then
			return
		end

		count += 1
		local v10 = count
		module2.batch(function()
			v7(nil)
			v6(feedStatus.Loading)
			v8(false)
			v9(loadMoreStatus.Idle)
		end)
		nextPage = nil

		task.spawn(function()
			local success, result = pcall(p2.fetchAsync, nil)

			if flag or v10 ~= count then
				return
			end

			local v11

			if success and type(result) == "table" and type(result.items) == "table" then
				v11 = result
			else
				v11 = nil
			end

			if v11 == nil then
				module2.batch(function()
					v5({})
					v7(success and "Malformed feed batch" or tostring(result))
					v6(feedStatus.Failed)
				end)

				return
			end

			nextPage = v11.nextPage
			module2.batch(function()
				v5(v11.items)
				v8(v11.nextPage ~= nil)
				local v13 = if #v11.items == 0 then feedStatus.Empty else feedStatus.Loaded
				v6(v13)
			end)
		end)
	end

	local function loadMore()
		if flag or nextPage == nil or signal5(false) == loadMoreStatus.Loading then
			return
		end

		v9(loadMoreStatus.Loading)
		local v10 = count

		task.spawn(function()
			local success, result = pcall(p2.fetchAsync, nextPage)

			if flag or v10 ~= count then
				return
			end

			if not success or type(result) ~= "table" or type(result.items) ~= "table" then
				result = nil
			end

			if result == nil then
				v9(loadMoreStatus.Failed)

				return
			end

			nextPage = result.nextPage
			module2.batch(function()
				v5(module4(signal(false), result.items))
				v8(result.nextPage ~= nil)
				v9(loadMoreStatus.Idle)
			end)
		end)
	end

	local function dispose()
		flag = true

		if p2.dispose then
			p2.dispose()
		end
	end

	return {
		getItems = signal,
		getStatus = signal2,
		getError = signal3,
		getHasMore = signal4,
		getLoadMoreStatus = signal5,
		loadInitial = runFetch,
		loadMore = loadMore,
		refresh = runFetch,
		dispose = dispose
	}
end

return createFriendsActivityFeedStore
