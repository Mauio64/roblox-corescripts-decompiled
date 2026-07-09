local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")
local AvatarExperienceControlBarParent = AvatarExperienceControlBar.Parent
local React = require(AvatarExperienceControlBarParent.React)
local Foundation = require(AvatarExperienceControlBarParent.Foundation)
local usePulseAnimationBinding = require(AvatarExperienceControlBarParent.AvatarExperienceCommon).Hooks.usePulseAnimationBinding
local useSemanticTokens = require(AvatarExperienceControlBar.Hooks.useSemanticTokens)
local useHoverBinding = require(AvatarExperienceControlBar.Hooks.useHoverBinding)

local function ImageItem(t1: {[any]: any}, p1) -- line: 25
	-- upvalues: useSemanticTokens (copy), useHoverBinding (copy), React (copy), usePulseAnimationBinding (copy), Foundation (copy)
	local v11 = useSemanticTokens()
	local v12, v13 = useHoverBinding()
	local v14 = React.useRef(nil)
	local v15 = if not t1.size then v11.defaultIconContainerSize else t1.size
	local v16 = usePulseAnimationBinding(t1.enableFocusAnimation)

	return React.createElement(Foundation.View, {
		tag = "auto-xy radius-circle",
		ref = p1,
		LayoutOrder = t1.LayoutOrder,
		stateLayer = {
			affordance = Foundation.Enums.StateLayerAffordance.None
		},
		onStateChanged = v13,
		onActivated = t1.onActivated,
		disabled = t1.disabled,
		Visible = t1.Visible
	}, {
		Thumbnail = React.createElement(Foundation.Image, {
			tag = "radius-circle",
			Image = t1.thumbnailUrl,
			Size = UDim2.fromOffset(v15, v15),
			backgroundStyle = v12:map(function(p2) -- line: 49
				-- upvalues: v11 (copy)
				if p2 then
					return v11.hoverThumbnailBackgroundStyle
				end

				return v11.thumbnailBackgroundStyle
			end)
		}),
		Indicator = if t1.hideIndicator then nil else React.createElement(Foundation.View, {
			tag = "auto-xy position-bottom-right anchor-bottom-right bg-surface-300 radius-circle size-400-400",
			ZIndex = 2
		}, {
			IndicatorImage = React.createElement(Foundation.Image, {
				Image = "icons/actions/truncationExpand_small",
				tag = "radius-circle position-center-center anchor-center-center size-250-250",
				imageStyle = v11.contentForegroundStyle
			})
		}),
		UIStroke = if not t1.enableFocusAnimation then nil else React.createElement("UIStroke", {
			Color = v11.imageBorderFocusStyle,
			Thickness = v16:map(function(p3) -- line: 71
				return p3.thickness
			end),
			Transparency = v16:map(function(p4) -- line: 74
				return p4.transparency
			end),
			ref = v14
		})
	})
end

return React.forwardRef(ImageItem)
