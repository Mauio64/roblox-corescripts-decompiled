local Parent = script:FindFirstAncestor("AvatarExperienceInitialization").Parent
local React = require(Parent.React)
local MessageBus = require(Parent.MessageBus).MessageBus
local v4 = game:DefineFastInt("AXAvatarUpdateOnGameLeaveDelay", 0)

local function gameLeaveMessageValidator(p1) -- line: 17
	return typeof(p1) == "table"
end
local function useAvatarUpdateOnGameLeave(p2: ((...any) -> ...any)) -- line: 21
	-- upvalues: React (copy), MessageBus (copy), gameLeaveMessageValidator (copy), v4 (copy)
	React.useEffect(function() -- line: 22
		-- upvalues: MessageBus (copy), gameLeaveMessageValidator (copy), v4 (copy), p2 (copy)
		local v9 = MessageBus.Subscriber.new()
		local v10 = MessageBus.getMessageId("Game", "onGameLeave")
		local thread = nil

		v9:subscribe({
			mid = v10,
			validateParams = gameLeaveMessageValidator
		}, function(_) -- line: 30
			-- upvalues: thread (ref), v4 (copy), p2 (copy)
			thread = task.delay(v4 / 1000, function() -- line: 31
				-- upvalues: p2 (copy)
				p2()
			end)
		end)

		return function() -- line: 36
			-- upvalues: v9 (copy), v10 (copy), thread (ref)
			v9:unsubscribeWithMsgId(v10)

			if thread then
				task.cancel(thread)
			end
		end
	end, { p2 })
end

return useAvatarUpdateOnGameLeave
