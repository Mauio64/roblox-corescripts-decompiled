local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local view = Foundation.View
local useSignalState = SignalsReact.useSignalState

local MomentContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentContext")
local useMomentGestures = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/Reactions/useMomentGestures")
local useReactionCommit = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/Reactions/useReactionCommit")

local function MomentGestureLayer(p2)
	local v5 = MomentContext.useMoment()
	local controller = v5.controller
	local store = v5.store
	local v6 = useReactionCommit()

	local v7 = useSignalState(store.getIsModerated)
	local v8 = useSignalState(store.getIsScrubbing)

	local v11 = useMomentGestures(not (v7 or v8), {
		onSingleTapConfirmed = React.useCallback(function()
			if controller ~= nil then
				controller.toggle()
			end
		end, { controller }),
		onDoubleTap = React.useCallback(function(p3)
			v6("doubleTap", p3, nil)
		end, { v6 })
	})

	return React.createElement(view, {
		ref = v11.ref,
		tag = "size-full",
		Active = true,
		BackgroundTransparency = 1,
		ZIndex = p2.ZIndex
	})
end

return React.memo(MomentGestureLayer)
