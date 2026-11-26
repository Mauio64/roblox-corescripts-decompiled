local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/fHU")
local module2 = require("@luauforge/bundled/fHw")

local function useHomeThemeBackground()
	local v5 = React.useContext(module2)
	local v6 = module.useHomeThemeBackgroundImage()
	local v7, v8 = React.useBinding({ position = Vector2.zero, size = Vector2.zero })

	local v9 = React.useCallback(function(p2)
		if p2 then
			v8({ position = p2.AbsolutePosition, size = p2.AbsoluteSize })
		end
	end, {})

	if not v6 or v5 then
		v6 = nil
	end

	return {
		isTransparent = v5 ~= nil or v6 ~= nil,
		image = v6,
		geometry = v7,
		onPageChanged = v9
	}
end

return useHomeThemeBackground
