local parent = script:FindFirstAncestor("ProgressLoading").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Progress = Foundation.Progress
local ProgressShape = Foundation.Enums.ProgressShape

local Badge = Foundation.Badge
local Icon = Foundation.Icon
local IconButton = Foundation.IconButton
local Text = Foundation.Text
local Enums = Foundation.Enums
local IconSize = Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local PioneerUtils = require(parent.PioneerUtils)
local isPioneerLaunch = PioneerUtils.isPioneerLaunch
local TiltLockup = require(script.Parent.Components.TiltLockup)
local TiltLoadingScreenStatusPanel = require(script.Parent.Components.TiltLoadingScreenStatusPanel)
local SharedFlags = require(parent.SharedFlags)
local FFlagTiltLoadingScreenConsoleHints = SharedFlags.FFlagTiltLoadingScreenConsoleHints

require(script.Parent.Types)

local function TiltLoadingScreenView(props)
	local v = useTokens()
	local v2 = useLocalization({
		autoTranslate = "CoreScripts.TopBar.LoadingScreen.AutoTranslate",
		back = FFlagTiltLoadingScreenConsoleHints and "CoreScripts.TopBar.Back" or nil
	})

	local createElement = React.createElement
	local v3 = {
		tag = "size-full bg-surface-0",
		GroupTransparency = props.chromeReveal:map(function(p: number)
			return 1 - p
		end),
		testId = "tilt-loading-screen-root"
	}

	local v4 = {
		Overlay = React.createElement(View, {
			tag = "size-full",
			backgroundStyle = v.Color.Extended.Black.Black_50,
			ZIndex = 0
		}),
		SafeArea = 0
	}
	local safeArea

	if props.showContent then
		local createElement2 = React.createElement
		local v5 = {
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
		local cancelButton

		if not (isPioneerLaunch() or props.isDirectionalInput) then
			cancelButton = React.createElement(
				View,
				{ tag = "col align-x-left align-y-top size-full padding-xlarge", ZIndex = 2 },
				{
					Button = React.createElement(IconButton, {
						icon = Enums.IconName.X,
						variant = Enums.ButtonVariant.Standard,
						size = Enums.InputSize.Large,
						isCircular = true,
						onActivated = props.onCancel,
						testId = "tilt-loading-screen-cancel-button"
					})
				}
			)
		end

		local gamepadCancelHint

		if not (isPioneerLaunch() or not props.isDirectionalInput) then
			gamepadCancelHint = React.createElement(
				View,
				{
					tag = "col align-x-left align-y-bottom size-full padding-xlarge",
					ZIndex = 2,
					testId = "tilt-loading-screen-gamepad-cancel-hint"
				},
				{
					Hint = React.createElement(
						View,
						{ tag = "row align-y-center gap-small auto-xy padding-x-medium" },
						{
							ButtonIcon = React.createElement(Icon, {
								LayoutOrder = 1,
								name = props.gamepadCancelIcon,
								size = IconSize.Medium,
								style = v.Color.System.Contrast
							}),
							Label = React.createElement(Text, {
								LayoutOrder = 2,
								Text = v2.back,
								tag = "auto-xy text-title-large content-system-contrast"
							})
						}
					)
				}
			)
		end

		local createElement3 = React.createElement

		local createElement4 = React.createElement

		local createElement5 = React.createElement
		local gameName

		if props.gameData then
			gameName = props.gameData.name
		end

		local creatorName

		if props.gameData then
			creatorName = props.gameData.creator
		end

		local isCreatorVerified

		if props.gameData then
			isCreatorVerified = props.gameData.verified
		end

		local v6 = {
			Lockup = createElement5(TiltLockup, {
				LayoutOrder = 1,
				gameName = gameName,
				creatorName = creatorName,
				isCreatorVerified = isCreatorVerified,
				thumbnailUrl = props.thumbnailUrl,
				onThumbnailLoaded = props.onThumbnailLoaded,
				animation = props.animation
			}),
			AutoTranslate = 0
		}
		local autoTranslate

		if props.isAutoTranslated then
			autoTranslate = React.createElement(View, {
				LayoutOrder = 2,
				tag = "auto-xy",
				GroupTransparency = props.animation.creator.reveal:map(function(p)
					return 1 - p
				end)
			}, {
				Badge = React.createElement(Badge, {
					text = v2.autoTranslate,
					variant = Enums.BadgeVariant.Neutral,
					shape = Enums.BadgeShape.Box,
					icon = {
						name = Enums.IconName.LanguageCharacters,
						size = Enums.IconSize.XSmall,
						position = Enums.IconPosition.Left
					}
				})
			})
		end

		v6.AutoTranslate = autoTranslate
		local children = {
			Content = createElement4(
				View,
				{
					LayoutOrder = 1,
					tag = "col align-x-center align-y-center grow gap-large size-full-0 padding-x-xxlarge",
					testId = "tilt-loading-screen-lockup-slot"
				},
				v6
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
		local progressBar

		if props.statusPanel.queueTreatment == nil then
			progressBar = React.createElement(View, {
				LayoutOrder = 4,
				testId = "tilt-loading-screen-progress-slot",
				tag = {
					["size-full-0 auto-y padding-x-medium padding-bottom-xlarge"] = props.isMobile,
					["size-full-0 auto-y"] = not props.isMobile
				}
			}, {
				Bar = React.createElement(Progress, {
					shape = ProgressShape.Bar,
					testId = "loading-screen-progress-bar"
				})
			})
		end

		children.ProgressBar = progressBar
		safeArea = createElement2(View, v5, {
			CancelButton = cancelButton,
			GamepadCancelHint = gamepadCancelHint,
			Layout = createElement3(View, { tag = "col size-full", ZIndex = 1 }, children)
		})
	end

	v4.SafeArea = safeArea
	return createElement(View, v3, v4)
end

return React.memo(TiltLoadingScreenView)
