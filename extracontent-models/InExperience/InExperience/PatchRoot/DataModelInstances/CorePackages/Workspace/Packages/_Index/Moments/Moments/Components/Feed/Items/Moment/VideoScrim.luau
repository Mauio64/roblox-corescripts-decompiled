local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local getColorStyleWithTransparency = require(Moments.Utils.getColorStyleWithTransparency)
local MomentContext = require(script.Parent.MomentContext)

local useTokens = Foundation.Hooks.useTokens
local useSignalState = SignalsReact.useSignalState

local function VideoScrim(p)
	local v = useTokens()
	local v2 = MomentContext.useMoment()
	local active = useSignalState(v2.store.getIsScrubbing)

	local mapped = v2.animationRatio:map(function(p2: number)
		return getColorStyleWithTransparency(v.Color.Common.Scrim, 1 - p2).Transparency or 0
	end)

	return React.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = v.Color.Common.Scrim.Color3,
		BackgroundTransparency = mapped,
		BorderSizePixel = 0,
		Active = active,
		ZIndex = p.ZIndex
	})
end

return React.memo(VideoScrim)
