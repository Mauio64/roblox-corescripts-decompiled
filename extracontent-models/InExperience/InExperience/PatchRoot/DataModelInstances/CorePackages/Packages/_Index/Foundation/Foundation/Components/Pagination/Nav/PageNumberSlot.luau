local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

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

local parent2 = script.Parent.Parent
local paginationUtils = require(parent2.paginationUtils)

local function PageNumberText(props)
	return React.createElement(Text, {
		Text = tostring(props.page),
		textStyle = props.textStyle,
		tag = props.textTag,
		padding = props.padding,
		LayoutOrder = 1,
		testId = `{props.testId}--text`
	})
end

local v = { colorNamespace = ColorNamespace.Color, isIconSize = true }

local v2 = { [PaginationSize.Small] = "size-0-600", [PaginationSize.Medium] = "size-0-800" }

local function PageNumberSlot(props, ref)
	local v3 = useTokens()

	local v4 = not props.isChecked
	local needsWidePageSlot = paginationUtils.needsWidePageSlot(props.page)
	local v5

	if props.slotSize == PaginationSize.Small then
		v5 = ChipSize.Small
	else
		v5 = ChipSize.Medium
	end

	local v6 = useChipVariants(v3, v5, ChipVariant.Utility, true, false, false)
	local v7 = useChipVariants(v3, v5, ChipVariant.Utility, false, false, false)
	local formatted = `row align-x-center align-y-center auto-x radius-circle {v2[props.slotSize]}`

	local onActivated = React.useCallback(function()
		props.onPageActivated(props.page)
	end, { props.onPageActivated, props.page })

	local selection = {
		Selectable = v4 and props.Selectable ~= false,
		NextSelectionLeft = props.NextSelectionLeft,
		NextSelectionRight = props.NextSelectionRight,
		NextSelectionUp = props.NextSelectionUp,
		NextSelectionDown = props.NextSelectionDown
	}

	if needsWidePageSlot then
		if v4 then
			return React.createElement(
				View,
				withCommonProps({ LayoutOrder = props.LayoutOrder, testId = props.testId }, {
					backgroundStyle = v7.chip.backgroundStyle,
					padding = v7.chip.padding,
					cursor = paginationUtils.getSlotCursor(v3),
					onActivated = onActivated,
					ref = ref,
					selection = selection,
					tag = formatted
				}),
				{
					Label = React.createElement(PresentationContext.Provider, { value = v }, {
						Text = React.createElement(PageNumberText, {
							page = props.page,
							textStyle = v7.text.contentStyle,
							textTag = v7.text.tag,
							padding = v7.text.padding,
							testId = props.testId
						})
					})
				}
			)
		end

		return React.createElement(View, withCommonProps({
			LayoutOrder = props.LayoutOrder,
			testId = props.testId
		}, {
			backgroundStyle = v6.chip.backgroundStyle,
			padding = v6.chip.padding,
			ref = ref,
			selection = { Selectable = false },
			tag = formatted
		}), {
			Text = React.createElement(PageNumberText, {
				page = props.page,
				textStyle = v6.text.contentStyle,
				textTag = v6.text.tag,
				padding = v6.text.padding,
				testId = props.testId
			})
		})
	else
		local createElement = React.createElement

		local v8 = { LayoutOrder = props.LayoutOrder, testId = props.testId }
		local v9 = {
			backgroundStyle = { Color3 = v3.Color.Surface.Surface_0.Color3, Transparency = 1 },
			cursor = 0,
			onActivated = 0,
			ref = 0,
			selection = 0,
			tag = 0
		}
		local cursor

		if v4 then
			cursor = paginationUtils.getSlotCursor(v3)
		end

		v9.cursor = cursor

		if not v4 then
			onActivated = nil
		end

		v9.onActivated = onActivated
		v9.ref = ref
		v9.selection = not v4 and { Selectable = false } or selection

		v9.tag = paginationUtils.getCircularSlotTag(props.slotSize)
		local v10 = withCommonProps(v8, v9)

		local createElement2 = React.createElement
		local v11 = {
			page = props.page,
			textStyle = 0,
			textTag = 0,
			padding = nil,
			testId = 0
		}
		local textStyle

		if props.isChecked then
			textStyle = v6.text.contentStyle
		else
			textStyle = v3.Color.Content.Default
		end

		v11.textStyle = textStyle

		v11.textTag = paginationUtils.getPageLabelTextTag(props.slotSize)

		v11.testId = props.testId
		return createElement(View, v10, {
			Text = createElement2(PageNumberText, v11)
		})
	end
end

return React.memo(React.forwardRef(PageNumberSlot))
