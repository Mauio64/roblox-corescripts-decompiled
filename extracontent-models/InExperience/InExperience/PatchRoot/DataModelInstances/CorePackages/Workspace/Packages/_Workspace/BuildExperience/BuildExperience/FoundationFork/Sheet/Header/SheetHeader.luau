local CorePackages = game:GetService("CorePackages")
local foundation = CorePackages.Packages._Index.Foundation.Foundation
local parent = foundation.Parent
local React = require(parent.React)
local useTokens = require(foundation.Providers.Style.useTokens)

local Sheet = script:FindFirstAncestor("Sheet")
local SheetContext = require(Sheet.SheetContext)
local SheetType = require(Sheet.SheetType)

local CloseAffordance = require(foundation.Components.CloseAffordance)
local CloseAffordanceVariant = require(foundation.Enums.CloseAffordanceVariant)
local View = require(foundation.Components.View)

local function SheetHeader(p, ref)
	local v = useTokens()
	local v2 = React.useContext(SheetContext)

	local innerScrollY = v2.innerScrollY
	local setHasHeader = v2.setHasHeader
	local hasFullBleed = v2.hasFullBleed
	local sheetType = v2.sheetType
	local closeSheet = v2.closeSheet
	local testId = v2.testId
	local closeAffordanceRef = v2.closeAffordanceRef
	local contentStartRef = v2.contentStartRef
	assert(innerScrollY and setHasHeader and closeSheet and testId, "SheetHeader must be used within a Sheet")

	local v3 = sheetType == SheetType.Bottom

	React.useEffect(function()
		setHasHeader(true)
		return function()
			setHasHeader(false)
		end
	end, {})
	local v4

	if p.hasCloseAffordance == nil then
		v4 = not v3
	else
		v4 = p.hasCloseAffordance
	end

	local createElement = React.createElement
	local v5 = {
		ZIndex = 2,
		tag = "col size-full-0 auto-y",
		testId = `{testId}--header`,
		ref = ref
	}

	local createElement2 = React.createElement

	local v6 = {
		SubContent = React.createElement(
			View,
			{ LayoutOrder = 1, tag = "row items-center shrink gap-small size-full-0 auto-y" },
			p.children
		),
		CloseAffordance = 0
	}
	local closeAffordance

	if v4 then
		local createElement3 = React.createElement
		local variant

		if hasFullBleed then
			variant = CloseAffordanceVariant.OverMedia
		else
			variant = CloseAffordanceVariant.Utility
		end

		closeAffordance = createElement3(CloseAffordance, {
			onActivated = closeSheet,
			ref = closeAffordanceRef,
			NextSelectionDown = contentStartRef,
			variant = variant,
			LayoutOrder = 2,
			testId = `{testId}--header--close-affordance`
		})
	end

	v6.CloseAffordance = closeAffordance
	return createElement(View, v5, {
		Content = createElement2(
			View,
			{
				LayoutOrder = 1,
				tag = "row align-y-center items-center gap-small size-full-1400 auto-y margin-left-small padding-y-small padding-right-medium"
			},
			v6
		),
		BottomBorder = React.createElement(View, {
			LayoutOrder = 2,
			backgroundStyle = innerScrollY:map(function(p2: number)
				return {
					Color3 = v.Color.Stroke.Default.Color3,
					Transparency = math.lerp(
						1,
						v.Color.Stroke.Default.Transparency,
						(math.clamp(p2 / v.Size.Size_1200, 0, 1))
					)
				}
			end),
			testId = `{testId}--header--bottom-border`,
			Size = UDim2.new(1, 0, 0, v.Stroke.Standard)
		})
	})
end

return React.memo(React.forwardRef(SheetHeader))
