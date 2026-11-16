local Http = script:FindFirstAncestor("Http")
local parent = Http.Parent

local Cryo = require(parent.Cryo)
local ArgCheck = require(parent.ArgCheck)
local AppCommonLib = require(parent.AppCommonLib)
local PromiseUtilities = AppCommonLib.Utils.PromiseUtilities
local FetchSubdividedThumbnails = require(script.Parent.FetchSubdividedThumbnails)

local PerformFetch = require(Http.PerformFetch)

local function convertToId(targetId) -- 1 equivalent call inferred from this helper
	return (tostring(targetId))
end

local function fn(data) -- 1 equivalent call inferred from this helper
	local targetId = data.targetId
	local v = data.iconSize and "." .. data.iconSize or ""
	local v2 = data.requestName and "." .. data.requestName or ""
	return "luaapp.thumbnails." .. convertToId(targetId) .. v .. v2 -- inferred equivalent call
end

local ApiFetchThumbnails = {}
ApiFetchThumbnails.KeyMapper = fn

local function subdivideIdsArray(list, p)
	local result = {}

	for i = 1, #list, p do
		table.insert(result, (Cryo.List.getRange(list, i, i + p - 1)))
	end

	return result
end

function ApiFetchThumbnails.Fetch(p, list, value, requestName, p2, p3, object)
	ArgCheck.isType(list, "table", "targetIds")
	ArgCheck.isType(requestName, "string", "requestName")
	ArgCheck.isNonNegativeNumber(#list, "targetIds count")
	local iconSize = value or "150x150"
	local v = {}
	local v2 = {}

	for _, item in pairs(list) do
		table.insert(v, { targetId = item, iconSize = iconSize, requestName = requestName })
	end

	local v3 = subdivideIdsArray(v, 100)

	for _, v4 in ipairs(v3) do
		table.insert(v2, object:dispatch(FetchSubdividedThumbnails.Fetch(p, v4, fn, requestName, p2, p3)))
	end

	return PromiseUtilities.Batch(v2)
end

function ApiFetchThumbnails.GetFetchingStatus(p, targetId, iconSize, requestName)
	return PerformFetch.GetStatus(p, fn({ -- inferred equivalent call
		targetId = targetId,
		requestName = requestName,
		iconSize = iconSize
	}))
end

return ApiFetchThumbnails
