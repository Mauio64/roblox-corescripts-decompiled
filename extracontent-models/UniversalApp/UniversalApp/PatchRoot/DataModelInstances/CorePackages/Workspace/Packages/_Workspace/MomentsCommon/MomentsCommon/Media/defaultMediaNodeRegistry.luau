local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local mediaNodeRegistry = require(MomentsCommon.Media.mediaNodeRegistry)
local createVideoNode = require(MomentsCommon.Media.Nodes.createVideoNode)
local createMusicNode = require(MomentsCommon.Media.Nodes.createMusicNode)
local createScreenshotNode = require(MomentsCommon.Media.Nodes.createScreenshotNode)
local createTextOverlayNode = require(MomentsCommon.Media.Nodes.createTextOverlayNode)

local function createDefaultMediaNodeRegistry() -- line: 26
	-- upvalues: mediaNodeRegistry (copy), createVideoNode (copy), createMusicNode (copy), createScreenshotNode (copy), createTextOverlayNode (copy)
	local v8 = mediaNodeRegistry()

	v8.register(createVideoNode)
	v8.register(createMusicNode)
	v8.register(createScreenshotNode)
	v8.register(createTextOverlayNode)

	return v8
end

return createDefaultMediaNodeRegistry
