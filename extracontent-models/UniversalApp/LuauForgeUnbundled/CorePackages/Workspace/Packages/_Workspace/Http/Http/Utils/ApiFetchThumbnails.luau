local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Cryo")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/ArgCheck")
local promiseUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/AppCommonLib").Utils.PromiseUtilities
local FetchSubdividedThumbnails = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Http/Utils/FetchSubdividedThumbnails")

local PerformFetch = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Http/PerformFetch")

local function convertToId(p2)
	return (tostring(p2))
end

local function fn(data)
	local targetId = data.targetId
	local v6 = data.iconSize and "." .. data.iconSize or ""
	local v7 = data.requestName and "." .. data.requestName or ""
	return "luaapp.thumbnails." .. tostring(targetId) .. v6 .. v7
end

local v5 = {}
v5.KeyMapper = fn

local function subdivideIdsArray(list, p2)
	local result = {}

	for i = 1, #list, p2 do
		table.insert(result, (Cryo.List.getRange(list, i, i + p2 - 1)))
	end

	return result
end

function v5.Fetch(p2, list, value, p3, p4, p5, object)
	ArgCheck.isType(list, "table", "targetIds")
	ArgCheck.isType(p3, "string", "requestName")
	ArgCheck.isNonNegativeNumber(#list, "targetIds count")
	local v6 = value or "150x150"
	local v7 = {}
	local v8 = {}

	for k, item in pairs(list) do
		table.insert(v7, { targetId = item, iconSize = v6, requestName = p3 })
	end

	local v9 = subdivideIdsArray(v7, 100)

	for i, v10 in ipairs(v9) do
		table.insert(v8, object:dispatch(FetchSubdividedThumbnails.Fetch(p2, v10, fn, p3, p4, p5)))
	end

	return promiseUtilities.Batch(v8)
end

function v5.GetFetchingStatus(p2, p3, p4, p5)
	local getStatus = PerformFetch.GetStatus

	local v6 = { targetId = p3, requestName = p5, iconSize = p4 }
	local targetId = v6.targetId
	local v7 = v6.iconSize and "." .. v6.iconSize or ""
	local v8 = v6.requestName and "." .. v6.requestName or ""
	return getStatus(p2, "luaapp.thumbnails." .. tostring(targetId) .. v7 .. v8)
end

return v5
