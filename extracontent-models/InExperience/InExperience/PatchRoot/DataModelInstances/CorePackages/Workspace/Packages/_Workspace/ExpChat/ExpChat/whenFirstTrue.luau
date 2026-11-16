local parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(parent.Signals)

local function whenFirstTrue(callback, callback2)
	local v = false
	return Signals.createEffect(function(p)
		if v or not callback(p) then
			return
		end

		v = true
		callback2()
	end)
end

return whenFirstTrue
