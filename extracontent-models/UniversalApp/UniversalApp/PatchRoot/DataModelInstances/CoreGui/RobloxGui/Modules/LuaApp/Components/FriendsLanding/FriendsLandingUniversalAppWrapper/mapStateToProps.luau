local CorePackages = game:GetService("CorePackages")
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local FFlagSignalsNavP3hMisc = SharedFlags.FFlagSignalsNavP3hMisc
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors

return function(p1, _) -- line: 8
	-- upvalues: FFlagSignalsNavP3hMisc (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), FormFactor (copy)
	local name = nil

	if not FFlagSignalsNavP3hMisc then
		local v10 = if not FFlagUseNavigationSelectors then p1.Navigation.history[#p1.Navigation.history] else Selectors.selectCurrentLegacyRoute(p1)

		name = v10[#v10].name
	end

	return {
		currentAppPage = name,
		wideMode = p1.FormFactor == FormFactor.WIDE
	}
end
