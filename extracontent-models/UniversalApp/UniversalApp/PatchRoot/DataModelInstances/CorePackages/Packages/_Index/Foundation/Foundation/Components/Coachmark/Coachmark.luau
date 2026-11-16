local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Dash = require(parent.Dash)
local React = require(parent.React)

local Constants = require(Foundation.Constants)

local Button = require(Foundation.Components.Button)
local ButtonGroup = require(Foundation.Components.ButtonGroup)
local CloseAffordance = require(Foundation.Components.CloseAffordance)
local CloseAffordanceVariant = require(Foundation.Enums.CloseAffordanceVariant)
local ColorNamespace = require(Foundation.Enums.ColorNamespace)
local FillBehavior = require(Foundation.Enums.FillBehavior)
local Flags = require(Foundation.Utility.Flags)
local InputSize = require(Foundation.Enums.InputSize)
local Logger = require(Foundation.Utility.Logger)
local Orientation = require(Foundation.Enums.Orientation)
local Popover = require(Foundation.Components.Popover)
local PopoverAlign = require(Foundation.Enums.PopoverAlign)
local PopoverSide = require(Foundation.Enums.PopoverSide)
local PresentationContext = require(Foundation.Providers.Style.PresentationContext)
local Radius = require(Foundation.Enums.Radius)
local Text = require(Foundation.Components.Text)
local Translator = require(Foundation.Utility.Localization.Translator)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)

local useScaledValue = require(Foundation.Utility.useScaledValue)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local v = {
	isOpen = false,
	align = PopoverAlign.Start,
	side = PopoverSide.Right,
	hasArrow = true,
	actionsFillBehavior = 0,
	testId = "--foundation-coachmark"
}
local actionsFillBehavior

if Flags.FoundationEducationalTooltipRefresh then
	actionsFillBehavior = FillBehavior.Fill
end

v.actionsFillBehavior = actionsFillBehavior

local v2 = { colorNamespace = ColorNamespace.Inverse }

local function stepsText(current: number, total: number) -- 1 equivalent call inferred from this helper
	return Translator:FormatByKey("CommonUI.Controls.Label.PageCount", {
		current = current,
		total = total
	})
end

