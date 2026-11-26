local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/TransientUIOverlay/Signals")

require("@game/CorePackages/Workspace/Packages/_Index/TransientUIOverlay/TransientUIOverlay/Types")

local function createTransientUIOverlayStore()
	local signal, v5 = Signals.createSignal(nil)
	local signal2, v6 = Signals.createSignal(nil)
	local signal3, v7 = Signals.createSignal(nil)
	local signal4, v8 = Signals.createSignal(0)

	local function setTimer(p2)
		v7(p2)
	end

	local function cancelTimer()
		local v9 = signal3(false)

		if v9 then
			task.cancel(v9)
			v7(nil)
		end
	end

	return {
		currentSnackbar = signal,
		currentDialog = signal2,
		dialogPresentationId = signal4,
		displaySnackbar = function(p2, duration)
			local v9 = signal3(false)

			if v9 then
				task.cancel(v9)
				v7(nil)
			end

			v5(p2)
			v7((task.delay(duration, function()
				v7(nil)

				v5(nil)
			end)))
		end,
		displayDialog = function(p2)
			v8(signal4(false) + 1)
			v6(p2)
		end,
		clearSnackbar = function()
			local v9 = signal3(false)

			if v9 then
				task.cancel(v9)
				v7(nil)
			end

			v5(nil)
		end,
		clearDialog = function()
			v6(nil)
		end
	}
end

return createTransientUIOverlayStore
