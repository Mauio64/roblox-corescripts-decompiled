local parent = script:FindFirstAncestor("Moments").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local View = Foundation.View
local useSignalState = SignalsReact.useSignalState

local MomentContext = require(script.Parent.Parent.MomentContext)
local useMomentGestures = require(script.Parent.useMomentGestures)
local useReactionCommit = require(script.Parent.useReactionCommit)

local function MomentGestureLayer(p)
	local v = MomentContext.useMoment()
	local controller = v.controller
	local store = v.store
	local v2 = useReactionCommit()

	local v3 = useSignalState(store.getIsModerated)
	local v4 = useSignalState(store.getIsScrubbing)

	local v5 = useMomentGestures(not (v3 or v4), {
		onSingleTapConfirmed = React.useCallback(function()
			if controller ~= nil then
				controller.toggle()
			end
		end, { controller }),
		onDoubleTap = React.useCallback(function(vector2: Vector2)
			v2("doubleTap", vector2, nil)
		end, { v2 })
	})

	return React.createElement(View, {
		ref = v5.ref,
		tag = "size-full",
		Active = true,
		BackgroundTransparency = 1,
		ZIndex = p.ZIndex
	})
end

return React.memo(MomentGestureLayer)