local function Coachmark(p, ref)
	local v3 = withDefaults(p, v)
	local v4 = useTokens()
	local v5 = useScaledValue(not Flags.FoundationEducationalTooltipRefresh and 320 or Constants.TOOLTIP_MAX_WIDTH)

	local v6 = useScaledValue(240)

	if Flags.FoundationEducationalTooltipMinMediaWidth and not v3.media then
		v6 = v4.Size.Size_3000
	end

	local sizeConstraint

	if not Flags.FoundationEducationalTooltipMinMediaWidth then
		sizeConstraint = v3.onClose and {
			MaxSize = Vector2.new(v5 - v4.Size.Size_1200, 1e999)
		} or nil
	end

	local buttons = React.useMemo(function()
		local children = {}

		if not v3.actions then
			return children
		end

		for k, action in v3.actions do
			if not Flags.FoundationEducationalTooltipRefresh and k > 2 then
				Logger:warning(`Coachmark only supports up to {2} actions`)
				return children
			end

			if Flags.FoundationEducationalTooltipRefresh then
				children[k] = action
			else
				local v7 = {
					LayoutOrder = k,
					size = InputSize.Medium,
					fillBehavior = FillBehavior.Fill,
					testId = `{v3.testId}--action-{k}`
				}

				local union = Dash.union(action, v7)
				children["CoachmarkButton" .. k] = React.createElement(Button, union)
			end
		end

		return children
	end, { v3.actions, v3.testId })
	local v7

	if Flags.FoundationEducationalTooltipMinMediaWidth then
		v7 = v3.onClose and not v3.media
	end

	local v8

	if
		Flags.FoundationEducationalTooltipBodyOnlyContentLayout
		and v3.title == ""
		and v3.text ~= nil
		and v3.text ~= ""
		and v3.media == nil
		and v3.steps == nil
	then
		v8 = v3.actions == nil or #v3.actions == 0
	else
		v8 = false
	end

	local createElement = React.createElement
	local root = Popover.Root
	local v9 = { isOpen = v3.isOpen, testId = v3.testId }
	local v10 = {
		Anchor = React.createElement(Popover.Anchor, withCommonProps(v3, {
			anchorRef = v3.anchorRef
		}), v3.children),
		Content = 0
	}

	local createElement2 = React.createElement
	local content = Popover.Content
	local v11 = {
		hasArrow = v3.hasArrow,
		align = v3.align,
		DO_NOT_USE_hasContentInputSink = true,
		onPressedOutside = v3.onPressedOutside,
		side = { position = v3.side, offset = v4.Size.Size_200 },
		radius = Radius.Medium,
		backgroundStyle = v4.Inverse.Surface.Surface_0,
		selection = v3.selection,
		selectionGroup = v3.selectionGroup,
		ref = ref
	}

	local createElement3 = React.createElement
	local provider = PresentationContext.Provider

	local createElement4 = React.createElement
	local v12 = {
		testId = v3.testId,
		tag = Flags.FoundationEducationalTooltipRefresh and "col auto-xy" or "col gap-medium auto-xy padding-bottom-medium",
		sizeConstraint = 0
	}

	local sizeConstraint2 = { MaxSize = Vector2.new(v5, 1e999), MinSize = 0 }
	local minSize

	if Flags.FoundationEducationalTooltipRefresh then
		minSize = Vector2.new(v6, 0)
	end

	sizeConstraint2.MinSize = minSize
	v12.sizeConstraint = sizeConstraint2
	local closeAffordanceContainer

	if v3.onClose then
		closeAffordanceContainer = React.createElement("Folder", {}, {
			CloseAffordance = React.createElement(CloseAffordance, {
				onActivated = v3.onClose,
				size = InputSize.Small,
				variant = CloseAffordanceVariant.Utility,
				Position = UDim2.new(1, -v4.Padding.Small, 0, v4.Padding.Small),
				AnchorPoint = Vector2.new(1, 0),
				ZIndex = 2,
				testId = `{v3.testId}--close-affordance`
			})
		})
	end

	local media

	if v3.media then
		media = React.createElement(View, { LayoutOrder = 1, tag = "size-full-0 auto-y" }, v3.media)
	end

	local createElement5 = React.createElement
	local tag

	if Flags.FoundationEducationalTooltipMinMediaWidth then
		tag = {}
		tag[Flags.FoundationEducationalTooltipRefresh and "col auto-xy" or "col gap-xsmall auto-xy"] = not Flags.FoundationEducationalTooltipBodyOnlyContentLayout
			or not v8
		local colalignycenterautoxy

		if Flags.FoundationEducationalTooltipBodyOnlyContentLayout then
			colalignycenterautoxy = v8
		else
			colalignycenterautoxy = false
		end

		tag["col align-y-center auto-xy"] = colalignycenterautoxy

		tag[Flags.FoundationEducationalTooltipRefresh and "padding-medium" or "padding-x-medium padding-bottom-xsmall padding-top-medium"] = not (v7 or v8)
	else
		tag = Flags.FoundationEducationalTooltipRefresh and "col auto-xy padding-medium"
			or "col gap-xsmall auto-xy padding-x-medium padding-bottom-xsmall padding-top-medium"
	end

	local padding

	if v8 then
		padding = {
			top = UDim.new(0, v4.Padding.Small),
			bottom = UDim.new(0, v4.Padding.Small),
			left = UDim.new(0, v4.Padding.Medium),
			right = 0
		}

		local v13 = if v7 then v4.Size.Size_1200 else v4.Padding.Medium
		padding.right = UDim.new(0, v13)
	elseif Flags.FoundationEducationalTooltipMinMediaWidth and v7 then
		padding = { top = UDim.new(0, v4.Padding.Medium), bottom = 0, left = 0, right = 0 }
		local v13

		if Flags.FoundationEducationalTooltipRefresh then
			v13 = v4.Padding.Medium
		else
			v13 = v4.Padding.XSmall
		end

		padding.bottom = UDim.new(0, v13)

		padding.left = UDim.new(0, v4.Padding.Medium)
		padding.right = UDim.new(0, v4.Size.Size_1200)
	end

	local v13 = {
		LayoutOrder = 2,
		tag = tag,
		padding = padding,
		sizeConstraint = v8 and {
			MinSize = Vector2.new(0, v4.Size.Size_800)
		} or nil
	}
	local stepIndicator

	if v3.steps then
		local createElement6 = React.createElement
		local v14 = {
			LayoutOrder = 1,
			Text = stepsText(v3.steps.current, v3.steps.total), -- inferred equivalent call
			tag = Flags.FoundationEducationalTooltipRefresh and "auto-xy text-caption-medium text-align-x-left text-truncate-end content-inverse-default" or "auto-xy text-label-small text-align-x-left text-truncate-end content-inverse-default",
			sizeConstraint = 0,
			testId = 0
		}
		local sizeConstraint3

		if not Flags.FoundationEducationalTooltipMinMediaWidth then
			sizeConstraint3 = sizeConstraint
		end

		v14.sizeConstraint = sizeConstraint3

		v14.testId = `{v3.testId}--step-indicator`
		stepIndicator = createElement6(Text, v14)
	end

	local header

	if v3.title ~= "" then
		local createElement6 = React.createElement
		local v14 = {
			LayoutOrder = 2,
			Text = v3.title,
			tag = "auto-xy text-title-large text-align-x-left text-truncate-split content-inverse-emphasis",
			sizeConstraint = 0,
			testId = 0
		}

		if Flags.FoundationEducationalTooltipMinMediaWidth then
			sizeConstraint = nil
		end

		v14.sizeConstraint = sizeConstraint

		v14.testId = `{v3.testId}--header`
		header = createElement6(Text, v14)
	end

	local text

	if v3.text and v3.text ~= "" then
		local createElement6 = React.createElement
		local v14 = {
			LayoutOrder = 3,
			Text = v3.text,
			tag = Flags.FoundationEducationalTooltipMinMediaWidth and "auto-xy text-body-medium text-wrap text-align-x-left content-inverse-default" or "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-inverse-default",
			padding = 0,
			testId = 0
		}
		local padding2

		if Flags.FoundationEducationalTooltipRefresh then
			if Flags.FoundationEducationalTooltipMinMediaWidth then
				padding2 = v3.title ~= "" and { top = UDim.new(0, v4.Size.Size_100) } or nil
			else
				padding2 = { top = UDim.new(0, v4.Size.Size_100) }
			end
		end

		v14.padding = padding2

		v14.testId = `{v3.testId}--text`
		text = createElement6(Text, v14)
	end

	local v14 = {
		CloseAffordanceContainer = closeAffordanceContainer,
		Media = media,
		ContentSection = createElement5(View, v13, {
			StepIndicator = stepIndicator,
			Header = header,
			Text = text
		}),
		Actions = 0
	}
	local actions

	if v3.actions and #v3.actions > 0 then
		actions = React.createElement(View, {
			LayoutOrder = 3,
			tag = Flags.FoundationEducationalTooltipRefresh and "row align-x-right size-full-0 auto-y padding-x-medium padding-bottom-medium" or "row gap-small size-full-0 auto-y padding-x-medium"
		}, Flags.FoundationEducationalTooltipRefresh and {
			ButtonGroup = React.createElement(ButtonGroup, {
				buttons = buttons,
				fillBehavior = v3.actionsFillBehavior,
				maxButtonCount = 2,
				orientation = Orientation.Horizontal,
				size = InputSize.Small,
				testId = `{v3.testId}--actions`
			})
		} or buttons)
	end

	v14.Actions = actions
	v10.Content = createElement2(content, v11, createElement3(provider, { value = v2 }, createElement4(View, v12, v14)))
	return createElement(root, v9, v10)
end

return React.memo(React.forwardRef(Coachmark))
