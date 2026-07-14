local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)
local Localization = require(ParentParent.InExperienceLocales).Localization
local useRobloxLocale = require(script.Parent.useRobloxLocale)

local function useInExperienceLocalization() -- line: 12
	-- upvalues: useRobloxLocale (copy), React (copy), Localization (copy)
	local v6 = useRobloxLocale()

	return React.useMemo(function() -- line: 14
		-- upvalues: Localization (copy), v6 (copy)
		local v7 = Localization.new(v6)

		return function(s1: string, t1: {[any]: any}?) -- line: 16
			-- upvalues: v7 (copy)
			return v7:Format(s1, t1)
		end
	end, { v6 })
end

return useInExperienceLocalization
