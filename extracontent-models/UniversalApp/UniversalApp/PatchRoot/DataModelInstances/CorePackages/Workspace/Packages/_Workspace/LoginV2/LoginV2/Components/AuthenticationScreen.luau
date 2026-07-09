local LoginV2 = script:FindFirstAncestor("LoginV2")
local LoginV2Parent = LoginV2.Parent
local HttpService = game:GetService("HttpService")
local React = require(LoginV2Parent.React)
local AppBlox = require(LoginV2Parent.AppBlox)
local AuthAnalytics = require(LoginV2Parent.AuthAnalytics)
local AuthCommon = require(LoginV2Parent.AuthCommon)
local FitFrame = require(LoginV2Parent.FitFrame)
local FFlagFixLoginV2LandscapeLayout = require(LoginV2Parent.SharedFlags).FFlagFixLoginV2LandscapeLayout
local Cryo = require(LoginV2Parent.Cryo)
local RoactAppExperiment = require(LoginV2Parent.RoactAppExperiment)
local AppBtidLayers = require(LoginV2Parent.ExperimentLayers).AppBtidLayers
local AuthenticationMethodType = require(LoginV2.Enums.AuthenticationMethodType)
local useLocalization = require(LoginV2Parent.Localization).Hooks.useLocalization
local useRoactService = require(LoginV2Parent.RobloxAppHooks).useRoactService
local RoactNetworking = require(LoginV2Parent.RoactServiceTags).RoactNetworking
local FullscreenPageWithSafeArea = AppBlox.FullscreenPageWithSafeArea
local UIBlox = require(LoginV2Parent.UIBlox)
local useDesignTokens = require(LoginV2Parent.Style).useDesignTokens
local useStyle = UIBlox.Core.Style.useStyle
local IconButton = UIBlox.App.Button.IconButton
local Images = UIBlox.App.ImageSet.Images
local Toast = UIBlox.App.Dialog.Toast
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local AuthenticationMethod = require(LoginV2.Components.AuthenticationMethod)
local NeedHelpButton = require(LoginV2.Components.NeedHelpButton)
local UserIdentifierHeading = require(LoginV2.Components.UserIdentifierHeading)
local UserIdentifierType = require(LoginV2.Enums.UserIdentifierType)
local LoginPageState = require(LoginV2.Enums.LoginPageState)
local LoginContext = require(LoginV2.Context.LoginContext)
local LoginActionType = require(LoginV2.Enums.LoginActionType)
local Constants = require(LoginV2.Components.Constants)
local authFormInteraction = AuthAnalytics.Events.authFormInteraction
local authPageload = AuthAnalytics.Events.authPageload
local authButtonClick = AuthAnalytics.Events.authButtonClick
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local GetUserByUsername = AuthCommon.Thunks.GetUserByUsername
local v38 = game:DefineFastFlag("FixAuthScreenOrDividerOrder", false)

