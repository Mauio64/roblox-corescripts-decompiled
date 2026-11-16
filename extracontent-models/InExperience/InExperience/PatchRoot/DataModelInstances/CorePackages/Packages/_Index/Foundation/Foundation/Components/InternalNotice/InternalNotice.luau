local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local CloseAffordance = require(Foundation.Components.CloseAffordance)
local CloseAffordanceVariant = require(Foundation.Enums.CloseAffordanceVariant)
local Flags = require(Foundation.Utility.Flags)
local Icon = require(Foundation.Components.Icon)
local InputSize = require(Foundation.Enums.InputSize)
local Link = require(Foundation.Components.Link)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)
local Text = require(Foundation.Components.Text)
local TextOverflow = require(Foundation.Enums.TextOverflow)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local escapeRichText = require(Foundation.Utility.escapeRichText)
local useInternalNoticeLayout = require(script.Parent.useInternalNoticeLayout)
local useInternalNoticeVariantsProps = require(script.Parent.useInternalNoticeVariantsProps)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)

local function InternalNotice(props, ref)
	local testId = props.testId or "--foundation-internal-notice"
	local size_600 = useTokens().Size.Size_600
	local udim = UDim2.fromOffset(0, size_600)
	local sizeConstraint = React.useMemo(function()
		return { MinSize = Vector2.new(0, size_600) }
	end, { size_600 })

	local v = useInternalNoticeLayout(props.onAbsoluteSizeChanged)
	local isStacked = v.isStacked
	local v2 = useInternalNoticeVariantsProps(props.variantProps, isStacked, props.truncation == true)
	local v3

	if typeof(props.icon) == "string" then
		v3 = { name = props.icon, variant = nil }
	else
		v3 = props.icon
	end

	local icon

	if v3 then
		icon = React.createElement(Icon, {
			name = v3.name,
			variant = v3.variant,
			size = v2.icon.size,
			style = v2.icon.style,
			LayoutOrder = 1,
			testId = `{testId}--icon`
		})
	end

	local icon2

	if icon then
		icon2 = React.createElement(View, {
			tag = "col align-y-center auto-x",
			Size = udim,
			LayoutOrder = 1
		}, {
			Icon = icon
		})
	end

	local element = React.createElement(Text, {
		Text = props.text,
		tag = v2.message.tag,
		padding = v2.message.padding,
		LayoutOrder = 2,
		testId = `{testId}--message`
	})

	local linkContainer = v2.linkContainer
	local link

	if props.link and Flags.FoundationInternalNoticeUseLink then
		local createElement = React.createElement
		local tag

		if linkContainer then
			tag = linkContainer.tag
		end

		local v4 = {
			tag = tag,
			padding = v2.link.padding,
			LayoutOrder = isStacked and 3 or 2,
			onAbsoluteSizeChanged = v.measureInlineLink
		}

		local createElement2 = React.createElement
		local v5 = {
			text = props.link.text,
			onActivated = props.link.onActivated,
			size = v2.link.size,
			hasUnderline = true,
			textOverflow = 0,
			testId = 0
		}
		local textOverflow

		if isStacked then
			if props.truncation then
				textOverflow = TextOverflow.Truncate
			else
				textOverflow = TextOverflow.Wrap
			end
		else
			textOverflow = TextOverflow.None
		end

		v5.textOverflow = textOverflow

		v5.testId = `{testId}--link`
		link = createElement(View, v4, { Link = createElement2(Link, v5) })
	elseif props.link then
		link = React.createElement(Text, {
			Text = `<u>{escapeRichText(props.link.text)}</u>`,
			RichText = true,
			tag = v2.link.tag,
			padding = v2.link.padding,
			sizeConstraint = v.stackedLinkConstraint,
			stateLayer = { affordance = StateLayerAffordance.None },
			onActivated = props.link.onActivated,
			LayoutOrder = isStacked and 3 or 2,
			testId = `{testId}--link`,
			onAbsoluteSizeChanged = v.measureInlineLink
		})
	end

	local close

	if props.onClose then
		close = React.createElement(View, {
			tag = "col align-y-center auto-x",
			Size = udim,
			LayoutOrder = 3
		}, {
			Close = React.createElement(CloseAffordance, {
				onActivated = props.onClose,
				size = InputSize.Small,
				variant = CloseAffordanceVariant.Utility,
				hasPadding = false,
				LayoutOrder = 1,
				testId = `{testId}--close`
			})
		})
	end

	local container = v2.container
	local tag

	if container then
		tag = container.tag
	end

	local backgroundStyle

	if container then
		backgroundStyle = container.backgroundStyle
	end

	local v4 = withCommonProps(props, { tag = tag, backgroundStyle = backgroundStyle, ref = ref })

	v4.onAbsoluteSizeChanged = v.onNoticeAbsoluteSizeChanged

	local createElement = React.createElement

	local v5 = {
		tag = v2.content.tag,
		padding = v2.content.padding,
		LayoutOrder = v2.border and 2 or 1
	}
	local v6

	if isStacked then
		v6 = {
			Icon = icon2,
			Stack = React.createElement(View, {
				LayoutOrder = 2,
				tag = v2.stack.tag,
				sizeConstraint = sizeConstraint,
				onAbsoluteSizeChanged = v.onStackedColumnAbsoluteSizeChanged,
				testId = `{testId}--stack`
			}, { Message = element, Link = link }),
			Close = close
		}
	else
		v6 = {
			Leading = React.createElement(
				View,
				{
					tag = v2.leading.tag,
					sizeConstraint = sizeConstraint,
					LayoutOrder = 1,
					testId = `{testId}--leading`
				},
				{ Icon = icon2, Message = element }
			),
			Link = link,
			Close = close
		}
	end

	local element2 = createElement(View, v5, v6)

	return React.createElement(View, v4, v2.border and {
		TopBorder = React.createElement(View, {
			Size = v2.border.Size,
			backgroundStyle = v2.border.backgroundStyle,
			LayoutOrder = 1,
			testId = `{testId}--top-border`
		}),
		Main = element2,
		BottomBorder = React.createElement(View, {
			Size = v2.border.Size,
			backgroundStyle = v2.border.backgroundStyle,
			LayoutOrder = 3,
			testId = `{testId}--bottom-border`
		})
	} or { Main = element2 })
end

return React.memo(React.forwardRef(InternalNotice))
