local TransientUIOverlay = script:FindFirstAncestor("TransientUIOverlay")
local parent = TransientUIOverlay.Parent

local Signals = require(parent.Signals)

require(TransientUIOverlay.Types)

local function createTransientUIOverlayStore()
	local signal, v = Signals.createSignal(nil)
	local signal2, v2 = Signals.createSignal(nil)
	local signal3, v3 = Signals.createSignal(nil)
	local signal4, v4 = Signals.createSignal(0)

	local function setTimer(thread: thread?) -- 3 equivalent calls inferred from this helper
		v3(thread)
	end

	local function cancelTimer() -- 2 equivalent calls inferred from this helper
		local v5 = signal3(false)

		if v5 then
			task.cancel(v5)
			setTimer(nil) -- inferred equivalent call
		end
	end

	return {
		currentSnackbar = signal,
		currentDialog = signal2,
		dialogPresentationId = signal4,
		displaySnackbar = function(p, duration: number)
			cancelTimer() -- inferred equivalent call
			v(p)
			setTimer(task.delay(duration, function() -- inferred equivalent call
				setTimer(nil) -- inferred equivalent call
				v(nil)
			end))
		end,
		displayDialog = function(p)
			v4(signal4(false) + 1)
			v2(p)
		end,
		clearSnackbar = function()
			cancelTimer() -- inferred equivalent call
			v(nil)
		end,
		clearDialog = function()
			v2(nil)
		end
	}
end

return createTransientUIOverlayStore
