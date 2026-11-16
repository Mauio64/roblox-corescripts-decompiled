require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsTypes")
local getFFlagMomentsStickerButton = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon").Flags.GetFFlagMomentsStickerButton

local v5 = { PrimaryAsset = "PrimaryAsset", Music = "Music", Sticker = "Sticker" }

local function makeRegistrationInfo(p2, p3, options)
	local edits = p3.edits
	local v6 = {}
	local v7

	if edits and edits.trim then
		table.insert(v6, {
			AssetId = 0,
			Description = "PrimaryAsset",
			TrimStartTime = edits.trim.startTime
		})

		v7 = edits.trim.endTime - edits.trim.startTime
	else
		table.insert(v6, {
			AssetId = 0,
			Description = "PrimaryAsset",
			TrimStartTime = 0
		})

		v7 = p3.assetTotalDuration
	end

	if edits and edits.music then
		table.insert(v6, {
			AssetId = edits.music.assetId,
			Description = "Music",
			TrimStartTime = edits.music.startTime
		})
	end

	if getFFlagMomentsStickerButton() and edits and edits.stickerOverlays then
		for k, stickerOverlay in edits.stickerOverlays do
			if stickerOverlay.stickerURI then
				table.insert(v6, {
					AssetId = 0,
					Description = "Sticker",
					Text = stickerOverlay.stickerURI
				})
			end
		end
	end

	local v8 = if p2.CaptureType == Enum.CaptureType.Screenshot then Enum.RecommendationItemContentType.Static else Enum.RecommendationItemContentType.Dynamic
	return {
		attributes = v6,
		contentType = v8,
		customTags = options or {},
		duration = v7
	}
end

return makeRegistrationInfo
