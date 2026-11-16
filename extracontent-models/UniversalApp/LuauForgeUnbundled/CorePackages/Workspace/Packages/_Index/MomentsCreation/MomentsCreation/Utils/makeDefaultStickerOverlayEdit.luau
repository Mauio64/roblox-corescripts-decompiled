local Constants = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Constants")

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsTypes")

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
