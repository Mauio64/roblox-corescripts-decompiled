local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local UIBlox = require(CorePackages.Packages.UIBlox)
local responsiveLayoutProvider = UIBlox.Core.Layout.Responsive.ResponsiveLayoutProvider
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local module2 = require("@luauforge/bundled/hYb")

return function(p2)
	local v5 = useDesignTokens()

	local v6 = useAppPolicy(function(p3)
		return p3.useGridPageLayout()
	end)

	local v7 = useSelector(function(p3)
		if p3.ScreenSize then
			return p3.ScreenSize.X
		end

		return nil
	end)

	local v8 = React.useMemo(function()
		if v6 then
			return p2.config or module2(v5)
		end

		return {}
	end, { p2.config, v6, v5 })

	return React.createElement(responsiveLayoutProvider, { width = v7, config = v8 }, p2.children)
end
