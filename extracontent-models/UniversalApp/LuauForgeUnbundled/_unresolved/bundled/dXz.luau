local module = require("@luauforge/bundled/dFu")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local fFlagSignalsNavP3hMisc = SharedFlags.FFlagSignalsNavP3hMisc
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux")
local selectors = NavigationRodux.Selectors

local module4 = require("@luauforge/bundled/dGJ")

local getLegacyNavigationStore = if fFlagSignalsNavP3hMisc then NavigationRodux.GetLegacyNavigationStore else nil

local function getDefaultRoute()
	return {
		{ name = module.Home }
	}
end

return function(object, p2)
	local v5

	if fFlagSignalsNavP3hMisc then
		v5 = getLegacyNavigationStore(false).getHistory(false)
	else
		local state = object:getState()

		if fFlagUseNavigationSelectors then
			v5 = selectors.selectLegacyHistory(state)
		else
			v5 = state.Navigation.history
		end
	end

	local v6 = v5[#v5] or {
		{ name = module.Home }
	}

	local v7 = {}

	for i = 1, #v6 do
		local name = v6[i].name

		if not (module4[name] and module4[name].isPeekView) then
			v7[#v7 + 1] = v6[i]
		end
	end

	v7[#v7 + 1] = p2
	local v8 = #v7 == 0 and {
		{ name = module.Home }
	} or v7

	local v9 = {}

	for i = 1, #v8 do
		local v10 = {}

		for j = 1, i do
			v10[#v10 + 1] = v8[j]
		end

		v9[#v9 + 1] = v10
	end

	return { newRoute = v8, newHistory = v9 }
end
