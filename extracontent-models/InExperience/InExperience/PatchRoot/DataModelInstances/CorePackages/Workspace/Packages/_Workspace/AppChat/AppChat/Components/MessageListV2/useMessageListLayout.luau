local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local ViewRecycler = require(parent.ViewRecycler)

local FIntAppChatMessageListV2EstimatedRowHeight = require(AppChat.Flags.FIntAppChatMessageListV2EstimatedRowHeight)

local frozen = table.freeze({ accepted = false, geometryChanged = false })

local function rejectEmptyMeasurements(measured, fn) -- 1 equivalent call inferred from this helper
	local clone = table.clone(measured)
	function clone.updateItemMeasurement(p)
		if p.length <= 0 then
			return frozen
		end

		local v = measured.updateItemMeasurement(p)
		fn()
		return v
	end

	return clone
end

local function useMessageListLayout(current)
	local ref = React.useRef(current)
	ref.current = current
	local v = React.useState(function()
		local flag = false

		local measured = ViewRecycler.Layout.measured({
			estimatedItemLength = FIntAppChatMessageListV2EstimatedRowHeight
		})

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

		return rejectEmptyMeasurements(measured, fn) -- inferred equivalent call
	end)

	React.useEffect(function()
		return function()
			ref.current = nil
			v.destroy()
		end
	end, { v })
	return v
end

return useMessageListLayout
