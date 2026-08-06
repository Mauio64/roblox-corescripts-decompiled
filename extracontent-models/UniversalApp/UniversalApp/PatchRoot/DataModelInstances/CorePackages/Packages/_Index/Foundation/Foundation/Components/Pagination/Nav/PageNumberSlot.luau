local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Text = require(Foundation.Components.Text)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local useChipVariants = require(Foundation.Components.Chip.useChipVariants)
local ChipSize = require(Foundation.Enums.ChipSize)
local ChipVariant = require(Foundation.Enums.ChipVariant)
local ColorNamespace = require(Foundation.Enums.ColorNamespace)
local PaginationSize = require(Foundation.Enums.PaginationSize)
local PresentationContext = require(Foundation.Providers.Style.PresentationContext)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local ParentParent = script.Parent.Parent
local paginationUtils = require(ParentParent.paginationUtils)

local function PageNumberText(t1: {[any]: any}) -- line: 43
	-- upvalues: React (copy), Text (copy)
	return React.createElement(Text, {
		LayoutOrder = 1,
		Text = tostring(t1.page),
		textStyle = t1.textStyle,
		tag = t1.textTag,
		padding = t1.padding,
		testId = `{ t1.testId }--text`
	})
end

local t2 = {
	[PaginationSize.Small] = "size-0-600",
	[PaginationSize.Medium] = "size-0-800"
}

local function PageNumberSlot(p1, p2) -- line: 65
	-- upvalues: useTokens (copy), paginationUtils (copy), PaginationSize (copy), ChipSize (copy), useChipVariants (copy), ChipVariant (copy), t2 (copy), React (copy), View (copy), withCommonProps (copy), PresentationContext (copy), ColorNamespace (copy), PageNumberText (copy)
	local v22 = useTokens()
	local v23 = not p1.isChecked
	local v24 = paginationUtils.needsWidePageSlot(p1.page)
	local v25 = if p1.slotSize ~= PaginationSize.Small then ChipSize.Medium else ChipSize.Small
	local v26 = useChipVariants(v22, v25, ChipVariant.Utility, true, false, false)
	local v27 = useChipVariants(v22, v25, ChipVariant.Utility, false, false, false)
	local v28 = `row align-x-center align-y-center auto-x radius-circle { t2[p1.slotSize] }`
	local v29 = React.useCallback(function() -- line: 76
		-- upvalues: p1 (copy)
		p1.onPageActivated(p1.page)
	end, {
		p1.onPageActivated,
		p1.page
	})
	local t3 = {
		Selectable = v23 and p1.Selectable ~= false,
		NextSelectionLeft = p1.NextSelectionLeft,
		NextSelectionRight = p1.NextSelectionRight,
		NextSelectionUp = p1.NextSelectionUp,
		NextSelectionDown = p1.NextSelectionDown
	}

	if v24 then
		if v23 then
			return React.createElement(View, withCommonProps({
				LayoutOrder = p1.layoutOrder,
				testId = p1.testId
			}, {
				backgroundStyle = v27.chip.backgroundStyle,
				padding = v27.chip.padding,
				cursor = paginationUtils.getSlotCursor(v22),
				onActivated = v29,
				ref = p2,
				selection = t3,
				tag = v28
			}), {
				Label = React.createElement(PresentationContext.Provider, {
					value = {
						isIconSize = true,
						colorNamespace = ColorNamespace.Color
					}
				}, {
					Text = React.createElement(PageNumberText, {
						page = p1.page,
						textStyle = v27.text.contentStyle,
						textTag = v27.text.tag,
						padding = v27.text.padding,
						testId = p1.testId
					})
				})
			})
		end

		return React.createElement(View, withCommonProps({
			LayoutOrder = p1.layoutOrder,
			testId = p1.testId
		}, {
			backgroundStyle = v26.chip.backgroundStyle,
			padding = v26.chip.padding,
			ref = p2,
			selection = {
				Selectable = false
			},
			tag = v28
		}), {
			Text = React.createElement(PageNumberText, {
				page = p1.page,
				textStyle = v26.text.contentStyle,
				textTag = v26.text.tag,
				padding = v26.text.padding,
				testId = p1.testId
			})
		})
	end

	return React.createElement(View, withCommonProps({
		LayoutOrder = p1.layoutOrder,
		testId = p1.testId
	}, {
		backgroundStyle = {
			Transparency = 1,
			Color3 = v22.Color.Surface.Surface_0.Color3
		},
		cursor = if not v23 then nil else paginationUtils.getSlotCursor(v22),
		onActivated = if not v23 then nil else v29,
		ref = p2,
		selection = if not v23 then {
			Selectable = false
		} else t3,
		tag = paginationUtils.getCircularSlotTag(p1.slotSize)
	}), {
		Text = React.createElement(PageNumberText, {
			padding = nil,
			page = p1.page,
			textStyle = if not p1.isChecked then v22.Color.Content.Default else v26.text.contentStyle,
			textTag = paginationUtils.getPageLabelTextTag(p1.slotSize),
			testId = p1.testId
		})
	})
end

return React.memo(React.forwardRef(PageNumberSlot))
