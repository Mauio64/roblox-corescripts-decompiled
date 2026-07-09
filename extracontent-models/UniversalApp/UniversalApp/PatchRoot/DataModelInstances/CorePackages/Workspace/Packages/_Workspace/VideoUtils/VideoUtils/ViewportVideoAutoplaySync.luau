local VideoUtils = script:FindFirstAncestor("VideoUtils")
local VideoUtilsParent = VideoUtils.Parent
local React = require(VideoUtilsParent.React)
local useViewportBounds = require(VideoUtilsParent.ViewportUtils).useViewportBounds

require(VideoUtils.ViewportVideoAutoplayController)

local VideoEndReason = require(VideoUtils.Analytics.Enums).VideoEndReason
local v6 = game:DefineFastInt("LuaAppVideoAutoplayWinnerLineOffsetFromTopBarPx", 240)

local function ViewportVideoAutoplaySync(t1: {[any]: any}) -- line: 20
	-- upvalues: useViewportBounds (copy), React (copy), v6 (copy), VideoEndReason (copy)
	local v9 = useViewportBounds(t1.scrollingFrameRef)

	React.useEffect(function() -- line: 25
		-- upvalues: t1 (copy), v6 (copy), v9 (copy)
		local viewportAutoplayController = t1.viewportAutoplayController

		if not viewportAutoplayController then
			return
		end

		viewportAutoplayController:setWinnerLineOffsetFromTopBarPx(v6)
		viewportAutoplayController:setFeedScopeRef(t1.scrollingFrameRef)
		viewportAutoplayController:setViewPortBounds(v9)
	end, {
		t1.viewportAutoplayController,
		t1.scrollingFrameRef,
		v9
	})
	React.useEffect(function() -- line: 45
		-- upvalues: t1 (copy), VideoEndReason (copy)
		local viewportAutoplayController = t1.viewportAutoplayController

		if not viewportAutoplayController then
			return
		end

		return function() -- line: 51
			-- upvalues: viewportAutoplayController (copy), VideoEndReason (copy)
			viewportAutoplayController:setFeedScopeRef({
				current = nil
			})
			viewportAutoplayController:reset(VideoEndReason.Unmounted)
		end
	end, { t1.viewportAutoplayController })

	return nil
end

return ViewportVideoAutoplaySync
