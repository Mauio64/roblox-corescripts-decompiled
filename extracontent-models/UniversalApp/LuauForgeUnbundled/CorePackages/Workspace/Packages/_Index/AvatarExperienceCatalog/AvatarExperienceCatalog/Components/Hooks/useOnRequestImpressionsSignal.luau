local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local signal = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AppCommonLib").Signal

local function useOnRequestImpressionsSignal()
	local ref = React.useRef(nil)

	if ref.current == nil then
		ref.current = signal.new()
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
