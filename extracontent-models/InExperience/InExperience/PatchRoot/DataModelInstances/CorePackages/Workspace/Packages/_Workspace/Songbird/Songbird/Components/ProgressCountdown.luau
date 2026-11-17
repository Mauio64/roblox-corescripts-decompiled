local Songbird = script:FindFirstAncestor("Songbird")

local Cryo = require(Songbird.Parent.Cryo)
local React = require(Songbird.Parent.React)
local Foundation = require(Songbird.Parent.Foundation)

local useCallback = React.useCallback

local v = { counterType = "Remaining" }

local function secondsToHHM(p: number)
	local v2 = math.floor(p / 3600)
	local v3 = math.floor(p % 3600 / 60)
	local v4 = p % 60

	if v2 > 0 then
		return string.format("%i:%02i:%02i", v2, v3, v4)
	end

	return string.format("%i:%02i", v3, v4)
end

local function ProgressCountdown(p)
	local joined = Cryo.Dictionary.join(v, p)

	local v2 = useCallback(function(p2: number)
		if joined.counterType ~= "Remaining" then
			return secondsToHHM(math.ceil(p2))
		end

		return "-" .. secondsToHHM(math.floor(joined.timeLength - p2))
	end, { joined.timeLength })

	return React.createElement(Foundation.Text, {
		tag = {
			["auto-xy text-label-medium content-muted"] = true,
			["align-x-right"] = joined.counterType == "Remaining"
		},
		Text = joined.timePosition:map(v2),
		LayoutOrder = joined.LayoutOrder
	})
end

return ProgressCountdown
