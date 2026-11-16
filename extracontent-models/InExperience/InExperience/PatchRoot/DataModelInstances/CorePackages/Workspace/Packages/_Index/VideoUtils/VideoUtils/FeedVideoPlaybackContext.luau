local VideoUtils = script:FindFirstAncestor("VideoUtils")
local parent = VideoUtils.Parent

local ViewportVideoAutoplayMode = require(VideoUtils.ViewportVideoAutoplayMode)
local VideoPlaybackCoordinator = require(VideoUtils.VideoPlaybackCoordinator)
local VideoPlaybackDetectionMethod = require(VideoUtils.VideoPlaybackDetectionMethod)
local ViewportVideoAutoplayController = require(VideoUtils.ViewportVideoAutoplayController)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppVideoAutoplayFeedElection = SharedFlags.FFlagLuaAppVideoAutoplayFeedElection
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppOneByTwoHoverIdleAutoplay = SharedFlags2.FFlagLuaAppOneByTwoHoverIdleAutoplay

local FeedVideoPlaybackContext = {}
FeedVideoPlaybackContext.__index = FeedVideoPlaybackContext

function FeedVideoPlaybackContext.new(flag: boolean?, flag2: boolean?, flag3: boolean?, p)
	local videoPlaybackCoordinator = VideoPlaybackCoordinator.new()
	local v = nil

	if FFlagLuaAppOneByTwoHoverIdleAutoplay then
		if p == VideoPlaybackDetectionMethod.Viewport then
			v = ViewportVideoAutoplayMode.AutoplayAllCandidates
		elseif p == VideoPlaybackDetectionMethod.Hover then
			v = ViewportVideoAutoplayMode.UserIntentWithSelectiveAutoplay
		end
	end

	local viewportVideoAutoplayController

	if FFlagLuaAppOneByTwoHoverIdleAutoplay and v ~= nil then
		local new = ViewportVideoAutoplayController.new
		local v2

		if FFlagLuaAppVideoAutoplayFeedElection then
			v2 = flag2
		end

		local v3

		if FFlagLuaAppVideoAutoplayFeedElection then
			v3 = flag3
		end

		viewportVideoAutoplayController = new(videoPlaybackCoordinator, v2, v3, v)
	end

	if flag then
		local new = ViewportVideoAutoplayController.new

		if not FFlagLuaAppVideoAutoplayFeedElection then
			flag2 = nil
		end

		if not FFlagLuaAppVideoAutoplayFeedElection then
			flag3 = nil
		end

		viewportVideoAutoplayController = new(videoPlaybackCoordinator, flag2, flag3)
	end

	local v2 = {
		videoPlaybackCoordinator = videoPlaybackCoordinator,
		viewportVideoAutoplayController = viewportVideoAutoplayController
	}

	setmetatable(v2, FeedVideoPlaybackContext)

	return v2
end

return FeedVideoPlaybackContext
