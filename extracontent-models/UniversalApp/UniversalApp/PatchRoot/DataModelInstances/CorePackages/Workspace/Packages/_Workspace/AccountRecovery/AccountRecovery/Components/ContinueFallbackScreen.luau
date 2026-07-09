local AccountRecovery = script:FindFirstAncestor("AccountRecovery")
local AccountRecoveryParent = AccountRecovery.Parent
local React = require(AccountRecoveryParent.React)
local UIBlox = require(AccountRecoveryParent.UIBlox)
local AppBlox = require(AccountRecoveryParent.AppBlox)
local useDesignTokens = require(AccountRecoveryParent.Style).useDesignTokens
local useLocalization = require(AccountRecoveryParent.Localization).Hooks.useLocalization
local FullscreenPageWithSafeArea = AppBlox.FullscreenPageWithSafeArea
local useStyle = UIBlox.Core.Style.useStyle
local Foundation = require(AccountRecoveryParent.Foundation)
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local ScrollView = Foundation.ScrollView
local Visibility = Foundation.Enums.Visibility
local InputSize = Foundation.Enums.InputSize
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local useClearFocusOnUnmount = require(AccountRecovery.Hooks).useClearFocusOnUnmount
local AccountRecoveryContext = require(AccountRecovery.Store.AccountRecoveryContext)
local RecoveryState = require(AccountRecovery.Enums.RecoveryState)
local RecoveryHeader = require(AccountRecovery.Components.RecoveryHeader)
local UserHeader = require(AccountRecovery.Components.UserHeader)
local AccountRecoveryPageState = require(AccountRecovery.Enums.AccountRecoveryPageState)
local Constants = require(AccountRecovery.Components.Constants)
local getModal = require(AccountRecovery.Components.getModal)
local GetFFlagEnableSkipPasswordReset = require(AccountRecovery.Flags.GetFFlagEnableSkipPasswordReset)

require(AccountRecovery.Common.AccountRecoveryRequestTypes)

