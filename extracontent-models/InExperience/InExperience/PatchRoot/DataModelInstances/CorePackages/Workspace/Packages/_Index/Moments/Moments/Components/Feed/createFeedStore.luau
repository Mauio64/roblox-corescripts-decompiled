local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local MomentsCommon = require(parent.MomentsCommon)
local Signals = require(parent.Signals)
local SignalsExperimental = require(parent.SignalsExperimental)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsOptimisticProfilePending = SharedFlags.FFlagMomentsOptimisticProfilePending
local createPendingFeedOverlay = require(script.Parent.createPendingFeedOverlay)
local GetDeletedMomentsStore = require(Moments.Stores.GetDeletedMomentsStore)
local FFlagMomentsParentTimeLimit = MomentsCommon.Flags.FFlagMomentsParentTimeLimit

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

local function createFeedStore(data, callback, flag: boolean?, p: number?, p2)
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
	local v13 = false
	local v14 = nil

	local v15 = nil

	local v16 = 0

	local count = 0

	local set = {}

	local v17 = p
	local signal6, v18 = createSignal(false)

	local signal7, v19 = createSignal(false)

	local v20 = {}

	local function stripTrailingSkeleton() -- 6 equivalent calls inferred from this helper
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

	local function countRealItems(items) -- 20 equivalent calls inferred from this helper
		local count2 = 0

		for _, item in items do
			if item.kind ~= "skeleton" and item.kind ~= "endState" and item.kind ~= "caughtUp" then
				count2 += 1
			end
		end

		return count2
	end

	local function publishStatus() -- 3 equivalent calls inferred from this helper
		local v21 = v8

		if FFlagMomentsParentTimeLimit and v13 then
			v21 = "LimitReached"
		elseif v4 ~= nil then
			if countRealItems(pagerStore.getItems(false)) > 0 then -- inferred equivalent call
				v21 = v8 == "LoadingMore" and "LoadingMore" or "Loaded"
			else
				v21 = v8 == "Loaded" and "Empty" or v21
			end
		end

		v7(v21)
	end

	local function setStatus(p3) -- 1 equivalent call inferred from this helper
		v8 = p3
		publishStatus() -- inferred equivalent call
	end

	local function getRetainedItems() -- 2 equivalent calls inferred from this helper
		local clone = table.clone(pagerStore.getItems(false))

		for _, v21 in v20 do
			table.insert(clone, v21)
		end

		return clone
	end

	local function maybeAppendEndState()
		if v17 == nil or signal6(false) then
			return
		end

		local items = pagerStore.getItems(false)

		if countRealItems(items) < v17 then -- inferred equivalent call
			return
		end

		local count3 = countRealItems(items) -- inferred equivalent call

		if v17 < count3 then
			local count2 = 0
			local v21 = {}

			for _, item in items do
				if not (item.kind ~= "skeleton" and item.kind ~= "endState" and item.kind ~= "caughtUp") then
					continue
				end

				if count2 < v17 then
					count2 += 1
					table.insert(v21, item)
				else
					table.insert(v20, item)
				end
			end

			pagerStore.setItems(v21)
		end

		assert(v19, "end-state fixes require the eligibility signal")(signal4(false) or #v20 > 0)

		v18(true)
		pagerStore.addItems({ v2 })
	end

	local function appendTerminalPage()
		local items = pagerStore.getItems(false)

		if not endsWithCaughtUp or signal4(false) or #v20 ~= 0 then
			maybeAppendEndState()
			return
		end

		if v17 ~= nil and not (countRealItems(items) <= v17) then -- inferred equivalent call
			maybeAppendEndState()
			return
		end

		local item = items[#items]

		if item ~= nil and item.kind ~= "skeleton" and item.kind ~= "endState" and item.kind ~= "caughtUp" then
			pagerStore.addItems({ v3 })
		end
	end

	local function commitItems(p3)
		if v4 == nil then
			pagerStore.setItems(p3)
			return
		end

		local currentItem = pagerStore.getCurrentItem(false)
		local v21

		if currentItem == nil then
			v21 = nil
		else
			v21 = v4.identity(currentItem)
		end

		v4.retireMissing(getRetainedItems()) -- inferred equivalent call
		local merged = v4.merge(p3)
		SignalsExperimental.batch(function()
			pagerStore.setItems(merged)

			for k, v22 in merged do
				local identity = v4.identity(v22)

				if v21 ~= nil and identity == v21 then
					pagerStore.goToItem(k)
				end
			end
		end)

		if callback ~= nil then
			for _, v22 in merged do
				if v22.kind ~= "moment" then
					continue
				end

				local v23 = callback(v22)

				if v23 ~= nil then
					set[v23] = true
				end
			end
		end
	end

	local function findMomentIndex(initialMomentId: string?)
		if initialMomentId == nil then
			return nil
		end

		local v21 = assert(v4, "initial identity resolution requires the pending overlay")

		for k, v22 in pagerStore.getItems(false) do
			if
				v22.kind == "moment"
				and (v21.identity(v22) == initialMomentId or v22.moment.momentId == initialMomentId)
				or v22.kind == "unavailableMoment" and v22.targetId == initialMomentId
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
		if flag2 or not (flag3 or signal4(false)) or FFlagMomentsParentTimeLimit and v13 then
			return
		end

		count += 1
		local v21 = count
		v12 = true
		v11(false)

		local v22 = nil

		if flag3 then
			Analytics.reportMomentsFeedLoadAttempt(recommendationSource)

			v9(nil)
			commitItems({ v })

			if v4 ~= nil then
				resolveInitialIndex(false) -- inferred equivalent call
			end

			v8 = "Loading"
			local v23 = v8

			if FFlagMomentsParentTimeLimit and v13 then
				v23 = "LimitReached"
			elseif v4 ~= nil then
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

			v17 = p
			v18(false)
			assert(v19, "end-state fixes require the eligibility signal")(false)
			table.clear(v20)

			if flag then
				MomentsSurfaceLoadManager.start()
				MomentsSurfaceLoadManager.primaryDataStarted()
				MomentsSurfaceLoadManager.primaryDataNetworkFetch()
				v22 = MomentsSurfaceLoadManager.getSessionGeneration()

				if FFlagMomentsParentTimeLimit then
					v15 = v22
				end
			end
		else
			Analytics.reportMomentsFeedLoadMore("attempted", recommendationSource)

			if not (FFlagMomentsLoadMoreKeepsPosition and flag4) then
				pagerStore.addItems({ v })
			end

			v8 = "LoadingMore"
			local v23 = v8

			if FFlagMomentsParentTimeLimit and v13 then
				v23 = "LimitReached"
			elseif v4 ~= nil then
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
		end

		local v23

		if flag3 then
			v23 = nil
		else
			v23 = nextCursor
		end

		task.spawn(function()
			local success, result = pcall(data.fetchAsync, v23)

			if flag2 or v21 ~= count then
				return
			end

			v12 = false

			local v24 = flag and flag3

			if v24 then
				if v22 == nil then
					v24 = false
				else
					v24 = MomentsSurfaceLoadManager.getSessionGeneration() == v22
				end
			end

			if v24 then
				MomentsSurfaceLoadManager.primaryDataResponseReceived()
			end

			local v25

			if FFlagMomentsParentTimeLimit and not success and p2 ~= nil then
				local MomentsParseMomentsLimitError = require(parent.DataHydration.MomentsParseMomentsLimitError)
				v25 = MomentsParseMomentsLimitError(result)
			end

			if v25 == nil then
				local v26

				if success and type(result) == "table" and type(result.items) == "table" then
					v26 = result
				end

				if v26 == nil then
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
						local v27 = v8

						if FFlagMomentsParentTimeLimit and v13 then
							v27 = "LimitReached"
						elseif v4 ~= nil then
							if countRealItems(pagerStore.getItems(false)) > 0 then -- inferred equivalent call
								if v8 == "LoadingMore" then
									v27 = "LoadingMore"
								else
									v27 = "Loaded"
								end
							elseif v8 == "Loaded" then
								v27 = "Empty"
							end
						end

						v7(v27)

						Analytics.reportMomentsFeedState(
							"failed",
							recommendationSource,
							success and "malformedResponse" or "requestFailed"
						)

						if v24 then
							MomentsSurfaceLoadManager.abort("failed")
						end
					else
						stripTrailingSkeleton() -- inferred equivalent call
						v11(true)
						v8 = pagerStore.getCount(false) == 0 and "Empty" or "Loaded"
						local v27 = v8

						if FFlagMomentsParentTimeLimit and v13 then
							v27 = "LimitReached"
						elseif v4 ~= nil then
							if countRealItems(pagerStore.getItems(false)) > 0 then -- inferred equivalent call
								if v8 == "LoadingMore" then
									v27 = "LoadingMore"
								else
									v27 = "Loaded"
								end
							elseif v8 == "Loaded" then
								v27 = "Empty"
							end
						end

						v7(v27)

						Analytics.reportMomentsFeedLoadMore(
							"failed",
							recommendationSource,
							success and "malformedResponse" or "requestFailed"
						)
					end
				else
					local v27

					if flag3 then
						set = {}
						v27 = dedupeAndTrack(v26.items)
						commitItems(v27)

						if v4 ~= nil then
							local momentIndex = findMomentIndex(data.initialMomentId)

							v6(momentIndex)

							local momentIndex2 = findMomentIndex(v26.initialMomentId)

							if momentIndex2 ~= nil then
								pagerStore.goToItem(momentIndex2)
							end
						end
					else
						v27 = dedupeAndTrack(v26.items)
						local clone = table.clone(pagerStore.getItems(false))
						local v28 = clone[#clone]

						if v28 ~= nil and v28.kind == "skeleton" then
							table.remove(clone)
						end

						for _, v29 in v27 do
							table.insert(clone, v29)
						end

						commitItems(clone)
					end

					nextCursor = v26.nextCursor

					v16 = (flag3 or #v27 ~= 0) and 0 or v16 + 1
					v10(v26.nextCursor ~= nil and v16 < 3)
					local v28 = pagerStore.getCount(false) == 0 and "Empty" or "Loaded"
					v8 = v28
					local v29 = v8

					if FFlagMomentsParentTimeLimit and v13 then
						v29 = "LimitReached"
					elseif v4 ~= nil then
						if countRealItems(pagerStore.getItems(false)) > 0 then -- inferred equivalent call
							if v8 == "LoadingMore" then
								v29 = "LoadingMore"
							else
								v29 = "Loaded"
							end
						elseif v8 == "Loaded" then
							v29 = "Empty"
						end
					end

					v7(v29)

					if flag3 then
						Analytics.reportMomentsFeedState(
							v28 == "Loaded" and "loaded" or "empty",
							recommendationSource,
							nil
						)
					end

					if v24 then
						local currentItem = pagerStore.getCurrentItem(false)

						if
							FFlagMomentsModeratedMomentPage
							and currentItem ~= nil
							and currentItem.kind == "unavailableMoment"
						then
							MomentsSurfaceLoadManager.abort("unavailable")
						elseif v28 == "Loaded" then
							MomentsSurfaceLoadManager.primaryDataReady()
						else
							MomentsSurfaceLoadManager.abort("empty")
						end
					end

					if v26.onAccepted ~= nil then
						v26.onAccepted()
					end

					if p ~= nil or endsWithCaughtUp then
						appendTerminalPage()
					end
				end
			else
				if flag3 and v4 ~= nil then
					commitItems({})
					local momentIndex = findMomentIndex(data.initialMomentId)

					v6(momentIndex)
				else
					stripTrailingSkeleton() -- inferred equivalent call
				end

				v13 = true
				v8 = pagerStore.getCount(false) == 0 and "Empty" or "Loaded"
				local v26 = v8

				if FFlagMomentsParentTimeLimit and v13 then
					v26 = "LimitReached"
				elseif v4 ~= nil then
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
					Analytics.reportMomentsFeedState("failed", recommendationSource, "parentalTimeLimitReached")
				else
					Analytics.reportMomentsFeedLoadMore("failed", recommendationSource, "parentalTimeLimitReached")
				end

				if v24 then
					MomentsSurfaceLoadManager.abort("parentalTimeLimitReached")
				end

				p2.markLimitReached(v25.limitSeconds)
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

		if flag2 or not signal4(false) or FFlagMomentsParentTimeLimit and v13 then
			return
		end

		count += 1
		local v21 = count
		v12 = true
		v11(false)

		local v22 = nil

		Analytics.reportMomentsFeedLoadMore("attempted", recommendationSource)

		pagerStore.addItems({ v })
		v8 = "LoadingMore"
		local v23 = v8

		if FFlagMomentsParentTimeLimit and v13 then
			v23 = "LimitReached"
		elseif v4 ~= nil then
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
					v23 = "LoadingMore"
				else
					v23 = "Loaded"
				end
			elseif v8 == "Loaded" then
				v23 = "Empty"
			end
		end

		v7(v23)

		local v24 = nextCursor

		local flag3 = false
		task.spawn(function()
			local success, result = pcall(data.fetchAsync, v24)

			if flag2 or v21 ~= count then
				return
			end

			v12 = false

			local v25 = flag and flag3

			if v25 then
				if v22 == nil then
					v25 = false
				else
					v25 = MomentsSurfaceLoadManager.getSessionGeneration() == v22
				end
			end

			if v25 then
				MomentsSurfaceLoadManager.primaryDataResponseReceived()
			end

			local v26

			if FFlagMomentsParentTimeLimit and not success and p2 ~= nil then
				local MomentsParseMomentsLimitError = require(parent.DataHydration.MomentsParseMomentsLimitError)
				v26 = MomentsParseMomentsLimitError(result)
			end

			if v26 == nil then
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

						if FFlagMomentsParentTimeLimit and v13 then
							v28 = "LimitReached"
						elseif v4 ~= nil then
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

						if v25 then
							MomentsSurfaceLoadManager.abort("failed")
						end
					else
						stripTrailingSkeleton() -- inferred equivalent call
						v11(true)
						v8 = pagerStore.getCount(false) == 0 and "Empty" or "Loaded"
						local v28 = v8

						if FFlagMomentsParentTimeLimit and v13 then
							v28 = "LimitReached"
						elseif v4 ~= nil then
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
						local clone = table.clone(pagerStore.getItems(false))
						local v29 = clone[#clone]

						if v29 ~= nil and v29.kind == "skeleton" then
							table.remove(clone)
						end

						for _, v30 in v28 do
							table.insert(clone, v30)
						end

						commitItems(clone)
					end

					nextCursor = v27.nextCursor

					v16 = (flag3 or #v28 ~= 0) and 0 or v16 + 1
					v10(v27.nextCursor ~= nil and v16 < 3)
					local v29 = pagerStore.getCount(false) == 0 and "Empty" or "Loaded"
					v8 = v29
					local v30 = v8

					if FFlagMomentsParentTimeLimit and v13 then
						v30 = "LimitReached"
					elseif v4 ~= nil then
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
						Analytics.reportMomentsFeedState(
							v29 == "Loaded" and "loaded" or "empty",
							recommendationSource,
							nil
						)
					end

					if v25 then
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
			else
				if flag3 and v4 ~= nil then
					commitItems({})
					local momentIndex = findMomentIndex(data.initialMomentId)

					v6(momentIndex)
				else
					stripTrailingSkeleton() -- inferred equivalent call
				end

				v13 = true
				v8 = pagerStore.getCount(false) == 0 and "Empty" or "Loaded"
				local v27 = v8

				if FFlagMomentsParentTimeLimit and v13 then
					v27 = "LimitReached"
				elseif v4 ~= nil then
					if countRealItems(pagerStore.getItems(false)) > 0 then -- inferred equivalent call
						if v8 == "LoadingMore" then
							v27 = "LoadingMore"
						else
							v27 = "Loaded"
						end
					elseif v8 == "Loaded" then
						v27 = "Empty"
					end
				end

				v7(v27)

				if flag3 then
					Analytics.reportMomentsFeedState("failed", recommendationSource, "parentalTimeLimitReached")
				else
					Analytics.reportMomentsFeedLoadMore("failed", recommendationSource, "parentalTimeLimitReached")
				end

				if v25 then
					MomentsSurfaceLoadManager.abort("parentalTimeLimitReached")
				end

				p2.markLimitReached(v26.limitSeconds)
			end
		end)
	end

	local function loadBeyondLimit()
		if flag2 or p == nil or not signal6(false) or not signal4(false) and #v20 == 0 then
			return
		end

		local items = pagerStore.getItems(false)
		local clone = table.clone(items)
		local v21 = clone[#clone]
		local v22

		if v21 == nil then
			v22 = false
		else
			v22 = v21.kind == "endState"
		end

		if v22 then
			table.remove(clone)
		end

		if FFlagMomentsLoadMoreKeepsPosition and v22 then
			pagerStore.goToItem(#items)
		end

		if not FFlagMomentsLoadMoreKeepsPosition and v22 then
			pagerStore.removeItem(#items)
		end

		local v23

		if FFlagMomentsLoadMoreKeepsPosition then
			v23 = countRealItems(clone) + p -- inferred equivalent call
		else
			v23 = countRealItems(pagerStore.getItems(false)) + p -- inferred equivalent call
		end

		v17 = v23

		v18(false)
		local v24 = false

		if #v20 > 0 then
			if not FFlagMomentsLoadMoreKeepsPosition then
				clone = table.clone(pagerStore.getItems(false))
			end

			for _, v25 in v20 do
				table.insert(clone, v25)
			end

			table.clear(v20)
			pagerStore.setItems(clone)

			appendTerminalPage()

			if signal6(false) then
				return
			end
		elseif FFlagMomentsLoadMoreKeepsPosition then
			table.insert(clone, v)
			pagerStore.setItems(clone)
			v24 = true
		end

		if not FFlagMomentsLoadMoreKeepsPosition then
			v24 = nil
		end

		if flag2 or not signal4(false) or FFlagMomentsParentTimeLimit and v13 then
			return
		end

		count += 1
		local v25 = count
		v12 = true
		v11(false)

		local v26 = nil

		Analytics.reportMomentsFeedLoadMore("attempted", recommendationSource)

		if not (FFlagMomentsLoadMoreKeepsPosition and v24) then
			pagerStore.addItems({ v })
		end

		v8 = "LoadingMore"
		local v27 = v8

		if FFlagMomentsParentTimeLimit and v13 then
			v27 = "LimitReached"
		elseif v4 ~= nil then
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
					v27 = "LoadingMore"
				else
					v27 = "Loaded"
				end
			elseif v8 == "Loaded" then
				v27 = "Empty"
			end
		end

		v7(v27)

		local v28 = nextCursor

		local flag3 = false
		task.spawn(function()
			local success, result = pcall(data.fetchAsync, v28)

			if flag2 or v25 ~= count then
				return
			end

			v12 = false

			local v29 = flag and flag3

			if v29 then
				if v26 == nil then
					v29 = false
				else
					v29 = MomentsSurfaceLoadManager.getSessionGeneration() == v26
				end
			end

			if v29 then
				MomentsSurfaceLoadManager.primaryDataResponseReceived()
			end

			local v30

			if FFlagMomentsParentTimeLimit and not success and p2 ~= nil then
				local MomentsParseMomentsLimitError = require(parent.DataHydration.MomentsParseMomentsLimitError)
				v30 = MomentsParseMomentsLimitError(result)
			end

			if v30 == nil then
				local v31

				if success and type(result) == "table" and type(result.items) == "table" then
					v31 = result
				end

				if v31 == nil then
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
						local v32 = v8

						if FFlagMomentsParentTimeLimit and v13 then
							v32 = "LimitReached"
						elseif v4 ~= nil then
							if countRealItems(pagerStore.getItems(false)) > 0 then -- inferred equivalent call
								if v8 == "LoadingMore" then
									v32 = "LoadingMore"
								else
									v32 = "Loaded"
								end
							elseif v8 == "Loaded" then
								v32 = "Empty"
							end
						end

						v7(v32)

						Analytics.reportMomentsFeedState(
							"failed",
							recommendationSource,
							success and "malformedResponse" or "requestFailed"
						)

						if v29 then
							MomentsSurfaceLoadManager.abort("failed")
						end
					else
						stripTrailingSkeleton() -- inferred equivalent call
						v11(true)
						v8 = pagerStore.getCount(false) == 0 and "Empty" or "Loaded"
						local v32 = v8

						if FFlagMomentsParentTimeLimit and v13 then
							v32 = "LimitReached"
						elseif v4 ~= nil then
							if countRealItems(pagerStore.getItems(false)) > 0 then -- inferred equivalent call
								if v8 == "LoadingMore" then
									v32 = "LoadingMore"
								else
									v32 = "Loaded"
								end
							elseif v8 == "Loaded" then
								v32 = "Empty"
							end
						end

						v7(v32)

						Analytics.reportMomentsFeedLoadMore(
							"failed",
							recommendationSource,
							success and "malformedResponse" or "requestFailed"
						)
					end
				else
					local v32

					if flag3 then
						set = {}
						v32 = dedupeAndTrack(v31.items)
						commitItems(v32)

						if v4 ~= nil then
							local momentIndex = findMomentIndex(data.initialMomentId)

							v6(momentIndex)

							local momentIndex2 = findMomentIndex(v31.initialMomentId)

							if momentIndex2 ~= nil then
								pagerStore.goToItem(momentIndex2)
							end
						end
					else
						v32 = dedupeAndTrack(v31.items)
						local clone2 = table.clone(pagerStore.getItems(false))
						local v34 = clone2[#clone2]

						if v34 ~= nil and v34.kind == "skeleton" then
							table.remove(clone2)
						end

						for _, v35 in v32 do
							table.insert(clone2, v35)
						end

						commitItems(clone2)
					end

					nextCursor = v31.nextCursor

					v16 = (flag3 or #v32 ~= 0) and 0 or v16 + 1
					v10(v31.nextCursor ~= nil and v16 < 3)
					local v35 = pagerStore.getCount(false) == 0 and "Empty" or "Loaded"
					v8 = v35
					local v36 = v8

					if FFlagMomentsParentTimeLimit and v13 then
						v36 = "LimitReached"
					elseif v4 ~= nil then
						if countRealItems(pagerStore.getItems(false)) > 0 then -- inferred equivalent call
							if v8 == "LoadingMore" then
								v36 = "LoadingMore"
							else
								v36 = "Loaded"
							end
						elseif v8 == "Loaded" then
							v36 = "Empty"
						end
					end

					v7(v36)

					if flag3 then
						Analytics.reportMomentsFeedState(
							v35 == "Loaded" and "loaded" or "empty",
							recommendationSource,
							nil
						)
					end

					if v29 then
						local currentItem = pagerStore.getCurrentItem(false)

						if
							FFlagMomentsModeratedMomentPage
							and currentItem ~= nil
							and currentItem.kind == "unavailableMoment"
						then
							MomentsSurfaceLoadManager.abort("unavailable")
						elseif v35 == "Loaded" then
							MomentsSurfaceLoadManager.primaryDataReady()
						else
							MomentsSurfaceLoadManager.abort("empty")
						end
					end

					if v31.onAccepted ~= nil then
						v31.onAccepted()
					end

					if p ~= nil or endsWithCaughtUp then
						appendTerminalPage()
					end
				end
			else
				if flag3 and v4 ~= nil then
					commitItems({})
					local momentIndex = findMomentIndex(data.initialMomentId)

					v6(momentIndex)
				else
					stripTrailingSkeleton() -- inferred equivalent call
				end

				v13 = true
				v8 = pagerStore.getCount(false) == 0 and "Empty" or "Loaded"
				local v31 = v8

				if FFlagMomentsParentTimeLimit and v13 then
					v31 = "LimitReached"
				elseif v4 ~= nil then
					if countRealItems(pagerStore.getItems(false)) > 0 then -- inferred equivalent call
						if v8 == "LoadingMore" then
							v31 = "LoadingMore"
						else
							v31 = "Loaded"
						end
					elseif v8 == "Loaded" then
						v31 = "Empty"
					end
				end

				v7(v31)

				if flag3 then
					Analytics.reportMomentsFeedState("failed", recommendationSource, "parentalTimeLimitReached")
				else
					Analytics.reportMomentsFeedLoadMore("failed", recommendationSource, "parentalTimeLimitReached")
				end

				if v29 then
					MomentsSurfaceLoadManager.abort("parentalTimeLimitReached")
				end

				p2.markLimitReached(v30.limitSeconds)
			end
		end)
	end

	local function prependItem(p3)
		local v21 = dedupeAndTrack({ p3 })

		if #v21 == 0 then
			return
		end

		pagerStore.addItemAt(1, v21[1])

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

		if FFlagMomentsParentTimeLimit and v14 ~= nil then
			v14()
		end

		if data.dispose then
			data.dispose()
		end

		pagerStore.dispose()
	end

	if FFlagMomentsParentTimeLimit and p2 ~= nil then
		local getIsLimitReached = p2.getIsLimitReached
		v14 = Signals.createEffect(function(p3)
			local isLimitReached = getIsLimitReached(p3)

			if isLimitReached == v13 then
				return
			end

			v13 = isLimitReached

			if isLimitReached then
				publishStatus() -- inferred equivalent call

				if flag and v15 == MomentsSurfaceLoadManager.getSessionGeneration() then
					MomentsSurfaceLoadManager.abort("parentalTimeLimitReached")
				end
			else
				runFetch(true)
			end
		end)
	end

	if v4 ~= nil and data.getPendingItems ~= nil then
		if data.initialMomentId ~= nil then
			v6(1e999)
		end

		local getPendingItems = data.getPendingItems
		v5 = Signals.createEffect(function(p3)
			local v21 = v4.update(getPendingItems(p3), GetDeletedMomentsStore(false).getDeletedIds(p3))
			local retainedItems = getRetainedItems() -- inferred equivalent call

			for i = #retainedItems, 1, -1 do
				if isTerminalPage(retainedItems[i]) then -- inferred equivalent call
					table.remove(retainedItems, i)
				end
			end

			SignalsExperimental.batch(function()
				commitItems(retainedItems)
				table.clear(v20)
				resolveInitialIndex(false) -- inferred equivalent call
				v18(false)
				appendTerminalPage()
				publishStatus() -- inferred equivalent call

				if v21 and data.recommendationSource == "Trending" then
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
