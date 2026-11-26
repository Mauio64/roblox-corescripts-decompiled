local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local SignalsExperimental = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsExperimental")
local fFlagMomentsOptimisticProfilePending = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagMomentsOptimisticProfilePending
local createPendingFeedOverlay = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/createPendingFeedOverlay")
local GetDeletedMomentsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetDeletedMomentsStore")
local fFlagMomentsParentTimeLimit = MomentsCommon.Flags.FFlagMomentsParentTimeLimit

local analytics = MomentsCommon.Analytics
local momentsSurfaceLoadManager = MomentsCommon.Performance.MomentsSurfaceLoadManager

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")
local createPagerStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/VerticalPager/createPagerStore")
local FFlagMomentsLoadMoreKeepsPosition = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsLoadMoreKeepsPosition")
local FFlagMomentsModeratedMomentPage = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsModeratedMomentPage")

local createSignal = Signals.createSignal

local v5 = { kind = "skeleton" }

local v6 = { kind = "endState" }

local v7 = { kind = "caughtUp" }

local function isTerminalPage(item): boolean
	return item.kind == "endState" or item.kind == "caughtUp"
end

local function isSentinel(p2): boolean
	return p2.kind == "skeleton" or p2.kind == "endState" or p2.kind == "caughtUp"
end

