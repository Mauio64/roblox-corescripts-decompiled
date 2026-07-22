local ParentParent = script.Parent.Parent.Parent.Parent
local React = require(ParentParent.React)
local Foundation = require(ParentParent.Foundation)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local usePreferences = Foundation.Hooks.usePreferences

local function PreferredTransparencyView(t1: {[any]: any}) -- line: 11
	-- upvalues: useTokens (copy), usePreferences (copy), React (copy), View (copy)
	local v9 = useTokens()
	local v10 = usePreferences()
	local OverMedia_200 = v9.Color.OverMedia.OverMedia_200
	local v12 = OverMedia_200.Transparency * v10.preferredTransparency
	local v13 = React.useMemo(function() -- line: 21
		-- upvalues: OverMedia_200 (copy), v12 (copy)
		return {
			Color3 = OverMedia_200.Color3,
			Transparency = v12
		}
	end, {
		OverMedia_200.Color3,
		v12
	})

	return React.createElement(View, {
		tag = "col radius-medium",
		Size = t1.size,
		backgroundStyle = v13,
		Visible = t1.visible
	}, t1.children)
end

return PreferredTransparencyView
