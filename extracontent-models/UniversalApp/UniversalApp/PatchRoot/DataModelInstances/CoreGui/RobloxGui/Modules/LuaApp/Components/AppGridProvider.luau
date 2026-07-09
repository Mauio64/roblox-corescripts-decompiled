local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local ResponsiveLayoutProvider = require(CorePackages.Packages.UIBlox).Core.Layout.Responsive.ResponsiveLayoutProvider
local useAppPolicy = require(Modules.LuaApp.Hooks.useAppPolicy)
local makeGridSettingsConfig = require(Modules.LuaApp.Common.makeGridSettingsConfig)

return function(t1: {[any]: any}) -- line: 20
	-- upvalues: useDesignTokens (copy), useAppPolicy (copy), useSelector (copy), React (copy), makeGridSettingsConfig (copy), ResponsiveLayoutProvider (copy)
	local v10 = useDesignTokens()
	local v11 = useAppPolicy(function(p1) -- line: 26
		return p1.useGridPageLayout()
	end)
	local v12 = useSelector(function(p2) -- line: 30
		if p2.ScreenSize then
			return p2.ScreenSize.X
		end

		return nil
	end)
	local v13 = React.useMemo(function() -- line: 34
		-- upvalues: v11 (copy), t1 (copy), makeGridSettingsConfig (copy), v10 (copy)
		if not v11 then
			return {}
		end

		return t1.config or makeGridSettingsConfig(v10)
	end, {
		t1.config,
		v11,
		v10
	})

	return React.createElement(ResponsiveLayoutProvider, {
		width = v12,
		config = v13
	}, t1.children)
end
