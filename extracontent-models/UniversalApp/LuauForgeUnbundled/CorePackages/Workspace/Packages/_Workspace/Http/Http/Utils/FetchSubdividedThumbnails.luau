local thumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Http/Models").Thumbnail
local PerformFetch = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Http/PerformFetch")

local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/ArgCheck")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Promise")
local Result = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Result")

local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/tutils")

local v5 = math.max(0, tonumber(settings():GetFVariable("LuaAppNonFinalThumbnailMaxRetries")) or 0)

local v6 = math.max(0, tonumber(settings():GetFVariable("LuaAppThumbnailsApiRetryTimeMultiplier")) or 0)

local v7 = {}

function v7._fetchIcons(object, p2, p3, p4, callback, p5, callback2, callback3)
	local function keyMapperForCurrentRequestNameAndSize(p6)
		return callback({ targetId = p6, requestName = p5, iconSize = p4 })
	end

	local function getTableOfFailedResults(items)
		local tableOfFailedResults = {}

		for k, item in pairs(items) do
			tableOfFailedResults[callback({
				targetId = item,
				requestName = p5,
				iconSize = p4
			})] = Result.new(false, { targetId = item })
		end

		return tableOfFailedResults
	end

	return callback2(p2, p3, p4):andThen(function(p6)
		local tableOfFailedResults = getTableOfFailedResults(p3)
		local v8 = {}

		local data = p6 and p6.responseBody and p6.responseBody.data

		if typeof(data) == "table" then
			for k, v9 in pairs(data) do
				if not thumbnail.isCompleteThumbnailData(v9) then
					continue
				end

				local targetId = tostring(v9.targetId)
				local v10

				if thumbnail.checkStateIsFinal(v9.state) then
					v8[targetId] = thumbnail.fromThumbnailData(v9, p4)
					v10 = true
				else
					v10 = false
				end

				tableOfFailedResults[callback({
					targetId = targetId,
					requestName = p5,
					iconSize = p4
				})] = Result.new(v10, v9)
			end
		end

		object:dispatch(callback3(v8))
		return Promise.resolve(tableOfFailedResults)
	end, function(p6)
		local tableOfFailedResults = getTableOfFailedResults(p3)
		return Promise.resolve(tableOfFailedResults)
	end)
end

function v7._fetch(p2, p3, p4, p5, p6, p7, p8, p9)
	return v7._fetchIcons(p2, p3, p4, p5, p6, p7, p8, p9):andThen(function(p10)
		local v8 = {}
		local v9 = p10

		if _G.__TESTEZ_RUNNING_TEST__ then
			v5 = 1
			v6 = 0.001
		end

		local function retry(p11)
			local v10 = {}

			for k, v11 in pairs(v9) do
				local unwrapped, v12 = v11:unwrap()

				if unwrapped and thumbnail.checkStateIsFinal(v12.state) then
					v8[k] = v11
				else
					table.insert(v10, v12)
				end
			end

			if tutils.fieldCount(v10) == 0 then
				return Promise.resolve(v8)
			end

			return Promise.new(function(callback, p12)
				coroutine.wrap(function()
					wait(v6 * math.pow(2, p11 - 1))
					callback()
				end)()
			end):andThen(function()
				return v7._fetchIcons(p2, p3, p4, p5, p6, p7, p8, p9)
			end):andThen(function(p12)
				v9 = p12

				if p11 > 1 then
					return retry(p11 - 1)
				end

				return Promise.resolve(v8)
			end)
		end

		return retry(v5)
	end)
end

function v7.Fetch(p2, list, keyMapper, p3, p4, p5)
	ArgCheck.isType(list, "table", "requests")
	ArgCheck.isType(p3, "string", "requestName")
	ArgCheck.isNonNegativeNumber(#list, "requests count")

	v7.KeyMapper = keyMapper
	return PerformFetch.Batch(list, keyMapper, function(p6, list2)
		local targetIds = {}
		local iconSize = nil

		for i, item in ipairs(list2) do
			local targetId = item.targetId
			iconSize = item.iconSize
			table.insert(targetIds, targetId)
		end

		return v7._fetch(p6, p2, targetIds, iconSize, keyMapper, p3, p4, p5)
	end)
end

return v7
