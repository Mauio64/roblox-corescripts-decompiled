local Players = game:GetService("Players")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/Foundation")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/RobloxAppHooks")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/Responsive")
local UserLib = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/UserLib")

local view = Foundation.View
local icon = Foundation.Icon
local image = Foundation.Image
local skeleton = Foundation.Skeleton
local text = Foundation.Text
local foundationProvider = Foundation.FoundationProvider
local iconName = Foundation.Enums.IconName
local colorMode = Foundation.Enums.ColorMode
local useTokens = Foundation.Hooks.useTokens
local usePreferences = Foundation.Hooks.usePreferences
local useDeviceType = RobloxAppHooks.useDeviceType
local useDeviceInsets = Responsive.useDeviceInsets
local usePreferredInput = Responsive.usePreferredInput
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/Localization").Hooks.useLocalization
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/SignalsReact").useSignalState
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/UniversalAppPolicy").useAppPolicy
local localUserIdStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/LocalUserIdStore").LocalUserIdStore
local getStandardSizeAvatarHeadShotRbxthumb = UserLib.Utils.getStandardSizeAvatarHeadShotRbxthumb
local useAssetFetchStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/RoactUtils").Hooks.useAssetFetchStatus
local module6 = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/VerifiedBadges/VerifiedBadge")

local function noOp() end

local function TourProfileChip(props)
	local v5 = useTokens()
	local v6 = useAssetFetchStatus(props.thumbnail) == Enum.AssetFetchStatus.Success
	local createElement = React.createElement
	local v8 = {
		tag = "row align-y-center gap-medium size-0-1000 auto-x padding-xsmall radius-medium",
		LayoutOrder = props.layoutOrder,
		testId = "split-pane-educational-tour--profile-chip"
	}

	local createElement2 = React.createElement
	local v10 = {
		tag = "size-1000-1000 radius-circle",
		backgroundStyle = v5.Color.Common.Shimmer,
		LayoutOrder = 1
	}

	local v12 = if not (props.isUserLoaded and v6) then React.createElement(skeleton, {
		radius = Foundation.Enums.Radius.Circle,
		ZIndex = 1
	}) else nil
	local children = {
		AvatarThumbnail = createElement2(view, v10, {
			ThumbnailShimmer = v12,
			Thumbnail = React.createElement(image, {
				tag = "size-full radius-circle",
				Image = props.thumbnail,
				ZIndex = 2
			})
		}),
		TextStack = 0
	}

	local createElement3 = React.createElement
	local createElement4 = React.createElement

	local v19 = if not props.isUserLoaded then React.createElement(skeleton, {
		radius = Foundation.Enums.Radius.Small,
		Size = UDim2.fromOffset(v5.Size.Size_3000, v5.Size.Size_300)
	}) else nil

	local v20 = if props.isUserLoaded then React.createElement(text, {
		tag = "auto-xy content-inverse-emphasis",
		fontStyle = v5.Typography.TitleLarge,
		Text = props.name,
		LayoutOrder = 1
	}) else nil

	local v21 = if props.isUserLoaded and props.isVerified then React.createElement(module6, {
		size = Foundation.Enums.IconSize.Large,
		LayoutOrder = 2
	}) else nil

	local v22 = if props.isUserLoaded and props.showSubscriberBadge then React.createElement(icon, {
		name = iconName.RobloxPlus,
		size = Foundation.Enums.IconSize.Small,
		style = v5.Inverse.Content.Emphasis,
		LayoutOrder = 3
	}) else nil
	children.TextStack = createElement3(view, { tag = "auto-xy", LayoutOrder = 2 }, {
		DisplayNameRow = createElement4(
			view,
			{ tag = "row align-y-center gap-small auto-xy", LayoutOrder = 1 },
			{
				DisplayNameShimmer = v19,
				DisplayNameText = v20,
				VerifiedBadge = v21,
				SubscriberBadge = v22
			}
		)
	})
	return createElement(view, v8, children)
end

