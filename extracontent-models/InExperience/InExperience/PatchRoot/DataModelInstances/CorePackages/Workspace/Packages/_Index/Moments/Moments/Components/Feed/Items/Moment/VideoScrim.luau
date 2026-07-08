local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local Foundation = require(MomentsParent.Foundation)
local React = require(MomentsParent.React)
local SignalsReact = require(MomentsParent.SignalsReact)
local getColorStyleWithTransparency = require(Moments.Utils.getColorStyleWithTransparency)
local MomentContext = require(script.Parent.MomentContext)
local useTokens = Foundation.Hooks.useTokens
local useSignalState = SignalsReact.useSignalState

local function VideoScrim(t1: {[any]: any}) -- line: 29
	-- upvalues: useTokens (copy), MomentContext (copy), useSignalState (copy), getColorStyleWithTransparency (copy), React (copy)
	local v12 = useTokens()
	local v13 = MomentContext.useMoment()
	local v14 = useSignalState(v13.store.getIsScrubbing)
	local v15 = v13.animationRatio:map(function(n1: number) -- line: 35
		-- upvalues: getColorStyleWithTransparency (copy), v12 (copy)
		return getColorStyleWithTransparency(v12.Color.Common.Scrim, 1 - n1).Transparency or 0
	end)

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = v12.Color.Common.Scrim.Color3,
		BackgroundTransparency = v15,
		Active = v14,
		ZIndex = t1.ZIndex
	})
end

return React.memo(VideoScrim)
