local parent = script:FindFirstAncestor("Moments").Parent

local Signals = require(parent.Signals)

local createSignal = Signals.createSignal

local function createImmersiveChromeStore()
	local signal, v = createSignal(true)

	local v2 = nil

	local signal2, v3 = createSignal(false)

	return {
		getChromeVisible = signal,
		setChromeVisible = function(flag: boolean)
			v(flag)
		end,
		revealChrome = function()
			if v2 == nil then
				v(true)
			else
				v2()
			end
		end,
		setRevealHandler = function(callback)
			v2 = callback
		end,
		getOverlayCovering = signal2,
		setOverlayCovering = function(flag: boolean)
			v3(flag)
		end
	}
end

return createImmersiveChromeStore
