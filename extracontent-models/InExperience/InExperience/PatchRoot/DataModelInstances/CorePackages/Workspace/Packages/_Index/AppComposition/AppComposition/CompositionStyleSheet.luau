local AppComposition = script:FindFirstAncestor("AppComposition")
local AppCompositionParent = AppComposition.Parent
local Foundation = require(AppCompositionParent.Foundation)
local React = require(AppCompositionParent.React)
local useStyleSheet = Foundation.Hooks.useStyleSheet
local useTokens = Foundation.Hooks.useTokens
local setupCompositionStyleRules = require(AppComposition.setupCompositionStyleRules)

local function CompositionStyleSheet() -- line: 18
	-- upvalues: React (copy), useStyleSheet (copy), useTokens (copy), setupCompositionStyleRules (copy)
	local v9 = React.useRef(nil)
	local v10 = useStyleSheet()
	local v11 = useTokens()

	React.useLayoutEffect(function() -- line: 23
		-- upvalues: v9 (copy), v10 (copy), setupCompositionStyleRules (copy), v11 (copy)
		if v9.current and v10 then
			v9.current:SetDerives({ v10 })

			return setupCompositionStyleRules(v9.current, v11)
		end

		return function() -- line: 28
		end
	end, {
		v9,
		v10,
		v11
	})

	return React.createElement(React.Fragment, nil, {
		CompositionStyleSheet = React.createElement("StyleSheet", {
			ref = v9
		}),
		CompositionStyleLink = React.createElement("StyleLink", {
			StyleSheet = v9.current
		})
	})
end

return CompositionStyleSheet
