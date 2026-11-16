local formFactor = require("@luauforge/bundled/dDI").Enums.FormFactor
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local fFlagSignalsNavP3hMisc = SharedFlags.FFlagSignalsNavP3hMisc
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors

return function(p2, p3)
	local name

	if not fFlagSignalsNavP3hMisc then
		local v5

		if fFlagUseNavigationSelectors then
			v5 = selectors.selectCurrentLegacyRoute(p2)
		else
			v5 = p2.Navigation.history[#p2.Navigation.history]
		end

		name = v5[#v5].name
	end

	return {
		currentAppPage = name,
		wideMode = p2.FormFactor == formFactor.WIDE
	}
end
