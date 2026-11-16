local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local Time = require(parent.Time)
local DateTime = Time.DateTime
local getConversationTimestamp = require(AppChat.Utils.getConversationTimestamp)

local function computeTimestamp(p: number?)
	if p == nil then
		return ""
	end

	return getConversationTimestamp(DateTime.fromUnixTimestamp(p))
end

local function useRelativeTimestampBinding(p: number?)
	local v, v2 = React.useBinding(computeTimestamp(p))

	React.useEffect(function()
		v2(computeTimestamp(p))

		if p == nil then
			return function() end
		end

		local flag = false
		local function scheduleUpdate()
			task.delay(30, function()
				if flag then
					return
				end

				v2(computeTimestamp(p))
				scheduleUpdate()
			end)
		end

		task.delay(30, function()
			if flag then
				return
			end

			v2(computeTimestamp(p))
			scheduleUpdate()
		end)

		return function()
			flag = true
		end
	end, { p })

	return v
end

return useRelativeTimestampBinding
