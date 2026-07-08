local function createPlaybackToggleIndicatorMachine(t1: {[any]: any}, t2: {[any]: any}) -- line: 63
	local s1 = "hidden"
	local u5 = nil

	local function clearTimer() -- line: 71
		-- upvalues: u5 (ref)
		if u5 ~= nil then
			u5()
			u5 = nil
		end
	end
	local function onExitElapsed() -- line: 78
		-- upvalues: u5 (ref), s1 (ref), t2 (copy)
		u5 = nil
		s1 = "hidden"
		t2.setMounted(false)
	end
	local function beginExit() -- line: 85
		-- upvalues: u5 (ref), s1 (ref), t2 (copy), t1 (copy), onExitElapsed (copy)
		u5 = nil
		s1 = "exiting"
		t2.animate("exit")
		u5 = t2.schedule(t1.exitDurationMs, onExitElapsed)
	end
	local function armDwell() -- line: 93
		-- upvalues: u5 (ref), t2 (copy), t1 (copy), beginExit (copy)
		if u5 ~= nil then
			u5()
			u5 = nil
		end

		u5 = t2.schedule(t1.dwellMs, beginExit)
	end

	return {
		notifyUserToggle = function() -- line: 99
			-- upvalues: s1 (ref), t2 (copy), u5 (ref), t1 (copy), beginExit (copy)
			if s1 == "hidden" then
				s1 = "shown"
				t2.setMounted(true)
				t2.animate("enter")
			elseif s1 == "exiting" then
				s1 = "shown"
				t2.animate("enter")
			end

			if u5 ~= nil then
				u5()
				u5 = nil
			end

			u5 = t2.schedule(t1.dwellMs, beginExit)
		end,
		getPhase = function() -- line: 121
			-- upvalues: s1 (ref)
			return s1
		end,
		dispose = function() -- line: 115
			-- upvalues: u5 (ref)
			if u5 ~= nil then
				u5()
				u5 = nil
			end
		end
	}
end

return createPlaybackToggleIndicatorMachine
