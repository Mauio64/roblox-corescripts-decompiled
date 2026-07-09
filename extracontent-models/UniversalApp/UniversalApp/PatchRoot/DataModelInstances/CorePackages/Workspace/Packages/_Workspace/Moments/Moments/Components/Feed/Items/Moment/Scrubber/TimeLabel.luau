local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local Foundation = require(MomentsParent.Foundation)
local React = require(MomentsParent.React)

require(script.Parent.Parent.Hooks.useMomentProgress)

local getColorStyleWithTransparency = require(Moments.Utils.getColorStyleWithTransparency)
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local function formatTime(n1: number) -- line: 13
	local v11 = math.max(0, n1)
	local v12 = math.floor(v11 / 60)
	local v13 = math.floor(v11 % 60)

	return string.format("%d:%02d", v12, v13)
end
local function TimeLabel(t1: {[any]: any}) -- line: 28
	-- upvalues: useTokens (copy), formatTime (copy), getColorStyleWithTransparency (copy), React (copy), FoundationText (copy)
	local v15 = useTokens()
	local v16 = t1.progress:map(function(p1) -- line: 31
		-- upvalues: formatTime (copy)
		local format = string.format
		local v20 = math.max(0, p1.time)
		local v21 = math.floor(v20 / 60)
		local v22 = math.floor(v20 % 60)

		return format("%s / %s", string.format("%d:%02d", v21, v22), formatTime(p1.duration))
	end)
	local v17 = t1.animationRatio:map(function(n2: number) -- line: 35
		-- upvalues: getColorStyleWithTransparency (copy), v15 (copy)
		return getColorStyleWithTransparency(v15.Color.Content.Emphasis, 1 - n2)
	end)

	return React.createElement(FoundationText, {
		tag = "auto-xy text-label-medium content-emphasis",
		Text = v16,
		textStyle = v17,
		LayoutOrder = t1.LayoutOrder
	})
end

return React.memo(TimeLabel)
