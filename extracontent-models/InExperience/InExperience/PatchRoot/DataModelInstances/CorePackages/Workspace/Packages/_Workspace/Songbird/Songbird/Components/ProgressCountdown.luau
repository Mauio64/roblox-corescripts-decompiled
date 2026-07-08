local Songbird = script:FindFirstAncestor("Songbird")
local Cryo = require(Songbird.Parent.Cryo)
local React = require(Songbird.Parent.React)
local Foundation = require(Songbird.Parent.Foundation)
local useCallback = React.useCallback
local t1 = {
	counterType = "Remaining"
}

local function secondsToHHM(n1: number) -- line: 24
	local v10 = math.floor(n1 / 3600)
	local v11 = math.floor(n1 % 3600 / 60)
	local v12 = n1 % 60

	if v10 > 0 then
		return string.format("%i:%02i:%02i", v10, v11, v12)
	end

	return string.format("%i:%02i", v11, v12)
end
local function ProgressCountdown(t2: {[any]: any}) -- line: 36
	-- upvalues: Cryo (copy), t1 (copy), useCallback (copy), secondsToHHM (copy), React (copy), Foundation (copy)
	local v14 = Cryo.Dictionary.join(t1, t2)
	local v15 = useCallback(function(n2: number) -- line: 39
		-- upvalues: v14 (copy), secondsToHHM (copy)
		if v14.counterType == "Remaining" then
			local v17 = math.floor(v14.timeLength - n2)

			return "-" .. secondsToHHM(v17)
		end

		return secondsToHHM((math.ceil(n2)))
	end, { v14.timeLength })

	return React.createElement(Foundation.Text, {
		tag = {
			["auto-xy text-label-medium content-muted"] = true,
			["align-x-right"] = v14.counterType == "Remaining"
		},
		Text = v14.timePosition:map(v15),
		LayoutOrder = v14.LayoutOrder
	})
end

return ProgressCountdown
