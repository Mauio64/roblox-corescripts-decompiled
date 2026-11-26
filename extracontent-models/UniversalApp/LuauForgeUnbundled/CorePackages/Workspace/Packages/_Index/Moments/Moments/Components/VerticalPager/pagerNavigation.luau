local v5 = {
	[Enum.KeyCode.Up] = "VerticalPagerPrevious",
	[Enum.KeyCode.PageUp] = "VerticalPagerPrevious",
	[Enum.KeyCode.Down] = "VerticalPagerNext",
	[Enum.KeyCode.PageDown] = "VerticalPagerNext"
}

local v6 = {
	[Enum.KeyCode.DPadUp] = "VerticalPagerPrevious",
	[Enum.KeyCode.DPadDown] = "VerticalPagerNext"
}

return {
	PREVIOUS_EVENT = "VerticalPagerPrevious",
	NEXT_EVENT = "VerticalPagerNext",
	KEYBOARD_KEY_EVENTS = v5,
	DPAD_KEY_EVENTS = v6,
	buildEventMap = function(p2, p3)
		if not p2 then
			return {}
		end

		local clone = table.clone(v6)

		if p3 == "focused" then
			for k, v7 in v5 do
				clone[k] = v7
			end
		end

		return clone
	end,
	thumbstickDirection = function(p2, p3): nil | string
		if math.abs(p2) < p3 then
			return nil
		end

		if p3 <= p2 then
			return "previous"
		end

		return "next"
	end,
	shouldTrackDrag = function(p2, p3)
		if p2 then
			return p3
		end

		return true
	end,
	resolveWheelGesture = function(p2, p3, p4)
		return p4 <= p2 - p3, p2
	end
}
