local Foundation = game:GetService("CorePackages").Packages._Index.Foundation.Foundation
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local ReactRoblox = require(FoundationParent.ReactRoblox)
local Sheet = script:FindFirstAncestor("Sheet")
local SheetContext = require(Sheet.SheetContext)
local SheetType = require(Sheet.SheetType)
local useTokens = require(Foundation.Providers.Style.useTokens)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)
local View = require(Foundation.Components.View)

local function SheetActions(t1: {[any]: any}, p1) -- line: 19
	-- upvalues: useTokens (copy), React (copy), SheetContext (copy), SheetType (copy), View (copy), StateLayerAffordance (copy), ReactRoblox (copy)
	local v14 = useTokens()
	local v15 = React.useContext(SheetContext)
	local sheetHeightAvailable = v15.sheetHeightAvailable
	local actionsHeight = v15.actionsHeight
	local setActionsHeight = v15.setActionsHeight
	local hasActionsDivider = v15.hasActionsDivider
	local safeAreaPadding = v15.safeAreaPadding
	local bottomPadding = v15.bottomPadding
	local sheetType = v15.sheetType
	local testId = v15.testId

	assert(sheetHeightAvailable and (actionsHeight and (setActionsHeight and (hasActionsDivider and (safeAreaPadding and (bottomPadding and testId))))), "SheetActions must be used within a Sheet")

	local innerSurface = v15.innerSurface
	local v25 = sheetType == SheetType.Bottom
	local v26 = React.createElement(View, {
		ZIndex = 1,
		LayoutOrder = 3,
		tag = {
			["row gap-small size-full-0 auto-y"] = true,
			["bg-surface-100"] = v25
		},
		padding = {
			top = UDim.new(0, v14.Margin.Small),
			left = UDim.new(0, v14.Margin.Small),
			right = UDim.new(0, v14.Margin.Small),
			bottom = UDim.new(0, bottomPadding + v14.Margin.Small)
		},
		stroke = {
			Color = v14.Color.Stroke.Default.Color3,
			Transparency = v14.Color.Stroke.Default.Transparency,
			Thickness = hasActionsDivider:map(function(b1: boolean) -- line: 60
				-- upvalues: v14 (copy)
				if b1 then
					return v14.Stroke.Standard
				end

				return 0
			end)
		},
		onAbsoluteSizeChanged = if not v25 then nil else function(p2) -- line: 69
			-- upvalues: setActionsHeight (copy), bottomPadding (copy)
			setActionsHeight(p2.AbsoluteSize.Y - bottomPadding)
		end,
		testId = `{ testId }--actions`,
		Position = if not v25 then nil else React.joinBindings({
			sheetHeightAvailable = sheetHeightAvailable,
			actionsHeight = actionsHeight
		}):map(function(t2: {[any]: any}) -- line: 79
			return UDim2.new(0, 0, 1, -math.min(t2.sheetHeightAvailable, t2.actionsHeight))
		end),
		ref = p1,
		onActivated = function() -- line: 89
		end,
		selection = {
			Selectable = false
		},
		stateLayer = {
			affordance = StateLayerAffordance.None
		}
	}, t1.children)

	if v25 then
		return innerSurface and ReactRoblox.createPortal(v26, innerSurface)
	end

	return v26
end

return React.memo(React.forwardRef(SheetActions))
