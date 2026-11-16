local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

require(parent.BuilderIcons)
local React = require(parent.React)

local Icon = require(Foundation.Components.Icon)
local InputSize = require(Foundation.Enums.InputSize)
local Text = require(Foundation.Components.Text)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local getSharedVariants = require(Foundation.Components.Button.getSharedVariants)
require(script.Parent.Parent.useCardVariants)
local useTokens = require(Foundation.Providers.Style.useTokens)

local function CardHeader(props)
	local v = useTokens()
	local variantProps = props.variantProps
	local gap = variantProps.titleRow.gap
	local name

	if typeof(props.icon) == "table" then
		name = props.icon.name
	else
		name = props.icon
	end

	local variant

	if typeof(props.icon) == "table" then
		variant = props.icon.variant
	end

	local v2

	if props.descriptionLineClamp ~= nil then
		v2 = variantProps.description.lineHeight * props.descriptionLineClamp
	end

	local createElement = React.createElement
	local v3 = {
		tag = variantProps.headerText.tag,
		LayoutOrder = 1,
		testId = `{props.testId}--header-content`
	}
	local eyebrow

	if props.eyebrow and props.title ~= nil then
		eyebrow = React.createElement(Text, {
			Text = props.eyebrow,
			tag = variantProps.eyebrow.tag,
			LayoutOrder = 1,
			testId = `{props.testId}--eyebrow`
		})
	end

	local titleRow

	if props.title ~= nil then
		local createElement2 = React.createElement
		local v4 = {
			tag = variantProps.titleRow.tag,
			layout = gap and {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, gap)
			} or nil,
			LayoutOrder = 2,
			testId = `{props.testId}--title-row`
		}
		local icon

		if name then
			icon = React.createElement(Icon, {
				name = name,
				variant = variant,
				size = variantProps.icon.size,
				LayoutOrder = 1,
				testId = `{props.testId}--icon`
			})
		end

		local title

		if props.title then
			title = React.createElement(Text, {
				Text = props.title,
				tag = variantProps.title.tag,
				LayoutOrder = 2,
				testId = `{props.testId}--title`
			})
		end

		titleRow = createElement2(View, v4, { Icon = icon, Title = title })
	end

	local description

	if props.description then
		local createElement2 = React.createElement
		local v4 = {
			Text = props.description,
			TextTruncate = 0,
			sizeConstraint = 0,
			tag = 0,
			LayoutOrder = 3,
			testId = 0
		}
		local textTruncate

		if v2 then
			textTruncate = Enum.TextTruncate.AtEnd
		end

		v4.TextTruncate = textTruncate
		v4.sizeConstraint = v2 and { MaxSize = Vector2.new(1e999, v2) } or nil

		v4.tag = variantProps.description.tag

		v4.testId = `{props.testId}--description`
		description = createElement2(Text, v4)
	end

	local element = createElement(View, v3, {
		Eyebrow = eyebrow,
		TitleRow = titleRow,
		Description = description
	})

	local height = getSharedVariants(v).sizes[InputSize.Small].container.height

	return React.createElement(View, {
		tag = variantProps.header.tag,
		sizeConstraint = { MinSize = Vector2.new(0, height) },
		LayoutOrder = 1,
		testId = `{props.testId}--header`
	}, { Text = element, Actions = props.actions })
end

return CardHeader
