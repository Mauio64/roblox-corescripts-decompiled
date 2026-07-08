local v1 = game:DefineFastString("RccInExperienceNameSettingsEnabledAllowList", "")
local t1 = nil

return {
	isAllowListedUserId = function(p1) -- line: 7
		-- upvalues: t1 (ref), v1 (copy)
		local str = tostring(p1)

		if t1 == nil then
			t1 = {}

			for match in string.gmatch(v1, "[^,]+") do
				t1[match] = true
			end
		end

		return t1[str] == true
	end
}