local function createFeedStore(data, callback, p2, p3, p4)
	local endsWithCaughtUp = data.endsWithCaughtUp == true
	local v8 = createPagerStore()
	local v9

	if fFlagMomentsOptimisticProfilePending and data.getPendingItems ~= nil then
		v9 = createPendingFeedOverlay()
	else
		v9 = nil
	end

	local v10 = nil

	local signal, v11 = createSignal(nil)

	local signal2, v12 = createSignal("Loading")
	local v13 = "Loading"

	local signal3, v14 = createSignal(nil)
	local signal4, v15 = createSignal(true)
	local signal5, v16 = createSignal(false)
	local recommendationSource = data.recommendationSource or "Unknown"

	local nextCursor = nil
	local v17 = false
	local flag = false
	local v18 = false
	local v19 = nil

	local v20 = nil

	local v21 = 0

	local count = 0

	local set = {}

	local v22 = p3
	local signal6, v23 = createSignal(false)

	local signal7, v24 = createSignal(false)

	local v26 = {}

	local function stripTrailingSkeleton()
		local items = v8.getItems(false)
		local item = items[#items]

		if item ~= nil and item.kind == "skeleton" then
			v8.removeItem(#items)
		end
	end

	local function dedupeAndTrack(items)
		if callback == nil then
			return items
		end

		local result = {}

		for k, item in items do
			local success, result2 = pcall(callback, item)

			if success then
				if result2 == nil or result2 == "" then
					table.insert(result, item)
				elseif set[result2] then
					analytics.reportMomentsFeedItemFiltered("duplicate", recommendationSource)
				else
					set[result2] = true
					table.insert(result, item)
				end
			else
				analytics.reportMomentsFeedItemFiltered("malformed", recommendationSource)
			end
		end

		return result
	end

	local function countRealItems(items)
		local count2 = 0

		for k, item in items do
			if item.kind ~= "skeleton" and item.kind ~= "endState" and item.kind ~= "caughtUp" then
				count2 += 1
			end
		end

		return count2
	end

	local function publishStatus()
		local v27 = v13

		if fFlagMomentsParentTimeLimit and v18 then
			v27 = "LimitReached"
		elseif v9 ~= nil then
			local items = v8.getItems(false)
			local count2 = 0

			for k, item in items do
				if item.kind ~= "skeleton" and item.kind ~= "endState" and item.kind ~= "caughtUp" then
					count2 += 1
				end
			end

			if count2 > 0 then
				v27 = v13 == "LoadingMore" and "LoadingMore" or "Loaded"
			else
				v27 = v13 == "Loaded" and "Empty" or v27
			end
		end

		v12(v27)
	end

	local function setStatus(p5)
		v13 = p5
		local v27 = v13

		if fFlagMomentsParentTimeLimit and v18 then
			v27 = "LimitReached"
		elseif v9 ~= nil then
			local items = v8.getItems(false)
			local count2 = 0

			for k, item in items do
				if item.kind ~= "skeleton" and item.kind ~= "endState" and item.kind ~= "caughtUp" then
					count2 += 1
				end
			end

			if count2 > 0 then
				v27 = v13 == "LoadingMore" and "LoadingMore" or "Loaded"
			else
				v27 = v13 == "Loaded" and "Empty" or v27
			end
		end

		v12(v27)
	end

	local function getRetainedItems()
		local clone = table.clone(v8.getItems(false))

		for k, v27 in v26 do
			table.insert(clone, v27)
		end

		return clone
	end

	local function maybeAppendEndState()
		if v22 == nil or signal6(false) then
			return
		end

		local items = v8.getItems(false)
		local count2 = 0

		for k, item in items do
			if item.kind ~= "skeleton" and item.kind ~= "endState" and item.kind ~= "caughtUp" then
				count2 += 1
			end
		end

		if count2 < v22 then
			return
		end

		local count3 = 0

		for k, item in items do
			if item.kind ~= "skeleton" and item.kind ~= "endState" and item.kind ~= "caughtUp" then
				count3 += 1
			end
		end

		if v22 < count3 then
			local count4 = 0
			local v27 = {}

			for k, item in items do
				if not (item.kind ~= "skeleton" and item.kind ~= "endState" and item.kind ~= "caughtUp") then
					continue
				end

				if count4 < v22 then
					count4 += 1
					table.insert(v27, item)
				else
					table.insert(v26, item)
				end
			end

			v8.setItems(v27)
		end

		assert(v24, "end-state fixes require the eligibility signal")(signal4(false) or #v26 > 0)

		v23(true)
		v8.addItems({ v6 })
	end

	local function appendTerminalPage()
		local items = v8.getItems(false)

		if not endsWithCaughtUp or signal4(false) or #v26 ~= 0 then
			maybeAppendEndState()
			return
		end

		if v22 ~= nil then
			local count2 = 0

			for k, item in items do
				if item.kind ~= "skeleton" and item.kind ~= "endState" and item.kind ~= "caughtUp" then
					count2 += 1
				end
			end

			if not (count2 <= v22) then
				maybeAppendEndState()
				return
			end
		end

		local item = items[#items]

		if
			item ~= nil
			and item.kind ~= "skeleton"
			and item.kind ~= "endState"
			and item.kind ~= "caughtUp"
		then
			v8.addItems({ v7 })
		end
	end

	local function commitItems(p5)
		if v9 == nil then
			v8.setItems(p5)
			return
		end

		local currentItem = v8.getCurrentItem(false)
		local v27 = if currentItem ~= nil then v9.identity(currentItem) else nil
		local retireMissing = v9.retireMissing
		local clone = table.clone(v8.getItems(false))

		for k, v28 in v26 do
			table.insert(clone, v28)
		end

		retireMissing(clone)
		local merged = v9.merge(p5)
		SignalsExperimental.batch(function()
			v8.setItems(merged)

			for k, v28 in merged do
				local identity = v9.identity(v28)

				if v27 ~= nil and identity == v27 then
					v8.goToItem(k)
				end
			end
		end)

		if callback ~= nil then
			for k, v28 in merged do
				if v28.kind ~= "moment" then
					continue
				end

				local v29 = callback(v28)

				if v29 ~= nil then
					set[v29] = true
				end
			end
		end
	end

	local function findMomentIndex(initialMomentId)
		if initialMomentId == nil then
			return nil
		end

		local v27 = assert(v9, "initial identity resolution requires the pending overlay")

		for k, v28 in v8.getItems(false) do
			if
				v28.kind == "moment"
				and (v27.identity(v28) == initialMomentId or v28.moment.momentId == initialMomentId)
				or v28.kind == "unavailableMoment" and v28.targetId == initialMomentId
			then
				return k
			end
		end

		return nil
	end

	local function resolveInitialIndex(p5)
		local momentIndex = findMomentIndex(data.initialMomentId)

		if momentIndex ~= nil or p5 then
			v11(momentIndex)
		end
	end

	local function runFetch(p5, p6)
		if flag or not (p5 or signal4(false)) or fFlagMomentsParentTimeLimit and v18 then
			return
		end

		count += 1
		local v27 = count
		v17 = true
		v16(false)

		local v28 = nil

		if p5 then
			analytics.reportMomentsFeedLoadAttempt(recommendationSource)

			v14(nil)
			commitItems({ v5 })

			if v9 ~= nil then
				local momentIndex = findMomentIndex(data.initialMomentId)

				if momentIndex ~= nil then
					v11(momentIndex)
				end
			end

			v13 = "Loading"
			local v29 = v13

			if fFlagMomentsParentTimeLimit and v18 then
				v29 = "LimitReached"
			elseif v9 ~= nil then
				local items = v8.getItems(false)
				local count2 = 0

				for k, item in items do
					if item.kind ~= "skeleton" and item.kind ~= "endState" and item.kind ~= "caughtUp" then
						count2 += 1
					end
				end

				if count2 > 0 then
					v29 = if v13 == "LoadingMore" then "LoadingMore" else "Loaded"
				elseif v13 == "Loaded" then
					v29 = "Empty"
				end
			end

			v12(v29)

			v22 = p3
			v23(false)
			assert(v24, "end-state fixes require the eligibility signal")(false)
			table.clear(v26)

			if p2 then
				momentsSurfaceLoadManager.start()
				momentsSurfaceLoadManager.primaryDataStarted()
				momentsSurfaceLoadManager.primaryDataNetworkFetch()
				v28 = momentsSurfaceLoadManager.getSessionGeneration()

				if fFlagMomentsParentTimeLimit then
					v20 = v28
				end
			end
		else
			analytics.reportMomentsFeedLoadMore("attempted", recommendationSource)

			if not (FFlagMomentsLoadMoreKeepsPosition and p6) then
				v8.addItems({ v5 })
			end

			v13 = "LoadingMore"
			local v29 = v13

			if fFlagMomentsParentTimeLimit and v18 then
				v29 = "LimitReached"
			elseif v9 ~= nil then
				local items = v8.getItems(false)
				local count2 = 0

				for k, item in items do
					if item.kind ~= "skeleton" and item.kind ~= "endState" and item.kind ~= "caughtUp" then
						count2 += 1
					end
				end

				if count2 > 0 then
					v29 = if v13 == "LoadingMore" then "LoadingMore" else "Loaded"
				elseif v13 == "Loaded" then
					v29 = "Empty"
				end
			end

			v12(v29)
		end

		local v29 = if not p5 then nextCursor else nil
		task.spawn(function()
			local success, result = pcall(data.fetchAsync, v29)

			if flag or v27 ~= count then
				return
			end

			v17 = false

			local v30 = p2 and p5

			if v30 then
				v30 = not (v28 == nil) and momentsSurfaceLoadManager.getSessionGeneration() == v28
			end

			if v30 then
				momentsSurfaceLoadManager.primaryDataResponseReceived()
			end

			local v31

			if fFlagMomentsParentTimeLimit and not success and p4 ~= nil then
				v31 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsParseMomentsLimitError")(result)
			end

			if v31 == nil then
				local v32

				if success and type(result) == "table" and type(result.items) == "table" then
					v32 = result
				end

				if v32 == nil then
					if p5 then
						if v9 == nil then
							v8.reset()
						else
							commitItems({})
							local momentIndex = findMomentIndex(data.initialMomentId)

							v11(momentIndex)
						end

						v14(success and "Malformed feed batch" or tostring(result))
						v13 = "Failed"
						local v33 = v13

						if fFlagMomentsParentTimeLimit and v18 then
							v33 = "LimitReached"
						elseif v9 ~= nil then
							local items = v8.getItems(false)
							local count2 = 0

							for k, item in items do
								if
									item.kind ~= "skeleton"
									and item.kind ~= "endState"
									and item.kind ~= "caughtUp"
								then
									count2 += 1
								end
							end

							if count2 > 0 then
								v33 = if v13 == "LoadingMore" then "LoadingMore" else "Loaded"
							elseif v13 == "Loaded" then
								v33 = "Empty"
							end
						end

						v12(v33)

						analytics.reportMomentsFeedState(
							"failed",
							recommendationSource,
							success and "malformedResponse" or "requestFailed"
						)

						if v30 then
							momentsSurfaceLoadManager.abort("failed")
						end
					else
						local items = v8.getItems(false)
						local item = items[#items]

						if item ~= nil and item.kind == "skeleton" then
							v8.removeItem(#items)
						end

						v16(true)
						v13 = v8.getCount(false) == 0 and "Empty" or "Loaded"
						local v33 = v13

						if fFlagMomentsParentTimeLimit and v18 then
							v33 = "LimitReached"
						elseif v9 ~= nil then
							local items2 = v8.getItems(false)
							local count2 = 0

							for k, item2 in items2 do
								if
									item2.kind ~= "skeleton"
									and item2.kind ~= "endState"
									and item2.kind ~= "caughtUp"
								then
									count2 += 1
								end
							end

							if count2 > 0 then
								v33 = if v13 == "LoadingMore" then "LoadingMore" else "Loaded"
							elseif v13 == "Loaded" then
								v33 = "Empty"
							end
						end

						v12(v33)

						analytics.reportMomentsFeedLoadMore(
							"failed",
							recommendationSource,
							success and "malformedResponse" or "requestFailed"
						)
					end
				else
					local v33

					if p5 then
						set = {}
						v33 = dedupeAndTrack(v32.items)
						commitItems(v33)

						if v9 ~= nil then
							local momentIndex = findMomentIndex(data.initialMomentId)

							v11(momentIndex)

							local momentIndex2 = findMomentIndex(v32.initialMomentId)

							if momentIndex2 ~= nil then
								v8.goToItem(momentIndex2)
							end
						end
					else
						v33 = dedupeAndTrack(v32.items)
						local clone = table.clone(v8.getItems(false))
						local v34 = clone[#clone]

						if v34 ~= nil and v34.kind == "skeleton" then
							table.remove(clone)
						end

						for k, v35 in v33 do
							table.insert(clone, v35)
						end

						commitItems(clone)
					end

					nextCursor = v32.nextCursor

					v21 = (p5 or #v33 ~= 0) and 0 or v21 + 1
					v15(v32.nextCursor ~= nil and v21 < 3)
					local v36 = v8.getCount(false) == 0 and "Empty" or "Loaded"
					v13 = v36
					local v37 = v13

					if fFlagMomentsParentTimeLimit and v18 then
						v37 = "LimitReached"
					elseif v9 ~= nil then
						local items = v8.getItems(false)
						local count2 = 0

						for k, item in items do
							if
								item.kind ~= "skeleton"
								and item.kind ~= "endState"
								and item.kind ~= "caughtUp"
							then
								count2 += 1
							end
						end

						if count2 > 0 then
							v37 = if v13 == "LoadingMore" then "LoadingMore" else "Loaded"
						elseif v13 == "Loaded" then
							v37 = "Empty"
						end
					end

					v12(v37)

					if p5 then
						analytics.reportMomentsFeedState(
							v36 == "Loaded" and "loaded" or "empty",
							recommendationSource,
							nil
						)
					end

					if v30 then
						local currentItem = v8.getCurrentItem(false)

						if FFlagMomentsModeratedMomentPage and currentItem ~= nil and currentItem.kind == "unavailableMoment" then
							momentsSurfaceLoadManager.abort("unavailable")
						elseif v36 == "Loaded" then
							momentsSurfaceLoadManager.primaryDataReady()
						else
							momentsSurfaceLoadManager.abort("empty")
						end
					end

					if v32.onAccepted ~= nil then
						v32.onAccepted()
					end

					if p3 ~= nil or endsWithCaughtUp then
						appendTerminalPage()
					end
				end
			else
				if p5 and v9 ~= nil then
					commitItems({})
					local momentIndex = findMomentIndex(data.initialMomentId)

					v11(momentIndex)
				else
					local items = v8.getItems(false)
					local item = items[#items]

					if item ~= nil and item.kind == "skeleton" then
						v8.removeItem(#items)
					end
				end

				v18 = true
				v13 = v8.getCount(false) == 0 and "Empty" or "Loaded"
				local v32 = v13

				if fFlagMomentsParentTimeLimit and v18 then
					v32 = "LimitReached"
				elseif v9 ~= nil then
					local items = v8.getItems(false)
					local count2 = 0

					for k, item in items do
						if
							item.kind ~= "skeleton"
							and item.kind ~= "endState"
							and item.kind ~= "caughtUp"
						then
							count2 += 1
						end
					end

					if count2 > 0 then
						v32 = if v13 == "LoadingMore" then "LoadingMore" else "Loaded"
					elseif v13 == "Loaded" then
						v32 = "Empty"
					end
				end

				v12(v32)

				if p5 then
					analytics.reportMomentsFeedState(
						"failed",
						recommendationSource,
						"parentalTimeLimitReached"
					)
				else
					analytics.reportMomentsFeedLoadMore(
						"failed",
						recommendationSource,
						"parentalTimeLimitReached"
					)
				end

				if v30 then
					momentsSurfaceLoadManager.abort("parentalTimeLimitReached")
				end

				p4.markLimitReached(v31.limitSeconds)
			end
		end)
	end

	local function loadInitial()
		runFetch(true)
	end

	local function loadMore()
		if
			v9 ~= nil and (count == 0 or signal3(false) ~= nil)
			or p3 ~= nil and signal6(false)
			or (v17 or signal5(false))
		then
			return
		end

		if flag or not signal4(false) or fFlagMomentsParentTimeLimit and v18 then
			return
		end

		count += 1
		local v27 = count
		v17 = true
		v16(false)

		local v28 = nil

		analytics.reportMomentsFeedLoadMore("attempted", recommendationSource)

		v8.addItems({ v5 })
		v13 = "LoadingMore"
		local v29 = v13

		if fFlagMomentsParentTimeLimit and v18 then
			v29 = "LimitReached"
		elseif v9 ~= nil then
			local items = v8.getItems(false)
			local count2 = 0

			for k, item in items do
				if item.kind == "skeleton" or isTerminalPage(item) then
					continue
				end

				count2 += 1
			end

			if count2 > 0 then
				v29 = if v13 == "LoadingMore" then "LoadingMore" else "Loaded"
			elseif v13 == "Loaded" then
				v29 = "Empty"
			end
		end

		v12(v29)

		local v30 = nextCursor

		local flag2 = false
		task.spawn(function()
			local success, result = pcall(data.fetchAsync, v30)

			if flag or v27 ~= count then
				return
			end

			v17 = false

			local v31 = p2 and flag2

			if v31 then
				v31 = not (v28 == nil) and momentsSurfaceLoadManager.getSessionGeneration() == v28
			end

			if v31 then
				momentsSurfaceLoadManager.primaryDataResponseReceived()
			end

			local v32

			if fFlagMomentsParentTimeLimit and not success and p4 ~= nil then
				v32 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsParseMomentsLimitError")(result)
			end

			if v32 == nil then
				local v33

				if success and type(result) == "table" and type(result.items) == "table" then
					v33 = result
				end

				if v33 == nil then
					if flag2 then
						if v9 == nil then
							v8.reset()
						else
							commitItems({})
							local momentIndex = findMomentIndex(data.initialMomentId)

							v11(momentIndex)
						end

						v14(success and "Malformed feed batch" or tostring(result))
						v13 = "Failed"
						local v34 = v13

						if fFlagMomentsParentTimeLimit and v18 then
							v34 = "LimitReached"
						elseif v9 ~= nil then
							local items = v8.getItems(false)
							local count2 = 0

							for k, item in items do
								if
									item.kind ~= "skeleton"
									and item.kind ~= "endState"
									and item.kind ~= "caughtUp"
								then
									count2 += 1
								end
							end

							if count2 > 0 then
								v34 = if v13 == "LoadingMore" then "LoadingMore" else "Loaded"
							elseif v13 == "Loaded" then
								v34 = "Empty"
							end
						end

						v12(v34)

						analytics.reportMomentsFeedState(
							"failed",
							recommendationSource,
							success and "malformedResponse" or "requestFailed"
						)

						if v31 then
							momentsSurfaceLoadManager.abort("failed")
						end
					else
						local items = v8.getItems(false)
						local item = items[#items]

						if item ~= nil and item.kind == "skeleton" then
							v8.removeItem(#items)
						end

						v16(true)
						v13 = v8.getCount(false) == 0 and "Empty" or "Loaded"
						local v34 = v13

						if fFlagMomentsParentTimeLimit and v18 then
							v34 = "LimitReached"
						elseif v9 ~= nil then
							local items2 = v8.getItems(false)
							local count2 = 0

							for k, item2 in items2 do
								if
									item2.kind ~= "skeleton"
									and item2.kind ~= "endState"
									and item2.kind ~= "caughtUp"
								then
									count2 += 1
								end
							end

							if count2 > 0 then
								v34 = if v13 == "LoadingMore" then "LoadingMore" else "Loaded"
							elseif v13 == "Loaded" then
								v34 = "Empty"
							end
						end

						v12(v34)

						analytics.reportMomentsFeedLoadMore(
							"failed",
							recommendationSource,
							success and "malformedResponse" or "requestFailed"
						)
					end
				else
					local v34

					if flag2 then
						set = {}
						v34 = dedupeAndTrack(v33.items)
						commitItems(v34)

						if v9 ~= nil then
							local momentIndex = findMomentIndex(data.initialMomentId)

							v11(momentIndex)

							local momentIndex2 = findMomentIndex(v33.initialMomentId)

							if momentIndex2 ~= nil then
								v8.goToItem(momentIndex2)
							end
						end
					else
						v34 = dedupeAndTrack(v33.items)
						local clone = table.clone(v8.getItems(false))
						local v35 = clone[#clone]

						if v35 ~= nil and v35.kind == "skeleton" then
							table.remove(clone)
						end

						for k, v36 in v34 do
							table.insert(clone, v36)
						end

						commitItems(clone)
					end

					nextCursor = v33.nextCursor

					v21 = (flag2 or #v34 ~= 0) and 0 or v21 + 1
					v15(v33.nextCursor ~= nil and v21 < 3)
					local v37 = v8.getCount(false) == 0 and "Empty" or "Loaded"
					v13 = v37
					local v38 = v13

					if fFlagMomentsParentTimeLimit and v18 then
						v38 = "LimitReached"
					elseif v9 ~= nil then
						local items = v8.getItems(false)
						local count2 = 0

						for k, item in items do
							if
								item.kind ~= "skeleton"
								and item.kind ~= "endState"
								and item.kind ~= "caughtUp"
							then
								count2 += 1
							end
						end

						if count2 > 0 then
							v38 = if v13 == "LoadingMore" then "LoadingMore" else "Loaded"
						elseif v13 == "Loaded" then
							v38 = "Empty"
						end
					end

					v12(v38)

					if flag2 then
						analytics.reportMomentsFeedState(
							v37 == "Loaded" and "loaded" or "empty",
							recommendationSource,
							nil
						)
					end

					if v31 then
						local currentItem = v8.getCurrentItem(false)

						if FFlagMomentsModeratedMomentPage and currentItem ~= nil and currentItem.kind == "unavailableMoment" then
							momentsSurfaceLoadManager.abort("unavailable")
						elseif v37 == "Loaded" then
							momentsSurfaceLoadManager.primaryDataReady()
						else
							momentsSurfaceLoadManager.abort("empty")
						end
					end

					if v33.onAccepted ~= nil then
						v33.onAccepted()
					end

					if p3 ~= nil or endsWithCaughtUp then
						appendTerminalPage()
					end
				end
			else
				if flag2 and v9 ~= nil then
					commitItems({})
					local momentIndex = findMomentIndex(data.initialMomentId)

					v11(momentIndex)
				else
					local items = v8.getItems(false)
					local item = items[#items]

					if item ~= nil and item.kind == "skeleton" then
						v8.removeItem(#items)
					end
				end

				v18 = true
				v13 = v8.getCount(false) == 0 and "Empty" or "Loaded"
				local v33 = v13

				if fFlagMomentsParentTimeLimit and v18 then
					v33 = "LimitReached"
				elseif v9 ~= nil then
					local items = v8.getItems(false)
					local count2 = 0

					for k, item in items do
						if
							item.kind ~= "skeleton"
							and item.kind ~= "endState"
							and item.kind ~= "caughtUp"
						then
							count2 += 1
						end
					end

					if count2 > 0 then
						v33 = if v13 == "LoadingMore" then "LoadingMore" else "Loaded"
					elseif v13 == "Loaded" then
						v33 = "Empty"
					end
				end

				v12(v33)

				if flag2 then
					analytics.reportMomentsFeedState(
						"failed",
						recommendationSource,
						"parentalTimeLimitReached"
					)
				else
					analytics.reportMomentsFeedLoadMore(
						"failed",
						recommendationSource,
						"parentalTimeLimitReached"
					)
				end

				if v31 then
					momentsSurfaceLoadManager.abort("parentalTimeLimitReached")
				end

				p4.markLimitReached(v32.limitSeconds)
			end
		end)
	end

	local function loadBeyondLimit()
		if flag or p3 == nil or not signal6(false) or not signal4(false) and #v26 == 0 then
			return
		end

		local items = v8.getItems(false)
		local clone = table.clone(items)
		local v27 = clone[#clone]
		local v28 = not (v27 == nil) and v27.kind == "endState"

		if v28 then
			table.remove(clone)
		end

		if FFlagMomentsLoadMoreKeepsPosition and v28 then
			v8.goToItem(#items)
		end

		if not FFlagMomentsLoadMoreKeepsPosition and v28 then
			v8.removeItem(#items)
		end

		local v29

		if FFlagMomentsLoadMoreKeepsPosition then
			local count2 = 0

			for k, v30 in clone do
				if v30.kind ~= "skeleton" and v30.kind ~= "endState" and v30.kind ~= "caughtUp" then
					count2 += 1
				end
			end

			v29 = count2 + p3
		else
			local items2 = v8.getItems(false)
			local count2 = 0

			for k, item in items2 do
				if item.kind ~= "skeleton" and item.kind ~= "endState" and item.kind ~= "caughtUp" then
					count2 += 1
				end
			end

			v29 = count2 + p3
		end

		v22 = v29

		v23(false)
		local v30 = false

		if #v26 > 0 then
			if not FFlagMomentsLoadMoreKeepsPosition then
				clone = table.clone(v8.getItems(false))
			end

			for k, v31 in v26 do
				table.insert(clone, v31)
			end

			table.clear(v26)
			v8.setItems(clone)

			appendTerminalPage()

			if signal6(false) then
				return
			end
		elseif FFlagMomentsLoadMoreKeepsPosition then
			table.insert(clone, v5)
			v8.setItems(clone)
			v30 = true
		end

		if not FFlagMomentsLoadMoreKeepsPosition then
			v30 = nil
		end

		if flag or not signal4(false) or fFlagMomentsParentTimeLimit and v18 then
			return
		end

		count += 1
		local v31 = count
		v17 = true
		v16(false)

		local v32 = nil

		analytics.reportMomentsFeedLoadMore("attempted", recommendationSource)

		if not (FFlagMomentsLoadMoreKeepsPosition and v30) then
			v8.addItems({ v5 })
		end

		v13 = "LoadingMore"
		local v33 = v13

		if fFlagMomentsParentTimeLimit and v18 then
			v33 = "LimitReached"
		elseif v9 ~= nil then
			local items2 = v8.getItems(false)
			local count2 = 0

			for k, item in items2 do
				if item.kind == "skeleton" or isTerminalPage(item) then
					continue
				end

				count2 += 1
			end

			if count2 > 0 then
				v33 = if v13 == "LoadingMore" then "LoadingMore" else "Loaded"
			elseif v13 == "Loaded" then
				v33 = "Empty"
			end
		end

		v12(v33)

		local v34 = nextCursor

		local flag2 = false
		task.spawn(function()
			local success, result = pcall(data.fetchAsync, v34)

			if flag or v31 ~= count then
				return
			end

			v17 = false

			local v35 = p2 and flag2

			if v35 then
				v35 = not (v32 == nil) and momentsSurfaceLoadManager.getSessionGeneration() == v32
			end

			if v35 then
				momentsSurfaceLoadManager.primaryDataResponseReceived()
			end

			local v36

			if fFlagMomentsParentTimeLimit and not success and p4 ~= nil then
				v36 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsParseMomentsLimitError")(result)
			end

			if v36 == nil then
				local v37

				if success and type(result) == "table" and type(result.items) == "table" then
					v37 = result
				end

				if v37 == nil then
					if flag2 then
						if v9 == nil then
							v8.reset()
						else
							commitItems({})
							local momentIndex = findMomentIndex(data.initialMomentId)

							v11(momentIndex)
						end

						v14(success and "Malformed feed batch" or tostring(result))
						v13 = "Failed"
						local v38 = v13

						if fFlagMomentsParentTimeLimit and v18 then
							v38 = "LimitReached"
						elseif v9 ~= nil then
							local items2 = v8.getItems(false)
							local count2 = 0

							for k, item in items2 do
								if
									item.kind ~= "skeleton"
									and item.kind ~= "endState"
									and item.kind ~= "caughtUp"
								then
									count2 += 1
								end
							end

							if count2 > 0 then
								v38 = if v13 == "LoadingMore" then "LoadingMore" else "Loaded"
							elseif v13 == "Loaded" then
								v38 = "Empty"
							end
						end

						v12(v38)

						analytics.reportMomentsFeedState(
							"failed",
							recommendationSource,
							success and "malformedResponse" or "requestFailed"
						)

						if v35 then
							momentsSurfaceLoadManager.abort("failed")
						end
					else
						local items2 = v8.getItems(false)
						local item = items2[#items2]

						if item ~= nil and item.kind == "skeleton" then
							v8.removeItem(#items2)
						end

						v16(true)
						v13 = v8.getCount(false) == 0 and "Empty" or "Loaded"
						local v38 = v13

						if fFlagMomentsParentTimeLimit and v18 then
							v38 = "LimitReached"
						elseif v9 ~= nil then
							local items3 = v8.getItems(false)
							local count2 = 0

							for k, item2 in items3 do
								if
									item2.kind ~= "skeleton"
									and item2.kind ~= "endState"
									and item2.kind ~= "caughtUp"
								then
									count2 += 1
								end
							end

							if count2 > 0 then
								v38 = if v13 == "LoadingMore" then "LoadingMore" else "Loaded"
							elseif v13 == "Loaded" then
								v38 = "Empty"
							end
						end

						v12(v38)

						analytics.reportMomentsFeedLoadMore(
							"failed",
							recommendationSource,
							success and "malformedResponse" or "requestFailed"
						)
					end
				else
					local v38

					if flag2 then
						set = {}
						v38 = dedupeAndTrack(v37.items)
						commitItems(v38)

						if v9 ~= nil then
							local momentIndex = findMomentIndex(data.initialMomentId)

							v11(momentIndex)

							local momentIndex2 = findMomentIndex(v37.initialMomentId)

							if momentIndex2 ~= nil then
								v8.goToItem(momentIndex2)
							end
						end
					else
						v38 = dedupeAndTrack(v37.items)
						local clone2 = table.clone(v8.getItems(false))
						local v39 = clone2[#clone2]

						if v39 ~= nil and v39.kind == "skeleton" then
							table.remove(clone2)
						end

						for k, v40 in v38 do
							table.insert(clone2, v40)
						end

						commitItems(clone2)
					end

					nextCursor = v37.nextCursor

					v21 = (flag2 or #v38 ~= 0) and 0 or v21 + 1
					v15(v37.nextCursor ~= nil and v21 < 3)
					local v41 = v8.getCount(false) == 0 and "Empty" or "Loaded"
					v13 = v41
					local v42 = v13

					if fFlagMomentsParentTimeLimit and v18 then
						v42 = "LimitReached"
					elseif v9 ~= nil then
						local items2 = v8.getItems(false)
						local count2 = 0

						for k, item in items2 do
							if
								item.kind ~= "skeleton"
								and item.kind ~= "endState"
								and item.kind ~= "caughtUp"
							then
								count2 += 1
							end
						end

						if count2 > 0 then
							v42 = if v13 == "LoadingMore" then "LoadingMore" else "Loaded"
						elseif v13 == "Loaded" then
							v42 = "Empty"
						end
					end

					v12(v42)

					if flag2 then
						analytics.reportMomentsFeedState(
							v41 == "Loaded" and "loaded" or "empty",
							recommendationSource,
							nil
						)
					end

					if v35 then
						local currentItem = v8.getCurrentItem(false)

						if FFlagMomentsModeratedMomentPage and currentItem ~= nil and currentItem.kind == "unavailableMoment" then
							momentsSurfaceLoadManager.abort("unavailable")
						elseif v41 == "Loaded" then
							momentsSurfaceLoadManager.primaryDataReady()
						else
							momentsSurfaceLoadManager.abort("empty")
						end
					end

					if v37.onAccepted ~= nil then
						v37.onAccepted()
					end

					if p3 ~= nil or endsWithCaughtUp then
						appendTerminalPage()
					end
				end
			else
				if flag2 and v9 ~= nil then
					commitItems({})
					local momentIndex = findMomentIndex(data.initialMomentId)

					v11(momentIndex)
				else
					local items2 = v8.getItems(false)
					local item = items2[#items2]

					if item ~= nil and item.kind == "skeleton" then
						v8.removeItem(#items2)
					end
				end

				v18 = true
				v13 = v8.getCount(false) == 0 and "Empty" or "Loaded"
				local v37 = v13

				if fFlagMomentsParentTimeLimit and v18 then
					v37 = "LimitReached"
				elseif v9 ~= nil then
					local items2 = v8.getItems(false)
					local count2 = 0

					for k, item in items2 do
						if
							item.kind ~= "skeleton"
							and item.kind ~= "endState"
							and item.kind ~= "caughtUp"
						then
							count2 += 1
						end
					end

					if count2 > 0 then
						v37 = if v13 == "LoadingMore" then "LoadingMore" else "Loaded"
					elseif v13 == "Loaded" then
						v37 = "Empty"
					end
				end

				v12(v37)

				if flag2 then
					analytics.reportMomentsFeedState(
						"failed",
						recommendationSource,
						"parentalTimeLimitReached"
					)
				else
					analytics.reportMomentsFeedLoadMore(
						"failed",
						recommendationSource,
						"parentalTimeLimitReached"
					)
				end

				if v35 then
					momentsSurfaceLoadManager.abort("parentalTimeLimitReached")
				end

				p4.markLimitReached(v36.limitSeconds)
			end
		end)
	end

	local function prependItem(p5)
		local v27 = dedupeAndTrack({ p5 })

		if #v27 == 0 then
			return
		end

		v8.addItemAt(1, v27[1])

		if signal2(false) == "Empty" then
			v13 = "Loaded"
			local v28 = v13

			if fFlagMomentsParentTimeLimit and v18 then
				v28 = "LimitReached"
			elseif v9 ~= nil then
				local items = v8.getItems(false)
				local count2 = 0

				for k, item in items do
					if item.kind ~= "skeleton" and item.kind ~= "endState" and item.kind ~= "caughtUp" then
						count2 += 1
					end
				end

				if count2 > 0 then
					v28 = v13 == "LoadingMore" and "LoadingMore" or "Loaded"
				else
					v28 = v13 == "Loaded" and "Empty" or v28
				end
			end

			v12(v28)
		end
	end

	local function retry()
		if v9 == nil or signal3(false) == nil then
			runFetch(v8.getCount(false) == 0)
		else
			runFetch(true)
		end
	end

	local function dispose()
		flag = true

		if v10 ~= nil then
			v10()
		end

		if fFlagMomentsParentTimeLimit and v19 ~= nil then
			v19()
		end

		if data.dispose then
			data.dispose()
		end

		v8.dispose()
	end

	if fFlagMomentsParentTimeLimit and p4 ~= nil then
		local getIsLimitReached = p4.getIsLimitReached
		v19 = Signals.createEffect(function(p5)
			local isLimitReached = getIsLimitReached(p5)

			if isLimitReached == v18 then
				return
			end

			v18 = isLimitReached

			if isLimitReached then
				local v27 = v13

				if fFlagMomentsParentTimeLimit and v18 then
					v27 = "LimitReached"
				elseif v9 ~= nil then
					local items = v8.getItems(false)
					local count2 = 0

					for k, item in items do
						if
							item.kind ~= "skeleton"
							and item.kind ~= "endState"
							and item.kind ~= "caughtUp"
						then
							count2 += 1
						end
					end

					if count2 > 0 then
						v27 = v13 == "LoadingMore" and "LoadingMore" or "Loaded"
					else
						v27 = v13 == "Loaded" and "Empty" or v27
					end
				end

				v12(v27)

				if p2 and v20 == momentsSurfaceLoadManager.getSessionGeneration() then
					momentsSurfaceLoadManager.abort("parentalTimeLimitReached")
				end
			else
				runFetch(true)
			end
		end)
	end

	if v9 ~= nil and data.getPendingItems ~= nil then
		if data.initialMomentId ~= nil then
			v11(1e999)
		end

		local getPendingItems = data.getPendingItems
		v10 = Signals.createEffect(function(p5)
			local v27 = v9.update(getPendingItems(p5), GetDeletedMomentsStore(false).getDeletedIds(p5))
			local clone = table.clone(v8.getItems(false))

			for k, v28 in v26 do
				table.insert(clone, v28)
			end

			for i = #clone, 1, -1 do
				local v28 = clone[i]

				if v28.kind == "endState" or v28.kind == "caughtUp" then
					table.remove(clone, i)
				end
			end

			SignalsExperimental.batch(function()
				commitItems(clone)
				table.clear(v26)
				local momentIndex = findMomentIndex(data.initialMomentId)

				if momentIndex ~= nil then
					v11(momentIndex)
				end

				v23(false)
				appendTerminalPage()
				local v28 = v13

				if fFlagMomentsParentTimeLimit and v18 then
					v28 = "LimitReached"
				elseif v9 ~= nil then
					local items = v8.getItems(false)
					local count2 = 0

					for k, item in items do
						if
							item.kind ~= "skeleton"
							and item.kind ~= "endState"
							and item.kind ~= "caughtUp"
						then
							count2 += 1
						end
					end

					if count2 > 0 then
						v28 = v13 == "LoadingMore" and "LoadingMore" or "Loaded"
					else
						v28 = v13 == "Loaded" and "Empty" or v28
					end
				end

				v12(v28)

				if v27 and data.recommendationSource == "Trending" then
					v8.goToItem(1)
				end
			end)
		end)
	end

	return {
		getInitialIndex = signal,
		observabilityFeedType = recommendationSource,
		pager = v8,
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
