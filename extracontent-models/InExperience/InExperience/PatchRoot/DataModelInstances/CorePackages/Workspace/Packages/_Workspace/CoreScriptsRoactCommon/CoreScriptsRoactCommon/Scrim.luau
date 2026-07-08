local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)
local Foundation = require(ParentParent.Foundation)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function Scrim(t1: {[any]: any}, _) -- line: 15
	-- upvalues: useTokens (copy), React (copy), View (copy)
	local Scrim2 = useTokens().Color.Common.Scrim

	return React.createElement(View, {
		tag = "size-full",
		backgroundStyle = Scrim2,
		Visible = t1 and t1.Visible,
		ZIndex = t1 and t1.ZIndex
	})
end

return React.memo(React.forwardRef(Scrim))
