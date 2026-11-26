local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/React")
local useViewportBounds = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/ViewportUtils").useViewportBounds

require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/ViewportVideoAutoplayController")
local videoEndReason = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/Analytics/Enums").VideoEndReason

local fFlagLuaAppOneByTwoHoverIdleAutoplay = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppOneByTwoHoverIdleAutoplay

local defineFastInt = game:DefineFastInt("LuaAppVideoAutoplayWinnerLineOffsetFromTopBarPx", 240)

local function ViewportVideoAutoplaySync(p2): nil
	local v5 = useViewportBounds(p2.scrollingFrameRef)

	React.useEffect(function()
		local viewportAutoplayController = p2.viewportAutoplayController

		if not viewportAutoplayController then
			return
		end

		viewportAutoplayController:setWinnerLineOffsetFromTopBarPx(defineFastInt)

		viewportAutoplayController:setFeedScopeRef(p2.scrollingFrameRef)
		viewportAutoplayController:setViewPortBounds(v5)
	end, { p2.viewportAutoplayController, p2.scrollingFrameRef, v5 })

	React.useEffect(function()
		local viewportAutoplayController = p2.viewportAutoplayController

		if viewportAutoplayController then
			return function()
				viewportAutoplayController:setFeedScopeRef({ current = nil })

				if fFlagLuaAppOneByTwoHoverIdleAutoplay then
					viewportAutoplayController:clearUserIntentCandidate()
				end

				viewportAutoplayController:reset(videoEndReason.Unmounted)
			end
		end
	end, { p2.viewportAutoplayController })

	return nil
end

return ViewportVideoAutoplaySync
