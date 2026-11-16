local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")

local parent = AvatarExperienceControlBar.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local usePulseAnimationBinding = AvatarExperienceCommon.Hooks.usePulseAnimationBinding

local useSemanticTokens = require(AvatarExperienceControlBar.Hooks.useSemanticTokens)
local useHoverBinding = require(AvatarExperienceControlBar.Hooks.useHoverBinding)

local function ImageItem(props, ref2)
	local v = useSemanticTokens()
	local v2, onStateChanged = useHoverBinding()
	local ref = React.useRef(nil)
	local v3

	if props.size then
		v3 = props.size
	else
		v3 = v.defaultIconContainerSize
	end

	local v4 = usePulseAnimationBinding(props.enableFocusAnimation)

	local createElement = React.createElement
	local view = Foundation.View
	local v5 = {
		tag = "auto-xy radius-circle",
		ref = ref2,
		LayoutOrder = props.LayoutOrder,
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		onStateChanged = onStateChanged,
		onActivated = props.onActivated,
		disabled = props.disabled,
		Visible = props.Visible
	}
	local v6 = {
		Thumbnail = React.createElement(Foundation.Image, {
			Image = props.thumbnailUrl,
			Size = UDim2.fromOffset(v3, v3),
			tag = "radius-circle",
			backgroundStyle = v2:map(function(p)
				if p then
					return v.hoverThumbnailBackgroundStyle
				end

				return v.thumbnailBackgroundStyle
			end)
		}),
		Indicator = 0,
		UIStroke = 0
	}
	local indicator

	if not props.hideIndicator then
		indicator = React.createElement(
			Foundation.View,
			{
				tag = "auto-xy position-bottom-right anchor-bottom-right bg-surface-300 radius-circle size-400-400",
				ZIndex = 2
			},
			{
				IndicatorImage = React.createElement(Foundation.Image, {
					Image = "icons/actions/truncationExpand_small",
					imageStyle = v.contentForegroundStyle,
					tag = "radius-circle position-center-center anchor-center-center size-250-250"
				})
			}
		)
	end

	v6.Indicator = indicator
	local uiStroke

	if props.enableFocusAnimation then
		uiStroke = React.createElement("UIStroke", {
			Color = v.imageBorderFocusStyle,
			Thickness = v4:map(function(p)
				return p.thickness
			end),
			Transparency = v4:map(function(p)
				return p.transparency
			end),
			ref = ref
		})
	end

	v6.UIStroke = uiStroke
	return createElement(view, v5, v6)
end

return React.forwardRef(ImageItem)
