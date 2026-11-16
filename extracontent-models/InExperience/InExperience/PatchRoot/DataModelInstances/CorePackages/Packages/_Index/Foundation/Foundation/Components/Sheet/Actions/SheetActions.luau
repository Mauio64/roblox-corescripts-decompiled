local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)

local Sheet = script:FindFirstAncestor("Sheet")
local SheetContext = require(Sheet.SheetContext)
local SheetType = require(Sheet.SheetType)

local useTokens = require(Foundation.Providers.Style.useTokens)

local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)
local View = require(Foundation.Components.View)

local function SheetActions(p, ref)
	local v = useTokens()

	local v2 = React.useContext(SheetContext)
	local sheetHeightAvailable = v2.sheetHeightAvailable
	local actionsHeight = v2.actionsHeight
	local setActionsHeight = v2.setActionsHeight
	local hasActionsDivider = v2.hasActionsDivider
	local safeAreaPadding = v2.safeAreaPadding
	local bottomPadding = v2.bottomPadding
	local sheetType = v2.sheetType
	local testId = v2.testId
	assert(
		sheetHeightAvailable and actionsHeight and setActionsHeight and hasActionsDivider and safeAreaPadding and bottomPadding and testId,
		"SheetActions must be used within a Sheet"
	)

	local innerSurface = v2.innerSurface

	local bgsurface = sheetType == SheetType.Bottom

	local createElement = React.createElement
	local v3 = {
		tag = { ["row gap-small size-full-0 auto-y"] = true, ["bg-surface-100"] = bgsurface },
		padding = {
			top = UDim.new(0, v.Margin.Small),
			left = UDim.new(0, v.Margin.Small),
			right = UDim.new(0, v.Margin.Small),
			bottom = UDim.new(0, bottomPadding + v.Margin.Small)
		},
		stroke = {
			Color = v.Color.Stroke.Default.Color3,
			Transparency = v.Color.Stroke.Default.Transparency,
			Thickness = hasActionsDivider:map(function(flag: boolean)
				return if flag then v.Stroke.Standard else 0
			end)
		},
		onAbsoluteSizeChanged = bgsurface and function(p2)
			setActionsHeight(p2.AbsoluteSize.Y - bottomPadding)
		end or nil,
		ZIndex = 1,
		testId = `{testId}--actions`,
		Position = 0,
		LayoutOrder = 3,
		ref = 0,
		onActivated = 0,
		selection = 0,
		stateLayer = 0
	}
	local position

	if bgsurface then
		position = React.joinBindings({
			sheetHeightAvailable = sheetHeightAvailable,
			actionsHeight = actionsHeight
		}):map(function(p2)
			return UDim2.new(0, 0, 1, -math.min(p2.sheetHeightAvailable, p2.actionsHeight))
		end)
	end

	v3.Position = position

	v3.ref = ref

	function v3.onActivated() end
	v3.selection = { Selectable = false }
	v3.stateLayer = { affordance = StateLayerAffordance.None }
	local element = createElement(View, v3, p.children)

	if bgsurface then
		return innerSurface and ReactRoblox.createPortal(element, innerSurface)
	end

	return element
end

return React.memo(React.forwardRef(SheetActions))
