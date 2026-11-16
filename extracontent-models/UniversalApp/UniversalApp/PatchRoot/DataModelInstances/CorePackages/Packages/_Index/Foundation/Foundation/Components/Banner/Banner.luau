local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Button = require(Foundation.Components.Button)
local Card = require(Foundation.Components.Card)
require(Foundation.Components.Types)

local BannerSize = require(Foundation.Enums.BannerSize)
local ButtonVariant = require(Foundation.Enums.ButtonVariant)
local CardDensity = require(Foundation.Enums.CardDensity)
local CardHeaderSize = require(Foundation.Enums.CardHeaderSize)
local CardVariant = require(Foundation.Enums.CardVariant)
local InputSize = require(Foundation.Enums.InputSize)

local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

require(script.Parent.Subcomponents.Thumbnail)
local UpsellContent = require(script.Parent.Subcomponents.UpsellContent)

local v = {
	size = BannerSize.Medium,
	density = CardDensity.Default,
	testId = "--foundation-banner"
}

local function Banner(props, ref)
	local v2 = withDefaults(props, v)
	local primary

	if props.actions then
		primary = props.actions.primary
	end

	local v3 = {
		variant = CardVariant.Emphasis,
		density = v2.density,
		headerSize = 0,
		onActivated = 0,
		ref = 0
	}
	local headerSize

	if v2.density == CardDensity.Compact then
		headerSize = CardHeaderSize.Small
	else
		headerSize = CardHeaderSize.Medium
	end

	v3.headerSize = headerSize
	local onActivated

	if primary then
		onActivated = primary.onActivated
	end

	v3.onActivated = onActivated
	v3.ref = ref
	local v4

	if props.size == BannerSize.Small then
		v4 = { UpsellContent = 0 }
		local createElement = React.createElement
		local v5 = {
			density = v2.density,
			title = v2.title,
			description = v2.description,
			thumbnail = props.thumbnail,
			onActivated = 0,
			onClose = 0,
			testId = 0
		}
		local onActivated2

		if primary then
			onActivated2 = primary.onActivated
		end

		v5.onActivated = onActivated2
		local onClose

		if not primary then
			onClose = props.onClose
		end

		v5.onClose = onClose
		v5.testId = v2.testId
		v4.UpsellContent = createElement(UpsellContent, v5)
	else
		local secondary

		if props.actions then
			secondary = props.actions.secondary
		end

		if props.onClose then
			v3.onClose = props.onClose
		end

		v3.title = v2.title
		v3.description = v2.description
		v3.lineClamp = {
			description = v2.density == CardDensity.Compact and 2 or 3
		}
		local media

		if typeof(props.media) == "table" then
			media = { image = props.media.image, width = props.media.width }
		else
			media = props.media
		end

		v3.media = media

		v4 = secondary and {
			SecondaryAction = React.createElement(Button, {
				text = secondary.text,
				onActivated = secondary.onActivated,
				variant = ButtonVariant.SoftEmphasis,
				size = InputSize.Small,
				LayoutOrder = 1,
				testId = `{v2.testId}--secondary-action`
			})
		} or nil
	end

	return React.createElement(Card, withCommonProps(v2, v3), v4)
end

return React.memo(React.forwardRef(Banner))
