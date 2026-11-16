local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local ViewRecyclerReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ViewRecyclerReact")

local FIntAppChatMessageListV2EstimatedRowHeight = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FIntAppChatMessageListV2EstimatedRowHeight")

local frozen = table.freeze({ accepted = false, geometryChanged = false })

local function rejectEmptyMeasurements(p2, callback)
	local clone = table.clone(p2)
	function clone.updateItemMeasurement(p3)
		if p3.length <= 0 then
			return frozen
		end

		local v5 = p2.updateItemMeasurement(p3)
		callback()
		return v5
	end

	return clone
end

local function useMessageListLayout(current)
	local ref = React.useRef(current)
	ref.current = current
	local v5 = React.useState(function()
		local flag = false

		local measured = ViewRecyclerReact.Layout.measured({ estimatedItemLength = FIntAppChatMessageListV2EstimatedRowHeight })

		local function fn()
			if flag then
				return
			end

			flag = true

			task.defer(function()
				local current2 = ref.current

				if current2 ~= nil then
					current2()
				end
			end)
		end

		local clone = table.clone(measured)
		function clone.updateItemMeasurement(p2)
			if p2.length <= 0 then
				return frozen
			end

			local v6 = measured.updateItemMeasurement(p2)
			fn()
			return v6
		end

		return clone
	end)

	React.useEffect(function()
		return function()
			ref.current = nil
			v5.destroy()
		end
	end, { v5 })
	return v5
end

return useMessageListLayout
