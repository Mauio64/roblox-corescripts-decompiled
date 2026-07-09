local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local React = require(Parent.React)
local Signal = require(Parent.AppCommonLib).Signal

local function useOnRequestImpressionsSignal() -- line: 20
	-- upvalues: React (copy), Signal (copy)
	local v5 = React.useRef(nil)

	if v5.current == nil then
		v5.current = Signal.new()
	end

	local current = v5.current

	React.useEffect(function() -- line: 29
		-- upvalues: current (copy)
		current:fire()

		local u7 = false
		local thread = nil

		local function scheduleNext() -- line: 37
			-- upvalues: u7 (ref), thread (ref), current (copy), scheduleNext (copy)
			if u7 then
				return
			end

			thread = task.delay(1, function() -- line: 41
				-- upvalues: u7 (ref), current (copy), scheduleNext (copy)
				if u7 then
					return
				end

				current:fire()
				scheduleNext()
			end)
		end

		if not u7 then
			thread = task.delay(1, function() -- line: 41
				-- upvalues: u7 (ref), current (copy), scheduleNext (copy)
				if u7 then
					return
				end

				current:fire()
				scheduleNext()
			end)
		end

		return function() -- line: 51
			-- upvalues: u7 (ref), thread (ref)
			u7 = true

			if thread then
				task.cancel(thread)
				thread = nil
			end
		end
	end, {})

	return current
end

return useOnRequestImpressionsSignal
