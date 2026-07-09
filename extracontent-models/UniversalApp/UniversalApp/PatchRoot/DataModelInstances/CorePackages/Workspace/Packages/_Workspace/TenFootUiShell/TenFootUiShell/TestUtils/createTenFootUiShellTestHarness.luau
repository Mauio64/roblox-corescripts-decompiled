local Parent = script:FindFirstAncestor("TenFootUiShell").Parent
local React = require(Parent.React)
local ReactFocusNavigation = require(Parent.ReactFocusNavigation)
local Provider = require(Parent.FocusNavigationUtils).FocusNavigableSurfaceRegistry.Provider
local FocusNavigationService = ReactFocusNavigation.FocusNavigationService
local TestHelpers = require(Parent.Dev.TenFootUiTesting).TestHelpers
local mapProviderListToSpecs = TestHelpers.mapProviderListToSpecs
local ProviderContainer = require(Parent.RoactUtils).Components.ProviderContainer
local mocks = TestHelpers.mocks
local CoreGui = ReactFocusNavigation.EngineInterface.CoreGui

local function createDefaultFocusNavigationService() -- line: 16
	-- upvalues: CoreGui (copy), FocusNavigationService (copy)
	local v13 = table.clone(CoreGui)

	function v13.setSelection() -- line: 20
	end

	return FocusNavigationService.new(v13)
end
local function createTenFootUiShellTestHarness(p1, p2) -- line: 24
	-- upvalues: mocks (copy), mapProviderListToSpecs (copy), React (copy), ReactFocusNavigation (copy), CoreGui (copy), FocusNavigationService (copy), ProviderContainer (copy), Provider (copy)
	local v16, v17 = mocks.makeMockProviders(p2)
	local v18 = mapProviderListToSpecs(v16)

	return React.forwardRef(function(t1: {[any]: any}, _) -- line: 28
		-- upvalues: React (copy), ReactFocusNavigation (copy), p1 (copy), CoreGui (copy), FocusNavigationService (copy), ProviderContainer (copy), v18 (copy), Provider (copy)
		local createElement = React.createElement
		local Provider2 = ReactFocusNavigation.FocusNavigationContext.Provider
		local t2 = {}
		local v24 = p1

		if not v24 then
			local v25 = table.clone(CoreGui)

			function v25.setSelection() -- line: 20
			end

			v24 = FocusNavigationService.new(v25)
		end

		t2.value = v24

		return createElement(Provider2, t2, React.createElement(ProviderContainer, {
			providers = v18
		}, React.createElement(Provider, nil, t1.children)))
	end), v17
end

return createTenFootUiShellTestHarness
