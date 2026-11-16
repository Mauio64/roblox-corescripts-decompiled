local Players = game:GetService("Players")

local parent = script:FindFirstAncestor("SplitPane").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local Responsive = require(parent.Responsive)
local UserLib = require(parent.UserLib)

local View = Foundation.View
local Icon = Foundation.Icon
local Image = Foundation.Image
local Skeleton = Foundation.Skeleton
local Text = Foundation.Text
local FoundationProvider = Foundation.FoundationProvider
local IconName = Foundation.Enums.IconName
local ColorMode = Foundation.Enums.ColorMode
local useTokens = Foundation.Hooks.useTokens
local usePreferences = Foundation.Hooks.usePreferences
local useDeviceType = RobloxAppHooks.useDeviceType
local useDeviceInsets = Responsive.useDeviceInsets
local usePreferredInput = Responsive.usePreferredInput
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local LocalUserIdStore = require(parent.LocalUserIdStore)
local localUserIdStore = LocalUserIdStore.LocalUserIdStore
local getStandardSizeAvatarHeadShotRbxthumb = UserLib.Utils.getStandardSizeAvatarHeadShotRbxthumb
local RoactUtils = require(parent.RoactUtils)
local useAssetFetchStatus = RoactUtils.Hooks.useAssetFetchStatus
local VerifiedBadge = require(parent.VerifiedBadges.VerifiedBadge)

local function noOp() end

local function TourProfileChip(props)
	local v = useTokens()
	local v2 = useAssetFetchStatus(props.thumbnail) == Enum.AssetFetchStatus.Success
	local createElement = React.createElement
	local v3 = {
		tag = "row align-y-center gap-medium size-0-1000 auto-x padding-xsmall radius-medium",
		LayoutOrder = props.layoutOrder,
		testId = "split-pane-educational-tour--profile-chip"
	}

	local createElement2 = React.createElement
	local v4 = {
		tag = "size-1000-1000 radius-circle",
		backgroundStyle = v.Color.Common.Shimmer,
		LayoutOrder = 1
	}
	local thumbnailShimmer

	if not (props.isUserLoaded and v2) then
		thumbnailShimmer = React.createElement(Skeleton, {
			radius = Foundation.Enums.Radius.Circle,
			ZIndex = 1
		})
	end

	local children = {
		AvatarThumbnail = createElement2(View, v4, {
			ThumbnailShimmer = thumbnailShimmer,
			Thumbnail = React.createElement(Image, {
				tag = "size-full radius-circle",
				Image = props.thumbnail,
				ZIndex = 2
			})
		}),
		TextStack = 0
	}

	local createElement3 = React.createElement
	local createElement4 = React.createElement
	local displayNameShimmer

	if not props.isUserLoaded then
		displayNameShimmer = React.createElement(Skeleton, {
			radius = Foundation.Enums.Radius.Small,
			Size = UDim2.fromOffset(v.Size.Size_3000, v.Size.Size_300)
		})
	end

	local displayNameText

	if props.isUserLoaded then
		displayNameText = React.createElement(Text, {
			tag = "auto-xy content-inverse-emphasis",
			fontStyle = v.Typography.TitleLarge,
			Text = props.name,
			LayoutOrder = 1
		})
	end

	local verifiedBadge

	if props.isUserLoaded and props.isVerified then
		verifiedBadge = React.createElement(VerifiedBadge, {
			size = Foundation.Enums.IconSize.Large,
			LayoutOrder = 2
		})
	end

	local subscriberBadge

	if props.isUserLoaded and props.showSubscriberBadge then
		subscriberBadge = React.createElement(Icon, {
			name = IconName.RobloxPlus,
			size = Foundation.Enums.IconSize.Small,
			style = v.Inverse.Content.Emphasis,
			LayoutOrder = 3
		})
	end

	children.TextStack = createElement3(View, { tag = "auto-xy", LayoutOrder = 2 }, {
		DisplayNameRow = createElement4(View, {
			tag = "row align-y-center gap-small auto-xy",
			LayoutOrder = 1
		}, {
			DisplayNameShimmer = displayNameShimmer,
			DisplayNameText = displayNameText,
			VerifiedBadge = verifiedBadge,
			SubscriberBadge = subscriberBadge
		})
	})
	return createElement(View, v3, children)
