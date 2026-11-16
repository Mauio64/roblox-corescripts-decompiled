local MomentsCommon = script:FindFirstAncestor("MomentsCommon")

local mediaNodeRegistry = require(MomentsCommon.Media.mediaNodeRegistry)

local createVideoNode = require(MomentsCommon.Media.Nodes.createVideoNode)
local createMusicNode = require(MomentsCommon.Media.Nodes.createMusicNode)
local createTtsNode = require(MomentsCommon.Media.Nodes.createTtsNode)
local createScreenshotNode = require(MomentsCommon.Media.Nodes.createScreenshotNode)
local createTextOverlayNode = require(MomentsCommon.Media.Nodes.createTextOverlayNode)
local createStickerOverlayNode = require(MomentsCommon.Media.Nodes.createStickerOverlayNode)
local GetFFlagMomentsStickerButton = require(MomentsCommon.Flags.GetFFlagMomentsStickerButton)

local function createDefaultMediaNodeRegistry()
	local defaultMediaNodeRegistry = mediaNodeRegistry()

	defaultMediaNodeRegistry.register(createVideoNode)
	defaultMediaNodeRegistry.register(createMusicNode)
	defaultMediaNodeRegistry.register(createTtsNode)
	defaultMediaNodeRegistry.register(createScreenshotNode)
	defaultMediaNodeRegistry.register(createTextOverlayNode)

	if GetFFlagMomentsStickerButton() then
		defaultMediaNodeRegistry.register(createStickerOverlayNode)
	end

	return defaultMediaNodeRegistry
end

return createDefaultMediaNodeRegistry
