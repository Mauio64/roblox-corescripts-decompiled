local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local InExperienceLocales = require(parent.InExperienceLocales)
local Localization = InExperienceLocales.Localization

local useRobloxLocale = require(script.Parent.useRobloxLocale)

local function useInExperienceLocalization()
	local v = useRobloxLocale()
	return React.useMemo(function()
		local v2 = Localization.new(v)
		return function(p: string, p2)
			return v2:Format(p, p2)
		end
	end, { v })
end

return useInExperienceLocalization
