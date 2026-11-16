local function createPlaybackToggleIndicatorMachine(p, data)
	local phase = "hidden"

	local v = nil

	local function clearTimer() -- 2 equivalent calls inferred from this helper
		if v ~= nil then
			v()
			v = nil
		end
	end

	local function onExitElapsed()
		v = nil
		phase = "hidden"
		data.setMounted(false)
	end

	local function beginExit()
		v = nil
		phase = "exiting"
		data.animate("exit")
		v = data.schedule(p.exitDurationMs, onExitElapsed)
	end

	local function armDwell() -- 1 equivalent call inferred from this helper
		clearTimer() -- inferred equivalent call
		v = data.schedule(p.dwellMs, beginExit)
	end

	return {
		notifyUserToggle = function()
			if phase == "hidden" then
				phase = "shown"
				data.setMounted(true)
				data.animate("enter")
			elseif phase == "exiting" then
				phase = "shown"
				data.animate("enter")
			end

			armDwell() -- inferred equivalent call
		end,
		getPhase = function()
			return phase
		end,
		dispose = function()
			clearTimer() -- inferred equivalent call
		end
	}
end

return createPlaybackToggleIndicatorMachine
