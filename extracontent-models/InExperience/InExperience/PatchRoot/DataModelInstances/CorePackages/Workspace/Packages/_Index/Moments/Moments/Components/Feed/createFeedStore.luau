local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local MomentsCommon = require(parent.MomentsCommon)
local Signals = require(parent.Signals)
local SignalsExperimental = require(parent.SignalsExperimental)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsOptimisticProfilePending = SharedFlags.FFlagMomentsOptimisticProfilePending
local createPendingFeedOverlay = require(script.Parent.createPendingFeedOverlay)
local GetDeletedMomentsStore = require(Moments.Stores.GetDeletedMomentsStore)

local Analytics = MomentsCommon.Analytics
local MomentsSurfaceLoadManager = MomentsCommon.Performance.MomentsSurfaceLoadManager

require(script.Parent.FeedTypes)
local createPagerStore = require(Moments.Components.VerticalPager.createPagerStore)
local FFlagMomentsLoadMoreKeepsPosition = require(Moments.Flags.FFlagMomentsLoadMoreKeepsPosition)
local FFlagMomentsModeratedMomentPage = require(Moments.Flags.FFlagMomentsModeratedMomentPage)

local createSignal = Signals.createSignal

local v = { kind = "skeleton" }

local v2 = { kind = "endState" }

local v3 = { kind = "caughtUp" }

local function isTerminalPage(item): boolean -- 1 equivalent call inferred from this helper
	return item.kind == "endState" or item.kind == "caughtUp"
end

local function isSentinel(p): boolean
	return p.kind == "skeleton" or p.kind == "endState" or p.kind == "caughtUp"
end

