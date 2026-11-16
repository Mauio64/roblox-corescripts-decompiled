local MomentsCreation = script:FindFirstAncestor("MomentsCreation")

local Constants = require(MomentsCreation.Constants)

require(MomentsCreation.Parent.MomentsTypes)

local function makeDefaultStickerOverlayEdit()
	return {
		stickerURI = nil,
		position = UDim2.fromScale(0.5, 0.5),
		stickerSize = Constants.StickerOverlay.DefaultStickerSize,
		rotation = 0,
		scale = 1,
		zIndex = 1
	}
end

return makeDefaultStickerOverlayEdit
