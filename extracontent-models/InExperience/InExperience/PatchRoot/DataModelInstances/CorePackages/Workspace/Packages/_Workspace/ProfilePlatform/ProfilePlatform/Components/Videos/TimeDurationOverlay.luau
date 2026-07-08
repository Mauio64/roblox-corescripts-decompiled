local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text

local function formatTime(n1: number) -- line: 13
	local v9 = math.floor(n1 / 60)
	local v10 = math.floor(n1 % 60)

	return string.format("%02d:%02d", v9, v10)
end
local function TimeDurationOverlay(t1: {[any]: any}) -- line: 19
	-- upvalues: React (copy), formatTime (copy), View (copy), FoundationText (copy)
	local v12 = React.useMemo(function() -- line: 20
		-- upvalues: formatTime (copy), t1 (copy)
		return formatTime(t1.timeLength)
	end, { t1.timeLength })

	return React.createElement(View, {
		tag = "position-bottom-right anchor-bottom-right padding-bottom-medium padding-right-medium auto-xy",
		ZIndex = 20
	}, { React.createElement(View, {
		tag = "bg-over-media-100 radius-small size-1000-500",
		ZIndex = 21
	}, {
		DurationText = React.createElement(FoundationText, {
			tag = "text-label-small anchor-center-center position-center-center color-content-emphasis",
			Text = v12
		})
	}) })
end

return TimeDurationOverlay
