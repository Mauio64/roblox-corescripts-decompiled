local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local module = require("@luauforge/deferred/goR")

local module2 = require("@luauforge/bundled/gfm")
local module3 = require("@luauforge/bundled/ftY")

local useTokens = Foundation.Hooks.useTokens
local useAvatarRoute = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.Hooks.useAvatarRoute
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local advancedCustomizationControlBar = module.AdvancedCustomizationControlBar
local undoRedoBar = module.UndoRedoBar

local fFlagAXResetAvatarButton = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXResetAvatarButton

local module4 = require("@luauforge/deferred/gVW")

local function RefinementControlBar(props, p2)
	local v5 = useTokens()
	local v6 = useAvatarRoute()

	local v7 = useSelector(module2)
	local v8 = useSelector(module3)

	local createElement = React.createElement
	local view = Foundation.View

	local v10 = if v7 then UDim2.fromOffset(v5.Size.Size_500, v8) else UDim2.new(0, v5.Size.Size_700, 0, v8 + v5.Size.Size_500)
	local v9 = {
		tag = "auto-xy col gap-medium",
		ref = p2,
		Position = v10,
		NextSelectionUp = props.NextSelectionUp,
		NextSelectionDown = props.NextSelectionDown,
		NextSelectionLeft = props.NextSelectionLeft,
		NextSelectionRight = props.NextSelectionRight,
		ZIndex = module4 and props.ZIndex or 2
	}
	local v11 = {
		AdvancedCustomizationControlBar = React.createElement(advancedCustomizationControlBar, {
			avatarRoute = v6,
			LayoutOrder = 1
		}),
		UndoRedoBar = 0
	}

	local v12 = if not (fFlagAXResetAvatarButton or props.hideUndoRedo) then React.createElement(undoRedoBar, {
		direction = "vertical",
		LayoutOrder = 2
	}) else nil
	v11.UndoRedoBar = v12
	return createElement(view, v9, v11)
end

return React.memo(React.forwardRef(RefinementControlBar))
