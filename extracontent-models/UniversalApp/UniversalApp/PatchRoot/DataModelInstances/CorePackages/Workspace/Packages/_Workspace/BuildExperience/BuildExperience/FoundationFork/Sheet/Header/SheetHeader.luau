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
local Flags = require(Foundation.Utility.Flags)

local function SheetHeader(t1: {[any]: any}, p1) -- line: 21
	-- upvalues: useTokens (copy), React (copy), SheetContext (copy), Flags (copy), SheetType (copy), View (copy), CloseAffordance (copy), CloseAffordanceVariant (copy)
	local v15 = useTokens()
	local v16 = React.useContext(SheetContext)
	local innerScrollY = v16.innerScrollY
	local setHasHeader = v16.setHasHeader
	local v19 = if not Flags.FoundationSheetFullBleed then nil else v16.hasFullBleed
	local sheetType = v16.sheetType
	local closeSheet = v16.closeSheet
	local testId = v16.testId
	local closeAffordanceRef = v16.closeAffordanceRef
	local contentStartRef = v16.contentStartRef

	assert(innerScrollY and (setHasHeader and (closeSheet and testId)), "SheetHeader must be used within a Sheet")

	local v25 = sheetType == SheetType.Bottom

	React.useEffect(function() -- line: 37
		-- upvalues: setHasHeader (copy)
		setHasHeader(true)

		return function() -- line: 39
			-- upvalues: setHasHeader (copy)
			setHasHeader(false)
		end
	end, {})

	local v26 = if t1.hasCloseAffordance ~= nil then t1.hasCloseAffordance else not v25

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
			CloseAffordance = if not v26 then nil else React.createElement(CloseAffordance, {
				LayoutOrder = 2,
				onActivated = closeSheet,
				ref = closeAffordanceRef,
				NextSelectionDown = contentStartRef,
				variant = if not Flags.FoundationSheetFullBleed or not v19 then CloseAffordanceVariant.Utility else CloseAffordanceVariant.OverMedia,
				testId = `{ testId }--header--close-affordance`
			})
		}),
		BottomBorder = React.createElement(View, {
			LayoutOrder = 2,
			backgroundStyle = innerScrollY:map(function(n1: number) -- line: 75
				-- upvalues: v15 (copy)
				return {
					Color3 = v15.Color.Stroke.Default.Color3,
					Transparency = math.lerp(1, v15.Color.Stroke.Default.Transparency, (math.clamp(n1 / v15.Size.Size_1200, 0, 1)))
				}
			end),
			testId = `{ testId }--header--bottom-border`,
			Size = UDim2.new(1, 0, 0, v15.Stroke.Standard)
		})
	})
end

return React.memo(React.forwardRef(SheetHeader))
