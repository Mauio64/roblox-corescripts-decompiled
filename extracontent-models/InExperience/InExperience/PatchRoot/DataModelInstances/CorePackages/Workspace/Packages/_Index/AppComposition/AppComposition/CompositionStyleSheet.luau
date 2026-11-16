local AppComposition = script:FindFirstAncestor("AppComposition")
local parent = AppComposition.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local useStyleSheet = Foundation.Hooks.useStyleSheet
local useTokens = Foundation.Hooks.useTokens

local setupCompositionStyleRules = require(AppComposition.setupCompositionStyleRules)

local function CompositionStyleSheet()
	local ref = React.useRef(nil)
	local v = useStyleSheet()
	local v2 = useTokens()

	React.useLayoutEffect(function()
		if ref.current and v then
			ref.current:SetDerives({ v })
			return setupCompositionStyleRules(ref.current, v2)
		end

		return function() end
	end, { ref, v, v2 })

	return React.createElement(React.Fragment, nil, {
		CompositionStyleSheet = React.createElement("StyleSheet", { ref = ref }),
		CompositionStyleLink = React.createElement("StyleLink", { StyleSheet = ref.current })
	})
end

return CompositionStyleSheet
