local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local DateTime = require(AppChatParent.Time).DateTime
local getConversationTimestamp = require(AppChat.Utils.getConversationTimestamp)

local function computeTimestamp(n1: number?) -- line: 10
	-- upvalues: getConversationTimestamp (copy), DateTime (copy)
	if n1 == nil then
		return ""
	end

	return getConversationTimestamp(DateTime.fromUnixTimestamp(n1))
end
local function useRelativeTimestampBinding(n2: number?) -- line: 17
	-- upvalues: React (copy), computeTimestamp (copy)
	local v10, v11 = React.useBinding(computeTimestamp(n2))

	React.useEffect(function() -- line: 20
		-- upvalues: v11 (copy), computeTimestamp (copy), n2 (copy)
		v11(computeTimestamp(n2))

		if n2 == nil then
			return function() -- line: 24
			end
		end

		local u12 = false

		local function scheduleUpdate() -- line: 29
			-- upvalues: u12 (ref), v11 (copy), computeTimestamp (copy), n2 (copy), scheduleUpdate (copy)
			task.delay(30, function() -- line: 30
				-- upvalues: u12 (ref), v11 (copy), computeTimestamp (copy), n2 (copy), scheduleUpdate (copy)
				if u12 then
					return
				end

				v11(computeTimestamp(n2))
				scheduleUpdate()
			end)
		end

		task.delay(30, function() -- line: 30
			-- upvalues: u12 (ref), v11 (copy), computeTimestamp (copy), n2 (copy), scheduleUpdate (copy)
			if u12 then
				return
			end

			v11(computeTimestamp(n2))
			scheduleUpdate()
		end)

		return function() -- line: 41
			-- upvalues: u12 (ref)
			u12 = true
		end
	end, { n2 })

	return v10
end

return useRelativeTimestampBinding
