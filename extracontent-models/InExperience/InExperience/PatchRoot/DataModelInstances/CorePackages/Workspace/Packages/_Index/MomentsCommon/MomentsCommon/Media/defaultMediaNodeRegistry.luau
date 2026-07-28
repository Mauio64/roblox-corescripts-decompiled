local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local mediaNodeRegistry = require(MomentsCommon.Media.mediaNodeRegistry)
local createVideoNode = require(MomentsCommon.Media.Nodes.createVideoNode)
local createMusicNode = require(MomentsCommon.Media.Nodes.createMusicNode)
local createScreenshotNode = require(MomentsCommon.Media.Nodes.createScreenshotNode)
local createTextOverlayNode = require(MomentsCommon.Media.Nodes.createTextOverlayNode)
local createStickerOverlayNode = require(MomentsCommon.Media.Nodes.createStickerOverlayNode)
local GetFFlagMomentsStickerButton = require(MomentsCommon.Flags.GetFFlagMomentsStickerButton)

local function createDefaultMediaNodeRegistry() -- line: 28
	-- upvalues: mediaNodeRegistry (copy), createVideoNode (copy), createMusicNode (copy), createScreenshotNode (copy), createTextOverlayNode (copy), GetFFlagMomentsStickerButton (copy), createStickerOverlayNode (copy)
	local v10 = mediaNodeRegistry()

	v10.register(createVideoNode)
	v10.register(createMusicNode)
	v10.register(createScreenshotNode)
	v10.register(createTextOverlayNode)

	if GetFFlagMomentsStickerButton() then
		v10.register(createStickerOverlayNode)
	end

	return v10
end

return createDefaultMediaNodeRegistry
