local Parent = script:FindFirstAncestor("MomentsCreation").Parent

require(Parent.MomentsTypes)

local _ = {
	PrimaryAsset = "PrimaryAsset",
	Music = "Music"
}

local function makeRegistrationInfo(p1, p2) -- line: 32
	local edits = p2.edits
	local t1 = {}
	local v8

	if edits and edits.trim then
		table.insert(t1, {
			AssetId = 0,
			Description = "PrimaryAsset",
			TrimStartTime = edits.trim.startTime
		})
		v8 = edits.trim.endTime - edits.trim.startTime
	else
		table.insert(t1, {
			AssetId = 0,
			Description = "PrimaryAsset",
			TrimStartTime = 0
		})
		v8 = p2.assetTotalDuration
	end

	if edits and edits.music then
		table.insert(t1, {
			Description = "Music",
			AssetId = edits.music.assetId,
			TrimStartTime = edits.music.startTime
		})
	end

	return {
		attributes = t1,
		contentType = if p1.CaptureType ~= Enum.CaptureType.Screenshot then Enum.RecommendationItemContentType.Dynamic else Enum.RecommendationItemContentType.Static,
		customTags = {},
		duration = v8
	}
end

return makeRegistrationInfo
