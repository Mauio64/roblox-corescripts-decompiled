local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Loading = Foundation.Loading
local View = Foundation.View

local function LibraryLeavingOverlay(p)
	local v = Foundation.Hooks.useTokens()
	return React.createElement(View, {
		ZIndex = p.ZIndex,
		backgroundStyle = v.Color.Common.Backdrop,
		onActivated = function() end,
		selection = { Selectable = false },
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		tag = "size-full row align-x-center align-y-center",
		testId = "Library.Leaving"
	}, {
		Spinner = React.createElement(Loading, {})
	})
end

return LibraryLeavingOverlay
