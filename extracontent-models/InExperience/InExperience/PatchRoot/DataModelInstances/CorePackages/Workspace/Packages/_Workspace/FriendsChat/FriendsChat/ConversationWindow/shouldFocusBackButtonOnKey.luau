local set = { [Enum.KeyCode.Up] = true, [Enum.KeyCode.DPadUp] = true }

local function shouldFocusBackButtonOnKey(p, flag: boolean, p2: string?): boolean
	if not set[p] then
		return false
	end

	if flag then
		return p2 == nil or p2 == ""
	end

	return false
end

return shouldFocusBackButtonOnKey
