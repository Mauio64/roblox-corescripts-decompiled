local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Foundation")

local useCallback = React.useCallback

local v5 = { counterType = "Remaining" }

local function secondsToHHM(p2)
	local v6 = math.floor(p2 / 3600)
	local v7 = math.floor(p2 % 3600 / 60)
	local v8 = p2 % 60

	if v6 > 0 then
		return string.format("%i:%02i:%02i", v6, v7, v8)
	end

	return string.format("%i:%02i", v7, v8)
end

local function ProgressCountdown(p2)
	local joined = Cryo.Dictionary.join(v5, p2)

	local v6 = useCallback(function(p3)
		if joined.counterType ~= "Remaining" then
			return secondsToHHM(math.ceil(p3))
		end

		return "-" .. secondsToHHM(math.floor(joined.timeLength - p3))
	end, { joined.timeLength })

	return React.createElement(Foundation.Text, {
		tag = {
			["auto-xy text-label-medium content-muted"] = true,
			["align-x-right"] = joined.counterType == "Remaining"
		},
		Text = joined.timePosition:map(v6),
		LayoutOrder = joined.LayoutOrder
	})
end

return ProgressCountdown
