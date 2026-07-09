local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local SocialCarouselParent = SocialCarousel.Parent
local TextService = game:GetService("TextService")
local Foundation = require(SocialCarouselParent.Foundation)
local React = require(SocialCarouselParent.React)
local Enums = Foundation.Enums
local FoundationImage = Foundation.Image
local Skeleton = Foundation.Skeleton
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local Flags = Foundation.Utility.Flags
local StatusIndicator = Foundation.StatusIndicator
local StatusIndicatorVariant = Foundation.Enums.StatusIndicatorVariant
local EnumsRadius = Foundation.Enums.Radius
local FFlagSocialCarouselShowLoadingSkeleton = require(SocialCarousel.Flags.FFlagSocialCarouselShowLoadingSkeleton)
local FIntSocalCarouselMaxNewRequestsCount = require(SocialCarousel.Flags.FIntSocalCarouselMaxNewRequestsCount)

local function Tile(t1: {[any]: any}) -- line: 43
	-- upvalues: React (copy), useTokens (copy), FFlagSocialCarouselShowLoadingSkeleton (copy), TextService (copy), View (copy), FoundationImage (copy), Enums (copy), FoundationText (copy), StatusIndicator (copy), Flags (copy), StatusIndicatorVariant (copy), FIntSocalCarouselMaxNewRequestsCount (copy), Skeleton (copy), EnumsRadius (copy), Icon (copy), IconSize (copy)
	local v22 = t1.tileRef or React.useRef(nil)
	local v23 = useTokens()
	local v24, v25 = React.useState(false)
	local TitleSmall = v23.Typography.TitleSmall
	local v27 = FFlagSocialCarouselShowLoadingSkeleton and t1.isLoading
	local v28 = React.useMemo(function() -- line: 50
		-- upvalues: t1 (copy), TextService (copy), TitleSmall (copy)
		if not t1.title then
			return Vector2.new(0, 0)
		end

		return TextService:GetTextSize(t1.title, TitleSmall.FontSize, TitleSmall.Font, Vector2.new(500, 500))
	end, { t1.title })
	local v29 = React.useMemo(function() -- line: 58
		-- upvalues: t1 (copy), React (copy), View (copy), FoundationImage (copy)
		if not t1.presenceIconEnabled and not t1.titleIcon then
			return nil
		end

		if t1.presenceIconEnabled then
			return (React.createElement(View, {
				tag = "size-300-300 bg-system-success radius-circle",
				LayoutOrder = 1
			}))
		end

		if t1.titleIcon then
			return (React.createElement(FoundationImage, {
				tag = "size-300-300 radius-circle",
				LayoutOrder = 1,
				Image = t1.titleIcon
			}))
		end

		return nil
	end, {
		t1.titleIcon,
		t1.presenceIconEnabled
	})
	local v30 = React.useMemo(function() -- line: 80
		-- upvalues: v22 (copy), v29 (copy), React (copy), v28 (copy)
		if not v22.current then
			return nil
		end

		local v34 = if not v29 then v22.current.AbsoluteSize.X else v22.current.AbsoluteSize.X - 16

		return (React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(v34, v28.Y)
		}))
	end, { v28 })
	local v31 = React.useCallback(function(p1) -- line: 91
		-- upvalues: v25 (copy), Enums (copy)
		v25(p1 == Enums.ControlState.Hover or p1 == Enums.ControlState.Pressed)
	end, {})
	local v32 = React.useMemo(function() -- line: 95
		-- upvalues: t1 (copy), React (copy), FoundationText (copy), v23 (copy)
		if not t1.subtitle then
			return nil
		end

		return (React.createElement(FoundationText, {
			tag = "size-full-0 auto-y clip text-truncate-end",
			LayoutOrder = 3,
			fontStyle = v23.Typography.LabelSmall,
			Text = t1.subtitle
		}))
	end, { t1.subtitle })
	local v33 = React.useMemo(function() -- line: 108
		-- upvalues: t1 (copy), React (copy), StatusIndicator (copy), Flags (copy), StatusIndicatorVariant (copy), FIntSocalCarouselMaxNewRequestsCount (copy)
		if not t1.badge then
			return nil
		end

		return (React.createElement(StatusIndicator, {
			Position = UDim2.new(0.9, 0, 0.1, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			variant = if not Flags.FoundationStatusIndicatorVariantExperiment then StatusIndicatorVariant.Emphasis else StatusIndicatorVariant.Alert,
			value = tonumber(t1.badge),
			max = FIntSocalCarouselMaxNewRequestsCount
		}))
	end, { t1.badge })

	return React.createElement(View, {
		tag = "auto-none",
		Size = t1.itemSize,
		LayoutOrder = t1.index,
		ref = v22,
		onStateChanged = v31,
		onActivated = if not v27 then t1.onActivated else nil,
		stateLayer = {
			affordance = Enums.StateLayerAffordance.None
		},
		selection = if v27 or not t1.selectionOrder then nil else {
			SelectionOrder = t1.selectionOrder,
			Selectable = t1.selectable == nil or t1.selectable
		}
	}, {
		Content = React.createElement(View, {
			tag = "size-full col align-x-center gap-small"
		}, {
			Image = if not v27 then React.createElement(FoundationImage, {
				LayoutOrder = 1,
				Image = t1.image,
				tag = {
					["size-full"] = true,
					["aspect-1-1"] = true,
					["bg-shift-300"] = not v24 and not t1.altBackground,
					["bg-system-neutral"] = not v24 and t1.altBackground,
					["radius-circle"] = true,
					["bg-shift-400"] = v24 and not t1.altBackground,
					["bg-system-contrast"] = v24 and t1.altBackground,
					["align-x-center"] = true,
					["align-y-center"] = true,
					row = true
				},
				stroke = {
					Color = v23.Color.Stroke.Emphasis.Color3,
					Transparency = v23.Color.Stroke.Emphasis.Transparency,
					Thickness = v23.Stroke.Thick,
					BorderStrokePosition = Enum.BorderStrokePosition.Inner
				}
			}, {
				Icon = if not t1.icon then nil else React.createElement(Icon, {
					name = t1.icon,
					size = IconSize.Large
				})
			}) else React.createElement(View, {
				tag = "size-full aspect-1-1",
				LayoutOrder = 1
			}, {
				AvatarSkeleton = React.createElement(Skeleton, {
					tag = "size-full",
					radius = EnumsRadius.Circle
				})
			}),
			TextContainer = React.createElement(View, {
				tag = "size-full-0 row auto-y gap-xsmall align-x-center align-y-center",
				LayoutOrder = 2
			}, {
				TitleIcon = if not v27 then v29 else nil,
				Title = if not t1.title or v27 then React.createElement(Skeleton, {
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, 16),
					radius = if not v27 then nil else EnumsRadius.Small
				}) else React.createElement(FoundationText, {
					tag = "auto-xy text-align-x-left clip text-truncate-end",
					LayoutOrder = 2,
					fontStyle = v23.Typography.TitleSmall,
					Text = t1.title
				}, {
					UISizeConstraint = v30
				})
			}),
			Subtitle = if not v27 then v32 else nil
		}),
		Badge = if not v27 then v33 else nil
	})
end

return Tile
