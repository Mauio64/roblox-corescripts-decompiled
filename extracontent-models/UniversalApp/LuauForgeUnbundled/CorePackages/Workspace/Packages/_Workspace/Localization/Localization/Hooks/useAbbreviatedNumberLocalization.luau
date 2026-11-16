local LocalizationService = game:GetService("LocalizationService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Localization/React")
local abbreviateCount = require("@game/CorePackages/Workspace/Packages/_Workspace/Localization/Localization/abbreviateCount")
local LocalizationRoactContext = require("@game/CorePackages/Workspace/Packages/_Workspace/Localization/Localization/LocalizationRoactContext")
local useSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/Localization/RoactUtils").Hooks.useSignal

local function useAbbreviatedNumberLocalization(p2)
	local v5 = React.useContext(LocalizationRoactContext)

	local state, setState = React.useState(LocalizationService.RobloxLocaleId)

	local v6 = React.useCallback(function(p3)
		local locale = v5:GetLocale()

		if locale ~= state then
			setState(locale)
		end
	end, { v5 })

	useSignal(v5.changed, v6)

	return React.useMemo(function()
		if p2 == nil then
			return nil
		end

		return abbreviateCount(p2, state)
	end, { p2, state })
end

return useAbbreviatedNumberLocalization
