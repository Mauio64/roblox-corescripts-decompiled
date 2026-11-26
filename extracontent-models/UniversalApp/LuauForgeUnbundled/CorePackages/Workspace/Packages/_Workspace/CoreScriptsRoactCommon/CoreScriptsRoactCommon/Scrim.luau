local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/Foundation")

local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function Scrim(p2, p3)
	local scrim = useTokens().Color.Common.Scrim

	return React.createElement(view, {
		tag = "size-full",
		backgroundStyle = scrim,
		Visible = p2 and p2.Visible,
		ZIndex = p2 and p2.ZIndex
	})
end

return React.memo(React.forwardRef(Scrim))
