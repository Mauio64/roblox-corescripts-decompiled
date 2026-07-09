local CorePackages = game:GetService("CorePackages")
local Modules = script:FindFirstAncestor("Modules")
local AppPage = require(Modules.LuaApp.AppPage)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local FFlagSignalsNavP3hMisc = SharedFlags.FFlagSignalsNavP3hMisc
local NavigationRodux = require(CorePackages.Workspace.Packages.NavigationRodux)
local Selectors = NavigationRodux.Selectors
local AppPageProperties = require(Modules.LuaApp.AppPageProperties)
local v10 = if not FFlagSignalsNavP3hMisc then nil else NavigationRodux.GetLegacyNavigationStore

local function getDefaultRoute() -- line: 16
	-- upvalues: AppPage (copy)
	return {{
		name = AppPage.Home
	}}
end

return function(p1, p2) -- line: 20
	-- upvalues: FFlagSignalsNavP3hMisc (copy), v10 (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), AppPage (copy), AppPageProperties (copy)
	local v14

	if FFlagSignalsNavP3hMisc then
		v14 = v10(false).getHistory(false)
	else
		local v15 = p1:getState()

		v14 = if not FFlagUseNavigationSelectors then v15.Navigation.history else Selectors.selectLegacyHistory(v15)
	end

	local v16 = v14[#v14] or {{
		name = AppPage.Home
	}}
	local t1 = {}

	for i = 1, #v16 do
		local name = v16[i].name

		if not AppPageProperties[name] or not AppPageProperties[name].isPeekView then
			t1[#t1 + 1] = v16[i]
		end
	end

	t1[#t1 + 1] = p2

	if #t1 == 0 then
		t1 = {{
			name = AppPage.Home
		}}
	end

	local t2 = {}

	for i = 1, #t1 do
		local t3 = {}

		for j = 1, i do
			t3[#t3 + 1] = t1[j]
		end

		t2[#t2 + 1] = t3
	end

	return {
		newRoute = t1,
		newHistory = t2
	}
end
