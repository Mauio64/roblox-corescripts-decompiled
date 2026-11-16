local parent = script:FindFirstAncestor("GenericChallenges").Parent

local React = require(parent.React)

local RoactServiceTags = require(parent.RoactServiceTags)
local AppLinking = RoactServiceTags.AppLinking

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local AppBlox = require(parent.AppBlox)
local FullscreenPageWithSafeArea = AppBlox.FullscreenPageWithSafeArea

local Foundation = require(parent.Foundation)
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local View = Foundation.View
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local FillBehavior = Foundation.Enums.FillBehavior
local Loading = Foundation.Loading
local Text = Foundation.Text

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local function PersonaLivenessHosted(props)
	local webLink = props.webLink
	local onCancel = props.onCancel
	local sessionId = props.sessionId

	local v = useRoactService(AppLinking)

	local state, setState = React.useState(false)

	local onActivated = React.useCallback(function()
		setState(true)
		v:openURL(webLink)
	end, { v, webLink, sessionId })

	local onActivated2 = React.useCallback(function()
		onCancel()
	end, { onCancel, sessionId })

	local v2 = useLocalization({
		title = "Feature.BiometricChallenge.Title.ConfirmHuman",
		bodyText = "Feature.BiometricChallenge.Content.LivenessHostedPrompt",
		loadingText = "Feature.BiometricChallenge.Content.Loading",
		continueButton = "Feature.BiometricChallenge.Action.Continue",
		cancelButton = "Feature.BiometricChallenge.Action.Cancel"
	})

	return React.createElement(
		"ScreenGui",
		{ ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 200, IgnoreGuiInset = true },
		{
			Overlay = React.createElement(FullscreenPageWithSafeArea, { includeStatusBar = false }, {
				FocusNavigableSurface = React.createElement(
					FocusNavigableSurfaceWrapper,
					{
						surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.ModerationOverlay,
						isIsolated = true
					},
					{
						Dialog = React.createElement(Dialog.Root, {
							size = DialogSize.Medium,
							hasBackdrop = true
						}, {
							DialogTitle = not state and React.createElement(Dialog.Title, {
								text = v2.title,
								LayoutOrder = 1
							}),
							DialogContent = React.createElement(Dialog.Content, nil, {
								DialogView = React.createElement(
									View,
									{ tag = "col fill auto-xy items-center gap-medium" },
									{
										Loading = state and React.createElement(
											View,
											{ LayoutOrder = 1, tag = "auto-xy margin-top-medium" },
											{ React.createElement(Loading, {}) }
										),
										DialogBody = state and React.createElement(Text, {
											Text = v2.loadingText,
											LayoutOrder = 2,
											tag = "text-wrap auto-y size-full-0 text-body-medium"
										}) or React.createElement(Dialog.Text, {
											Text = v2.bodyText,
											LayoutOrder = 2
										}),
										DialogFooter = React.createElement(
											View,
											{
												tag = "row size-full-0 auto-y gap-small",
												LayoutOrder = 3
											},
											{
												CancelButton = React.createElement(Button, {
													variant = ButtonVariant.Standard,
													size = InputSize.Medium,
													text = v2.cancelButton,
													fillBehavior = FillBehavior.Fill,
													onActivated = onActivated2,
													LayoutOrder = 1
												}),
												ContinueButton = not state and React.createElement(Button, {
													variant = ButtonVariant.Emphasis,
													size = InputSize.Medium,
													text = v2.continueButton,
													fillBehavior = FillBehavior.Fill,
													onActivated = onActivated,
													icon = "icons/navigation/externallink_medium",
													LayoutOrder = 2
												})
											}
										)
									}
								)
							})
						})
					}
				)
			})
		}
	)
end

return PersonaLivenessHosted
