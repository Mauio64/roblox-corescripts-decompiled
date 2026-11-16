local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local getColorStyleWithTransparency = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Utils/getColorStyleWithTransparency")
local MomentContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentContext")

local useTokens = Foundation.Hooks.useTokens
local useSignalState = SignalsReact.useSignalState

local function VideoScrim(p2)
	local v5 = useTokens()
	local v6 = MomentContext.useMoment()
	local v7 = useSignalState(v6.store.getIsScrubbing)

	local mapped = v6.animationRatio:map(function(p3)
		return getColorStyleWithTransparency(v5.Color.Common.Scrim, 1 - p3).Transparency or 0
	end)

	return React.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = v5.Color.Common.Scrim.Color3,
		BackgroundTransparency = mapped,
		BorderSizePixel = 0,
		Active = v7,
		ZIndex = p2.ZIndex
	})
end

return React.memo(VideoScrim)