local forwardRef = React.forwardRef(function(props, p2)
	local v5 = useTokens()
	local v6 = if props.usesOverMediaStyle then v5.Color.ActionOverMedia else v5.Color.ActionUtility
	local createElement = React.createElement
	local v8 = {
		ref = p2,
		tag = "row align-x-center align-y-center",
		Size = UDim2.fromOffset(v5.Size.Size_1000, v5.Size.Size_1000),
		cornerRadius = 0,
		backgroundStyle = 0,
		stroke = 0,
		testId = 0,
		LayoutOrder = 0
	}
	local newUDim = UDim.new
	local v10 = if props.isCircular then v5.Radius.Circle else v5.Radius.Medium
	v8.cornerRadius = newUDim(0, v10)
	v8.backgroundStyle = v6.Background
	v8.stroke = v6.Border ~= nil and {
			Color = v6.Border.Color3,
			Transparency = v6.Border.Transparency
		}
		or nil

	v8.testId = props.testId
	v8.LayoutOrder = props.LayoutOrder
	return createElement(view, v8, {
		Icon = React.createElement(icon, {
			name = props.icon,
			size = v5.Size.Size_600,
			style = v6.Foreground,
			LayoutOrder = 1
		})
	})
end)

local forwardRef2 = React.forwardRef(function(props, p2)
	local v5 = useTokens()
	local actionOverMedia = v5.Color.ActionOverMedia
	return React.createElement(view, {
		ref = p2,
		tag = "row align-x-center align-y-center gap-small padding-medium clip",
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.fromOffset(0, v5.Size.Size_1000),
		cornerRadius = UDim.new(0, v5.Radius.Medium),
		backgroundStyle = actionOverMedia.Background,
		stroke = actionOverMedia.Border ~= nil and {
			Color = actionOverMedia.Border.Color3,
			Transparency = actionOverMedia.Border.Transparency
		} or nil,
		testId = props.testId,
		LayoutOrder = props.LayoutOrder
	}, {
		Label = React.createElement(text, {
			tag = "shrink size-0-full auto-x text-label-medium text-truncate-end",
			Text = props.text,
			textStyle = actionOverMedia.Foreground,
			LayoutOrder = 1
		})
	})
end)

local function getHasRobloxSubscription(p2)
	if p2 == nil then
		return false
	end

	local success, result = pcall(function(): boolean
		return p2.HasRobloxSubscription == true
	end)

	return success and result
end

