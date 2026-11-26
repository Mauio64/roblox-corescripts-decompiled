local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local module = require("@luauforge/bundled/gnx")
local module2 = require("@luauforge/bundled/gnz")
local module3 = require("@luauforge/bundled/gow")

local useDesignTokens = require("@luauforge/bundled/gox").useDesignTokens
local useLocalization = require("@luauforge/bundled/goy").Hooks.useLocalization
local useDispatch = require("@luauforge/bundled/gnC").Hooks.RoactRodux.useDispatch
local useRoactService = require("@luauforge/bundled/gnP").useRoactService

local roactNetworking = require("@luauforge/bundled/gnQ").RoactNetworking

local fullscreenPageWithSafeArea = module3.FullscreenPageWithSafeArea
local useStyle = module2.Core.Style.useStyle
local styledTextLabel = module2.App.Text.StyledTextLabel

local module4 = require("@luauforge/bundled/goz")

local text = module4.Text
local textInput = module4.TextInput
local button = module4.Button
local buttonVariant = module4.Enums.ButtonVariant
local inputSize = module4.Enums.InputSize
local divider = module4.Divider
local dividerVariant = module4.Enums.DividerVariant
local orientation = module4.Enums.Orientation
local useTokens = module4.Hooks.useTokens
local loading = module4.Loading
local iconSize = module4.Enums.IconSize
local scrollView = module4.ScrollView
local visibility = module4.Enums.Visibility

local logger = require("@luauforge/bundled/gnM").Logger

local useClearFocusOnUnmount = require("@luauforge/bundled/goA").useClearFocusOnUnmount

local getUserByUsername = require("@luauforge/bundled/gnT").Thunks.GetUserByUsername

local module5 = require("@luauforge/bundled/gnU")
local module6 = require("@luauforge/bundled/goC")
local module7 = require("@luauforge/bundled/goE")
require("@luauforge/bundled/gnE")
local module8 = require("@luauforge/bundled/gnX")
local module9 = require("@luauforge/bundled/gou")
local module10 = require("@luauforge/bundled/goc")
local module11 = require("@luauforge/bundled/goG")
local module12 = require("@luauforge/bundled/goH")
local module13 = require("@luauforge/bundled/gnF")
require("@luauforge/bundled/gnG")
local module14 = require("@luauforge/bundled/goI")
local module15 = require("@luauforge/bundled/gnH")
require("@luauforge/bundled/gnK")
local module16 = require("@luauforge/bundled/gop")
local module17 = require("@luauforge/bundled/gon")
local module18 = require("@luauforge/bundled/goJ")
local module19 = require("@luauforge/bundled/goK")

local defineFastFlag = game:DefineFastFlag("DisableRecoveryForConsole", false)

