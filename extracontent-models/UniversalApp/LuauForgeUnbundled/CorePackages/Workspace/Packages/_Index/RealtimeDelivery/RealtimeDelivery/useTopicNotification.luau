local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RealtimeDelivery/React")

require("@game/CorePackages/Workspace/Packages/_Index/RealtimeDelivery/RealtimeDelivery/TopicEventReceiver")
local RealtimeContext = require("@game/CorePackages/Workspace/Packages/_Index/RealtimeDelivery/RealtimeDelivery/RealtimeContext")

local function useTopicNotification(p2, current, p3)
	local v5 = React.useContext(RealtimeContext)
	local ref = React.useRef(current)
	local onError = if p3 then p3.onError else nil
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
		local v6 = ref3
		local v7

		if p2 then
			v7 = v5:observeTopic(p2, function(p4)
				ref.current(p4)
			end, {
				onError = function(p4)
					local current3 = ref2.current

					if current3 then
						current3(p4)
					end
				end
			})
		end

		v6.current = v7

		if current2 then
			current2:disconnect()
		end
	end, { p2 or false, v5 })

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
