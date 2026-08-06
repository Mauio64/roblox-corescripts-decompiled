local Parent = script:FindFirstAncestor("MomentsCreation").Parent

require(Parent.MomentsTypes)

local GetFFlagMomentsStickerButton = require(Parent.MomentsCommon).Flags.GetFFlagMomentsStickerButton
local _ = {
	PrimaryAsset = "PrimaryAsset",
	Music = "Music",
	Sticker = "Sticker"
}

local function makeRegistrationInfo(p1, p2) -- line: 36
	-- upvalues: GetFFlagMomentsStickerButton (copy)
	local edits = p2.edits
	local t1 = {}
	local v9

	if edits and edits.trim then
		table.insert(t1, {
			AssetId = 0,
			Description = "PrimaryAsset",
			TrimStartTime = edits.trim.startTime
		})
		v9 = edits.trim.endTime - edits.trim.startTime
	else
		table.insert(t1, {
			AssetId = 0,
			Description = "PrimaryAsset",
			TrimStartTime = 0
		})
		v9 = p2.assetTotalDuration
	end

	if edits and edits.music then
		table.insert(t1, {
			Description = "Music",
			AssetId = edits.music.assetId,
			TrimStartTime = edits.music.startTime
		})
	end

	if GetFFlagMomentsStickerButton() and edits and edits.stickerOverlays then
		for _, v11 in edits.stickerOverlays do
			if v11.stickerURI then
				table.insert(t1, {
					AssetId = 0,
					Description = "Sticker",
					Text = v11.stickerURI
				})
			end
		end
	end

	return {
		attributes = t1,
		contentType = if p1.CaptureType ~= Enum.CaptureType.Screenshot then Enum.RecommendationItemContentType.Dynamic else Enum.RecommendationItemContentType.Static,
		customTags = {},
		duration = v9
	}
end

return makeRegistrationInfo
