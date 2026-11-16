local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ViewRecyclerReact")

local FIntAppChatOsaAutoScrollDelayMs = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FIntAppChatOsaAutoScrollDelayMs")

local function useDelayedScrollToStart(p2, p3, p4)
	local ref = React.useRef(false)
	React.useEffect(function()
		if p3 then
			ref.current = false
			return nil
		end

		if not p2 or ref.current then
			return nil
		end

		ref.current = true
		local thread = nil
		thread = task.delay(FIntAppChatOsaAutoScrollDelayMs / 1000, function()
			thread = nil
			local current = p4.current

			if current ~= nil then
				current.scrollToStart()
			end
		end)
		return function()
			if thread ~= nil then
				task.cancel(thread)
				thread = nil

				ref.current = false
			end
		end
	end, { p2, p3 })
end

return useDelayedScrollToStart
