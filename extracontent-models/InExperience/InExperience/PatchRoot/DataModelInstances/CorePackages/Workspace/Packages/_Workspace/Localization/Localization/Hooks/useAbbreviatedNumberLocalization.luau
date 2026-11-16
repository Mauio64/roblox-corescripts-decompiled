local Localization = script:FindFirstAncestor("Localization")
local parent = Localization.Parent
local LocalizationService = game:GetService("LocalizationService")

local React = require(parent.React)
local abbreviateCount = require(Localization.abbreviateCount)
local LocalizationRoactContext = require(Localization.LocalizationRoactContext)
local RoactUtils = require(parent.RoactUtils)
local useSignal = RoactUtils.Hooks.useSignal

local function useAbbreviatedNumberLocalization(p: number?)
	local v = React.useContext(LocalizationRoactContext)

	local state, setState = React.useState(LocalizationService.RobloxLocaleId)

	local v2 = React.useCallback(function(_)
		local locale = v:GetLocale()

		if locale ~= state then
			setState(locale)
		end
	end, { v })

	useSignal(v.changed, v2)

	return React.useMemo(function()
		if p == nil then
			return nil
		end

		return abbreviateCount(p, state)
	end, { p, state })
end

return useAbbreviatedNumberLocalization
