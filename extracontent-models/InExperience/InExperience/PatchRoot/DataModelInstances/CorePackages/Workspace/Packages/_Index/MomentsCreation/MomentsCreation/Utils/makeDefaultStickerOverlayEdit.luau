local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local Constants = require(MomentsCreation.Constants)

require(MomentsCreation.Parent.MomentsTypes)

local function makeDefaultStickerOverlayEdit() -- line: 9
	-- upvalues: Constants (copy)
	return {
		stickerURI = nil,
		rotation = 0,
		scale = 1,
		zIndex = 1,
		position = UDim2.fromScale(0.5, 0.5),
		stickerSize = Constants.StickerOverlay.DefaultStickerSize
	}
end

return makeDefaultStickerOverlayEdit
