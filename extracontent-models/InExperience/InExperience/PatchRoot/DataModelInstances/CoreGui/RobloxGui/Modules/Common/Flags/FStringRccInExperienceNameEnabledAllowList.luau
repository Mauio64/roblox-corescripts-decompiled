local defineFastString = game:DefineFastString("RccInExperienceNameSettingsEnabledAllowList", "")

local set = nil

return {
	isAllowListedUserId = function(p): boolean
		local v = tostring(p)

		if set == nil then
			set = {}

			for k in string.gmatch(defineFastString, "[^,]+") do
				set[k] = true
			end
		end

		return set[v] == true
	end
}
