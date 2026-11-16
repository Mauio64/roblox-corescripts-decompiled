local Http = script:FindFirstAncestor("Http")
local parent = Http.Parent

local Models = require(Http.Models)
local Thumbnail = Models.Thumbnail
local PerformFetch = require(Http.PerformFetch)

local ArgCheck = require(parent.ArgCheck)
local Promise = require(parent.Promise)
local Result = require(parent.Result)

local tutils = require(parent.tutils)

local v = math.max(0, tonumber(settings():GetFVariable("LuaAppNonFinalThumbnailMaxRetries")) or 0)

local v2 = math.max(0, tonumber(settings():GetFVariable("LuaAppThumbnailsApiRetryTimeMultiplier")) or 0)

local FetchSubdividedThumbnails = {}

function FetchSubdividedThumbnails._fetchIcons(object, p, p2, iconSize, callback, requestName, callback2, callback3)
	local function keyMapperForCurrentRequestNameAndSize(targetId) -- 2 equivalent calls inferred from this helper
		return callback({ targetId = targetId, requestName = requestName, iconSize = iconSize })
	end

	local function getTableOfFailedResults(items)
		local tableOfFailedResults = {}

		for _, item in pairs(items) do
			tableOfFailedResults[keyMapperForCurrentRequestNameAndSize(item)] = Result.new(false, { -- inferred equivalent call
				targetId = item
			})
		end

		return tableOfFailedResults
	end

	return callback2(p, p2, iconSize):andThen(function(p3)
		local tableOfFailedResults = getTableOfFailedResults(p2)
		local v3 = {}

		local data = p3 and p3.responseBody and p3.responseBody.data

		if typeof(data) == "table" then
			for _, v4 in pairs(data) do
				if not Thumbnail.isCompleteThumbnailData(v4) then
					continue
				end

				local targetId = tostring(v4.targetId)
				local v5

				if Thumbnail.checkStateIsFinal(v4.state) then
					v3[targetId] = Thumbnail.fromThumbnailData(v4, iconSize)
					v5 = true
				else
					v5 = false
				end

				tableOfFailedResults[keyMapperForCurrentRequestNameAndSize(targetId)] = Result.new(v5, v4) -- inferred equivalent call
			end
		end

		object:dispatch(callback3(v3))
		return Promise.resolve(tableOfFailedResults)
	end, function(_)
		local tableOfFailedResults = getTableOfFailedResults(p2)
		return Promise.resolve(tableOfFailedResults)
	end)
end

function FetchSubdividedThumbnails._fetch(p, p2, p3, p4, p5, p6, p7, p8)
	return FetchSubdividedThumbnails._fetchIcons(p, p2, p3, p4, p5, p6, p7, p8):andThen(function(p9)
		local v3 = {}
		local v4 = p9

		if _G.__TESTEZ_RUNNING_TEST__ then
			v = 1
			v2 = 0.001
		end

		local function retry(p10)
			local v5 = {}

			for k, v6 in pairs(v4) do
				local unwrapped, v7 = v6:unwrap()

				if unwrapped and Thumbnail.checkStateIsFinal(v7.state) then
					v3[k] = v6
				else
					table.insert(v5, v7)
				end
			end

			if tutils.fieldCount(v5) == 0 then
				return Promise.resolve(v3)
			end

			return Promise.new(function(callback, _)
				coroutine.wrap(function()
					wait(v2 * math.pow(2, p10 - 1))
					callback()
				end)()
			end):andThen(function()
				return FetchSubdividedThumbnails._fetchIcons(p, p2, p3, p4, p5, p6, p7, p8)
			end):andThen(function(p11)
				v4 = p11

				if p10 > 1 then
					return retry(p10 - 1)
				end

				return Promise.resolve(v3)
			end)
		end

		return retry(v)
	end)
end

function FetchSubdividedThumbnails.Fetch(p, list, keyMapper, p2, p3, p4)
	ArgCheck.isType(list, "table", "requests")
	ArgCheck.isType(p2, "string", "requestName")
	ArgCheck.isNonNegativeNumber(#list, "requests count")

	FetchSubdividedThumbnails.KeyMapper = keyMapper
	return PerformFetch.Batch(list, keyMapper, function(p5, list2)
		local targetIds = {}
		local iconSize = nil

		for _, item in ipairs(list2) do
			local targetId = item.targetId
			iconSize = item.iconSize
			table.insert(targetIds, targetId)
		end

		return FetchSubdividedThumbnails._fetch(p5, p, targetIds, iconSize, keyMapper, p2, p3, p4)
	end)
end

return FetchSubdividedThumbnails
