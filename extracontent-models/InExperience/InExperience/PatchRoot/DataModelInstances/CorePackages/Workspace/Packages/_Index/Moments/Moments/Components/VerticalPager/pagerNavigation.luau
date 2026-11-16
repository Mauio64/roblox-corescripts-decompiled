local v = {
	[Enum.KeyCode.Up] = "VerticalPagerPrevious",
	[Enum.KeyCode.PageUp] = "VerticalPagerPrevious",
	[Enum.KeyCode.Down] = "VerticalPagerNext",
	[Enum.KeyCode.PageDown] = "VerticalPagerNext"
}

local v2 = {
	[Enum.KeyCode.DPadUp] = "VerticalPagerPrevious",
	[Enum.KeyCode.DPadDown] = "VerticalPagerNext"
}
local PagerNavigation = {}
PagerNavigation.PREVIOUS_EVENT = "VerticalPagerPrevious"
PagerNavigation.NEXT_EVENT = "VerticalPagerNext"
PagerNavigation.KEYBOARD_KEY_EVENTS = v
PagerNavigation.DPAD_KEY_EVENTS = v2

function PagerNavigation.buildEventMap(flag: boolean, p: string)
	if not flag then
		return {}
	end

	local clone = table.clone(v2)

	if p == "focused" then
		for k, v3 in v do
			clone[k] = v3
		end
	end

	return clone
end

function PagerNavigation.thumbstickDirection(p: number, p2: number): nil | string
	if math.abs(p) < p2 then
		return nil
	end

	return if p2 <= p then "previous" else "next"
end

function PagerNavigation.shouldTrackDrag(flag: boolean, flag2: boolean)
	return not flag or flag2
end

function PagerNavigation.resolveWheelGesture(p: number, p2: number, p3: number)
	return p3 <= p - p2, p
end

return PagerNavigation
