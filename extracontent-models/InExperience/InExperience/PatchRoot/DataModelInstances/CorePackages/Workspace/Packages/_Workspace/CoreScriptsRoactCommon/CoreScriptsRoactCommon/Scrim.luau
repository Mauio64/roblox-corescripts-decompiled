local parent = script.Parent.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function Scrim(p, _)
	local scrim = useTokens().Color.Common.Scrim

	return React.createElement(View, {
		tag = "size-full",
		backgroundStyle = scrim,
		Visible = p and p.Visible,
		ZIndex = p and p.ZIndex
	})
end

return React.memo(React.forwardRef(Scrim))
