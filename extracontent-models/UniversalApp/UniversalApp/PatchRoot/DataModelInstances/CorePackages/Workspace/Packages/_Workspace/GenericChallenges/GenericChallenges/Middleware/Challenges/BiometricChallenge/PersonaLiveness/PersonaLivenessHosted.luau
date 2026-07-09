local Parent = script:FindFirstAncestor("GenericChallenges").Parent
local React = require(Parent.React)
local AppLinking = require(Parent.RoactServiceTags).AppLinking
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local FullscreenPageWithSafeArea = require(Parent.AppBlox).FullscreenPageWithSafeArea
local Foundation = require(Parent.Foundation)
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local View = Foundation.View
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local FillBehavior = Foundation.Enums.FillBehavior
local Loading = Foundation.Loading
local FoundationText = Foundation.Text
local FocusNavigationUtils = require(Parent.FocusNavigationUtils)
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local function PersonaLivenessHosted(t1: {[any]: any}) -- line: 35
	-- upvalues: useRoactService (copy), AppLinking (copy), React (copy), useLocalization (copy), FullscreenPageWithSafeArea (copy), FocusNavigableSurfaceWrapper (copy), FocusNavigableSurfaceIdentifierEnum (copy), Dialog (copy), DialogSize (copy), View (copy), Loading (copy), FoundationText (copy), Button (copy), ButtonVariant (copy), InputSize (copy), FillBehavior (copy)
	local webLink = t1.webLink
	local onCancel = t1.onCancel
	local sessionId = t1.sessionId
	local v25 = useRoactService(AppLinking)
	local v26, v27 = React.useState(false)
	local v28 = React.useCallback(function() -- line: 44
		-- upvalues: v27 (copy), v25 (copy), webLink (copy)
		v27(true)
		v25:openURL(webLink)
	end, {
		v25,
		webLink,
		sessionId
	})
	local v29 = React.useCallback(function() -- line: 49
		-- upvalues: onCancel (copy)
		onCancel()
	end, {
		onCancel,
		sessionId
	})
	local v30 = useLocalization({
		title = "Feature.BiometricChallenge.Title.ConfirmHuman",
		bodyText = "Feature.BiometricChallenge.Content.LivenessHostedPrompt",
		loadingText = "Feature.BiometricChallenge.Content.Loading",
		continueButton = "Feature.BiometricChallenge.Action.Continue",
		cancelButton = "Feature.BiometricChallenge.Action.Cancel"
	})

	return React.createElement("ScreenGui", {
		DisplayOrder = 200,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
		Overlay = React.createElement(FullscreenPageWithSafeArea, {
			includeStatusBar = false
		}, {
			FocusNavigableSurface = React.createElement(FocusNavigableSurfaceWrapper, {
				isIsolated = true,
				surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.ModerationOverlay
			}, {
				Dialog = React.createElement(Dialog.Root, {
					hasBackdrop = true,
					size = DialogSize.Medium
				}, {
					DialogTitle = not v26 and React.createElement(Dialog.Title, {
						LayoutOrder = 1,
						text = v30.title
					}),
					DialogContent = React.createElement(Dialog.Content, nil, {
						DialogView = React.createElement(View, {
							tag = "col fill auto-xy items-center gap-medium"
						}, {
							Loading = v26 and React.createElement(View, {
								LayoutOrder = 1,
								tag = "auto-xy margin-top-medium"
							}, { React.createElement(Loading, {}) }),
							DialogBody = v26 and React.createElement(FoundationText, {
								LayoutOrder = 2,
								tag = "text-wrap auto-y size-full-0 text-body-medium",
								Text = v30.loadingText
							}) or React.createElement(Dialog.Text, {
								LayoutOrder = 2,
								Text = v30.bodyText
							}),
							DialogFooter = React.createElement(View, {
								tag = "row size-full-0 auto-y gap-small",
								LayoutOrder = 3
							}, {
								CancelButton = React.createElement(Button, {
									LayoutOrder = 1,
									variant = ButtonVariant.Standard,
									size = InputSize.Medium,
									text = v30.cancelButton,
									fillBehavior = FillBehavior.Fill,
									onActivated = v29
								}),
								ContinueButton = not v26 and React.createElement(Button, {
									icon = "icons/navigation/externallink_medium",
									LayoutOrder = 2,
									variant = ButtonVariant.Emphasis,
									size = InputSize.Medium,
									text = v30.continueButton,
									fillBehavior = FillBehavior.Fill,
									onActivated = v28
								})
							})
						})
					})
				})
			})
		})
	})
end

return PersonaLivenessHosted
