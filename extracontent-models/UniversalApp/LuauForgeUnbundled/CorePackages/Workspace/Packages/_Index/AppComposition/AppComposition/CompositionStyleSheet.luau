local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppComposition/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppComposition/React")

local useStyleSheet = Foundation.Hooks.useStyleSheet
local useTokens = Foundation.Hooks.useTokens

local setupCompositionStyleRules = require("@game/CorePackages/Workspace/Packages/_Index/AppComposition/AppComposition/setupCompositionStyleRules")

local function CompositionStyleSheet()
	local ref = React.useRef(nil)
	local v5 = useStyleSheet()
	local v6 = useTokens()

	React.useLayoutEffect(function()
		if ref.current and v5 then
			ref.current:SetDerives({ v5 })
			return setupCompositionStyleRules(ref.current, v6)
		end

		return function() end
	end, { ref, v5, v6 })

	return React.createElement(React.Fragment, nil, {
		CompositionStyleSheet = React.createElement("StyleSheet", { ref = ref }),
		CompositionStyleLink = React.createElement("StyleLink", {
			StyleSheet = ref.current
		})
	})
end

return CompositionStyleSheet
