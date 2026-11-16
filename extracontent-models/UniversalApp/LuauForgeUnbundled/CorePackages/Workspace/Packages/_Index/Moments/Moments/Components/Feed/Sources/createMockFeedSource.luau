require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")
local MomentsMomentFixtures = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsMomentFixtures")

local function createMockFeedSource(options)
	local v5 = options or {}
	local pageSize = v5.pageSize or 5
	local total = v5.total
	local latencySeconds = v5.latencySeconds or 0
	local failAfterPages = v5.failAfterPages
	local deferred = v5.deferred == true

	local count = 0

	local threads = {}

	local function buildPage(p2)
		local v6 = if total == nil then pageSize else math.max(total - (p2 - 1), 0)
		local v7 = math.min(pageSize, v6)
		local v8 = p2 + v7
		local v9 = total == nil or v8 <= total
		local page = {
			items = MomentsMomentFixtures.buildMomentFeedItems(p2, v7),
			nextCursor = 0
		}

		if not v9 then
			v8 = nil
		end

		page.nextCursor = v8
		return page
	end

	return {
		fetchAsync = function(value)
			count += 1
			local v7 = count

			if deferred then
				table.insert(threads, coroutine.running())
				local v8, v9 = coroutine.yield()

				if not v8 then
					error(v9 or "mock feed source fetch rejected")
				end
			else
				if latencySeconds > 0 then
					task.wait(latencySeconds)
				end

				if failAfterPages ~= nil and failAfterPages < v7 then
					error(`mock feed source failed on page {v7}`)
				end
			end

			return buildPage(value or 1)
		end,
		id = v5.id or "mock",
		recommendationSource = v5.recommendationSource or "Trending",
		endsWithCaughtUp = v5.endsWithCaughtUp,
		dispose = function() end,
		getPendingCount = function()
			return #threads
		end,
		resolveNext = function()
			local v6 = table.remove(threads, 1)

			if v6 ~= nil then
				local v7, v8 = coroutine.resume(v6, true)

				if not v7 then
					error(v8)
				end
			end
		end,
		rejectNext = function(p2)
			local v6 = table.remove(threads, 1)

			if v6 ~= nil then
				local v7, v8 = coroutine.resume(v6, false, p2)

				if not v7 then
					error(v8)
				end
			end
		end
	}
end

return createMockFeedSource
