local MomentsCommon = script:FindFirstAncestor("MomentsCommon")

require(MomentsCommon.Types)

local Constants = require(MomentsCommon.Constants)

local function getTagsForMoment(data)
	local tagsForMoment = {}

	if data.captureType == Enum.CaptureType.Screenshot then
		table.insert(tagsForMoment, "screenshot")
	elseif data.captureType == Enum.CaptureType.Video then
		table.insert(tagsForMoment, "video")
	end

	if data.universeId then
		table.insert(tagsForMoment, Constants.TagPrefix.Universe .. tostring(data.universeId))
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
			table.insert(tagsForMoment, Constants.TagPrefix.Music .. tostring(data.edits.music.assetId))
		end
	end

	if data.edits.textOverlays then
		table.insert(tagsForMoment, "text_overlay")
	end

	return tagsForMoment
end

return getTagsForMoment
