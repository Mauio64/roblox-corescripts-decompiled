local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/Foundation")
local usePulseAnimationBinding = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/AvatarExperienceCommon").Hooks.usePulseAnimationBinding

local useSemanticTokens = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/Hooks/useSemanticTokens")
local useHoverBinding = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/Hooks/useHoverBinding")

local function ImageItem(props, p2)
	local v5 = useSemanticTokens()
	local v6, v7 = useHoverBinding()
	local ref = React.useRef(nil)

	local v8 = if props.size then props.size else v5.defaultIconContainerSize
	local v9 = usePulseAnimationBinding(props.enableFocusAnimation)

	local createElement = React.createElement
	local view = Foundation.View
	local v10 = {
		tag = "auto-xy radius-circle",
		ref = p2,
		LayoutOrder = props.LayoutOrder,
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		onStateChanged = v7,
		onActivated = props.onActivated,
		disabled = props.disabled,
		Visible = props.Visible
	}
	local v11 = {
		Thumbnail = React.createElement(Foundation.Image, {
			Image = props.thumbnailUrl,
			Size = UDim2.fromOffset(v8, v8),
			tag = "radius-circle",
			backgroundStyle = v6:map(function(p3)
				if p3 then
					return v5.hoverThumbnailBackgroundStyle
				end

				return v5.thumbnailBackgroundStyle
			end)
		}),
		Indicator = 0,
		UIStroke = 0
	}

	local v12 = if not props.hideIndicator then React.createElement(
		Foundation.View,
		{
			tag = "auto-xy position-bottom-right anchor-bottom-right bg-surface-300 radius-circle size-400-400",
			ZIndex = 2
		},
		{
			IndicatorImage = React.createElement(Foundation.Image, {
				Image = "icons/actions/truncationExpand_small",
				imageStyle = v5.contentForegroundStyle,
				tag = "radius-circle position-center-center anchor-center-center size-250-250"
			})
		}
	) else nil
	v11.Indicator = v12
	local v13

	if props.enableFocusAnimation then
		v13 = React.createElement("UIStroke", {
			Color = v5.imageBorderFocusStyle,
			Thickness = v9:map(function(p3)
				return p3.thickness
			end),
			Transparency = v9:map(function(p3)
				return p3.transparency
			end),
			ref = ref
		})
	end

	v11.UIStroke = v13
	return createElement(view, v10, v11)
end

return React.forwardRef(ImageItem)
