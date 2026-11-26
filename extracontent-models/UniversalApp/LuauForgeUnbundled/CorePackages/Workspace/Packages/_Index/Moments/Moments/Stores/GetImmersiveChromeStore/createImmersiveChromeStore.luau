local createSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals").createSignal

local function createImmersiveChromeStore()
	local signal, v5 = createSignal(true)

	local v6 = nil

	local signal2, v7 = createSignal(false)

	return {
		getChromeVisible = signal,
		setChromeVisible = function(p2)
			v5(p2)
		end,
		revealChrome = function()
			if v6 == nil then
				v5(true)
			else
				v6()
			end
		end,
		setRevealHandler = function(p2)
			v6 = p2
		end,
		getOverlayCovering = signal2,
		setOverlayCovering = function(p2)
			v7(p2)
		end
	}
end

return createImmersiveChromeStore