end

local forwardRef = React.forwardRef(function(props, ref)
	local v = useTokens()
	local v2

	if props.usesOverMediaStyle then
		v2 = v.Color.ActionOverMedia
	else
		v2 = v.Color.ActionUtility
	end

	local createElement = React.createElement
	local v3 = {
		ref = ref,
		tag = "row align-x-center align-y-center",
		Size = UDim2.fromOffset(v.Size.Size_1000, v.Size.Size_1000),
		cornerRadius = 0,
		backgroundStyle = 0,
		stroke = 0,
		testId = 0,
		LayoutOrder = 0
	}
	local v4

	if props.isCircular then
		v4 = v.Radius.Circle
	else
		v4 = v.Radius.Medium
	end

	v3.cornerRadius = UDim.new(0, v4)
	v3.backgroundStyle = v2.Background
	v3.stroke = v2.Border ~= nil and {
		Color = v2.Border.Color3,
		Transparency = v2.Border.Transparency
	} or nil

	v3.testId = props.testId
	v3.LayoutOrder = props.LayoutOrder
	return createElement(View, v3, {
		Icon = React.createElement(Icon, {
			name = props.icon,
			size = v.Size.Size_600,
			style = v2.Foreground,
			LayoutOrder = 1
		})
	})
end)

local forwardRef2 = React.forwardRef(function(props, ref)
	local v = useTokens()
	local actionOverMedia = v.Color.ActionOverMedia
	return React.createElement(View, {
		ref = ref,
		tag = "row align-x-center align-y-center gap-small padding-medium clip",
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.fromOffset(0, v.Size.Size_1000),
		cornerRadius = UDim.new(0, v.Radius.Medium),
		backgroundStyle = actionOverMedia.Background,
		stroke = actionOverMedia.Border ~= nil and {
			Color = actionOverMedia.Border.Color3,
			Transparency = actionOverMedia.Border.Transparency
		} or nil,
		testId = props.testId,
		LayoutOrder = props.LayoutOrder
	}, {
		Label = React.createElement(Text, {
			tag = "shrink size-0-full auto-x text-label-medium text-truncate-end",
			Text = props.text,
			textStyle = actionOverMedia.Foreground,
			LayoutOrder = 1
		})
	})
end)

local function getHasRobloxSubscription(localPlayer) -- 1 equivalent call inferred from this helper
	if localPlayer == nil then
		return false
	end

	local success, result = pcall(function(): boolean
		return localPlayer.HasRobloxSubscription == true
	end)

	return success and result
end

