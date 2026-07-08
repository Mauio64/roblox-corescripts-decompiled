local TopicContentsRodux = script:FindFirstAncestor("TopicContentsRodux")
local TopicContentsEntryModel = require(TopicContentsRodux.TopicContentsEntryModel)
local TopicContentsRoduxParent = TopicContentsRodux.Parent
local OmniRecommendationsContentType = require(TopicContentsRoduxParent.DiscoveryTypes).OmniRecommendationsContentType
local FFlagLuaAppEnableHomepageOneByTwoTile = require(TopicContentsRoduxParent.SharedFlags).FFlagLuaAppEnableHomepageOneByTwoTile
local t1 = {
	new = function() -- line: 14
		return {
			entries = {},
			rowsRequested = 0,
			hasMoreRows = false,
			nextPageExclusiveStartId = 0,
			updatedTimestamp = nil,
			nextPageToken = ""
		}
	end
}

function t1.mock() -- line: 28
	-- upvalues: t1 (copy), TopicContentsEntryModel (copy)
	local v7 = t1.new()

	v7.entries = { TopicContentsEntryModel.mock() }
	v7.rowsRequested = 1
	v7.hasMoreRows = false
	v7.nextPageExclusiveStartId = 0
	v7.updatedTimestamp = nil
	v7.nextPageToken = ""

	return v7
end
function t1.fromData(p1) -- line: 42
	return {
		entries = p1.entries,
		rowsRequested = p1.rowsRequested,
		hasMoreRows = p1.hasMoreRows,
		nextPageExclusiveStartId = p1.nextPageExclusiveStartId,
		updatedTimestamp = p1.updatedTimestamp,
		nextPageToken = not p1.nextPageToken and "" or p1.nextPageToken
	}
end
function t1.fromContentList(t2: {[any]: any}?, p2, p3, n1: number?) -- line: 56
	-- upvalues: t1 (copy), TopicContentsEntryModel (copy), FFlagLuaAppEnableHomepageOneByTwoTile (copy), OmniRecommendationsContentType (copy)
	local v13 = t1.new()

	v13.updatedTimestamp = n1
	v13.entries = {}
	v13.hasMoreRows = false

	if t2 then
		for _, v in ipairs(t2) do
			if v13.hasMoreRows then
				return v13
			end

			TopicContentsEntryModel.fromOmniRecommendations(v):match(function(p4) -- line: 75
				-- upvalues: FFlagLuaAppEnableHomepageOneByTwoTile (copy), OmniRecommendationsContentType (copy), v13 (copy), v (copy), p2 (copy), p3 (copy)
				if FFlagLuaAppEnableHomepageOneByTwoTile and p4.contentType == OmniRecommendationsContentType.AdLink then
					if p4.universeId ~= nil then
						warn("AdLink entry unexpectedly has universe ID")
					end

					table.insert(v13.entries, p4)

					return
				end

				local contentType = v.contentType
				local v18 = p2(contentType)

				if v18 ~= nil then
					local v19 = p3(p4, v18)

					if v19 ~= nil then
						table.insert(v13.entries, v19)

						return
					end

					v13.hasMoreRows = true
				end
			end):matchError(function(p5) -- line: 98
				warn(p5)
			end)
		end
	end

	return v13
end

return t1
