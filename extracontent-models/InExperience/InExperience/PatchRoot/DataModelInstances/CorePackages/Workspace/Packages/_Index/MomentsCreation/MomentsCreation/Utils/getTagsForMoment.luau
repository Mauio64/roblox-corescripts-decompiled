local parent = script:FindFirstAncestor("MomentsCreation").Parent

require(parent.MomentsTypes)

local function getTagsForMoment(data)
	local tagsForMoment = {}

	if data.captureType == Enum.CaptureType.Screenshot then
		table.insert(tagsForMoment, "screenshot")
	elseif data.captureType == Enum.CaptureType.Video then
		table.insert(tagsForMoment, "video")
	end

	if data.universeId then
		table.insert(tagsForMoment, "universe:" .. tostring(data.universeId))
	end

	if not data.edits then
		return tagsForMoment
	end

	if data.edits.trim then
		table.insert(tagsForMoment, "trim")
	end

	if data.edits.music then
		table.insert(tagsForMoment, "music")

		if data.edits.music.assetId then
			table.insert(tagsForMoment, "music:" .. tostring(data.edits.music.assetId))
		end
	end

	if data.edits.textOverlays then
		table.insert(tagsForMoment, "text_overlay")
	end

	return tagsForMoment
end

return getTagsForMoment
