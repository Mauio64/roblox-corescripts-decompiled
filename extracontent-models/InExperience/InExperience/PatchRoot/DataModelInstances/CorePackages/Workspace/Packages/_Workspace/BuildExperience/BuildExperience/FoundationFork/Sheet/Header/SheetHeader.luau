local Foundation = game:GetService("CorePackages").Packages._Index.Foundation.Foundation
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local useTokens = require(Foundation.Providers.Style.useTokens)
local Sheet = script:FindFirstAncestor("Sheet")
local SheetContext = require(Sheet.SheetContext)
local SheetType = require(Sheet.SheetType)
local CloseAffordance = require(Foundation.Components.CloseAffordance)
local CloseAffordanceVariant = require(Foundation.Enums.CloseAffordanceVariant)
local View = require(Foundation.Components.View)

local function SheetHeader(t1: {[any]: any}, p1) -- line: 19
	-- upvalues: useTokens (copy), React (copy), SheetContext (copy), SheetType (copy), View (copy), CloseAffordance (copy), CloseAffordanceVariant (copy)
	local v14 = useTokens()
	local v15 = React.useContext(SheetContext)
	local innerScrollY = v15.innerScrollY
	local setHasHeader = v15.setHasHeader
	local hasFullBleed = v15.hasFullBleed
	local sheetType = v15.sheetType
	local closeSheet = v15.closeSheet
	local testId = v15.testId
	local closeAffordanceRef = v15.closeAffordanceRef
	local contentStartRef = v15.contentStartRef

	assert(innerScrollY and (setHasHeader and (closeSheet and testId)), "SheetHeader must be used within a Sheet")

	local v24 = sheetType == SheetType.Bottom

	React.useEffect(function() -- line: 35
		-- upvalues: setHasHeader (copy)
		setHasHeader(true)

		return function() -- line: 37
			-- upvalues: setHasHeader (copy)
			setHasHeader(false)
		end
	end, {})

	local v25 = if t1.hasCloseAffordance ~= nil then t1.hasCloseAffordance else not v24

	return React.createElement(View, {
		ZIndex = 2,
		tag = "col size-full-0 auto-y",
		testId = `{ testId }--header`,
		ref = p1
	}, {
		Content = React.createElement(View, {
			LayoutOrder = 1,
			tag = "row align-y-center items-center gap-small size-full-1400 auto-y margin-left-small padding-y-small padding-right-medium"
		}, {
			SubContent = React.createElement(View, {
				LayoutOrder = 1,
				tag = "row items-center shrink gap-small size-full-0 auto-y"
			}, t1.children),
			CloseAffordance = if not v25 then nil else React.createElement(CloseAffordance, {
				LayoutOrder = 2,
				onActivated = closeSheet,
				ref = closeAffordanceRef,
				NextSelectionDown = contentStartRef,
				variant = if not hasFullBleed then CloseAffordanceVariant.Utility else CloseAffordanceVariant.OverMedia,
				testId = `{ testId }--header--close-affordance`
			})
		}),
		BottomBorder = React.createElement(View, {
			LayoutOrder = 2,
			backgroundStyle = innerScrollY:map(function(n1: number) -- line: 71
				-- upvalues: v14 (copy)
				return {
					Color3 = v14.Color.Stroke.Default.Color3,
					Transparency = math.lerp(1, v14.Color.Stroke.Default.Transparency, (math.clamp(n1 / v14.Size.Size_1200, 0, 1)))
				}
			end),
			testId = `{ testId }--header--bottom-border`,
			Size = UDim2.new(1, 0, 0, v14.Stroke.Standard)
		})
	})
end

return React.memo(React.forwardRef(SheetHeader))
