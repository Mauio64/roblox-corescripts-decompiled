local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/Hooks/useMomentProgress")
local getColorStyleWithTransparency = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Utils/getColorStyleWithTransparency")

local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local function formatTime(duration)
	local v5 = math.max(0, duration)
	local v6 = math.floor(v5 / 60)
	local v7 = math.floor(v5 % 60)
	return string.format("%d:%02d", v6, v7)
end

local function TimeLabel(props)
	local v5 = useTokens()

	local mapped = props.progress:map(function(p2)
		local format = string.format
		local v6 = math.max(0, p2.time)
		local v7 = math.floor(v6 / 60)
		local v8 = math.floor(v6 % 60)
		return format("%s / %s", string.format("%d:%02d", v7, v8), formatTime(p2.duration))
	end)

	local mapped2 = props.animationRatio:map(function(p2)
		return getColorStyleWithTransparency(v5.Color.Content.Emphasis, 1 - p2)
	end)

	return React.createElement(text, {
		tag = "auto-xy text-label-medium content-emphasis",
		Text = mapped,
		textStyle = mapped2,
		LayoutOrder = props.LayoutOrder
	})
end

return React.memo(TimeLabel)
