local AccountRecovery = script:FindFirstAncestor("AccountRecovery")
local AccountRecoveryParent = AccountRecovery.Parent
local React = require(AccountRecoveryParent.React)
local UIBlox = require(AccountRecoveryParent.UIBlox)
local AppBlox = require(AccountRecoveryParent.AppBlox)
local useDesignTokens = require(AccountRecoveryParent.Style).useDesignTokens
local useLocalization = require(AccountRecoveryParent.Localization).Hooks.useLocalization
local useRoactService = require(AccountRecoveryParent.RobloxAppHooks).useRoactService
local RoactNetworking = require(AccountRecoveryParent.RoactServiceTags).RoactNetworking
local FullscreenPageWithSafeArea = AppBlox.FullscreenPageWithSafeArea
local useStyle = UIBlox.Core.Style.useStyle
local Foundation = require(AccountRecoveryParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local FoundationText = Foundation.Text
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local Logger = require(AccountRecoveryParent.Loggers).Logger
local GetUserById = require(AccountRecoveryParent.AuthCommon).Thunks.GetUserById
local GetFFlagEnable2SVRecovery = require(AccountRecovery.Flags.GetFFlagEnable2SVRecovery)
local getModal = require(AccountRecovery.Components.getModal)
local GetFFlagEnableSkipPasswordReset = require(AccountRecovery.Flags.GetFFlagEnableSkipPasswordReset)
local RecoveryHeader = require(AccountRecovery.Components.RecoveryHeader)
local UserHeader = require(AccountRecovery.Components.UserHeader)
local AccountRecoveryPageState = require(AccountRecovery.Enums.AccountRecoveryPageState)
local useClearFocusOnUnmount = require(AccountRecovery.Hooks).useClearFocusOnUnmount
local AccountRecoveryContext = require(AccountRecovery.Store.AccountRecoveryContext)
local Constants = require(AccountRecovery.Components.Constants)

return function(t1: {[any]: any}) -- line: 48
	-- upvalues: React (copy), AccountRecoveryContext (copy), useStyle (copy), useTokens (copy), useDesignTokens (copy), useRoactService (copy), RoactNetworking (copy), useClearFocusOnUnmount (copy), GetUserById (copy), Logger (copy), useLocalization (copy), GetFFlagEnable2SVRecovery (copy), FullscreenPageWithSafeArea (copy), RecoveryHeader (copy), UserHeader (copy), FoundationText (copy), Button (copy), ButtonVariant (copy), InputSize (copy), GetFFlagEnableSkipPasswordReset (copy), Constants (copy), AccountRecoveryPageState (copy), getModal (copy)
	local v30 = React.useContext(AccountRecoveryContext)
	local v31 = useStyle()
	local v32 = useTokens()
	local v33 = useDesignTokens()
	local v34 = useRoactService(RoactNetworking)
	local v35, v36 = React.useState("")
	local v37, v38 = React.useState("")
	local v39, v40 = React.useState(false)
	local v41, v42 = React.useState("")
	local v43 = t1.navigation.getParam("userID")
	local v44 = t1.navigation.getParam("closeRecoveryOnBack") or false

	useClearFocusOnUnmount()
	React.useEffect(function() -- line: 66
		-- upvalues: v43 (copy), GetUserById (copy), v34 (copy), v38 (copy), v36 (copy), Logger (copy)
		if v43 and v43 ~= 0 then
			GetUserById(v34, v43):andThen(function(p1) -- line: 68
				-- upvalues: v38 (copy), v36 (copy)
				v38(p1.name)
				v36(p1.displayName)
			end):catch(function(p2) -- line: 71
				-- upvalues: Logger (copy)
				Logger:warning("Error getting user info: {}", p2)
			end)
		end
	end, {})

	local v45 = useLocalization({
		recoveryHeadingText = "Authentication.AccountRecovery.Heading.RobloxAccountRecovery",
		continueButtonText = "Authentication.AccountRecovery.Action.Continue",
		resetPasswordButtonText = "Authentication.AccountRecovery.Action.ResetPassword",
		trustedLocationResetPasswordText = {
			"Authentication.AccountRecovery.Description.TrustedLocationResetPassword",
			username = `@{ v37 }`
		},
		trustedLocationResetPasswordSkip2svText = {
			"Authentication.AccountRecovery.Description.TrustedLocationResetPasswordSkip2SV",
			username = `@{ v37 }`
		},
		trustedLocationSkip2svText = {
			"Authentication.AccountRecovery.Description.TrustedLocationSkip2SV",
			username = `@{ v37 }`
		},
		requestErrorText = if v41 == "" then nil else v41
	})
	local v46 = if not GetFFlagEnable2SVRecovery() or (not v30.state.recover2sv or not v30.state.recoverPassword) then if not GetFFlagEnable2SVRecovery() or not v30.state.recover2sv then v45.trustedLocationResetPasswordText else v45.trustedLocationSkip2svText else v45.trustedLocationResetPasswordSkip2svText
	local v47 = if not GetFFlagEnable2SVRecovery() or not v30.state.recover2sv then v45.resetPasswordButtonText else v45.continueButtonText

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = v31.Theme.BackgroundDefault.Color
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v33.Size.Size_200),
			PaddingLeft = UDim.new(0, v33.Size.Size_300),
			PaddingRight = UDim.new(0, v33.Size.Size_300),
			PaddingBottom = UDim.new(0, v33.Size.Size_200)
		}),
		Wrapper = React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical
			}),
			Header = React.createElement(RecoveryHeader, {
				LayoutOrder = 1,
				backButtonDisabled = false,
				currentComponent = "accountVerifiedConfirmation",
				onBackActivated = function() -- line: 130
					-- upvalues: v44 (copy), v30 (copy), t1 (copy)
					if v44 then
						v30.parentNavigation.goBack()

						return
					end

					t1.navigation.goBack()
				end,
				recoveryHeadingText = v45.recoveryHeadingText,
				recoverySessionId = v30.state.recoverySessionId
			}),
			Content = React.createElement("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v33.Size.Size_200),
					PaddingRight = UDim.new(0, v33.Size.Size_200)
				}),
				UIListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, v33.Size.Size_50)
				}),
				RecoveryHeadingSpacing = React.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, v33.Size.Size_500)
				}),
				UserHeader = React.createElement(UserHeader, {
					LayoutOrder = 2,
					userId = v43 or 0,
					displayName = v35,
					username = v37
				}),
				UserHeaderSpacing = React.createElement("Frame", {
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, v32.Size.Size_400)
				}),
				BodyText = React.createElement(FoundationText, {
					LayoutOrder = 4,
					TextWrapped = true,
					Text = v46,
					fontStyle = v32.Typography.BodyMedium,
					textStyle = v32.Color.Content.Default,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center
				}),
				BodyTextSpacing = React.createElement("Frame", {
					LayoutOrder = 5,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, v33.Size.Size_300)
				}),
				ResetPasswordButton = React.createElement(Button, {
					LayoutOrder = 6,
					variant = ButtonVariant.Emphasis,
					size = InputSize.Medium,
					text = v47,
					width = UDim.new(1, 0),
					isLoading = v39,
					onActivated = function() -- line: 196
						-- upvalues: GetFFlagEnableSkipPasswordReset (copy), v30 (copy), v40 (copy), v42 (copy), Constants (copy), v43 (copy), v37 (copy), t1 (copy), AccountRecoveryPageState (copy)
						if GetFFlagEnableSkipPasswordReset() and (v30.state.recover2sv and not v30.state.recoverPassword) then
							v40(true)
							v42("")
							v30.utils.handleUpdatePassword(v30.state.recoverySessionId, v43, v37, "", "", function(s1: string?) -- line: 206
								-- upvalues: v42 (copy), Constants (copy), v40 (copy)
								v42(s1 or Constants.UnknownErrorKey)
								v40(false)
							end, v30.utils.launchAppOrGoBack)

							return
						end

						t1.navigation.navigate(AccountRecoveryPageState.ChooseAccountScreen, {
							userID = v43
						})
					end
				}),
				RequestErrorTextLabel = v41 ~= "" and React.createElement(FoundationText, {
					LayoutOrder = 7,
					Text = v45.requestErrorText or "",
					fontStyle = v32.Typography.CaptionSmall,
					textStyle = v32.Color.System.Alert,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					padding = {
						top = UDim.new(0, v32.Size.Size_200)
					}
				}),
				Modal = GetFFlagEnableSkipPasswordReset() and getModal(v30.state.modalStateAndProps)
			})
		})
	})
end
