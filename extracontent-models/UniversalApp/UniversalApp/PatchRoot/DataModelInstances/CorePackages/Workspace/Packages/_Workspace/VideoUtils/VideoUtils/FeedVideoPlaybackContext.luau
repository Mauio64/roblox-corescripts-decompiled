local VideoUtils = script:FindFirstAncestor("VideoUtils")
local VideoPlaybackCoordinator = require(VideoUtils.VideoPlaybackCoordinator)
local ViewportVideoAutoplayController = require(VideoUtils.ViewportVideoAutoplayController)
local t1 = {}

t1.__index = t1

function t1.new(b1: boolean?) -- line: 22
	-- upvalues: VideoPlaybackCoordinator (copy), ViewportVideoAutoplayController (copy), t1 (copy)
	local v6 = VideoPlaybackCoordinator.new()
	local t2 = {
		videoPlaybackCoordinator = v6,
		viewportVideoAutoplayController = if not b1 then nil else ViewportVideoAutoplayController.new(v6)
	}

	setmetatable(t2, t1)

	return t2
end

return t1
