local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local BannerContextPresentation = require(Foundation.Enums.BannerContextPresentation)
local BannerContextVariant = require(Foundation.Enums.BannerContextVariant)
local InternalNotice = require(Foundation.Components.InternalNotice)
require(Foundation.Components.Types)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local useBannerContextVariants = require(script.Parent.useBannerContextVariants)

local v = {
	variant = BannerContextVariant.Standard,
	presentation = BannerContextPresentation.Inline,
	testId = "--foundation-banner-context"
}

local function BannerContext(p, ref)
	local v2 = withDefaults(p, v)
	local variantProps = useBannerContextVariants(useTokens(), v2.presentation, v2.variant)

	return React.createElement(InternalNotice, withCommonProps(v2, {
		text = v2.text,
		icon = v2.icon,
		link = v2.link,
		onClose = v2.onClose,
		truncation = true,
		variantProps = variantProps,
		ref = ref
	}))
end

return React.memo(React.forwardRef(BannerContext))
