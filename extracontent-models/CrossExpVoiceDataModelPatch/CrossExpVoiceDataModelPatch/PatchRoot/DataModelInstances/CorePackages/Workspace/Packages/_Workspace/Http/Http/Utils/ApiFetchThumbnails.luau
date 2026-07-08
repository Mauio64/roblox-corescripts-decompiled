local Http = script:FindFirstAncestor("Http")
local HttpParent = Http.Parent
local Cryo = require(HttpParent.Cryo)
local ArgCheck = require(HttpParent.ArgCheck)
local PromiseUtilities = require(HttpParent.AppCommonLib).Utils.PromiseUtilities
local FetchSubdividedThumbnails = require(script.Parent.FetchSubdividedThumbnails)
local PerformFetch = require(Http.PerformFetch)

local function convertToId(p1) -- line: 15
	return (tostring(p1))
end

local t1 = {}

local function v10(p2) -- line: 21
	local targetId = p2.targetId
	local v15 = p2.iconSize and "." .. p2.iconSize or ""
	local v16 = p2.requestName and "." .. p2.requestName or ""

	return "luaapp.thumbnails." .. tostring(targetId) .. v15 .. v16
end

t1.KeyMapper = v10

local function subdivideIdsArray(p3, p4) -- line: 30
	-- upvalues: Cryo (copy)
	local t2 = {}

	for i = 1, #p3, p4 do
		table.insert(t2, (Cryo.List.getRange(p3, i, i + p4 - 1)))
	end

	return t2
end

function t1.Fetch(p5, p6, p7, p8, p9, p10, p11) -- line: 39
	-- upvalues: ArgCheck (copy), subdivideIdsArray (copy), FetchSubdividedThumbnails (copy), v10 (copy), PromiseUtilities (copy)
	local v28 = p7 or "150x150"

	ArgCheck.isType(p6, "table", "targetIds")
	ArgCheck.isType(p8, "string", "requestName")
	ArgCheck.isNonNegativeNumber(#p6, "targetIds count")

	local t3 = {}
	local t4 = {}

	for _, v in pairs(p6) do
		table.insert(t3, {
			targetId = v,
			iconSize = v28,
			requestName = p8
		})
	end

	local v33 = subdivideIdsArray(t3, 100)

	for _, v in ipairs(v33) do
		table.insert(t4, p11:dispatch(FetchSubdividedThumbnails.Fetch(p5, v, v10, p8, p9, p10)))
	end

	return PromiseUtilities.Batch(t4)
end
function t1.GetFetchingStatus(p12, p13, p14, p15) -- line: 75
	-- upvalues: PerformFetch (copy)
	local GetStatus = PerformFetch.GetStatus
	local t5 = {
		targetId = p13,
		requestName = p15,
		iconSize = p14
	}
	local targetId = t5.targetId
	local v43 = t5.iconSize and "." .. t5.iconSize or ""
	local v44 = t5.requestName and "." .. t5.requestName or ""

	return GetStatus(p12, "luaapp.thumbnails." .. tostring(targetId) .. v43 .. v44)
end

return t1
