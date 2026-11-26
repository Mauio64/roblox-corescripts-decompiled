local mediaNodeRegistry = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/mediaNodeRegistry")

local createVideoNode = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/Nodes/createVideoNode")
local createMusicNode = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/Nodes/createMusicNode")
local createTtsNode = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/Nodes/createTtsNode")
local createScreenshotNode = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/Nodes/createScreenshotNode")
local createTextOverlayNode = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/Nodes/createTextOverlayNode")
local createStickerOverlayNode = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/Nodes/createStickerOverlayNode")
local GetFFlagMomentsStickerButton = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/GetFFlagMomentsStickerButton")

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
