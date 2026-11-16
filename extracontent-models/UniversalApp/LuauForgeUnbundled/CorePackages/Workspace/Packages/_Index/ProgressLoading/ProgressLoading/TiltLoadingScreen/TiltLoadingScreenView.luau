local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Foundation")
local view = Foundation.View
local progress = Foundation.Progress
local progressShape = Foundation.Enums.ProgressShape

local badge = Foundation.Badge
local icon = Foundation.Icon
local iconButton = Foundation.IconButton
local text = Foundation.Text
local enums = Foundation.Enums
local iconSize = enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Localization").Hooks.useLocalization
local isPioneerLaunch = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/PioneerUtils").isPioneerLaunch
local TiltLockup = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/Components/TiltLockup")
local TiltLoadingScreenStatusPanel = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/Components/TiltLoadingScreenStatusPanel")
local fFlagTiltLoadingScreenConsoleHints = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/SharedFlags").FFlagTiltLoadingScreenConsoleHints

require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/Types")

local function TiltLoadingScreenView(props)
	local v5 = useTokens()
	local v6 = useLocalization({
		autoTranslate = "CoreScripts.TopBar.LoadingScreen.AutoTranslate",
		back = fFlagTiltLoadingScreenConsoleHints and "CoreScripts.TopBar.Back" or nil
	})

	local createElement = React.createElement
	local v8 = {
		tag = "size-full bg-surface-0",
		GroupTransparency = props.chromeReveal:map(function(p2)
			return 1 - p2
		end),
		testId = "tilt-loading-screen-root"
	}

	local v9 = {
		Overlay = React.createElement(view, {
			tag = "size-full",
			backgroundStyle = v5.Color.Extended.Black.Black_50,
			ZIndex = 0
		}),
		SafeArea = 0
	}
	local v10

	if props.showContent then
		local createElement2 = React.createElement
		local v12 = {
			tag = "size-full",
			padding = {
				left = UDim.new(0, props.safeAreaInsets.left),
				top = UDim.new(0, props.safeAreaInsets.top),
				right = UDim.new(0, props.safeAreaInsets.right),
				bottom = UDim.new(0, props.safeAreaInsets.bottom)
			},
			ZIndex = 1,
			testId = "tilt-loading-screen-safe-area"
		}

		local v14 = if not (isPioneerLaunch() or props.isDirectionalInput) then React.createElement(
			view,
			{
				tag = "col align-x-left align-y-top size-full padding-xlarge",
				ZIndex = 2
			},
			{
				Button = React.createElement(iconButton, {
					icon = enums.IconName.X,
					variant = enums.ButtonVariant.Standard,
					size = enums.InputSize.Large,
					isCircular = true,
					onActivated = props.onCancel,
					testId = "tilt-loading-screen-cancel-button"
				})
			}
		) else nil

		local v15 = if not (isPioneerLaunch() or not props.isDirectionalInput) then React.createElement(
			view,
			{
				tag = "col align-x-left align-y-bottom size-full padding-xlarge",
				ZIndex = 2,
				testId = "tilt-loading-screen-gamepad-cancel-hint"
			},
			{
				Hint = React.createElement(
					view,
					{ tag = "row align-y-center gap-small auto-xy padding-x-medium" },
					{
						ButtonIcon = React.createElement(icon, {
							LayoutOrder = 1,
							name = props.gamepadCancelIcon,
							size = iconSize.Medium,
							style = v5.Color.System.Contrast
						}),
						Label = React.createElement(text, {
							LayoutOrder = 2,
							Text = v6.back,
							tag = "auto-xy text-title-large content-system-contrast"
						})
					}
				)
			}
		) else nil

		local createElement3 = React.createElement

		local createElement4 = React.createElement

		local createElement5 = React.createElement

		local v23 = if props.gameData then props.gameData.name else nil
		local v24 = if props.gameData then props.gameData.creator else nil
		local v25 = if props.gameData then props.gameData.verified else nil
		local v20 = {
			Lockup = createElement5(TiltLockup, {
				LayoutOrder = 1,
				gameName = v23,
				creatorName = v24,
				isCreatorVerified = v25,
				thumbnailUrl = props.thumbnailUrl,
				onThumbnailLoaded = props.onThumbnailLoaded,
				animation = props.animation
			}),
			AutoTranslate = 0
		}
		local v26

		if props.isAutoTranslated then
			v26 = React.createElement(view, {
				LayoutOrder = 2,
				tag = "auto-xy",
				GroupTransparency = props.animation.creator.reveal:map(function(p2)
					return 1 - p2
				end)
			}, {
				Badge = React.createElement(badge, {
					text = v6.autoTranslate,
					variant = enums.BadgeVariant.Neutral,
					shape = enums.BadgeShape.Box,
					icon = {
						name = enums.IconName.LanguageCharacters,
						size = enums.IconSize.XSmall,
						position = enums.IconPosition.Left
					}
				})
			})
		end

		v20.AutoTranslate = v26
		local children = {
			Content = createElement4(
				view,
				{
					LayoutOrder = 1,
					tag = "col align-x-center align-y-center grow gap-large size-full-0 padding-x-xxlarge",
					testId = "tilt-loading-screen-lockup-slot"
				},
				v20
			),
			StatusPanel = React.createElement(TiltLoadingScreenStatusPanel, {
				LayoutOrder = 3,
				status = props.statusPanel.status,
				statusText = props.statusPanel.statusText,
				queuePosition = props.statusPanel.queuePosition,
				queueTreatment = props.statusPanel.queueTreatment,
				followUserId = props.statusPanel.followUserId,
				isSubjectToChinaPolicies = props.statusPanel.isSubjectToChinaPolicies,
				onAutoJoinNewServer = props.statusPanel.onAutoJoinNewServer,
				onJoinNewServer = props.statusPanel.onJoinNewServer,
				onJoinTheLine = props.statusPanel.onJoinTheLine,
				onShowConnectionHealth = props.statusPanel.onShowConnectionHealth
			}),
			ProgressBar = 0
		}

		local v27 = if props.statusPanel.queueTreatment == nil then React.createElement(view, {
			LayoutOrder = 4,
			testId = "tilt-loading-screen-progress-slot",
			tag = {
				["size-full-0 auto-y padding-x-medium padding-bottom-xlarge"] = props.isMobile,
				["size-full-0 auto-y"] = not props.isMobile
			}
		}, {
			Bar = React.createElement(progress, {
				shape = progressShape.Bar,
				testId = "loading-screen-progress-bar"
			})
		}) else nil
		children.ProgressBar = v27
		v10 = createElement2(view, v12, {
			CancelButton = v14,
			GamepadCancelHint = v15,
			Layout = createElement3(view, { tag = "col size-full", ZIndex = 1 }, children)
		})
	end

	v9.SafeArea = v10
	return createElement(view, v8, v9)
end

return React.memo(TiltLoadingScreenView)
