local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local MomentsCommon = require(MomentsParent.MomentsCommon)
local SharedFlags = require(MomentsParent.SharedFlags)
local Signals = require(MomentsParent.Signals)
local MomentsSurfaceLoadManager = MomentsCommon.Performance.MomentsSurfaceLoadManager
local FFlagMomentsSurfaceLoadTTI = SharedFlags.FFlagMomentsSurfaceLoadTTI

require(script.Parent.FeedTypes)

local createPagerStore = require(Moments.Components.VerticalPager.createPagerStore)
local createSignal = Signals.createSignal
local t1 = {
	kind = "skeleton"
}

local function createFeedStore(p1, p2: ((...any) -> ...any)?, b1: boolean?) -- line: 74
	-- upvalues: createPagerStore (copy), createSignal (copy), t1 (copy), FFlagMomentsSurfaceLoadTTI (copy), MomentsSurfaceLoadManager (copy)
	local v15 = createPagerStore()
	local v16, v17 = createSignal("Loading")
	local v18, v19 = createSignal(nil)
	local v20, v21 = createSignal(true)
	local v22, v23 = createSignal(false)
	local nextCursor = nil
	local u25 = false
	local u26 = false
	local n1 = 0
	local n2 = 0
	local t2 = {}

	local function stripTrailingSkeleton() -- line: 104
		-- upvalues: v15 (copy)
		local v34 = v15.getItems(false)
		local v35 = v34[#v34]

		if v35 ~= nil and v35.kind == "skeleton" then
			v15.removeItem(#v34)
		end
	end
	local function dedupeAndTrack(t3: {[any]: any}) -- line: 119
		-- upvalues: p2 (copy), t2 (ref)
		if p2 == nil then
			return t3
		end

		local t4 = {}

		for _, v39 in t3 do
			local ok, result = pcall(p2, v39)

			if ok then
				if result == nil or result == "" then
					table.insert(t4, v39)
				elseif not t2[result] then
					t2[result] = true
					table.insert(t4, v39)
				end
			end
		end

		return t4
	end
	local function runFetch(b2: boolean) -- line: 138
		-- upvalues: u26 (ref), v20 (copy), n2 (ref), u25 (ref), v23 (copy), v19 (copy), v15 (copy), t1 (copy), v17 (copy), FFlagMomentsSurfaceLoadTTI (copy), b1 (copy), MomentsSurfaceLoadManager (copy), nextCursor (ref), p1 (copy), t2 (ref), dedupeAndTrack (copy), n1 (ref), v21 (copy)
		if u26 then
			return
		end

		if not b2 and not v20(false) then
			return
		end

		n2 += 1

		local v43 = n2

		u25 = true
		v23(false)

		local u44 = nil

		if b2 then
			v19(nil)
			v15.setItems({ t1 })
			v17("Loading")

			if FFlagMomentsSurfaceLoadTTI and b1 then
				MomentsSurfaceLoadManager.start()
				MomentsSurfaceLoadManager.primaryDataStarted()
				MomentsSurfaceLoadManager.primaryDataNetworkFetch()
				u44 = MomentsSurfaceLoadManager.getSessionGeneration()
			end
		else
			v15.addItems({ t1 })
			v17("LoadingMore")
		end

		local v45 = if not b2 then nextCursor else nil

		task.spawn(function() -- line: 187
			-- upvalues: p1 (copy), v45 (copy), u26 (ref), v43 (copy), n2 (ref), u25 (ref), FFlagMomentsSurfaceLoadTTI (copy), b1 (copy), b2 (copy), u44 (ref), MomentsSurfaceLoadManager (copy), t2 (ref), dedupeAndTrack (copy), v15 (copy), nextCursor (ref), n1 (ref), v21 (copy), v17 (copy), v19 (copy), v23 (copy)
			local ok, result = pcall(p1.fetchAsync, v45)

			if u26 or v43 ~= n2 then
				return
			end

			u25 = false

			local v54 = FFlagMomentsSurfaceLoadTTI and (b1 and (b2 and (u44 ~= nil and MomentsSurfaceLoadManager.getSessionGeneration() == u44)))

			if v54 then
				MomentsSurfaceLoadManager.primaryDataResponseReceived()
			end

			local v55 = if not ok or (type(result) ~= "table" or type(result.items) ~= "table") then nil else result

			if v55 ~= nil then
				local v56

				if b2 then
					t2 = {}
					v56 = dedupeAndTrack(v55.items)
					v15.setItems(v56)
				else
					v56 = dedupeAndTrack(v55.items)

					local v57 = table.clone(v15.getItems(false))
					local v58 = v57[#v57]

					if v58 ~= nil and v58.kind == "skeleton" then
						table.remove(v57)
					end

					for _, v60 in v56 do
						table.insert(v57, v60)
					end

					v15.setItems(v57)
				end

				nextCursor = v55.nextCursor
				n1 = (b2 or #v56 ~= 0) and 0 or n1 + 1
				v21(v55.nextCursor ~= nil and n1 < 3)

				local v61 = v15.getCount(false) ~= 0 and "Loaded" or "Empty"

				v17(v61)

				if v54 then
					if v61 == "Loaded" then
						MomentsSurfaceLoadManager.primaryDataReady()
					else
						MomentsSurfaceLoadManager.abort()
					end
				end

				if v55.onAccepted ~= nil then
					v55.onAccepted()

					return
				end
			elseif b2 then
				v15.reset()
				v19(if not ok then tostring(result) else "Malformed feed batch")
				v17("Failed")

				if v54 then
					MomentsSurfaceLoadManager.abort()

					return
				end
			else
				local v62 = v15.getItems(false)
				local v63 = v62[#v62]

				if v63 ~= nil and v63.kind == "skeleton" then
					v15.removeItem(#v62)
				end

				v23(true)
				v17(v15.getCount(false) ~= 0 and "Loaded" or "Empty")
			end
		end)
	end
	local function loadInitial() -- line: 280
		-- upvalues: runFetch (copy)
		runFetch(true)
	end

	return {
		pager = v15,
		getStatus = v16,
		getError = v18,
		getHasMore = v20,
		getLoadMoreFailed = v22,
		loadInitial = loadInitial,
		loadMore = function() -- line: 284
			-- upvalues: u25 (ref), v22 (copy), u26 (ref), v20 (copy), n2 (ref), v23 (copy), v15 (copy), t1 (copy), v17 (copy), nextCursor (ref), p1 (copy), FFlagMomentsSurfaceLoadTTI (copy), b1 (copy), MomentsSurfaceLoadManager (copy), t2 (ref), dedupeAndTrack (copy), n1 (ref), v21 (copy), v19 (copy)
			if u25 or v22(false) then
				return
			end

			if u26 then
				return
			end

			if not v20(false) then
				return
			end

			n2 += 1

			local v46 = n2

			u25 = true
			v23(false)

			local u47 = nil

			v15.addItems({ t1 })
			v17("LoadingMore")

			local v48 = nextCursor
			local v49 = false

			task.spawn(function() -- line: 187
				-- upvalues: p1 (copy), v48 (copy), u26 (ref), v46 (copy), n2 (ref), u25 (ref), FFlagMomentsSurfaceLoadTTI (copy), b1 (copy), v49 (copy), u47 (ref), MomentsSurfaceLoadManager (copy), t2 (ref), dedupeAndTrack (copy), v15 (copy), nextCursor (ref), n1 (ref), v21 (copy), v17 (copy), v19 (copy), v23 (copy)
				local ok, result = pcall(p1.fetchAsync, v48)

				if u26 or v46 ~= n2 then
					return
				end

				u25 = false

				local v66 = FFlagMomentsSurfaceLoadTTI and (b1 and (v49 and (u47 ~= nil and MomentsSurfaceLoadManager.getSessionGeneration() == u47)))

				if v66 then
					MomentsSurfaceLoadManager.primaryDataResponseReceived()
				end

				local v67 = if not ok or (type(result) ~= "table" or type(result.items) ~= "table") then nil else result

				if v67 ~= nil then
					local v68

					if v49 then
						t2 = {}
						v68 = dedupeAndTrack(v67.items)
						v15.setItems(v68)
					else
						v68 = dedupeAndTrack(v67.items)

						local v69 = table.clone(v15.getItems(false))
						local v70 = v69[#v69]

						if v70 ~= nil and v70.kind == "skeleton" then
							table.remove(v69)
						end

						for _, v72 in v68 do
							table.insert(v69, v72)
						end

						v15.setItems(v69)
					end

					nextCursor = v67.nextCursor
					n1 = (v49 or #v68 ~= 0) and 0 or n1 + 1
					v21(v67.nextCursor ~= nil and n1 < 3)

					local v73 = v15.getCount(false) ~= 0 and "Loaded" or "Empty"

					v17(v73)

					if v66 then
						if v73 == "Loaded" then
							MomentsSurfaceLoadManager.primaryDataReady()
						else
							MomentsSurfaceLoadManager.abort()
						end
					end

					if v67.onAccepted ~= nil then
						v67.onAccepted()

						return
					end
				elseif v49 then
					v15.reset()
					v19(if not ok then tostring(result) else "Malformed feed batch")
					v17("Failed")

					if v66 then
						MomentsSurfaceLoadManager.abort()

						return
					end
				else
					local v74 = v15.getItems(false)
					local v75 = v74[#v74]

					if v75 ~= nil and v75.kind == "skeleton" then
						v15.removeItem(#v74)
					end

					v23(true)
					v17(v15.getCount(false) ~= 0 and "Loaded" or "Empty")
				end
			end)
		end,
		prependItem = function(p3) -- line: 302
			-- upvalues: dedupeAndTrack (copy), v15 (copy), v16 (copy), v17 (copy)
			local v51 = dedupeAndTrack({ p3 })

			if #v51 == 0 then
				return
			end

			v15.addItemAt(1, v51[1])

			if v16(false) == "Empty" then
				v17("Loaded")
			end
		end,
		refresh = loadInitial,
		retry = function() -- line: 316
			-- upvalues: runFetch (copy), v15 (copy)
			runFetch(v15.getCount(false) == 0)
		end,
		dispose = function() -- line: 320
			-- upvalues: u26 (ref), p1 (copy), v15 (copy)
			u26 = true

			if p1.dispose then
				p1.dispose()
			end

			v15.dispose()
		end
	}
end

return createFeedStore
