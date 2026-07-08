local MomentsCommon = script:FindFirstAncestor("MomentsCommon")

require(MomentsCommon.Types)

local Constants = require(MomentsCommon.Constants)

local function getTagsForMoment(p1) -- line: 8
	-- upvalues: Constants (copy)
	local t1 = {}

	if p1.captureType == Enum.CaptureType.Screenshot then
		table.insert(t1, "screenshot")
	elseif p1.captureType == Enum.CaptureType.Video then
		table.insert(t1, "video")
	end

	if p1.universeId then
		table.insert(t1, Constants.TagPrefix.Universe .. tostring(p1.universeId))
	end

	if p1.edits then
		if p1.edits.trim then
			table.insert(t1, "trim")
		end

		if p1.edits.music then
			table.insert(t1, "music")

			if p1.edits.music.assetId then
				table.insert(t1, Constants.TagPrefix.Music .. tostring(p1.edits.music.assetId))
			end
		end

		if p1.edits.textOverlays then
			table.insert(t1, "text_overlay")
		end
	end

	return t1
end

return getTagsForMoment
