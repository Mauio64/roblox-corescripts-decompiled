local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

require(script.Parent.Parent.Hooks.useMomentProgress)
local getColorStyleWithTransparency = require(Moments.Utils.getColorStyleWithTransparency)

local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local function formatTime(duration: number) -- 1 equivalent call inferred from this helper
	local v = math.max(0, duration)
	local v2 = math.floor(v / 60)
	local v3 = math.floor(v % 60)
	return string.format("%d:%02d", v2, v3)
end

local function TimeLabel(props)
	local v = useTokens()

	local mapped = props.progress:map(function(p)
		return string.format("%s / %s", formatTime(p.time), formatTime(p.duration)) -- inferred equivalent call
	end)

	local mapped2 = props.animationRatio:map(function(p: number)
		return getColorStyleWithTransparency(v.Color.Content.Emphasis, 1 - p)
	end)

	return React.createElement(Text, {
		tag = "auto-xy text-label-medium content-emphasis",
		Text = mapped,
		textStyle = mapped2,
		LayoutOrder = props.LayoutOrder
	})
end

return React.memo(TimeLabel)
