local t1 = {
	[Enum.KeyCode.Up] = "VerticalPagerPrevious",
	[Enum.KeyCode.PageUp] = "VerticalPagerPrevious",
	[Enum.KeyCode.Down] = "VerticalPagerNext",
	[Enum.KeyCode.PageDown] = "VerticalPagerNext"
}
local t2 = {
	[Enum.KeyCode.DPadUp] = "VerticalPagerPrevious",
	[Enum.KeyCode.DPadDown] = "VerticalPagerNext"
}

return {
	PREVIOUS_EVENT = "VerticalPagerPrevious",
	NEXT_EVENT = "VerticalPagerNext",
	KEYBOARD_KEY_EVENTS = t1,
	DPAD_KEY_EVENTS = t2,
	buildEventMap = function(b1: boolean, s1: string) -- line: 40
		-- upvalues: t2 (copy), t1 (copy)
		if not b1 then
			return {}
		end

		local v5 = table.clone(t2)

		if s1 == "focused" then
			for v6, v7 in t1 do
				v5[v6] = v7
			end
		end

		return v5
	end,
	thumbstickDirection = function(n1: number, n2: number) -- line: 59
		if n2 > math.abs(n1) then
			return nil
		end

		if n2 <= n1 then
			return "previous"
		end

		return "next"
	end,
	shouldTrackDrag = function(b2: boolean, b3: boolean) -- line: 77
		if not b2 then
			return true
		end

		return b3
	end,
	resolveWheelGesture = function(n3: number, n4: number, n5: number) -- line: 99
		return n5 <= n3 - n4, n3
	end
}