local function TourOwnedSupportPaneChrome(props)
	local v5 = useTokens()
	local v6 = useDeviceType()
	local v7 = usePreferences()
	local v8 = useDeviceInsets()
	local v9 = usePreferredInput() == Responsive.Input.Directional
	local v10 = useLocalization({
		editAvatarButtonText = "Feature.SplitPane.EditAvatarButtonText"
	})

	local v11 = useSignalState(localUserIdStore.getCurrentUserId)
	local localPlayer = Players.LocalPlayer
	local v12 = not (localPlayer == nil) and v11 ~= ""
	local v13

	if localPlayer == nil then
		v13 = false
	else
		local success, result = pcall(function(): boolean
			return localPlayer.HasRobloxSubscription == true
		end)
		v13 = success and result
	end

	local v14 = useAppPolicy(function(p2)
		return p2.getShowDisplayName()
	end)

	local function scopedStyle(p2)
		return { colorMode = p2, device = v6, preferences = v7 }
	end

	local createElement = React.createElement
	local v16 = {
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
			Position = UDim2.fromOffset(0, -v8.top),
			Size = UDim2.new(1, v8.right, 1, v8.top + v8.bottom),
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

	local createElement3 = React.createElement

	local v19 = {
		BottomPaneTooltipAnchor = React.createElement("Frame", {
			ref = props.onBottomPaneTooltipAnchorInstanceChanged,
			Position = UDim2.new(0, 0, 1, v5.Padding.Small),
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

	local v20 = if v9 then React.createElement("Frame", {
		Name = "GamepadStepTwoTooltipAnchor",
		ref = props.onGamepadStepTwoTooltipAnchorInstanceChanged,
		Position = UDim2.new(0.5, 0, 1, -16),
		AnchorPoint = Vector2.new(0.5, 0),
		Size = UDim2.fromOffset(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}) else nil
	v19.GamepadStepTwoTooltipAnchor = v20

	local v21 = if v9 then React.createElement("Frame", {
		Name = "GamepadFinalTooltipAnchor",
		ref = props.onGamepadFinalTooltipAnchorInstanceChanged,
		Position = UDim2.new(0.5, 0, 150 / 217, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		Size = UDim2.fromOffset(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}) else nil
	v19.GamepadFinalTooltipAnchor = v21

	local createElement4 = React.createElement
	local v23 = { Size = UDim2.fromScale(1, 1) }

	local createElement5 = React.createElement
	local v26 = { colorMode = colorMode.Light, device = v6, preferences = v7 }
	local createElement6 = React.createElement
	local v29 = {
		tag = "row align-y-center anchor-top-center size-full-1200",
		Position = UDim2.new(0.5, 0, 0, props.topInset),
		padding = not v9 and {
			right = UDim.new(0, -v5.Padding.Small)
		} or nil
	}

	local createElement7 = React.createElement

	local v32 = if v12 then getStandardSizeAvatarHeadShotRbxthumb(v11) else nil

	local v33 = if localPlayer then (if v14 then localPlayer.DisplayName else localPlayer.Name) else nil

	local v34 = if localPlayer then localPlayer.HasVerifiedBadge else nil
	local children2 = {
		ProfileChip = createElement7(TourProfileChip, {
			isUserLoaded = v12,
			thumbnail = v32,
			name = v33,
			isVerified = v34,
			showSubscriberBadge = v13,
			layoutOrder = 1
		}),
		Spacer = React.createElement(view, { tag = "grow auto-y", LayoutOrder = 2 }),
		CollapseButton = 0,
		TopEditAvatarButton = 0
	}
	local v35 = if not v9 then React.createElement(
		view,
		{ AutomaticSize = Enum.AutomaticSize.XY, LayoutOrder = 3 },
		{
			DarkScope = React.createElement(
				foundationProvider,
				{ colorMode = colorMode.Dark, device = v6, preferences = v7 },
				{
					CollapseButton = React.createElement(forwardRef, {
						ref = props.onTopRightControlInstanceChanged,
						testId = "split-pane-educational-tour--collapse",
						icon = iconName.RectangleRightPaneChevronRight,
						LayoutOrder = 3
					})
				}
			)
		}
	) else nil
	children2.CollapseButton = v35

	local v36 = if v9 then React.createElement(forwardRef2, {
		ref = props.onTopRightControlInstanceChanged,
		testId = "split-pane-educational-tour--top-edit-avatar",
		text = v10.editAvatarButtonText,
		LayoutOrder = 3
	}) else nil
	children2.TopEditAvatarButton = v36
	v19.OverMediaScope = createElement4(view, v23, {
		OverMediaProvider = createElement5(foundationProvider, v26, {
			TopArea = createElement6(view, v29, children2)
		})
	})
	local v37 = if not v9 then React.createElement(view, {
		Size = UDim2.fromScale(1, 1)
	}, {
		LightScope = React.createElement(
			foundationProvider,
			{ colorMode = colorMode.Light, device = v6, preferences = v7 },
			{
				MiddleArea = React.createElement(
					view,
					{
						tag = "row position-center-center anchor-center-center size-full-1000"
					},
					{
						Spacer = React.createElement(view, {
							tag = "grow auto-y",
							LayoutOrder = 1
						}),
						RightChevron = React.createElement(forwardRef, {
							testId = "split-pane-educational-tour--next-avatar",
							icon = iconName.ChevronLargeRight,
							isCircular = true,
							usesOverMediaStyle = true,
							LayoutOrder = 3
						})
					}
				)
			}
		)
	}) else nil
	v19.MiddleAreaScope = v37
	local v38 = if not v9 then React.createElement(view, {
		Size = UDim2.fromScale(1, 1)
	}, {
		LightScope = React.createElement(
			foundationProvider,
			{ colorMode = colorMode.Light, device = v6, preferences = v7 },
			{
				BottomArea = React.createElement(
					view,
					{
						tag = "row align-x-center position-bottom-center anchor-bottom-center size-full-1200 padding-bottom-small"
					},
					{
						EditAvatarButton = React.createElement(forwardRef2, {
							testId = "split-pane-educational-tour--edit-avatar",
							text = v10.editAvatarButtonText
						})
					}
				)
			}
		)
	}) else nil
	v19.BottomAreaScope = v38
	children.Content = createElement3(
		view,
		{ tag = "size-full-full margin-x-medium padding-y-small", ZIndex = 4 },
		v19
	)
	return createElement("Frame", v16, children)
end

return TourOwnedSupportPaneChrome