function AuthenticationScreen(t1: {[any]: any}) -- line: 59
	-- upvalues: React (copy), LoginContext (copy), useDesignTokens (copy), useStyle (copy), useRoactService (copy), RoactNetworking (copy), RoactAppExperiment (copy), AppBtidLayers (copy), LoginActionType (copy), LoginPageState (copy), authPageload (copy), EventStreamConstants (copy), HttpService (copy), UserIdentifierType (copy), GetUserByUsername (copy), Cryo (copy), AuthenticationMethodType (copy), authFormInteraction (copy), authButtonClick (copy), useLocalization (copy), AuthenticationMethod (copy), v38 (copy), StyledTextLabel (copy), Images (copy), FullscreenPageWithSafeArea (copy), Toast (copy), FFlagFixLoginV2LandscapeLayout (copy), FitFrame (copy), IconButton (copy), Constants (copy), UserIdentifierHeading (copy), NeedHelpButton (copy)
	local v40 = React.useContext(LoginContext)
	local state = v40.state
	local utils = v40.utils
	local v43 = useDesignTokens()
	local v44 = useStyle()
	local v45 = useRoactService(RoactNetworking)
	local v46, v47 = React.useState(nil)
	local v48, v49 = React.useState(nil)
	local v50 = React.useRef(nil)
	local v51 = RoactAppExperiment.useBrowserTrackerExperiment({ AppBtidLayers.LoginLayer }, function(p1) -- line: 74
		-- upvalues: AppBtidLayers (copy)
		return {
			shouldFilterCredentialsForPrefill = (p1[AppBtidLayers.LoginLayer] or {}).shouldFilterCredentialsForPrefill or false
		}
	end)

	local function v52(p2) -- line: 82
		-- upvalues: v40 (copy), LoginActionType (copy), LoginPageState (copy)
		v40.dispatch({
			type = LoginActionType.SetComponentState,
			data = {
				component = LoginPageState.AuthenticationScreen,
				payload = p2
			}
		})
	end
	local function v53(p3) -- line: 92
		-- upvalues: v40 (copy), LoginActionType (copy), LoginPageState (copy)
		v40.dispatch({
			type = LoginActionType.SetComponentState,
			data = {
				component = LoginPageState.LoginScreenV2,
				payload = p3
			}
		})
	end

	local v54 = state and state.componentState[LoginPageState.AuthenticationScreen].errorType or nil
	local v55 = state and state.componentState[LoginPageState.AuthenticationScreen].errorKey or ""

	local function v56(p4) -- line: 125
		-- upvalues: v40 (copy), LoginActionType (copy), LoginPageState (copy)
		v40.dispatch({
			type = LoginActionType.SetComponentState,
			data = {
				component = LoginPageState.EmailOtpScreen,
				payload = {
					sessionToken = p4
				}
			}
		})
	end

	local v57 = state and state.userIdentifier or ""
	local v58, v59 = React.useState(false)

	React.useEffect(function() -- line: 155
		-- upvalues: utils (copy), state (copy), authPageload (copy), EventStreamConstants (copy), HttpService (copy)
		local t2 = {
			isAuthenticated = utils.isUserAuthenticated(),
			userIdentifierType = state.userIdentifierType,
			authenticationMethods = table.concat(state.availableLoginMethods, ",")
		}

		authPageload(EventStreamConstants.Context.LoginFormV2Auth, HttpService:JSONEncode(t2))
	end, {})
	React.useEffect(function() -- line: 165
		-- upvalues: state (copy), UserIdentifierType (copy), GetUserByUsername (copy), v45 (copy), v57 (copy), v47 (copy), v49 (copy)
		if state.userIdentifierType == UserIdentifierType.Username then
			GetUserByUsername(v45, v57)():andThen(function(p5) -- line: 168
				-- upvalues: v47 (copy), v49 (copy)
				v47(p5.id)
				v49(p5.displayName)
			end):catch(function(_) -- line: 171
			end)
		end
	end, {})

	local t3 = {
		isLoginByOtp = false,
		setInProgress = v59,
		setErrorKey = function(p7) -- line: 105
			-- upvalues: v52 (copy)
			v52({
				errorKey = p7
			})
		end,
		navigation = t1.navigation,
		eventContext = EventStreamConstants.Context.LoginFormV2Auth
	}
	local v61 = Cryo.Dictionary.join(t3, {
		onCredentialsPopupAbandoned = function() -- line: 188
			-- upvalues: v50 (copy)
			spawn(function() -- line: 189
				-- upvalues: v50 (copy)
				wait(0.1)

				if v50.current then
					v50.current.focus()
				end
			end)
		end
	})
	local v62 = state and state.credentialsProtocolStatus.shouldShowAuthScreenCredentialsPopup
	local v63 = state and state.credentialsProtocolStatus.shouldShowAuthScreenUserSpecificPasskeyPopup

	React.useEffect(function() -- line: 207
		-- upvalues: v62 (copy), state (copy), utils (copy), v51 (copy), v61 (copy), v40 (copy), LoginActionType (copy), v63 (copy), Cryo (copy), AuthenticationMethodType (copy), v50 (copy)
		if v62 then
			local v78 = state and state.credentialsProtocolStatus.fido2Supported
			local v79 = state and state.credentialsProtocolStatus.passwordsSupported

			if state and state.credentialsProtocolStatus.v2InterfaceSupported then
				utils.showGenericCredentialLoginPopup(v78, v79, v51.shouldFilterCredentialsForPrefill, v61)
			elseif v78 then
				utils.showPasskeyLoginPopup(v61, v51.shouldFilterCredentialsForPrefill, true)
			end

			v40.dispatch({
				type = LoginActionType.UpdateCredentialsProtocolStatus,
				data = {
					shouldShowAuthScreenCredentialsPopup = false,
					shouldShowAuthScreenUserSpecificPasskeyPopup = false
				}
			})

			return
		end

		if v63 and Cryo.List.find(state.availableLoginMethods, AuthenticationMethodType.Passkey) ~= nil then
			if state.credentialsProtocolStatus.fido2Supported then
				utils.showPasskeyLoginPopup(v61, true, true)
			end

			v40.dispatch({
				type = LoginActionType.UpdateCredentialsProtocolStatus,
				data = {
					shouldShowAuthScreenUserSpecificPasskeyPopup = false
				}
			})

			return
		end

		if v50.current then
			v50.current.focus()
		end
	end, {})

	local t4 = {
		[AuthenticationMethodType.Password] = function(s1: string?) -- line: 257
			-- upvalues: v59 (copy), AuthenticationMethodType (copy), v52 (copy), authFormInteraction (copy), EventStreamConstants (copy), authButtonClick (copy), utils (copy), t3 (copy)
			if s1 ~= "" then
				v59(true)

				local Password = AuthenticationMethodType.Password

				v52({
					errorType = Password
				})
				v52({
					errorKey = ""
				})
				authFormInteraction(EventStreamConstants.Context.LoginFormV2Auth, EventStreamConstants.Field.Password, nil, nil, nil)
				authButtonClick(EventStreamConstants.Context.LoginFormV2Auth, EventStreamConstants.Button.Password, nil, nil)
				utils.handleLoginWithFormData(nil, s1, nil, nil, nil, false, t3)
			end
		end,
		[AuthenticationMethodType.Passkey] = function(_: string?) -- line: 279
			-- upvalues: AuthenticationMethodType (copy), v52 (copy), authButtonClick (copy), EventStreamConstants (copy), utils (copy), t3 (copy)
			local Passkey = AuthenticationMethodType.Passkey

			v52({
				errorType = Passkey
			})
			v52({
				errorKey = ""
			})
			authButtonClick(EventStreamConstants.Context.LoginFormV2Auth, EventStreamConstants.Button.Passkey, nil, nil)
			utils.showPasskeyLoginPopup(t3, true, false)
		end,
		[AuthenticationMethodType.EmailOtp] = function(_: string?) -- line: 290
			-- upvalues: v59 (copy), AuthenticationMethodType (copy), v52 (copy), authButtonClick (copy), EventStreamConstants (copy), v56 (copy), t1 (copy), LoginPageState (copy), utils (copy), t3 (copy)
			v59(true)

			local EmailOtp = AuthenticationMethodType.EmailOtp

			v52({
				errorType = EmailOtp
			})
			v52({
				errorKey = ""
			})
			authButtonClick(EventStreamConstants.Context.LoginFormV2Auth, EventStreamConstants.Button.EmailOtp, nil, nil)
			utils.handleSendEmailOtp(function(s4: string) -- line: 301
				-- upvalues: v59 (copy), v56 (copy), t1 (copy), LoginPageState (copy)
				v59(false)
				v56(s4)
				t1.navigation.navigate(LoginPageState.EmailOtpScreen)
			end, t3)
		end
	}
	local v65 = useLocalization({
		signInHeadingText = "Authentication.Login.Heading.SignIn",
		passkeyDescriptionText = "Authentication.Login.Description.PasskeyDescription",
		passkeyLoginIncompatibleText = "Authentication.Login.Description.PasskeyLoginIncompatibleDevice",
		orText = "Authentication.SignUp.Description.Or",
		toastErrorText = v55 ~= "" and (v54 ~= AuthenticationMethodType.Password and v55) or nil
	})
	local v66 = (function(t5: {[any]: any}) -- line: 317
		-- upvalues: state (copy), Cryo (copy), AuthenticationMethodType (copy), React (copy), AuthenticationMethod (copy), v38 (copy), t4 (copy), v58 (copy), v59 (copy), v50 (copy), v43 (copy), StyledTextLabel (copy), v65 (copy), v44 (copy)
		if not state.credentialsProtocolStatus.fido2Supported and (#t5 > 1 and Cryo.List.find(t5, AuthenticationMethodType.Passkey) ~= nil) then
			t5 = Cryo.List.filter(t5, function(p8) -- line: 324
				-- upvalues: AuthenticationMethodType (copy)
				return p8 ~= AuthenticationMethodType.Passkey
			end)
		end

		local v87 = #t5 > 1 and t5[1] == AuthenticationMethodType.Password
		local v88 = Cryo.List.map(t5, function(p9, p10) -- line: 330
			-- upvalues: React (copy), AuthenticationMethod (copy), v38 (copy), v87 (copy), t4 (copy), v58 (copy), v59 (copy), v50 (copy)
			return React.createElement(AuthenticationMethod, {
				layoutOrder = if not v38 or (not v87 or not (p10 > 1)) then p10 else p10 + 1,
				isFirstItemInList = p10 == 1,
				authMethod = p9,
				onSubmit = t4[p9],
				isLoginInProgress = v58,
				setIsLoginInProgress = v59,
				textBoxRef = v50
			})
		end)

		if v38 and v87 or not v38 and #t5 > 1 and t5[1] == AuthenticationMethodType.Password then
			table.insert(v88, React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = not v38 and 1.5 or 2,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, v43.Size.Size_200),
					PaddingBottom = UDim.new(0, v43.Size.Size_400)
				}),
				ListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				DividerText = React.createElement(StyledTextLabel, {
					layoutOrder = 1,
					text = v65.orText,
					fontStyle = v44.Font.Header2,
					colorStyle = v44.Theme.TextDefault,
					textXAlignment = Enum.TextXAlignment.Center
				})
			}))

			return v88
		end

		if #t5 == 1 and t5[1] == AuthenticationMethodType.Passkey then
			table.insert(v88, React.createElement("Frame", {
				LayoutOrder = 0,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingBottom = UDim.new(0, v43.Size.Size_400)
				}),
				TextLabel = React.createElement(StyledTextLabel, {
					layoutOrder = 0,
					fluidSizing = true,
					lineHeight = 1,
					text = if not state.credentialsProtocolStatus.fido2Supported then v65.passkeyLoginIncompatibleText else v65.passkeyDescriptionText,
					fontStyle = v44.Font.Body,
					colorStyle = v44.Theme.TextDefault,
					automaticSize = Enum.AutomaticSize.XY
				})
			}))
		end

		return v88
	end)(state.availableLoginMethods)
	local v67 = React.useMemo(function() -- line: 415
		-- upvalues: v65 (copy), Images (copy), v43 (copy)
		return {
			toastTitle = v65.toastErrorText,
			iconImage = Images["icons/status/error_large"],
			iconSize = Vector2.new(v43.Size.Size_600, v43.Size.Size_600),
			iconColorStyle = {
				Transparency = 0,
				Color = v43.Color.System.Alert.Color3
			}
		}
	end, { v65.toastErrorText })
	local v68 = #state.availableLoginMethods == 1 and state.availableLoginMethods[1] == AuthenticationMethodType.Password

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = v44.Theme.BackgroundDefault.Color
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v43.Size.Size_200),
			PaddingBottom = UDim.new(0, v43.Size.Size_200),
			PaddingLeft = UDim.new(0, v43.Size.Size_200),
			PaddingRight = UDim.new(0, v43.Size.Size_200)
		}),
		ErrorToastFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 100,
			Size = UDim2.new(1, 0, 0.5, 0)
		}, {
			ErrorToast = v65.toastErrorText and React.createElement(Toast, {
				duration = 3,
				toastContent = v67
			})
		}),
		Wrapper = React.createElement(if not FFlagFixLoginV2LandscapeLayout then FitFrame.FitFrameVertical else "ScrollingFrame", if not FFlagFixLoginV2LandscapeLayout then {
			BackgroundTransparency = 1,
			width = UDim.new(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		} else {
			BackgroundTransparency = 1,
			ScrollBarThickness = 0,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.XY,
			ScrollingDirection = Enum.ScrollingDirection.Y
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = if not FFlagFixLoginV2LandscapeLayout then nil else Enum.HorizontalAlignment.Center
			}),
			Header = React.createElement("Frame", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}, {
				BackButton = React.createElement(IconButton, {
					layoutOrder = 1,
					icon = Images["icons/actions/cycleLeft"],
					onActivated = function() -- line: 484
						-- upvalues: authButtonClick (copy), EventStreamConstants (copy), v52 (copy), v53 (copy), t1 (copy), LoginPageState (copy)
						authButtonClick(EventStreamConstants.Context.LoginFormV2Auth, EventStreamConstants.Button.Back)
						v52({
							errorKey = ""
						})
						v52({
							errorType = nil
						})
						v52({
							password = ""
						})
						v53({
							userIdentifier = "",
							shouldAttemptCredentialPrefill = false
						})
						t1.navigation.navigate(LoginPageState.LoginScreenV2)
					end,
					size = UDim2.new(0, 36, 0, 36),
					isDisabled = v58
				}),
				SignInHeadingFrame = React.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 0, 1, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AutomaticSize = Enum.AutomaticSize.X
				}, {
					SignInHeadingText = React.createElement(StyledTextLabel, {
						text = v65.signInHeadingText,
						fontStyle = v44.Font.Header1,
						colorStyle = v44.Theme.TextEmphasis,
						textXAlignment = Enum.TextXAlignment.Center
					})
				})
			}),
			ButtonSpacing = React.createElement("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, v43.Size.Size_200)
			}),
			Content = React.createElement("Frame", {
				LayoutOrder = 3,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}, {
				UISizeConstraint = FFlagFixLoginV2LandscapeLayout and React.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(Constants.CONTENT_MAX_WIDTH, 1e999)
				}),
				UIPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v43.Size.Size_200),
					PaddingRight = UDim.new(0, v43.Size.Size_200),
					PaddingBottom = UDim.new(0, if not FFlagFixLoginV2LandscapeLayout then v43.Size.Size_400 else v43.Size.Size_800),
					PaddingTop = UDim.new(0, v43.Size.Size_400)
				}),
				UIListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, v43.Size.Size_50)
				}),
				Heading = React.createElement(UserIdentifierHeading, {
					layoutOrder = 1,
					userIdentifier = v57,
					userId = v46,
					displayName = v48
				}),
				AuthenticationComponents = React.createElement(FitFrame.FitFrameVertical, {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					width = UDim.new(1, 0)
				}, v66),
				HelpButtonFrame = React.createElement("Frame", {
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0)
				}, {
					ListLayout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center
					}),
					HelpButton = React.createElement(NeedHelpButton, {
						layoutOrder = 1,
						isDisabled = v58,
						originPage = EventStreamConstants.Context.LoginFormV2Auth,
						textKey = not v68 and "Authentication.Login.Label.TroubleSigningIn" or "Authentication.Login.Label.ForgotYourPassword",
						identifierAutofill = v57
					})
				})
			})
		})
	})
end

return AuthenticationScreen
