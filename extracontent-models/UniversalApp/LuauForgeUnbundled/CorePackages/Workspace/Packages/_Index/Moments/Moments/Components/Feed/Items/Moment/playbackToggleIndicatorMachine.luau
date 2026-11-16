local function createPlaybackToggleIndicatorMachine(p2, data)
	local phase = "hidden"

	local v5 = nil

	local function clearTimer()
		if v5 ~= nil then
			v5()
			v5 = nil
		end
	end

	local function onExitElapsed()
		v5 = nil
		phase = "hidden"
		data.setMounted(false)
	end

	local function beginExit()
		v5 = nil
		phase = "exiting"
		data.animate("exit")
		v5 = data.schedule(p2.exitDurationMs, onExitElapsed)
	end

	local function armDwell()
		if v5 ~= nil then
			v5()
			v5 = nil
		end

		v5 = data.schedule(p2.dwellMs, beginExit)
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

			if v5 ~= nil then
				v5()
				v5 = nil
			end

			v5 = data.schedule(p2.dwellMs, beginExit)
		end,
		getPhase = function()
			return phase
		end,
		dispose = function()
			if v5 ~= nil then
				v5()
				v5 = nil
			end
		end
	}
end

return createPlaybackToggleIndicatorMachine
