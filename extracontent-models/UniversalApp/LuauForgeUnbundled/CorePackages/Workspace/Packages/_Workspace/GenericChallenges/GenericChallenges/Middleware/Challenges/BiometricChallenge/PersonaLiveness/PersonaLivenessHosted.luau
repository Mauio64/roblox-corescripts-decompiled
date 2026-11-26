local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/React")

local appLinking = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/RoactServiceTags").AppLinking

local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/RobloxAppHooks").useRoactService
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/Localization").Hooks.useLocalization

local fullscreenPageWithSafeArea = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/AppBlox").FullscreenPageWithSafeArea

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/Foundation")
local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize
local view = Foundation.View
local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize
local fillBehavior = Foundation.Enums.FillBehavior
local loading = Foundation.Loading
local text = Foundation.Text

local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/FocusNavigationUtils")
local focusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local function PersonaLivenessHosted(props)
	local webLink = props.webLink
	local onCancel = props.onCancel
	local sessionId = props.sessionId

	local v5 = useRoactService(appLinking)

	local state, setState = React.useState(false)

	local v6 = React.useCallback(function()
		setState(true)
		v5:openURL(webLink)
	end, { v5, webLink, sessionId })

	local v7 = React.useCallback(function()
		onCancel()
	end, { onCancel, sessionId })

	local v8 = useLocalization({
		title = "Feature.BiometricChallenge.Title.ConfirmHuman",
		bodyText = "Feature.BiometricChallenge.Content.LivenessHostedPrompt",
		loadingText = "Feature.BiometricChallenge.Content.Loading",
		continueButton = "Feature.BiometricChallenge.Action.Continue",
		cancelButton = "Feature.BiometricChallenge.Action.Cancel"
	})

	return React.createElement(
		"ScreenGui",
		{
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			DisplayOrder = 200,
			IgnoreGuiInset = true
		},
		{
			Overlay = React.createElement(fullscreenPageWithSafeArea, {
				includeStatusBar = false
			}, {
				FocusNavigableSurface = React.createElement(
					focusNavigableSurfaceWrapper,
					{
						surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.ModerationOverlay,
						isIsolated = true
					},
					{
						Dialog = React.createElement(
							dialog.Root,
							{ size = dialogSize.Medium, hasBackdrop = true },
							{
								DialogTitle = not state and React.createElement(dialog.Title, {
									text = v8.title,
									LayoutOrder = 1
								}),
								DialogContent = React.createElement(dialog.Content, nil, {
									DialogView = React.createElement(
										view,
										{
											tag = "col fill auto-xy items-center gap-medium"
										},
										{
											Loading = state and React.createElement(
												view,
												{
													LayoutOrder = 1,
													tag = "auto-xy margin-top-medium"
												},
												{ React.createElement(loading, {}) }
											),
											DialogBody = state and React.createElement(text, {
												Text = v8.loadingText,
												LayoutOrder = 2,
												tag = "text-wrap auto-y size-full-0 text-body-medium"
											}) or React.createElement(dialog.Text, {
												Text = v8.bodyText,
												LayoutOrder = 2
											}),
											DialogFooter = React.createElement(
												view,
												{
													tag = "row size-full-0 auto-y gap-small",
													LayoutOrder = 3
												},
												{
													CancelButton = React.createElement(button, {
														variant = buttonVariant.Standard,
														size = inputSize.Medium,
														text = v8.cancelButton,
														fillBehavior = fillBehavior.Fill,
														onActivated = v7,
														LayoutOrder = 1
													}),
													ContinueButton = not state and React.createElement(button, {
														variant = buttonVariant.Emphasis,
														size = inputSize.Medium,
														text = v8.continueButton,
														fillBehavior = fillBehavior.Fill,
														onActivated = v6,
														icon = "icons/navigation/externallink_medium",
														LayoutOrder = 2
													})
												}
											)
										}
									)
								})
							}
						)
					}
				)
			})
		}
	)
end

return PersonaLivenessHosted
