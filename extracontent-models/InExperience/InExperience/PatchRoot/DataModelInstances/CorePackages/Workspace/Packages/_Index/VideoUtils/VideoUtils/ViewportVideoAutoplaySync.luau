local VideoUtils = script:FindFirstAncestor("VideoUtils")
local parent = VideoUtils.Parent

local React = require(parent.React)
local ViewportUtils = require(parent.ViewportUtils)
local useViewportBounds = ViewportUtils.useViewportBounds

require(VideoUtils.ViewportVideoAutoplayController)
local Enums = require(VideoUtils.Analytics.Enums)
local VideoEndReason = Enums.VideoEndReason

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppOneByTwoHoverIdleAutoplay = SharedFlags.FFlagLuaAppOneByTwoHoverIdleAutoplay

local defineFastInt = game:DefineFastInt("LuaAppVideoAutoplayWinnerLineOffsetFromTopBarPx", 240)

local function ViewportVideoAutoplaySync(p): nil
	local v = useViewportBounds(p.scrollingFrameRef)

	React.useEffect(function()
		local viewportAutoplayController = p.viewportAutoplayController

		if not viewportAutoplayController then
			return
		end

		viewportAutoplayController:setWinnerLineOffsetFromTopBarPx(defineFastInt)

		viewportAutoplayController:setFeedScopeRef(p.scrollingFrameRef)
		viewportAutoplayController:setViewPortBounds(v)
	end, { p.viewportAutoplayController, p.scrollingFrameRef, v })

	React.useEffect(function()
		local viewportAutoplayController = p.viewportAutoplayController

		if viewportAutoplayController then
			return function()
				viewportAutoplayController:setFeedScopeRef({ current = nil })

				if FFlagLuaAppOneByTwoHoverIdleAutoplay then
					viewportAutoplayController:clearUserIntentCandidate()
				end

				viewportAutoplayController:reset(VideoEndReason.Unmounted)
			end
		end
	end, { p.viewportAutoplayController })

	return nil
end

return ViewportVideoAutoplaySync
