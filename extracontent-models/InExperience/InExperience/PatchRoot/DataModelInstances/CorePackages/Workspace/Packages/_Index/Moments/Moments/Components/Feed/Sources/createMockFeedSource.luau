local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

require(Moments.Components.Feed.FeedTypes)
local MomentsMomentFixtures = require(parent.DataHydration.MomentsMomentFixtures)

local function createMockFeedSource(options)
	local v = options or {}
	local pageSize = v.pageSize or 5
	local total = v.total
	local latencySeconds = v.latencySeconds or 0
	local failAfterPages = v.failAfterPages
	local deferred = v.deferred == true

	local count = 0

	local threads = {}

	local function buildPage(p: number)
		local v2

		if total == nil then
			v2 = pageSize
		else
			v2 = math.max(total - (p - 1), 0)
		end

		local v3 = math.min(pageSize, v2)
		local nextCursor = p + v3
		local v4 = total == nil or nextCursor <= total
		local page = {
			items = MomentsMomentFixtures.buildMomentFeedItems(p, v3),
			nextCursor = 0
		}

		if not v4 then
			nextCursor = nil
		end

		page.nextCursor = nextCursor
		return page
	end

	return {
		fetchAsync = function(value: number?)
			count += 1
			local v2 = count

			if deferred then
				table.insert(threads, coroutine.running())
				local v3, v4 = coroutine.yield()

				if not v3 then
					error(v4 or "mock feed source fetch rejected")
				end
			else
				if latencySeconds > 0 then
					task.wait(latencySeconds)
				end

				if failAfterPages ~= nil and failAfterPages < v2 then
					error(`mock feed source failed on page {v2}`)
				end
			end

			return buildPage(value or 1)
		end,
		id = v.id or "mock",
		recommendationSource = v.recommendationSource or "Trending",
		endsWithCaughtUp = v.endsWithCaughtUp,
		dispose = function() end,
		getPendingCount = function()
			return #threads
		end,
		resolveNext = function()
			local v2 = table.remove(threads, 1)

			if v2 ~= nil then
				local v3, v4 = coroutine.resume(v2, true)

				if not v3 then
					error(v4)
				end
			end
		end,
		rejectNext = function(p: string?)
			local v2 = table.remove(threads, 1)

			if v2 ~= nil then
				local v3, v4 = coroutine.resume(v2, false, p)

				if not v3 then
					error(v4)
				end
			end
		end
	}
end

return createMockFeedSource
