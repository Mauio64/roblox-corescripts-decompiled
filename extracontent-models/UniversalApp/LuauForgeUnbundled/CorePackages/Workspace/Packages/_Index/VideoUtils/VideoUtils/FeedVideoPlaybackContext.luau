local ViewportVideoAutoplayMode = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/ViewportVideoAutoplayMode")
local VideoPlaybackCoordinator = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/VideoPlaybackCoordinator")
local VideoPlaybackDetectionMethod = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/VideoPlaybackDetectionMethod")
local ViewportVideoAutoplayController = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/ViewportVideoAutoplayController")

local fFlagLuaAppVideoAutoplayFeedElection = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppVideoAutoplayFeedElection
local fFlagLuaAppOneByTwoHoverIdleAutoplay = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppOneByTwoHoverIdleAutoplay

local class = {}
class.__index = class

function class.new(p2, p3, p4, p5)
	local v5 = VideoPlaybackCoordinator.new()
	local v6 = nil

	if fFlagLuaAppOneByTwoHoverIdleAutoplay then
		if p5 == VideoPlaybackDetectionMethod.Viewport then
			v6 = ViewportVideoAutoplayMode.AutoplayAllCandidates
		elseif p5 == VideoPlaybackDetectionMethod.Hover then
			v6 = ViewportVideoAutoplayMode.UserIntentWithSelectiveAutoplay
		end
	end

	local v7

	if fFlagLuaAppOneByTwoHoverIdleAutoplay and v6 ~= nil then
		local new = ViewportVideoAutoplayController.new
		local v8 = if fFlagLuaAppVideoAutoplayFeedElection then p3 else nil
		local v9 = if fFlagLuaAppVideoAutoplayFeedElection then p4 else nil
		v7 = new(v5, v8, v9, v6)
	end

	if p2 then
		local new = ViewportVideoAutoplayController.new

		if not fFlagLuaAppVideoAutoplayFeedElection then
			p3 = nil
		end

		if not fFlagLuaAppVideoAutoplayFeedElection then
			p4 = nil
		end

		v7 = new(v5, p3, p4)
	end

	local v8 = { videoPlaybackCoordinator = v5, viewportVideoAutoplayController = v7 }

	setmetatable(v8, class)

	return v8
end

return class