local function createFeedStore(data, callback, flag: boolean?, p: number?)
	local endsWithCaughtUp = data.endsWithCaughtUp == true
	local pagerStore = createPagerStore()
	local v4

	if FFlagMomentsOptimisticProfilePending and data.getPendingItems ~= nil then
		v4 = createPendingFeedOverlay()
	else
		v4 = nil
	end

	local v5 = nil

	local signal, v6 = createSignal(nil)

	local signal2, v7 = createSignal("Loading")
	local v8 = "Loading"

	local signal3, v9 = createSignal(nil)
	local signal4, v10 = createSignal(true)
	local signal5, v11 = createSignal(false)
	local recommendationSource = data.recommendationSource or "Unknown"

	local nextCursor = nil
	local v12 = false
	local flag2 = false

	local v13 = 0

	local count = 0

	local set = {}

	local v14 = p
	local signal6, v15 = createSignal(false)

	local signal7, v16 = createSignal(false)

	local v17 = {}

	local function stripTrailingSkeleton() -- 3 equivalent calls inferred from this helper
		local items = pagerStore.getItems(false)
		local item = items[#items]

		if item ~= nil and item.kind == "skeleton" then
			pagerStore.removeItem(#items)
		end
	end

	local function dedupeAndTrack(items)
		if callback == nil then
			return items
		end

		local result = {}

		for _, item in items do
			local success, result2 = pcall(callback, item)

			if success then
				if result2 == nil or result2 == "" then
					table.insert(result, item)
				elseif set[result2] then
					Analytics.reportMomentsFeedItemFiltered("duplicate", recommendationSource)
				else
					set[result2] = true
					table.insert(result, item)
				end
			else
				Analytics.reportMomentsFeedItemFiltered("malformed", recommendationSource)
			end
		end

		return result
	end

	local function countRealItems(items) -- 17 equivalent calls inferred from this helper
		local count2 = 0

		for _, item in items do
			if item.kind ~= "skeleton" and item.kind ~= "endState" and item.kind ~= "caughtUp" then
				count2 += 1
			end
		end

		return count2
	end

	local function publishStatus() -- 2 equivalent calls inferred from this helper
		local v18 = v8

		if v4 ~= nil then
			if countRealItems(pagerStore.getItems(false)) > 0 then -- inferred equivalent call
				v18 = v8 == "LoadingMore" and "LoadingMore" or "Loaded"
			else
				v18 = v8 == "Loaded" and "Empty" or v18
			end
		end

		v7(v18)
	end

	local function setStatus(p2) -- 1 equivalent call inferred from this helper
		v8 = p2
		publishStatus() -- inferred equivalent call
	end

	local function getRetainedItems() -- 2 equivalent calls inferred from this helper
		local clone = table.clone(pagerStore.getItems(false))

		for _, v18 in v17 do
			table.insert(clone, v18)
		end

		return clone
	end

	local function maybeAppendEndState()
		if v14 == nil or signal6(false) then
			return
		end

		local items = pagerStore.getItems(false)

		if countRealItems(items) < v14 then -- inferred equivalent call
			return
		end

		local count3 = countRealItems(items) -- inferred equivalent call

		if v14 < count3 then
			local count2 = 0
			local v18 = {}

			for _, item in items do
				if not (item.kind ~= "skeleton" and item.kind ~= "endState" and item.kind ~= "caughtUp") then
					continue
				end

				if count2 < v14 then
					count2 += 1
					table.insert(v18, item)
				else
					table.insert(v17, item)
				end
			end

			pagerStore.setItems(v18)
		end

		assert(v16, "end-state fixes require the eligibility signal")(signal4(false) or #v17 > 0)

		v15(true)
		pagerStore.addItems({ v2 })
	end

	local function appendTerminalPage()
		local items = pagerStore.getItems(false)

		if not endsWithCaughtUp or signal4(false) or #v17 ~= 0 then
			maybeAppendEndState()
			return
		end

		if v14 ~= nil and not (countRealItems(items) <= v14) then -- inferred equivalent call
			maybeAppendEndState()
			return
		end

		local item = items[#items]

		if item ~= nil and item.kind ~= "skeleton" and item.kind ~= "endState" and item.kind ~= "caughtUp" then
			pagerStore.addItems({ v3 })
		end
	end

	local function commitItems(p2)
		if v4 == nil then
			pagerStore.setItems(p2)
			return
		end

		local currentItem = pagerStore.getCurrentItem(false)
		local v18

		if currentItem == nil then
			v18 = nil
		else
			v18 = v4.identity(currentItem)
		end

		v4.retireMissing(getRetainedItems()) -- inferred equivalent call
		local merged = v4.merge(p2)
		SignalsExperimental.batch(function()
			pagerStore.setItems(merged)

			for k, v19 in merged do
				local identity = v4.identity(v19)

				if v18 ~= nil and identity == v18 then
					pagerStore.goToItem(k)
				end
			end
		end)

		if callback ~= nil then
			for _, v19 in merged do
				if v19.kind ~= "moment" then
					continue
				end

				local v20 = callback(v19)

				if v20 ~= nil then
					set[v20] = true
				end
			end
		end
	end

	local function findMomentIndex(initialMomentId: string?)
		if initialMomentId == nil then
			return nil
		end

		local v18 = assert(v4, "initial identity resolution requires the pending overlay")

		for k, v19 in pagerStore.getItems(false) do
			if
				v19.kind == "moment"
				and (v18.identity(v19) == initialMomentId or v19.moment.momentId == initialMomentId)
				or v19.kind == "unavailableMoment" and v19.targetId == initialMomentId
			then
				return k
			end
		end

		return nil
	end

	local function resolveInitialIndex(flag3: boolean) -- 2 equivalent calls inferred from this helper
		local momentIndex = findMomentIndex(data.initialMomentId)

		if momentIndex ~= nil or flag3 then
			v6(momentIndex)
		end
	end

	local function runFetch(flag3: boolean, flag4: boolean?)
		if flag2 or not (flag3 or signal4(false)) then
			return
		end

		count += 1
		local v18 = count
		v12 = true
		v11(false)

		local v19 = nil

		if flag3 then
			Analytics.reportMomentsFeedLoadAttempt(recommendationSource)

			v9(nil)
			commitItems({ v })

			if v4 ~= nil then
				resolveInitialIndex(false) -- inferred equivalent call
			end

			v8 = "Loading"
			local v20 = v8

			if v4 ~= nil then
				if countRealItems(pagerStore.getItems(false)) > 0 then -- inferred equivalent call
					if v8 == "LoadingMore" then
						v20 = "LoadingMore"
					else
						v20 = "Loaded"
					end
				elseif v8 == "Loaded" then
					v20 = "Empty"
				end
			end

			v7(v20)

			v14 = p
			v15(false)
			assert(v16, "end-state fixes require the eligibility signal")(false)
			table.clear(v17)

			if flag then
				MomentsSurfaceLoadManager.start()
				MomentsSurfaceLoadManager.primaryDataStarted()
				MomentsSurfaceLoadManager.primaryDataNetworkFetch()
				v19 = MomentsSurfaceLoadManager.getSessionGeneration()
			end
		else
			Analytics.reportMomentsFeedLoadMore("attempted", recommendationSource)

			if not (FFlagMomentsLoadMoreKeepsPosition and flag4) then
				pagerStore.addItems({ v })
			end

			v8 = "LoadingMore"
			local v20 = v8

			if v4 ~= nil then
				if countRealItems(pagerStore.getItems(false)) > 0 then -- inferred equivalent call
					if v8 == "LoadingMore" then
						v20 = "LoadingMore"
					else
						v20 = "Loaded"
					end
				elseif v8 == "Loaded" then
					v20 = "Empty"
				end
			end

			v7(v20)
		end

		local v20

		if flag3 then
			v20 = nil
		else
			v20 = nextCursor
		end

		task.spawn(function()
			local success, result = pcall(data.fetchAsync, v20)

			if flag2 or v18 ~= count then
				return
			end

			v12 = false

			local v21 = flag and flag3

			if v21 then
				if v19 == nil then
					v21 = false
				else
					v21 = MomentsSurfaceLoadManager.getSessionGeneration() == v19
				end
			end

			if v21 then
				MomentsSurfaceLoadManager.primaryDataResponseReceived()
			end

			local v22

			if success and type(result) == "table" and type(result.items) == "table" then
				v22 = result
			end

			if v22 == nil then
				if flag3 then
					if v4 == nil then
						pagerStore.reset()
					else
						commitItems({})
						local momentIndex = findMomentIndex(data.initialMomentId)

						v6(momentIndex)
					end

					v9(success and "Malformed feed batch" or tostring(result))
					v8 = "Failed"
					local v23 = v8

					if v4 ~= nil then
						if countRealItems(pagerStore.getItems(false)) > 0 then -- inferred equivalent call
							if v8 == "LoadingMore" then
								v23 = "LoadingMore"
							else
								v23 = "Loaded"
							end
						elseif v8 == "Loaded" then
							v23 = "Empty"
						end
					end

					v7(v23)

					Analytics.reportMomentsFeedState(
						"failed",
						recommendationSource,
						success and "malformedResponse" or "requestFailed"
					)

					if v21 then
						MomentsSurfaceLoadManager.abort("failed")
					end
				else
					stripTrailingSkeleton() -- inferred equivalent call
					v11(true)
					v8 = pagerStore.getCount(false) == 0 and "Empty" or "Loaded"
					local v23 = v8

					if v4 ~= nil then
						if countRealItems(pagerStore.getItems(false)) > 0 then -- inferred equivalent call
							if v8 == "LoadingMore" then
								v23 = "LoadingMore"
							else
								v23 = "Loaded"
							end
						elseif v8 == "Loaded" then
							v23 = "Empty"
						end
					end

					v7(v23)

					Analytics.reportMomentsFeedLoadMore(
						"failed",
						recommendationSource,
						success and "malformedResponse" or "requestFailed"
					)
				end
			else
				local v23

				if flag3 then
					set = {}
					v23 = dedupeAndTrack(v22.items)
					commitItems(v23)

					if v4 ~= nil then
						local momentIndex = findMomentIndex(data.initialMomentId)

						v6(momentIndex)

						local momentIndex2 = findMomentIndex(v22.initialMomentId)

						if momentIndex2 ~= nil then
							pagerStore.goToItem(momentIndex2)
						end
					end
				else
					v23 = dedupeAndTrack(v22.items)
					local clone = table.clone(pagerStore.getItems(false))
					local v24 = clone[#clone]

					if v24 ~= nil and v24.kind == "skeleton" then
						table.remove(clone)
					end

					for _, v25 in v23 do
						table.insert(clone, v25)
					end

					commitItems(clone)
				end

				nextCursor = v22.nextCursor

				v13 = (flag3 or #v23 ~= 0) and 0 or v13 + 1
				v10(v22.nextCursor ~= nil and v13 < 3)
				local v24 = pagerStore.getCount(false) == 0 and "Empty" or "Loaded"
				v8 = v24
				local v25 = v8

				if v4 ~= nil then
					if countRealItems(pagerStore.getItems(false)) > 0 then -- inferred equivalent call
						if v8 == "LoadingMore" then
							v25 = "LoadingMore"
						else
							v25 = "Loaded"
						end
					elseif v8 == "Loaded" then
						v25 = "Empty"
					end
				end

				v7(v25)

				if flag3 then
					Analytics.reportMomentsFeedState(v24 == "Loaded" and "loaded" or "empty", recommendationSource, nil)
				end

				if v21 then
					local currentItem = pagerStore.getCurrentItem(false)

					if
						FFlagMomentsModeratedMomentPage
						and currentItem ~= nil
						and currentItem.kind == "unavailableMoment"
					then
						MomentsSurfaceLoadManager.abort("unavailable")
					elseif v24 == "Loaded" then
						MomentsSurfaceLoadManager.primaryDataReady()
					else
						MomentsSurfaceLoadManager.abort("empty")
					end
				end

				if v22.onAccepted ~= nil then
					v22.onAccepted()
				end

				if p ~= nil or endsWithCaughtUp then
					appendTerminalPage()
				end
			end
		end)
	end

	local function loadInitial()
		runFetch(true)
	end

	local function loadMore()
		if
			v4 ~= nil and (count == 0 or signal3(false) ~= nil)
			or p ~= nil and signal6(false)
			or (v12 or signal5(false))
		then
			return
		end

		if flag2 or not signal4(false) then
			return
		end

		count += 1
		local v18 = count
		v12 = true
		v11(false)

		local v19 = nil

		Analytics.reportMomentsFeedLoadMore("attempted", recommendationSource)

		pagerStore.addItems({ v })
		v8 = "LoadingMore"
		local v20 = v8

		if v4 ~= nil then
			local items = pagerStore.getItems(false)
			local count2 = 0

			for _, item in items do
				if item.kind == "skeleton" or isTerminalPage(item) then
					continue
				end

				count2 += 1
			end

			if count2 > 0 then
				if v8 == "LoadingMore" then
					v20 = "LoadingMore"
				else
					v20 = "Loaded"
				end
			elseif v8 == "Loaded" then
				v20 = "Empty"
			end
		end

		v7(v20)

		local v21 = nextCursor

		local flag3 = false
		task.spawn(function()
			local success, result = pcall(data.fetchAsync, v21)

			if flag2 or v18 ~= count then
				return
			end

			v12 = false

			local v22 = flag and flag3

			if v22 then
				if v19 == nil then
					v22 = false
				else
					v22 = MomentsSurfaceLoadManager.getSessionGeneration() == v19
				end
			end

			if v22 then
				MomentsSurfaceLoadManager.primaryDataResponseReceived()
			end

			local v23

			if success and type(result) == "table" and type(result.items) == "table" then
				v23 = result
			end

			if v23 == nil then
				if flag3 then
					if v4 == nil then
						pagerStore.reset()
					else
						commitItems({})
						local momentIndex = findMomentIndex(data.initialMomentId)

						v6(momentIndex)
					end

					v9(success and "Malformed feed batch" or tostring(result))
					v8 = "Failed"
					local v24 = v8

					if v4 ~= nil then
						if countRealItems(pagerStore.getItems(false)) > 0 then -- inferred equivalent call
							if v8 == "LoadingMore" then
								v24 = "LoadingMore"
							else
								v24 = "Loaded"
							end
						elseif v8 == "Loaded" then
							v24 = "Empty"
						end
					end

					v7(v24)

					Analytics.reportMomentsFeedState(
						"failed",
						recommendationSource,
						success and "malformedResponse" or "requestFailed"
					)

					if v22 then
						MomentsSurfaceLoadManager.abort("failed")
					end
				else
					stripTrailingSkeleton() -- inferred equivalent call
					v11(true)
					v8 = pagerStore.getCount(false) == 0 and "Empty" or "Loaded"
					local v24 = v8

					if v4 ~= nil then
						if countRealItems(pagerStore.getItems(false)) > 0 then -- inferred equivalent call
							if v8 == "LoadingMore" then
								v24 = "LoadingMore"
							else
								v24 = "Loaded"
							end
						elseif v8 == "Loaded" then
							v24 = "Empty"
						end
					end

					v7(v24)

					Analytics.reportMomentsFeedLoadMore(
						"failed",
						recommendationSource,
						success and "malformedResponse" or "requestFailed"
					)
				end
			else
				local v24

				if flag3 then
					set = {}
					v24 = dedupeAndTrack(v23.items)
					commitItems(v24)

					if v4 ~= nil then
						local momentIndex = findMomentIndex(data.initialMomentId)

						v6(momentIndex)

						local momentIndex2 = findMomentIndex(v23.initialMomentId)

						if momentIndex2 ~= nil then
							pagerStore.goToItem(momentIndex2)
						end
					end
				else
					v24 = dedupeAndTrack(v23.items)
					local clone = table.clone(pagerStore.getItems(false))
					local v25 = clone[#clone]

					if v25 ~= nil and v25.kind == "skeleton" then
						table.remove(clone)
					end

					for _, v26 in v24 do
						table.insert(clone, v26)
					end

					commitItems(clone)
				end

				nextCursor = v23.nextCursor

				v13 = (flag3 or #v24 ~= 0) and 0 or v13 + 1
				v10(v23.nextCursor ~= nil and v13 < 3)
				local v25 = pagerStore.getCount(false) == 0 and "Empty" or "Loaded"
				v8 = v25
				local v26 = v8

				if v4 ~= nil then
					if countRealItems(pagerStore.getItems(false)) > 0 then -- inferred equivalent call
						if v8 == "LoadingMore" then
							v26 = "LoadingMore"
						else
							v26 = "Loaded"
						end
					elseif v8 == "Loaded" then
						v26 = "Empty"
					end
				end

				v7(v26)

				if flag3 then
					Analytics.reportMomentsFeedState(v25 == "Loaded" and "loaded" or "empty", recommendationSource, nil)
				end

				if v22 then
					local currentItem = pagerStore.getCurrentItem(false)

					if
						FFlagMomentsModeratedMomentPage
						and currentItem ~= nil
						and currentItem.kind == "unavailableMoment"
					then
						MomentsSurfaceLoadManager.abort("unavailable")
					elseif v25 == "Loaded" then
						MomentsSurfaceLoadManager.primaryDataReady()
					else
						MomentsSurfaceLoadManager.abort("empty")
					end
				end

				if v23.onAccepted ~= nil then
					v23.onAccepted()
				end

				if p ~= nil or endsWithCaughtUp then
					appendTerminalPage()
				end
			end
		end)
	end

	local function loadBeyondLimit()
		if flag2 or p == nil or not signal6(false) or not signal4(false) and #v17 == 0 then
			return
		end

		local items = pagerStore.getItems(false)
		local clone = table.clone(items)
		local v18 = clone[#clone]
		local v19

		if v18 == nil then
			v19 = false
		else
			v19 = v18.kind == "endState"
		end

		if v19 then
			table.remove(clone)
		end

		if FFlagMomentsLoadMoreKeepsPosition and v19 then
			pagerStore.goToItem(#items)
		end

		if not FFlagMomentsLoadMoreKeepsPosition and v19 then
			pagerStore.removeItem(#items)
		end

		local v20

		if FFlagMomentsLoadMoreKeepsPosition then
			v20 = countRealItems(clone) + p -- inferred equivalent call
		else
			v20 = countRealItems(pagerStore.getItems(false)) + p -- inferred equivalent call
		end

		v14 = v20

		v15(false)
		local v21 = false

		if #v17 > 0 then
			if not FFlagMomentsLoadMoreKeepsPosition then
				clone = table.clone(pagerStore.getItems(false))
			end

			for _, v22 in v17 do
				table.insert(clone, v22)
			end

			table.clear(v17)
			pagerStore.setItems(clone)

			appendTerminalPage()

			if signal6(false) then
				return
			end
		elseif FFlagMomentsLoadMoreKeepsPosition then
			table.insert(clone, v)
			pagerStore.setItems(clone)
			v21 = true
		end

		if not FFlagMomentsLoadMoreKeepsPosition then
			v21 = nil
		end

		if flag2 or not signal4(false) then
			return
		end

		count += 1
		local v22 = count
		v12 = true
		v11(false)

		local v23 = nil

		Analytics.reportMomentsFeedLoadMore("attempted", recommendationSource)

		if not (FFlagMomentsLoadMoreKeepsPosition and v21) then
			pagerStore.addItems({ v })
		end

		v8 = "LoadingMore"
		local v24 = v8

		if v4 ~= nil then
			local items2 = pagerStore.getItems(false)
			local count2 = 0

			for _, item in items2 do
				if item.kind == "skeleton" or isTerminalPage(item) then
					continue
				end

				count2 += 1
			end

			if count2 > 0 then
				if v8 == "LoadingMore" then
					v24 = "LoadingMore"
				else
					v24 = "Loaded"
				end
			elseif v8 == "Loaded" then
				v24 = "Empty"
			end
		end

		v7(v24)

		local v25 = nextCursor

		local flag3 = false
		task.spawn(function()
			local success, result = pcall(data.fetchAsync, v25)

			if flag2 or v22 ~= count then
				return
			end

			v12 = false

			local v26 = flag and flag3

			if v26 then
				if v23 == nil then
					v26 = false
				else
					v26 = MomentsSurfaceLoadManager.getSessionGeneration() == v23
				end
			end

			if v26 then
				MomentsSurfaceLoadManager.primaryDataResponseReceived()
			end

			local v27

			if success and type(result) == "table" and type(result.items) == "table" then
				v27 = result
			end

			if v27 == nil then
				if flag3 then
					if v4 == nil then
						pagerStore.reset()
					else
						commitItems({})
						local momentIndex = findMomentIndex(data.initialMomentId)

						v6(momentIndex)
					end

					v9(success and "Malformed feed batch" or tostring(result))
					v8 = "Failed"
					local v28 = v8

					if v4 ~= nil then
						if countRealItems(pagerStore.getItems(false)) > 0 then -- inferred equivalent call
							if v8 == "LoadingMore" then
								v28 = "LoadingMore"
							else
								v28 = "Loaded"
							end
						elseif v8 == "Loaded" then
							v28 = "Empty"
						end
					end

					v7(v28)

					Analytics.reportMomentsFeedState(
						"failed",
						recommendationSource,
						success and "malformedResponse" or "requestFailed"
					)

					if v26 then
						MomentsSurfaceLoadManager.abort("failed")
					end
				else
					stripTrailingSkeleton() -- inferred equivalent call
					v11(true)
					v8 = pagerStore.getCount(false) == 0 and "Empty" or "Loaded"
					local v28 = v8

					if v4 ~= nil then
						if countRealItems(pagerStore.getItems(false)) > 0 then -- inferred equivalent call
							if v8 == "LoadingMore" then
								v28 = "LoadingMore"
							else
								v28 = "Loaded"
							end
						elseif v8 == "Loaded" then
							v28 = "Empty"
						end
					end

					v7(v28)

					Analytics.reportMomentsFeedLoadMore(
						"failed",
						recommendationSource,
						success and "malformedResponse" or "requestFailed"
					)
				end
			else
				local v28

				if flag3 then
					set = {}
					v28 = dedupeAndTrack(v27.items)
					commitItems(v28)

					if v4 ~= nil then
						local momentIndex = findMomentIndex(data.initialMomentId)

						v6(momentIndex)

						local momentIndex2 = findMomentIndex(v27.initialMomentId)

						if momentIndex2 ~= nil then
							pagerStore.goToItem(momentIndex2)
						end
					end
				else
					v28 = dedupeAndTrack(v27.items)
					local clone2 = table.clone(pagerStore.getItems(false))
					local v29 = clone2[#clone2]

					if v29 ~= nil and v29.kind == "skeleton" then
						table.remove(clone2)
					end

					for _, v30 in v28 do
						table.insert(clone2, v30)
					end

					commitItems(clone2)
				end

				nextCursor = v27.nextCursor

				v13 = (flag3 or #v28 ~= 0) and 0 or v13 + 1
				v10(v27.nextCursor ~= nil and v13 < 3)
				local v29 = pagerStore.getCount(false) == 0 and "Empty" or "Loaded"
				v8 = v29
				local v30 = v8

				if v4 ~= nil then
					if countRealItems(pagerStore.getItems(false)) > 0 then -- inferred equivalent call
						if v8 == "LoadingMore" then
							v30 = "LoadingMore"
						else
							v30 = "Loaded"
						end
					elseif v8 == "Loaded" then
						v30 = "Empty"
					end
				end

				v7(v30)

				if flag3 then
					Analytics.reportMomentsFeedState(v29 == "Loaded" and "loaded" or "empty", recommendationSource, nil)
				end

				if v26 then
					local currentItem = pagerStore.getCurrentItem(false)

					if
						FFlagMomentsModeratedMomentPage
						and currentItem ~= nil
						and currentItem.kind == "unavailableMoment"
					then
						MomentsSurfaceLoadManager.abort("unavailable")
					elseif v29 == "Loaded" then
						MomentsSurfaceLoadManager.primaryDataReady()
					else
						MomentsSurfaceLoadManager.abort("empty")
					end
				end

				if v27.onAccepted ~= nil then
					v27.onAccepted()
				end

				if p ~= nil or endsWithCaughtUp then
					appendTerminalPage()
				end
			end
		end)
	end

	local function prependItem(p2)
		local v18 = dedupeAndTrack({ p2 })

		if #v18 == 0 then
			return
		end

		pagerStore.addItemAt(1, v18[1])

		if signal2(false) == "Empty" then
			setStatus("Loaded") -- inferred equivalent call
		end
	end

	local function retry()
		if v4 == nil or signal3(false) == nil then
			runFetch(pagerStore.getCount(false) == 0)
		else
			runFetch(true)
		end
	end

	local function dispose()
		flag2 = true

		if v5 ~= nil then
			v5()
		end

		if data.dispose then
			data.dispose()
		end

		pagerStore.dispose()
	end

	if v4 ~= nil and data.getPendingItems ~= nil then
		if data.initialMomentId ~= nil then
			v6(1e999)
		end

		local getPendingItems = data.getPendingItems
		v5 = Signals.createEffect(function(p2)
			local v18 = v4.update(getPendingItems(p2), GetDeletedMomentsStore(false).getDeletedIds(p2))
			local retainedItems = getRetainedItems() -- inferred equivalent call

			for i = #retainedItems, 1, -1 do
				if isTerminalPage(retainedItems[i]) then -- inferred equivalent call
					table.remove(retainedItems, i)
				end
			end

			SignalsExperimental.batch(function()
				commitItems(retainedItems)
				table.clear(v17)
				resolveInitialIndex(false) -- inferred equivalent call
				v15(false)
				appendTerminalPage()
				publishStatus() -- inferred equivalent call

				if v18 and data.recommendationSource == "Trending" then
					pagerStore.goToItem(1)
				end
			end)
		end)
	end

	return {
		getInitialIndex = signal,
		observabilityFeedType = recommendationSource,
		pager = pagerStore,
		getStatus = signal2,
		getError = signal3,
		getHasMore = signal4,
		getLoadMoreFailed = signal5,
		getAtScrollLimit = signal6,
		getCanLoadMoreBeyondLimit = signal7,
		loadInitial = loadInitial,
		loadMore = loadMore,
		loadBeyondLimit = loadBeyondLimit,
		prependItem = prependItem,
		refresh = loadInitial,
		retry = retry,
		dispose = dispose
	}
end

return createFeedStore
