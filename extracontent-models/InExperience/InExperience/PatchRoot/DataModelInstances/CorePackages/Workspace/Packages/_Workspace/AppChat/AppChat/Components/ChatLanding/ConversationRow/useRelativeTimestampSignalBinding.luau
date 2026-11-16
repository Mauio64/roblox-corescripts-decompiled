local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local Time = require(parent.Time)
local DateTime = Time.DateTime
local getConversationTimestamp = require(AppChat.Utils.getConversationTimestamp)

local function computeTimestamp(p: number?)
	if p == nil then
		return ""
	end

	return getConversationTimestamp(DateTime.fromUnixTimestamp(p))
end

local function useRelativeTimestampSignalBinding(callback, callback2)
	local v = React.useState(function()
		local signal, setSignal = Signals.createSignal(0)
		return { signal = signal, setSignal = setSignal }
	end)

	React.useEffect(function()
		local flag = false
		local count = 0
		local function scheduleUpdate()
			task.delay(30, function()
				if flag then
					return
				end

				count += 1
				v.setSignal(count)
				scheduleUpdate()
			end)
		end

		task.delay(30, function()
			if flag then
				return
			end

			count += 1
			v.setSignal(count)
			scheduleUpdate()
		end)

		return function()
			flag = true
		end
	end, { v })

	local v2 = React.useCallback(function(p, p2)
		v.signal(p2)
		return computeTimestamp(callback2(p, p2))
	end, { v, callback2 })

	return SignalsReact.useSignalBinding(function(p)
		return v2(callback(p), p)
	end)
end

return useRelativeTimestampSignalBinding
