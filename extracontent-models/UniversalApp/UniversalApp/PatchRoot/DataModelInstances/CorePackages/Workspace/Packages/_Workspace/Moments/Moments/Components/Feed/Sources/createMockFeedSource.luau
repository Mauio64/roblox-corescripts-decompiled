local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent

require(Moments.Components.Feed.FeedTypes)

local MomentsMomentFixtures = require(MomentsParent.DataHydration.MomentsMomentFixtures)

local function createMockFeedSource(t1: {[any]: any}?) -- line: 58
	-- upvalues: MomentsMomentFixtures (copy)
	local v6 = t1 or {}
	local v7 = v6.pageSize or 5
	local total = v6.total
	local v9 = v6.latencySeconds or 0
	local failAfterPages = v6.failAfterPages
	local v11 = v6.deferred == true
	local n1 = 0
	local t2 = {}

	local function buildPage(n2: number) -- line: 71
		-- upvalues: total (copy), v7 (copy), MomentsMomentFixtures (copy)
		local v16 = if total == nil then v7 else math.max(total - (n2 - 1), 0)
		local v17 = math.min(v7, v16)
		local v18 = n2 + v17
		local v19 = total == nil or v18 <= total

		return {
			items = MomentsMomentFixtures.buildMomentFeedItems(n2, v17),
			nextCursor = if not v19 then nil else v18
		}
	end

	return {
		fetchAsync = function(n3: number?) -- line: 82
			-- upvalues: n1 (ref), v11 (copy), t2 (copy), v9 (copy), failAfterPages (copy), buildPage (copy)
			local v21 = n3 or 1

			n1 += 1

			local v22 = n1

			if v11 then
				table.insert(t2, coroutine.running())

				local v23, v24 = coroutine.yield()

				if not v23 then
					error(v24 or "mock feed source fetch rejected")
				end
			else
				if v9 > 0 then
					task.wait(v9)
				end

				if failAfterPages ~= nil and v22 > failAfterPages then
					error(`mock feed source failed on page { v22 }`)
				end
			end

			return (buildPage(v21))
		end,
		id = v6.id or "mock",
		recommendationSource = v6.recommendationSource or "Trending",
		dispose = function() -- line: 134
		end,
		getPendingCount = function() -- line: 108
			-- upvalues: t2 (copy)
			return #t2
		end,
		resolveNext = function() -- line: 112
			-- upvalues: t2 (copy)
			local v25 = table.remove(t2, 1)

			if v25 ~= nil then
				local ok, result = coroutine.resume(v25, true)

				if not ok then
					error(result)
				end
			end
		end,
		rejectNext = function(s1: string?) -- line: 124
			-- upvalues: t2 (copy)
			local v29 = table.remove(t2, 1)

			if v29 ~= nil then
				local ok, result = coroutine.resume(v29, false, s1)

				if not ok then
					error(result)
				end
			end
		end
	}
end

return createMockFeedSource
