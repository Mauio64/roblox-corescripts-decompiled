local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local dateTime = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Time").DateTime
local getConversationTimestamp = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getConversationTimestamp")

local function computeTimestamp(p2)
	if p2 == nil then
		return ""
	end

	return getConversationTimestamp(dateTime.fromUnixTimestamp(p2))
end

local function useRelativeTimestampBinding(p2)
	local v5, v6 = React.useBinding(computeTimestamp(p2))

	React.useEffect(function()
		v6(computeTimestamp(p2))

		if p2 == nil then
			return function() end
		end

		local flag = false
		local function scheduleUpdate()
			task.delay(30, function()
				if flag then
					return
				end

				v6(computeTimestamp(p2))
				scheduleUpdate()
			end)
		end

		task.delay(30, function()
			if flag then
				return
			end

			v6(computeTimestamp(p2))
			scheduleUpdate()
		end)

		return function()
			flag = true
		end
	end, { p2 })

	return v5
end

return useRelativeTimestampBinding
