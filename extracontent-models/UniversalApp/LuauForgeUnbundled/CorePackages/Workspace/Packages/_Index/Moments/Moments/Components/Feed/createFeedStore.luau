local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local SignalsExperimental = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsExperimental")
local fFlagMomentsOptimisticProfilePending = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagMomentsOptimisticProfilePending
local createPendingFeedOverlay = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/createPendingFeedOverlay")
local GetDeletedMomentsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetDeletedMomentsStore")

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

local function createFeedStore(data, callback, p2, p3)
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

	local v18 = 0

	local count = 0

	local set = {}

	local v19 = p3
	local signal6, v20 = createSignal(false)

	local signal7, v21 = createSignal(false)

	local v23 = {}

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
		local v24 = v13

		if v9 ~= nil then
			local items = v8.getItems(false)
			local count2 = 0

			for k, item in items do
				if item.kind ~= "skeleton" and item.kind ~= "endState" and item.kind ~= "caughtUp" then
					count2 += 1
				end
			end

			if count2 > 0 then
				v24 = v13 == "LoadingMore" and "LoadingMore" or "Loaded"
			else
				v24 = v13 == "Loaded" and "Empty" or v24
			end
		end

		v12(v24)
	end

	local function setStatus(p4)
		v13 = p4
		local v24 = v13

		if v9 ~= nil then
			local items = v8.getItems(false)
			local count2 = 0

			for k, item in items do
				if item.kind ~= "skeleton" and item.kind ~= "endState" and item.kind ~= "caughtUp" then
					count2 += 1
				end
			end

			if count2 > 0 then
				v24 = v13 == "LoadingMore" and "LoadingMore" or "Loaded"
			else
				v24 = v13 == "Loaded" and "Empty" or v24
			end
		end

		v12(v24)
	end

	local function getRetainedItems()
		local clone = table.clone(v8.getItems(false))

		for k, v24 in v23 do
			table.insert(clone, v24)
		end

		return clone
	end

	local function maybeAppendEndState()
		if v19 == nil or signal6(false) then
			return
		end

		local items = v8.getItems(false)
		local count2 = 0

		for k, item in items do
			if item.kind ~= "skeleton" and item.kind ~= "endState" and item.kind ~= "caughtUp" then
				count2 += 1
			end
		end

		if count2 < v19 then
			return
		end

		local count3 = 0

		for k, item in items do
			if item.kind ~= "skeleton" and item.kind ~= "endState" and item.kind ~= "caughtUp" then
				count3 += 1
			end
		end

		if v19 < count3 then
			local count4 = 0
			local v24 = {}

			for k, item in items do
				if not (item.kind ~= "skeleton" and item.kind ~= "endState" and item.kind ~= "caughtUp") then
					continue
				end

				if count4 < v19 then
					count4 += 1
					table.insert(v24, item)
				else
					table.insert(v23, item)
				end
			end

			v8.setItems(v24)
		end

		assert(v21, "end-state fixes require the eligibility signal")(signal4(false) or #v23 > 0)

		v20(true)
		v8.addItems({ v6 })
	end

	local function appendTerminalPage()
		local items = v8.getItems(false)

		if not endsWithCaughtUp or signal4(false) or #v23 ~= 0 then
			maybeAppendEndState()
			return
		end

		if v19 ~= nil then
			local count2 = 0

			for k, item in items do
				if item.kind ~= "skeleton" and item.kind ~= "endState" and item.kind ~= "caughtUp" then
					count2 += 1
				end
			end

			if not (count2 <= v19) then
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

	local function commitItems(p4)
		if v9 == nil then
			v8.setItems(p4)
			return
		end

		local currentItem = v8.getCurrentItem(false)
		local v24 = if currentItem ~= nil then v9.identity(currentItem) else nil
		local retireMissing = v9.retireMissing
		local clone = table.clone(v8.getItems(false))

		for k, v25 in v23 do
			table.insert(clone, v25)
		end

		retireMissing(clone)
		local merged = v9.merge(p4)
		SignalsExperimental.batch(function()
			v8.setItems(merged)

			for k, v25 in merged do
				local identity = v9.identity(v25)

				if v24 ~= nil and identity == v24 then
					v8.goToItem(k)
				end
			end
		end)

		if callback ~= nil then
			for k, v25 in merged do
				if v25.kind ~= "moment" then
					continue
				end

				local v26 = callback(v25)

				if v26 ~= nil then
					set[v26] = true
				end
			end
		end
	end

	local function findMomentIndex(initialMomentId)
		if initialMomentId == nil then
			return nil
		end

		local v24 = assert(v9, "initial identity resolution requires the pending overlay")

		for k, v25 in v8.getItems(false) do
			if
				v25.kind == "moment"
				and (v24.identity(v25) == initialMomentId or v25.moment.momentId == initialMomentId)
				or v25.kind == "unavailableMoment" and v25.targetId == initialMomentId
			then
				return k
			end
		end

		return nil
	end

	local function resolveInitialIndex(p4)
		local momentIndex = findMomentIndex(data.initialMomentId)

		if momentIndex ~= nil or p4 then
			v11(momentIndex)
		end
	end

	local function runFetch(p4, p5)
		if flag or not (p4 or signal4(false)) then
			return
		end

		count += 1
		local v24 = count
		v17 = true
		v16(false)

		local v25 = nil

		if p4 then
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
			local v26 = v13

			if v9 ~= nil then
				local items = v8.getItems(false)
				local count2 = 0

				for k, item in items do
					if item.kind ~= "skeleton" and item.kind ~= "endState" and item.kind ~= "caughtUp" then
						count2 += 1
					end
				end

				if count2 > 0 then
					v26 = if v13 == "LoadingMore" then "LoadingMore" else "Loaded"
				elseif v13 == "Loaded" then
					v26 = "Empty"
				end
			end

			v12(v26)

			v19 = p3
			v20(false)
			assert(v21, "end-state fixes require the eligibility signal")(false)
			table.clear(v23)

			if p2 then
				momentsSurfaceLoadManager.start()
				momentsSurfaceLoadManager.primaryDataStarted()
				momentsSurfaceLoadManager.primaryDataNetworkFetch()
				v25 = momentsSurfaceLoadManager.getSessionGeneration()
			end
		else
			analytics.reportMomentsFeedLoadMore("attempted", recommendationSource)

			if not (FFlagMomentsLoadMoreKeepsPosition and p5) then
				v8.addItems({ v5 })
			end

			v13 = "LoadingMore"
			local v26 = v13

			if v9 ~= nil then
				local items = v8.getItems(false)
				local count2 = 0

				for k, item in items do
					if item.kind ~= "skeleton" and item.kind ~= "endState" and item.kind ~= "caughtUp" then
						count2 += 1
					end
				end

				if count2 > 0 then
					v26 = if v13 == "LoadingMore" then "LoadingMore" else "Loaded"
				elseif v13 == "Loaded" then
					v26 = "Empty"
				end
			end

			v12(v26)
		end

		local v26 = if not p4 then nextCursor else nil
		task.spawn(function()
			local success, result = pcall(data.fetchAsync, v26)

			if flag or v24 ~= count then
				return
			end

			v17 = false

			local v27 = p2 and p4

			if v27 then
				v27 = not (v25 == nil) and momentsSurfaceLoadManager.getSessionGeneration() == v25
			end

			if v27 then
				momentsSurfaceLoadManager.primaryDataResponseReceived()
			end

			local v28

			if success and type(result) == "table" and type(result.items) == "table" then
				v28 = result
			end

			if v28 == nil then
				if p4 then
					if v9 == nil then
						v8.reset()
					else
						commitItems({})
						local momentIndex = findMomentIndex(data.initialMomentId)

						v11(momentIndex)
					end

					v14(success and "Malformed feed batch" or tostring(result))
					v13 = "Failed"
					local v29 = v13

					if v9 ~= nil then
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
							v29 = if v13 == "LoadingMore" then "LoadingMore" else "Loaded"
						elseif v13 == "Loaded" then
							v29 = "Empty"
						end
					end

					v12(v29)

					analytics.reportMomentsFeedState(
						"failed",
						recommendationSource,
						success and "malformedResponse" or "requestFailed"
					)

					if v27 then
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
					local v29 = v13

					if v9 ~= nil then
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
							v29 = if v13 == "LoadingMore" then "LoadingMore" else "Loaded"
						elseif v13 == "Loaded" then
							v29 = "Empty"
						end
					end

					v12(v29)

					analytics.reportMomentsFeedLoadMore(
						"failed",
						recommendationSource,
						success and "malformedResponse" or "requestFailed"
					)
				end
			else
				local v29

				if p4 then
					set = {}
					v29 = dedupeAndTrack(v28.items)
					commitItems(v29)

					if v9 ~= nil then
						local momentIndex = findMomentIndex(data.initialMomentId)

						v11(momentIndex)

						local momentIndex2 = findMomentIndex(v28.initialMomentId)

						if momentIndex2 ~= nil then
							v8.goToItem(momentIndex2)
						end
					end
				else
					v29 = dedupeAndTrack(v28.items)
					local clone = table.clone(v8.getItems(false))
					local v30 = clone[#clone]

					if v30 ~= nil and v30.kind == "skeleton" then
						table.remove(clone)
					end

					for k, v31 in v29 do
						table.insert(clone, v31)
					end

					commitItems(clone)
				end

				nextCursor = v28.nextCursor

				v18 = (p4 or #v29 ~= 0) and 0 or v18 + 1
				v15(v28.nextCursor ~= nil and v18 < 3)
				local v32 = v8.getCount(false) == 0 and "Empty" or "Loaded"
				v13 = v32
				local v33 = v13

				if v9 ~= nil then
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

				if p4 then
					analytics.reportMomentsFeedState(
						v32 == "Loaded" and "loaded" or "empty",
						recommendationSource,
						nil
					)
				end

				if v27 then
					local currentItem = v8.getCurrentItem(false)

					if FFlagMomentsModeratedMomentPage and currentItem ~= nil and currentItem.kind == "unavailableMoment" then
						momentsSurfaceLoadManager.abort("unavailable")
					elseif v32 == "Loaded" then
						momentsSurfaceLoadManager.primaryDataReady()
					else
						momentsSurfaceLoadManager.abort("empty")
					end
				end

				if v28.onAccepted ~= nil then
					v28.onAccepted()
				end

				if p3 ~= nil or endsWithCaughtUp then
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
			v9 ~= nil and (count == 0 or signal3(false) ~= nil)
			or p3 ~= nil and signal6(false)
			or (v17 or signal5(false))
		then
			return
		end

		if flag or not signal4(false) then
			return
		end

		count += 1
		local v24 = count
		v17 = true
		v16(false)

		local v25 = nil

		analytics.reportMomentsFeedLoadMore("attempted", recommendationSource)

		v8.addItems({ v5 })
		v13 = "LoadingMore"
		local v26 = v13

		if v9 ~= nil then
			local items = v8.getItems(false)
			local count2 = 0

			for k, item in items do
				if item.kind == "skeleton" or isTerminalPage(item) then
					continue
				end

				count2 += 1
			end

			if count2 > 0 then
				v26 = if v13 == "LoadingMore" then "LoadingMore" else "Loaded"
			elseif v13 == "Loaded" then
				v26 = "Empty"
			end
		end

		v12(v26)

		local v27 = nextCursor

		local flag2 = false
		task.spawn(function()
			local success, result = pcall(data.fetchAsync, v27)

			if flag or v24 ~= count then
				return
			end

			v17 = false

			local v28 = p2 and flag2

			if v28 then
				v28 = not (v25 == nil) and momentsSurfaceLoadManager.getSessionGeneration() == v25
			end

			if v28 then
				momentsSurfaceLoadManager.primaryDataResponseReceived()
			end

			local v29

			if success and type(result) == "table" and type(result.items) == "table" then
				v29 = result
			end

			if v29 == nil then
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
					local v30 = v13

					if v9 ~= nil then
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
							v30 = if v13 == "LoadingMore" then "LoadingMore" else "Loaded"
						elseif v13 == "Loaded" then
							v30 = "Empty"
						end
					end

					v12(v30)

					analytics.reportMomentsFeedState(
						"failed",
						recommendationSource,
						success and "malformedResponse" or "requestFailed"
					)

					if v28 then
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
					local v30 = v13

					if v9 ~= nil then
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
							v30 = if v13 == "LoadingMore" then "LoadingMore" else "Loaded"
						elseif v13 == "Loaded" then
							v30 = "Empty"
						end
					end

					v12(v30)

					analytics.reportMomentsFeedLoadMore(
						"failed",
						recommendationSource,
						success and "malformedResponse" or "requestFailed"
					)
				end
			else
				local v30

				if flag2 then
					set = {}
					v30 = dedupeAndTrack(v29.items)
					commitItems(v30)

					if v9 ~= nil then
						local momentIndex = findMomentIndex(data.initialMomentId)

						v11(momentIndex)

						local momentIndex2 = findMomentIndex(v29.initialMomentId)

						if momentIndex2 ~= nil then
							v8.goToItem(momentIndex2)
						end
					end
				else
					v30 = dedupeAndTrack(v29.items)
					local clone = table.clone(v8.getItems(false))
					local v31 = clone[#clone]

					if v31 ~= nil and v31.kind == "skeleton" then
						table.remove(clone)
					end

					for k, v32 in v30 do
						table.insert(clone, v32)
					end

					commitItems(clone)
				end

				nextCursor = v29.nextCursor

				v18 = (flag2 or #v30 ~= 0) and 0 or v18 + 1
				v15(v29.nextCursor ~= nil and v18 < 3)
				local v33 = v8.getCount(false) == 0 and "Empty" or "Loaded"
				v13 = v33
				local v34 = v13

				if v9 ~= nil then
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

				if flag2 then
					analytics.reportMomentsFeedState(
						v33 == "Loaded" and "loaded" or "empty",
						recommendationSource,
						nil
					)
				end

				if v28 then
					local currentItem = v8.getCurrentItem(false)

					if FFlagMomentsModeratedMomentPage and currentItem ~= nil and currentItem.kind == "unavailableMoment" then
						momentsSurfaceLoadManager.abort("unavailable")
					elseif v33 == "Loaded" then
						momentsSurfaceLoadManager.primaryDataReady()
					else
						momentsSurfaceLoadManager.abort("empty")
					end
				end

				if v29.onAccepted ~= nil then
					v29.onAccepted()
				end

				if p3 ~= nil or endsWithCaughtUp then
					appendTerminalPage()
				end
			end
		end)
	end

	local function loadBeyondLimit()
		if flag or p3 == nil or not signal6(false) or not signal4(false) and #v23 == 0 then
			return
		end

		local items = v8.getItems(false)
		local clone = table.clone(items)
		local v24 = clone[#clone]
		local v25 = not (v24 == nil) and v24.kind == "endState"

		if v25 then
			table.remove(clone)
		end

		if FFlagMomentsLoadMoreKeepsPosition and v25 then
			v8.goToItem(#items)
		end

		if not FFlagMomentsLoadMoreKeepsPosition and v25 then
			v8.removeItem(#items)
		end

		local v26

		if FFlagMomentsLoadMoreKeepsPosition then
			local count2 = 0

			for k, v27 in clone do
				if v27.kind ~= "skeleton" and v27.kind ~= "endState" and v27.kind ~= "caughtUp" then
					count2 += 1
				end
			end

			v26 = count2 + p3
		else
			local items2 = v8.getItems(false)
			local count2 = 0

			for k, item in items2 do
				if item.kind ~= "skeleton" and item.kind ~= "endState" and item.kind ~= "caughtUp" then
					count2 += 1
				end
			end

			v26 = count2 + p3
		end

		v19 = v26

		v20(false)
		local v27 = false

		if #v23 > 0 then
			if not FFlagMomentsLoadMoreKeepsPosition then
				clone = table.clone(v8.getItems(false))
			end

			for k, v28 in v23 do
				table.insert(clone, v28)
			end

			table.clear(v23)
			v8.setItems(clone)

			appendTerminalPage()

			if signal6(false) then
				return
			end
		elseif FFlagMomentsLoadMoreKeepsPosition then
			table.insert(clone, v5)
			v8.setItems(clone)
			v27 = true
		end

		if not FFlagMomentsLoadMoreKeepsPosition then
			v27 = nil
		end

		if flag or not signal4(false) then
			return
		end

		count += 1
		local v28 = count
		v17 = true
		v16(false)

		local v29 = nil

		analytics.reportMomentsFeedLoadMore("attempted", recommendationSource)

		if not (FFlagMomentsLoadMoreKeepsPosition and v27) then
			v8.addItems({ v5 })
		end

		v13 = "LoadingMore"
		local v30 = v13

		if v9 ~= nil then
			local items2 = v8.getItems(false)
			local count2 = 0

			for k, item in items2 do
				if item.kind == "skeleton" or isTerminalPage(item) then
					continue
				end

				count2 += 1
			end

			if count2 > 0 then
				v30 = if v13 == "LoadingMore" then "LoadingMore" else "Loaded"
			elseif v13 == "Loaded" then
				v30 = "Empty"
			end
		end

		v12(v30)

		local v31 = nextCursor

		local flag2 = false
		task.spawn(function()
			local success, result = pcall(data.fetchAsync, v31)

			if flag or v28 ~= count then
				return
			end

			v17 = false

			local v32 = p2 and flag2

			if v32 then
				v32 = not (v29 == nil) and momentsSurfaceLoadManager.getSessionGeneration() == v29
			end

			if v32 then
				momentsSurfaceLoadManager.primaryDataResponseReceived()
			end

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

					if v9 ~= nil then
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

					if v32 then
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
					local v34 = v13

					if v9 ~= nil then
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
					local clone2 = table.clone(v8.getItems(false))
					local v35 = clone2[#clone2]

					if v35 ~= nil and v35.kind == "skeleton" then
						table.remove(clone2)
					end

					for k, v36 in v34 do
						table.insert(clone2, v36)
					end

					commitItems(clone2)
				end

				nextCursor = v33.nextCursor

				v18 = (flag2 or #v34 ~= 0) and 0 or v18 + 1
				v15(v33.nextCursor ~= nil and v18 < 3)
				local v37 = v8.getCount(false) == 0 and "Empty" or "Loaded"
				v13 = v37
				local v38 = v13

				if v9 ~= nil then
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

				if flag2 then
					analytics.reportMomentsFeedState(
						v37 == "Loaded" and "loaded" or "empty",
						recommendationSource,
						nil
					)
				end

				if v32 then
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
		end)
	end

	local function prependItem(p4)
		local v24 = dedupeAndTrack({ p4 })

		if #v24 == 0 then
			return
		end

		v8.addItemAt(1, v24[1])

		if signal2(false) == "Empty" then
			v13 = "Loaded"
			local v25 = v13

			if v9 ~= nil then
				local items = v8.getItems(false)
				local count2 = 0

				for k, item in items do
					if item.kind ~= "skeleton" and item.kind ~= "endState" and item.kind ~= "caughtUp" then
						count2 += 1
					end
				end

				if count2 > 0 then
					v25 = v13 == "LoadingMore" and "LoadingMore" or "Loaded"
				else
					v25 = v13 == "Loaded" and "Empty" or v25
				end
			end

			v12(v25)
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

		if data.dispose then
			data.dispose()
		end

		v8.dispose()
	end

	if v9 ~= nil and data.getPendingItems ~= nil then
		if data.initialMomentId ~= nil then
			v11(1e999)
		end

		local getPendingItems = data.getPendingItems
		v10 = Signals.createEffect(function(p4)
			local v24 = v9.update(getPendingItems(p4), GetDeletedMomentsStore(false).getDeletedIds(p4))
			local clone = table.clone(v8.getItems(false))

			for k, v25 in v23 do
				table.insert(clone, v25)
			end

			for i = #clone, 1, -1 do
				local v25 = clone[i]

				if v25.kind == "endState" or v25.kind == "caughtUp" then
					table.remove(clone, i)
				end
			end

			SignalsExperimental.batch(function()
				commitItems(clone)
				table.clear(v23)
				local momentIndex = findMomentIndex(data.initialMomentId)

				if momentIndex ~= nil then
					v11(momentIndex)
				end

				v20(false)
				appendTerminalPage()
				local v25 = v13

				if v9 ~= nil then
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
						v25 = v13 == "LoadingMore" and "LoadingMore" or "Loaded"
					else
						v25 = v13 == "Loaded" and "Empty" or v25
					end
				end

				v12(v25)

				if v24 and data.recommendationSource == "Trending" then
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