return function(p2)
	local v5 = module.useContext(module5)

	local v6 = useStyle()
	local v7 = useTokens()
	local v8 = useDesignTokens()
	local v9 = useDispatch()
	local v10 = useRoactService(roactNetworking)

	local state, setState = module.useState(false)

	local state2, setState2 = module.useState("")
	local state3, setState3 = module.useState(1)

	local state4, setState4 = module.useState(false)
	local state5, setState5 = module.useState("")

	local state6, setState6 = module.useState(true)
	local state7, setState7 = module.useState(Vector2.new(0, 0))

	useClearFocusOnUnmount()

	local function fn(recoverySessionId, p3)
		local identifierType = module14.getIdentifierType(p3, state)
		local v11 = {}

		if v5.state.recover2sv then
			table.insert(v11, "twostepverification")
		end

		if v5.state.recoverPassword then
			table.insert(v11, "password")
		end

		return v9(module6(v10, {
			identifier = module14.formatIdentifier(p3, identifierType, v5.state.phonePrefixList[state3]),
			identifierType = identifierType,
			recoverySessionId = recoverySessionId,
			requestedRecoveryTypes = v11
		}))
	end

	local function fn2(p3, fn3, fn4, p4)
		setState4(true)
		setState5("")
		fn(v5.state.recoverySessionId, p3):andThen(function(data)
			if not data.isError then
				fn3(data.data, fn4, p4)
				return
			end

			logger:warning("Error initializing recovery: {}", HttpService:JSONEncode(data))
			fn4(data.errorKey or module10.UnknownErrorKey)
			setState4(false)
		end):await()
	end

	local function fn3(data, callback, p3)
		if data == nil then
			callback(module10.UnknownErrorKey)
			setState4(false)
		else
			v5.dispatch({
				type = module8.SET_RECOVERY_SESSION_ID,
				data = { recoverySessionId = data.recoverySessionId }
			})

			local requestRecoveryMetadata = data.requestRecoveryMetadata
			local v11 = v5.state.recover2sv
			local v12 = v5.state.recoverPassword

			if module18() then
				if requestRecoveryMetadata ~= nil then
					if requestRecoveryMetadata.shouldRecover2sv ~= nil then
						v11 = requestRecoveryMetadata.shouldRecover2sv
					end

					if requestRecoveryMetadata.shouldResetPassword ~= nil then
						v12 = requestRecoveryMetadata.shouldResetPassword
					end
				end

				v5.dispatch({
					type = module8.SET_RECOVERY_INTENT,
					data = { recover2sv = v11, recoverPassword = v12 }
				})
			end

			local userID = requestRecoveryMetadata and requestRecoveryMetadata.userID or 0

			if data.recoveryState == module13.RECOVERY_STATE_CONTACT_METHOD_VERIFICATION_REQUIRED then
				local identifierType = module14.getIdentifierType(state2, state)

				if identifierType == module15.Username then
					if p3 then
						module16.sendRecoveryInitializedFromAutofillEvent(
							data.recoverySessionId,
							identifierType,
							"sendCode"
						)
					else
						module16.sendIdentifierSentEvent(data.recoverySessionId, identifierType, "sendCode")
					end

					if module17() and v11 and not v12 then
						p2.navigation.replace(module9.SendCodeScreen, {
							userID = userID,
							closeRecoveryOnBack = true
						})
					else
						p2.navigation.navigate(module9.SendCodeScreen, {
							userID = userID
						})
					end

					setState4(false)
				else
					local identifierTypeToContactMethodType = module14.identifierTypeToContactMethodType(identifierType)

					local formatIdentifier = module14.formatIdentifier(
						state2,
						identifierType,
						v5.state.phonePrefixList[state3]
					)
					v9(module7(v10, {
						recoverySessionId = data.recoverySessionId,
						contactMethod = formatIdentifier,
						contactMethodType = identifierTypeToContactMethodType,
						contactMethodNumber = 0
					})):andThen(function(p4)
						if p4.isError then
							logger:warning("Error sending code: {}", HttpService:JSONEncode(p4))
							callback(p4.errorKey or module10.UnknownErrorKey)
						else
							module16.sendIdentifierSentEvent(
								data.recoverySessionId,
								identifierType,
								"resendOrVerifyCode"
							)

							p2.navigation.navigate(module9.VerifyCodeScreen, {
								identifierInfo = {
									identifierType = identifierType,
									contactMethodType = identifierTypeToContactMethodType,
									contactMethod = formatIdentifier
								},
								contactMethodNumber = 0
							})
						end

						setState4(false)
					end)
				end
			else
				if data.recoveryState == module13.RECOVERY_STATE_ACCOUNT_VERIFIED then
					p2.navigation.navigate(module9.AccountVerifiedConfirmationScreen, {
						userID = userID
					})

					if p3 then
						module16.sendRecoveryInitializedFromAutofillEvent(
							data.recoverySessionId,
							"username",
							"accountVerifiedConfirmation"
						)
					else
						module16.sendIdentifierSentEvent(
							data.recoverySessionId,
							"username",
							"accountVerifiedConfirmation"
						)
					end
				else
					callback(module10.UnknownErrorKey)
				end

				setState4(false)
			end
		end
	end

	local function fn4(id, data, fn5)
		if data == nil then
			fn5(module10.UnknownErrorKey)
		elseif data.recoveryState == module13.RECOVERY_STATE_CONTACT_METHOD_VERIFICATION_REQUIRED then
			p2.navigation.replace(module9.SendCodeScreen, {
				userID = id,
				isSecondContactMethodVerification = true,
				previousRecoveryMethod = data.previousRecoveryMethod,
				previousRecoveryMethodTypes = data.previousRecoveryMethodTypes,
				nextRecoveryMethodTypes = data.nextRecoveryMethodTypes,
				closeRecoveryOnBack = true
			})
		elseif data.recoveryState == module13.RECOVERY_STATE_ACCOUNT_VERIFIED then
			p2.navigation.replace(module9.AccountVerifiedConfirmationScreen, {
				userID = id,
				closeRecoveryOnBack = true
			})
		elseif data.recoveryState == module13.RECOVERY_STATE_AWAITING_REEVALUATION then
			p2.navigation.navigate(module9.CannotRecoverAccountScreen, { userID = id })
		else
			fn5(module10.UnknownErrorKey)
		end
	end

	local v11 = module17() and { v5.state.deeplinkUuid } or {}
	module.useEffect(function()
		setState6(true)
		module16.sendPageLoadEvent()

		if defineFastFlag then
			local success, result = pcall(function()
				return UserInputService:GetPlatform()
			end)

			if success then
				local v12 = result == Enum.Platform.PS3
					or result == Enum.Platform.PS4
					or game:GetEngineFeature("PlatformEnumPS5") and result == Enum.Platform.PS5
				local v13 = result == Enum.Platform.XBoxOne or result == Enum.Platform.XBox360

				if v12 or v13 then
					setState6(false)
					p2.navigation.replace(module9.CannotRecoverAccountScreen, {
						isConsole = true
					})

					return
				end
			end
		end

		if module17() and v5.state.continuingRecovery then
			local function fn5(p3)
				v5.dispatch({
					type = module8.RESET_RECOVERY_FLOW,
					data = {
						continuingRecovery = false,
						recover2sv = false,
						recoverPassword = true,
						recoverySessionId = "",
						autofillIdentifier = "",
						deeplinkUuid = ""
					}
				})

				setState5(p3 or module10.UnknownErrorKey)
				setState6(false)
			end
			local autofillIdentifier = v5.state.autofillIdentifier

			if autofillIdentifier == nil or autofillIdentifier == "" then
				fn5(module10.UnknownErrorKey)
			else
				getUserByUsername(v10, v5.state.autofillIdentifier)():andThen(function(p3)
					local id = p3.id
					v5.utils.handleContinueRecovery(v5.state.recoverySessionId, id, function(p4)
						fn4(id, p4, fn5)
						setState6(false)
					end, function(p4)
						fn5(p4)
					end, function()
						logger:warning("2SV recovery abandoned when continuing 2SV recovery")
						fn5(module10.UnknownErrorKey)
					end, v5.state.recover2sv)
				end):catch(function(p3)
					logger:warning("Error getting user info: {}", p3)
					fn5(module10.UnknownErrorKey)
				end)
			end
		else
			local autofillIdentifier = v5.state.autofillIdentifier

			if autofillIdentifier == nil or autofillIdentifier == "" then
				setState6(false)
				return
			end

			local identifierType = module14.getIdentifierType(autofillIdentifier, false)

			if identifierType == module15.Phone then
				setState2(autofillIdentifier)
				setState(true)
				module16.sendRecoveryInitializedFromAutofillEvent("", identifierType, "identifierInput")
			elseif identifierType == module15.Email then
				setState2(autofillIdentifier)
				module16.sendRecoveryInitializedFromAutofillEvent("", identifierType, "identifierInput")
			elseif identifierType == module15.Username then
				fn2(autofillIdentifier, fn3, function(p3)
					v5.dispatch({
						type = module8.RESET_RECOVERY_FLOW,
						data = {
							continuingRecovery = false,
							recover2sv = false,
							recoverPassword = true,
							recoverySessionId = "",
							autofillIdentifier = "",
							deeplinkUuid = ""
						}
					})

					module16.sendRecoveryInitializedFromAutofillEvent("", identifierType, "identifierInput")
				end, true)
			end

			setState6(false)
		end
	end, v11)

	local function fn5(p3)
		if state7 ~= p3.AbsoluteSize then
			setState7(p3.AbsoluteSize)
		end
	end

	local v14 = if state5 ~= "" then state5 else nil
	local v15 = useLocalization({
		recoveryHeadingText = "Authentication.AccountRecovery.Heading.RobloxAccountRecovery",
		usernameEmailText = "Authentication.AccountRecovery.Label.UsernameEmail",
		phoneText = "Authentication.AccountRecovery.LabelPhone",
		usePhoneInsteadText = "Authentication.AccountRecovery.Action.UsePhoneInstead",
		useUsernameEmailInsteadText = "Authentication.AccountRecovery.Action.UseUsernameEmailInstead",
		nextButtonText = "Authentication.AccountRecovery.Action.Next",
		orText = "Authentication.AccountRecovery.Label.Or",
		errorText = v14
	})

	local createElement = module.createElement
	local v17 = {
		includeStatusBar = true,
		BackgroundColor3 = v6.Theme.BackgroundDefault.Color
	}
	local v18 = {
		UIPadding = module.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v8.Size.Size_200),
			PaddingLeft = UDim.new(0, v8.Size.Size_300),
			PaddingRight = UDim.new(0, v8.Size.Size_300),
			PaddingBottom = UDim.new(0, v8.Size.Size_200)
		}),
		Wrapper = 0
	}

	local createElement2 = module.createElement
	local v20 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0)
	}

	local createElement3 = module.createElement
	local v22 = {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = 0
	}
	local v23 = if module19() then Enum.HorizontalAlignment.Center else nil
	v22.HorizontalAlignment = v23
	local children = {
		UIListLayout = createElement3("UIListLayout", v22),
		Header = module.createElement(module12, {
			LayoutOrder = 1,
			onBackActivated = function()
				v5.parentNavigation.goBack()
			end,
			backButtonDisabled = state4,
			recoveryHeadingText = v15.recoveryHeadingText,
			currentComponent = "identifierInput",
			recoverySessionId = v5.state.recoverySessionId
		}),
		Loading = state6 and module.createElement(
			"Frame",
			{
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			},
			{
				UIListLayout = module.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, v8.Size.Size_50),
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				LoadingIcon = module.createElement(loading, { size = iconSize.Medium })
			}
		),
		Content = 0
	}

	local v24 = not state6

	if v24 then
		v24 = module.createElement(
			"Frame",
			{
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			},
			{
				UISizeConstraint = module19() and module.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(module10.ContentMaxWidth, 1e999)
				}),
				UIListLayout = module.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical
				}),
				PreScrollContent = module.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0),
					[module.Change.AbsoluteSize] = fn5
				}, {
					UIPadding = module.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, v8.Size.Size_200),
						PaddingRight = UDim.new(0, v8.Size.Size_200)
					}),
					UIListLayout = module.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						Padding = UDim.new(0, v8.Size.Size_50)
					}),
					RecoveryHeadingSpacing = module.createElement("Frame", {
						LayoutOrder = 1,
						Size = UDim2.new(1, 0, 0, v8.Size.Size_500),
						BackgroundTransparency = 1
					})
				}),
				InputsOverflowScrollView = module.createElement(scrollView, {
					LayoutOrder = 2,
					scroll = {
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						CanvasSize = UDim2.new(1, 0, 0, 0),
						ScrollingDirection = Enum.ScrollingDirection.Y,
						scrollBarVisibility = visibility.Always
					},
					Size = UDim2.new(1, 0, 1, -state7.Y)
				}, {
					UIPadding = module.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, v8.Size.Size_200),
						PaddingRight = UDim.new(0, v8.Size.Size_200)
					}),
					UIListLayout = module.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						Padding = UDim.new(0, v8.Size.Size_50)
					}),
					PhoneDropdown = state and module.createElement(module11, {
						LayoutOrder = 2,
						value = state3,
						onChange = function(p3)
							setState3(p3)
						end,
						phonePrefixList = v5.state.phonePrefixList,
						topOffset = v8.Size.Size_1600 * 3
					}),
					PhoneDropdownSpacing = state and module.createElement("Frame", {
						LayoutOrder = 3,
						Size = UDim2.new(1, 0, 0, v8.Size.Size_500),
						BackgroundTransparency = 1
					}),
					IdentifierLabel = module.createElement(styledTextLabel, {
						layoutOrder = 4,
						text = state and v15.phoneText or v15.usernameEmailText,
						fontStyle = v7.Typography.TitleMedium,
						colorStyle = v6.Theme.TextEmphasis,
						automaticSize = Enum.AutomaticSize.XY
					}),
					IdentifierLabelSpacing = module.createElement("Frame", {
						LayoutOrder = 5,
						Size = UDim2.new(1, 0, 0, v8.Size.Size_100),
						BackgroundTransparency = 1
					}),
					UserIdentifierTextField = module.createElement(textInput, {
						LayoutOrder = 6,
						text = state2,
						label = "",
						width = UDim.new(1, 0),
						textInputType = state and Enum.TextInputType.Phone or Enum.TextInputType.Username,
						onChanged = function(p3)
							if state5 ~= "" then
								setState5("")
							end

							setState2(p3)
						end,
						isDisabled = state4,
						size = inputSize.Medium
					}),
					ErrorTextSpacing = module.createElement("Frame", {
						LayoutOrder = 7,
						Size = UDim2.new(1, 0, 0, v7.Size.Size_200),
						BackgroundTransparency = 1
					}),
					ErrorTextLabel = module.createElement(text, {
						Text = v15.errorText or "",
						fontStyle = v7.Typography.CaptionSmall,
						textStyle = v7.Color.System.Alert,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						LayoutOrder = 8
					}),
					NextButtonSpacing = module.createElement("Frame", {
						LayoutOrder = 9,
						Size = UDim2.new(1, 0, 0, v7.Size.Size_300),
						BackgroundTransparency = 1
					}),
					NextButton = module.createElement(button, {
						LayoutOrder = 10,
						variant = buttonVariant.Emphasis,
						size = inputSize.Medium,
						text = v15.nextButtonText,
						width = UDim.new(1, 0),
						onActivated = function()
							fn2(state2, fn3, function(p3)
								setState5(p3)
							end, false)
						end,
						isDisabled = #state2 < 3,
						isLoading = state4
					}),
					DividerSpacing = module.createElement("Frame", {
						LayoutOrder = 11,
						Size = UDim2.new(1, 0, 0, v7.Size.Size_900),
						BackgroundTransparency = 1
					}),
					SwitchInputDivider = module.createElement(
						"Frame",
						{
							LayoutOrder = 12,
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y
						},
						{
							LabelContainer = module.createElement("Frame", {
								BackgroundColor3 = v6.Theme.BackgroundDefault.Color,
								BackgroundTransparency = 0,
								BorderSizePixel = 0,
								Position = UDim2.new(0.5, 0, 0, 0),
								AnchorPoint = Vector2.new(0.5, 0.5),
								AutomaticSize = Enum.AutomaticSize.XY,
								ZIndex = 2
							}, {
								UIPadding = module.createElement("UIPadding", {
									PaddingLeft = UDim.new(0, v8.Size.Size_200),
									PaddingRight = UDim.new(0, v8.Size.Size_200),
									PaddingTop = UDim.new(0, v8.Size.Size_50),
									PaddingBottom = UDim.new(0, v8.Size.Size_50)
								}),
								Label = module.createElement(text, {
									Text = v15.orText,
									fontStyle = v7.Typography.LabelMedium,
									textStyle = v7.Color.ActionStandard.Foreground,
									Size = UDim2.new(1, 0, 0, 0),
									AutomaticSize = Enum.AutomaticSize.Y,
									TextXAlignment = Enum.TextXAlignment.Center,
									TextYAlignment = Enum.TextYAlignment.Center
								})
							}),
							Divider = module.createElement(divider, {
								variant = dividerVariant.Default,
								orientation = orientation.Horizontal,
								ZIndex = 1
							})
						}
					),
					SwitchInputButtonSpacing = module.createElement("Frame", {
						LayoutOrder = 13,
						Size = UDim2.new(1, 0, 0, v7.Size.Size_700),
						BackgroundTransparency = 1
					}),
					SwitchInputButton = module.createElement(button, {
						LayoutOrder = 14,
						variant = buttonVariant.Standard,
						size = inputSize.Medium,
						text = state and v15.useUsernameEmailInsteadText or v15.usePhoneInsteadText,
						width = UDim.new(1, 0),
						onActivated = function()
							module16.sendSwitchedInputEvent("", not state, "identifierInput")
							setState(not state)
							setState2("")
						end,
						isDisabled = state4
					})
				})
			}
		)
	end

	children.Content = v24
	v18.Wrapper = createElement2("Frame", v20, children)
	return createElement(fullscreenPageWithSafeArea, v17, v18)
end
