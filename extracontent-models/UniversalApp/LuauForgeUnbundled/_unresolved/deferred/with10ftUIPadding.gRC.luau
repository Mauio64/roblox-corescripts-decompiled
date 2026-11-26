local CorePackages = game:GetService("CorePackages")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local Dash = require(CorePackages.Packages.Dash)
local React = require(CorePackages.Packages.React)

local function with10ftUIPadding(p2)
	return function(p3)
		local v5 = useDesignTokens(function()
			return {
				topPadding = 0,
				leftPadding = 0,
				bottomPadding = 0,
				rightPadding = 0
			}
		end)

		return React.createElement(p2, Dash.join(p3, { designTokens = v5 }))
	end
end

return with10ftUIPadding
