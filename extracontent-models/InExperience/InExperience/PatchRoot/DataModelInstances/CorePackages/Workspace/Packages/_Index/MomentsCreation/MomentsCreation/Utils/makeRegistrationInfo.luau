local parent = script:FindFirstAncestor("MomentsCreation").Parent

require(parent.MomentsTypes)
local MomentsCommon = require(parent.MomentsCommon)

local GetFFlagMomentsStickerButton = MomentsCommon.Flags.GetFFlagMomentsStickerButton

local _ = { PrimaryAsset = "PrimaryAsset", Music = "Music", Sticker = "Sticker" }

local function makeRegistrationInfo(p, p2, options)
	local edits = p2.edits
	local attributes = {}
	local duration

	if edits and edits.trim then
		table.insert(attributes, {
			AssetId = 0,
			Description = "PrimaryAsset",
			TrimStartTime = edits.trim.startTime
		})

		duration = edits.trim.endTime - edits.trim.startTime
	else
		table.insert(attributes, { AssetId = 0, Description = "PrimaryAsset", TrimStartTime = 0 })

		duration = p2.assetTotalDuration
	end

	if edits and edits.music then
		table.insert(attributes, {
			AssetId = edits.music.assetId,
			Description = "Music",
			TrimStartTime = edits.music.startTime
		})
	end

	if GetFFlagMomentsStickerButton() and edits and edits.stickerOverlays then
		for _, stickerOverlay in edits.stickerOverlays do
			if stickerOverlay.stickerURI then
				table.insert(attributes, {
					AssetId = 0,
					Description = "Sticker",
					Text = stickerOverlay.stickerURI
				})
			end
		end
	end

	local contentType

	if p.CaptureType == Enum.CaptureType.Screenshot then
		contentType = Enum.RecommendationItemContentType.Static
	else
		contentType = Enum.RecommendationItemContentType.Dynamic
	end

	return {
		attributes = attributes,
		contentType = contentType,
		customTags = options or {},
		duration = duration
	}
end

return makeRegistrationInfo
