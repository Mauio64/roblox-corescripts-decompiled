local RealtimeDelivery = script:FindFirstAncestor("RealtimeDelivery")
local React = require(RealtimeDelivery.Parent.React)

require(script.Parent.TopicEventReceiver)
local TopicRealtimeContext = require(script.Parent.TopicRealtimeContext)

local function useTopicNotification(p: string?, current, p2)
	local v = React.useContext(TopicRealtimeContext)
	local ref = React.useRef(current)
	local onError

	if p2 then
		onError = p2.onError
	else
		onError = nil
	end

	local ref2 = React.useRef(onError)
	local ref3 = React.useRef(nil)

	React.useEffect(function()
		ref.current = current
	end, { current })

	React.useEffect(function()
		ref2.current = onError
	end, { onError or false })

	React.useEffect(function()
		local current2 = ref3.current
		local current4

		if p then
			current4 = v:observeTopic(p, function(p3)
				ref.current(p3)
			end, {
				onError = function(p3)
					local current3 = ref2.current

					if current3 then
						current3(p3)
					end
				end
			})
		end

		ref3.current = current4

		if current2 then
			current2:disconnect()
		end
	end, { p or false, v })

	React.useEffect(function()
		return function()
			local current2 = ref3.current
			ref3.current = nil

			if current2 then
				current2:disconnect()
			end
		end
	end, {})
end

return useTopicNotification
