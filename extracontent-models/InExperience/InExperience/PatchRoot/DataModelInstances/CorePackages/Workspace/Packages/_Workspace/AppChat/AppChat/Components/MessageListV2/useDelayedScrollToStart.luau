local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
require(parent.ViewRecycler)

local FIntAppChatOsaAutoScrollDelayMs = require(AppChat.Flags.FIntAppChatOsaAutoScrollDelayMs)

local function useDelayedScrollToStart(flag: boolean, flag2: boolean, p)
	local ref = React.useRef(false)
	React.useEffect(function()
		if flag2 then
			ref.current = false
			return nil
		end

		if not flag or ref.current then
			return nil
		end

		ref.current = true
		local thread = nil
		thread = task.delay(FIntAppChatOsaAutoScrollDelayMs / 1000, function()
			thread = nil
			local current = p.current

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
	end, { flag, flag2 })
end

return useDelayedScrollToStart
