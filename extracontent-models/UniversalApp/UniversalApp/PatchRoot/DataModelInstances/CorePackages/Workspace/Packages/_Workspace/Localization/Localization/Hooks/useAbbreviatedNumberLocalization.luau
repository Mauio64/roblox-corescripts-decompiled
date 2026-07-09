local Localization = script:FindFirstAncestor("Localization")
local LocalizationParent = Localization.Parent
local LocalizationService = game:GetService("LocalizationService")
local React = require(LocalizationParent.React)
local abbreviateCount = require(Localization.abbreviateCount)
local LocalizationRoactContext = require(Localization.LocalizationRoactContext)
local useSignal = require(LocalizationParent.RoactUtils).Hooks.useSignal

local function useAbbreviatedNumberLocalization(n1: number?) -- line: 13
	-- upvalues: React (copy), LocalizationRoactContext (copy), LocalizationService (copy), useSignal (copy), abbreviateCount (copy)
	local v10 = React.useContext(LocalizationRoactContext)
	local v11, v12 = React.useState(LocalizationService.RobloxLocaleId)
	local v13 = React.useCallback(function(_) -- line: 18
		-- upvalues: v10 (copy), v11 (copy), v12 (copy)
		local Locale = v10:GetLocale()

		if Locale ~= v11 then
			v12(Locale)
		end
	end, { v10 })

	useSignal(v10.changed, v13)

	return React.useMemo(function() -- line: 27
		-- upvalues: n1 (copy), abbreviateCount (copy), v11 (copy)
		if n1 == nil then
			return nil
		end

		return abbreviateCount(n1, v11)
	end, {
		n1,
		v11
	})
end

return useAbbreviatedNumberLocalization