local function TourOwnedSupportPaneChrome(props)
	local v = useTokens()
	local device = useDeviceType()
	local preferences = usePreferences()
	local v2 = useDeviceInsets()
	local v3 = usePreferredInput() == Responsive.Input.Directional
	local v4 = useLocalization({ editAvatarButtonText = "Feature.SplitPane.EditAvatarButtonText" })

	local v5 = useSignalState(localUserIdStore.getCurrentUserId)
	local localPlayer = Players.LocalPlayer
	local isUserLoaded

	if localPlayer == nil then
		isUserLoaded = false
	else
		isUserLoaded = v5 ~= ""
	end

	local hasRobloxSubscription = getHasRobloxSubscription(localPlayer) -- inferred equivalent call
	local v6 = useAppPolicy(function(p)
		return p.getShowDisplayName()
	end)

	local function scopedStyle(colorMode) -- 4 equivalent calls inferred from this helper
		return { colorMode = colorMode, device = device, preferences = preferences }
	end

	local createElement = React.createElement
	local v7 = {
		Name = "TourOwnedSupportPaneChrome",
		Position = UDim2.fromOffset(props.supportPaneRect.Min.X, props.supportPaneRect.Min.Y),
		Size = UDim2.fromOffset(
			props.supportPaneRect.Max.X - props.supportPaneRect.Min.X,
			props.supportPaneRect.Max.Y - props.supportPaneRect.Min.Y
		),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 2
	}

	local children = {
		InputSink = React.createElement("TextButton", {
			Name = "InputSink",
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Active = true,
			Selectable = false,
			Text = "",
			ZIndex = 2,
			[React.Event.Activated] = noOp
		}),
		Vignette = React.createElement("Frame", {
			Name = "Vignette",
			Position = UDim2.fromOffset(0, -v2.top),
			Size = UDim2.new(1, v2.right, 1, v2.top + v2.bottom),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 3
		}, {
			TopScrim = React.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 0, 158),
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 0.1,
					BorderSizePixel = 0
				},
				{
					Gradient = React.createElement("UIGradient", {
						Rotation = 90,
						Transparency = NumberSequence.new({
							NumberSequenceKeypoint.new(0, 0),
							NumberSequenceKeypoint.new(1, 1)
						})
					})
				}
			),
			BottomScrim = React.createElement("Frame", {
				Position = UDim2.new(0, 0, 1, 0),
				AnchorPoint = Vector2.new(0, 1),
				Size = UDim2.new(1, 0, 0, 158),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 0.3,
				BorderSizePixel = 0
			}, {
				Gradient = React.createElement("UIGradient", {
					Rotation = 90,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(1, 0)
					})
				})
			})
		}),
		Content = 0
	}

	local createElement2 = React.createElement

	local v8 = {
		BottomPaneTooltipAnchor = React.createElement("Frame", {
			ref = props.onBottomPaneTooltipAnchorInstanceChanged,
			Position = UDim2.new(0, 0, 1, v.Padding.Small),
			AnchorPoint = Vector2.new(0, 1),
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}),
		GamepadStepTwoTooltipAnchor = 0,
		GamepadFinalTooltipAnchor = 0,
		OverMediaScope = 0,
		MiddleAreaScope = 0,
		BottomAreaScope = 0
	}
	local gamepadStepTwoTooltipAnchor

	if v3 then
		gamepadStepTwoTooltipAnchor = React.createElement("Frame", {
			Name = "GamepadStepTwoTooltipAnchor",
			ref = props.onGamepadStepTwoTooltipAnchorInstanceChanged,
			Position = UDim2.new(0.5, 0, 1, -16),
			AnchorPoint = Vector2.new(0.5, 0),
			Size = UDim2.fromOffset(1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		})
	end

	v8.GamepadStepTwoTooltipAnchor = gamepadStepTwoTooltipAnchor
	local gamepadFinalTooltipAnchor

	if v3 then
		gamepadFinalTooltipAnchor = React.createElement("Frame", {
			Name = "GamepadFinalTooltipAnchor",
			ref = props.onGamepadFinalTooltipAnchorInstanceChanged,
			Position = UDim2.new(0.5, 0, 150 / 217, 0),
			AnchorPoint = Vector2.new(0.5, 0),
			Size = UDim2.fromOffset(1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		})
	end

	v8.GamepadFinalTooltipAnchor = gamepadFinalTooltipAnchor

	local createElement3 = React.createElement
	local v9 = { Size = UDim2.fromScale(1, 1) }

	local createElement4 = React.createElement
	local v10 = scopedStyle(ColorMode.Light) -- inferred equivalent call
	local createElement5 = React.createElement
	local v11 = {
		tag = "row align-y-center anchor-top-center size-full-1200",
		Position = UDim2.new(0.5, 0, 0, props.topInset),
		padding = not v3 and {
			right = UDim.new(0, -v.Padding.Small)
		} or nil
	}

	local createElement6 = React.createElement
	local thumbnail

	if isUserLoaded then
		thumbnail = getStandardSizeAvatarHeadShotRbxthumb(v5)
	end

	local name

	if localPlayer then
		name = if v6 then localPlayer.DisplayName else localPlayer.Name
	end

	local isVerified

	if localPlayer then
		isVerified = localPlayer.HasVerifiedBadge
	end

	local children2 = {
		ProfileChip = createElement6(TourProfileChip, {
			isUserLoaded = isUserLoaded,
			thumbnail = thumbnail,
			name = name,
			isVerified = isVerified,
			showSubscriberBadge = hasRobloxSubscription,
			layoutOrder = 1
		}),
		Spacer = React.createElement(View, { tag = "grow auto-y", LayoutOrder = 2 }),
		CollapseButton = 0,
		TopEditAvatarButton = 0
	}
	local collapseButton

	if not v3 then
		collapseButton = React.createElement(View, {
			AutomaticSize = Enum.AutomaticSize.XY,
			LayoutOrder = 3
		}, {
			DarkScope = React.createElement(FoundationProvider, scopedStyle(ColorMode.Dark), { -- inferred equivalent call
				CollapseButton = React.createElement(forwardRef, {
					ref = props.onTopRightControlInstanceChanged,
					testId = "split-pane-educational-tour--collapse",
					icon = IconName.RectangleRightPaneChevronRight,
					LayoutOrder = 3
				})
			})
		})
	end

	children2.CollapseButton = collapseButton
	local topEditAvatarButton

	if v3 then
		topEditAvatarButton = React.createElement(forwardRef2, {
			ref = props.onTopRightControlInstanceChanged,
			testId = "split-pane-educational-tour--top-edit-avatar",
			text = v4.editAvatarButtonText,
			LayoutOrder = 3
		})
	end

	children2.TopEditAvatarButton = topEditAvatarButton
	v8.OverMediaScope = createElement3(View, v9, {
		OverMediaProvider = createElement4(FoundationProvider, v10, {
			TopArea = createElement5(View, v11, children2)
		})
	})
	local middleAreaScope

	if not v3 then
		middleAreaScope = React.createElement(View, { Size = UDim2.fromScale(1, 1) }, {
			LightScope = React.createElement(FoundationProvider, scopedStyle(ColorMode.Light), { -- inferred equivalent call
				MiddleArea = React.createElement(
					View,
					{ tag = "row position-center-center anchor-center-center size-full-1000" },
					{
						Spacer = React.createElement(View, { tag = "grow auto-y", LayoutOrder = 1 }),
						RightChevron = React.createElement(forwardRef, {
							testId = "split-pane-educational-tour--next-avatar",
							icon = IconName.ChevronLargeRight,
							isCircular = true,
							usesOverMediaStyle = true,
							LayoutOrder = 3
						})
					}
				)
			})
		})
	end

	v8.MiddleAreaScope = middleAreaScope
	local bottomAreaScope

	if not v3 then
		bottomAreaScope = React.createElement(View, { Size = UDim2.fromScale(1, 1) }, {
			LightScope = React.createElement(FoundationProvider, scopedStyle(ColorMode.Light), { -- inferred equivalent call
				BottomArea = React.createElement(
					View,
					{
						tag = "row align-x-center position-bottom-center anchor-bottom-center size-full-1200 padding-bottom-small"
					},
					{
						EditAvatarButton = React.createElement(forwardRef2, {
							testId = "split-pane-educational-tour--edit-avatar",
							text = v4.editAvatarButtonText
						})
					}
				)
			})
		})
	end

	v8.BottomAreaScope = bottomAreaScope
	children.Content = createElement2(View, {
		tag = "size-full-full margin-x-medium padding-y-small",
		ZIndex = 4
	}, v8)
	return createElement("Frame", v7, children)
end

return TourOwnedSupportPaneChrome