return function(t1: {[any]: any}) -- line: 42
	-- upvalues: React (copy), AccountRecoveryContext (copy), useStyle (copy), useTokens (copy), useDesignTokens (copy), useClearFocusOnUnmount (copy), Constants (copy), RecoveryState (copy), AccountRecoveryPageState (copy), GetFFlagEnableSkipPasswordReset (copy), useLocalization (copy), FullscreenPageWithSafeArea (copy), RecoveryHeader (copy), ScrollView (copy), Visibility (copy), UserHeader (copy), FoundationText (copy), Button (copy), ButtonVariant (copy), InputSize (copy), getModal (copy)
	local v28 = React.useContext(AccountRecoveryContext)
	local v29 = useStyle()
	local v30 = useTokens()
	local v31 = useDesignTokens()
	local v32 = t1.navigation.getParam("userID")
	local v33 = t1.navigation.getParam("displayName")
	local v34 = t1.navigation.getParam("username")
	local v35 = t1.navigation.getParam("didAbandon2SV")
	local v36 = t1.navigation.getParam("contactMethodNumber")
	local v37, v38 = React.useState("")
	local v39, v40 = React.useState(false)
	local v41, v42 = React.useState(Vector2.new(0, 0))

	useClearFocusOnUnmount()

	local function v43(n1: number, p1, p2: ((...any) -> ...any)) -- line: 62
		-- upvalues: Constants (copy), RecoveryState (copy), t1 (copy), AccountRecoveryPageState (copy), v36 (copy), v28 (copy), GetFFlagEnableSkipPasswordReset (copy), v34 (copy)
		if p1 == nil then
			p2(Constants.UnknownErrorKey)

			return
		end

		if p1.recoveryState == RecoveryState.RECOVERY_STATE_CONTACT_METHOD_VERIFICATION_REQUIRED then
			t1.navigation.navigate(AccountRecoveryPageState.SendCodeScreen, {
				isSecondContactMethodVerification = true,
				userID = n1,
				previousRecoveryMethod = p1.previousRecoveryMethod,
				previousRecoveryMethodTypes = p1.previousRecoveryMethodTypes,
				nextRecoveryMethodTypes = p1.nextRecoveryMethodTypes
			})

			return
		end

		if p1.recoveryState == RecoveryState.RECOVERY_STATE_ACCOUNT_VERIFIED then
			if v36 == 0 and v28.state.recover2sv then
				t1.navigation.replace(AccountRecoveryPageState.AccountVerifiedConfirmationScreen, {
					userID = n1
				})

				return
			end

			if GetFFlagEnableSkipPasswordReset() and v28.state.recover2sv and not v28.state.recoverPassword then
				v28.utils.handleUpdatePassword(v28.state.recoverySessionId, n1, v34, "", "", p2, v28.utils.launchAppOrGoBack)

				return
			end

			t1.navigation.replace(AccountRecoveryPageState.ChooseAccountScreen, {
				userID = n1
			})

			return
		end

		if p1.recoveryState == RecoveryState.RECOVERY_STATE_AWAITING_REEVALUATION then
			t1.navigation.navigate(AccountRecoveryPageState.CannotRecoverAccountScreen, {
				userID = n1
			})

			return
		end

		p2(Constants.UnknownErrorKey)
	end

	local v44 = useLocalization({
		recoveryHeadingText = "Authentication.AccountRecovery.Heading.RobloxAccountRecovery",
		verifyAgainBodyText = "Authentication.AccountRecovery.Description.VerifyAgain",
		somethingWentWrongVerifyAgainText = "Authentication.AccountRecovery.Description.SomethingWentWrongVerifyAgain",
		continueButtonText = "Authentication.AccountRecovery.Action.Continue",
		requestErrorText = if v37 == "" then nil else v37
	})

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = v29.Theme.BackgroundDefault.Color
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v31.Size.Size_200),
			PaddingLeft = UDim.new(0, v31.Size.Size_300),
			PaddingRight = UDim.new(0, v31.Size.Size_300),
			PaddingBottom = UDim.new(0, v31.Size.Size_200)
		}),
		Wrapper = React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, v31.Size.Size_500)
			}),
			PreScrollContent = React.createElement("Frame", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0),
				[React.Change.AbsoluteSize] = function(p3) -- line: 119
					-- upvalues: v41 (copy), v42 (copy)
					if v41 ~= p3.AbsoluteSize then
						v42(p3.AbsoluteSize)
					end
				end
			}, {
				Header = React.createElement(RecoveryHeader, {
					LayoutOrder = 1,
					currentComponent = "continueFallback",
					onBackActivated = function() -- line: 162
						-- upvalues: t1 (copy)
						t1.navigation.goBack()
					end,
					backButtonDisabled = v39,
					recoveryHeadingText = v44.recoveryHeadingText,
					recoverySessionId = v28.state.recoverySessionId
				})
			}),
			ContentScrollView = React.createElement(ScrollView, {
				LayoutOrder = 2,
				scroll = {
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.new(1, 0, 0, 0),
					ScrollingDirection = Enum.ScrollingDirection.Y,
					scrollBarVisibility = Visibility.Auto
				},
				Size = UDim2.new(1, 0, 1, -v41.Y)
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v31.Size.Size_200),
					PaddingRight = UDim.new(0, v31.Size.Size_200)
				}),
				UIListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, v31.Size.Size_50)
				}),
				UserHeader = React.createElement(UserHeader, {
					LayoutOrder = 1,
					userId = v32,
					displayName = v33,
					username = v34
				}),
				BodyText = React.createElement(FoundationText, {
					LayoutOrder = 2,
					TextWrapped = true,
					Text = v35 and v44.verifyAgainBodyText or v44.somethingWentWrongVerifyAgainText,
					fontStyle = v30.Typography.BodyMedium,
					textStyle = v30.Color.Content.Default,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					padding = {
						top = UDim.new(0, v30.Size.Size_300),
						bottom = UDim.new(0, v30.Size.Size_300)
					}
				}),
				ContinueButton = React.createElement(Button, {
					LayoutOrder = 3,
					variant = ButtonVariant.Emphasis,
					size = InputSize.Medium,
					text = v44.continueButtonText,
					width = UDim.new(1, 0),
					onActivated = function() -- line: 220
						-- upvalues: v40 (copy), v38 (copy), Constants (copy), v28 (copy), v32 (copy), v43 (copy)
						v40(true)
						v38("")

						local function v49(s1: string?) -- line: 224
							-- upvalues: v38 (copy), Constants (copy), v40 (copy)
							v38(s1 or Constants.UnknownErrorKey)
							v40(false)
						end

						v28.utils.handleContinueRecovery(v28.state.recoverySessionId, v32, function(p4) -- line: 231
							-- upvalues: v43 (copy), v32 (copy), v49 (copy)
							v43(v32, p4, v49)
						end, v49, function() -- line: 235
							-- upvalues: v40 (copy)
							v40(false)
						end)
					end,
					isLoading = v39
				}),
				RequestErrorTextLabel = React.createElement(FoundationText, {
					LayoutOrder = 4,
					Text = v44.requestErrorText or "",
					fontStyle = v30.Typography.CaptionSmall,
					textStyle = v30.Color.System.Alert,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					padding = {
						top = UDim.new(0, v30.Size.Size_200)
					}
				}),
				Modal = GetFFlagEnableSkipPasswordReset() and getModal(v28.state.modalStateAndProps)
			})
		})
	})
end
