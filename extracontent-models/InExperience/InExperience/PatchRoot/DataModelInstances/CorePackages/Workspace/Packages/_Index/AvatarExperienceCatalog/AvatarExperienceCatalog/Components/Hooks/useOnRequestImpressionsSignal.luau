local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local React = require(parent.React)
local AppCommonLib = require(parent.AppCommonLib)
local Signal = AppCommonLib.Signal

local function useOnRequestImpressionsSignal()
	local ref = React.useRef(nil)

	if ref.current == nil then
		ref.current = Signal.new()
	end

	local current = ref.current

	React.useEffect(function()
		current:fire()

		local flag = false
		local thread = nil
		local function scheduleNext()
			if flag then
				return
			end

			thread = task.delay(1, function()
				if flag then
					return
				end

				current:fire()
				scheduleNext()
			end)
		end

		if not flag then
			thread = task.delay(1, function()
				if flag then
					return
				end

				current:fire()
				scheduleNext()
			end)
		end

		return function()
			flag = true

			if thread then
				task.cancel(thread)
				thread = nil
			end
		end
	end, {})

	return current
end

return useOnRequestImpressionsSignal
