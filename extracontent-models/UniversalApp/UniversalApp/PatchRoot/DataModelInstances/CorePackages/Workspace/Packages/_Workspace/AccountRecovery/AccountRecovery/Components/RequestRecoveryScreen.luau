local AccountRecovery = script:FindFirstAncestor("AccountRecovery")
local AccountRecoveryParent = AccountRecovery.Parent
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local React = require(AccountRecoveryParent.React)
local UIBlox = require(AccountRecoveryParent.UIBlox)
local AppBlox = require(AccountRecoveryParent.AppBlox)
local useDesignTokens = require(AccountRecoveryParent.Style).useDesignTokens
local useLocalization = require(AccountRecoveryParent.Localization).Hooks.useLocalization
local useDispatch = require(AccountRecoveryParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(AccountRecoveryParent.RobloxAppHooks).useRoactService
local RoactNetworking = require(AccountRecoveryParent.RoactServiceTags).RoactNetworking
local FullscreenPageWithSafeArea = AppBlox.FullscreenPageWithSafeArea
local useStyle = UIBlox.Core.Style.useStyle
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local Foundation = require(AccountRecoveryParent.Foundation)
local FoundationText = Foundation.Text
local TextInput = Foundation.TextInput
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local Divider = Foundation.Divider
local DividerVariant = Foundation.Enums.DividerVariant
local EnumsOrientation = Foundation.Enums.Orientation
local useTokens = Foundation.Hooks.useTokens
local Loading = Foundation.Loading
local IconSize = Foundation.Enums.IconSize
local ScrollView = Foundation.ScrollView
local Visibility = Foundation.Enums.Visibility
local Logger = require(AccountRecoveryParent.Loggers).Logger
local useClearFocusOnUnmount = require(AccountRecovery.Hooks).useClearFocusOnUnmount
local GetUserByUsername = require(AccountRecoveryParent.AuthCommon).Thunks.GetUserByUsername
local AccountRecoveryContext = require(AccountRecovery.Store.AccountRecoveryContext)
local RequestRecovery = require(AccountRecovery.Thunks.RequestRecovery)
local SendCode = require(AccountRecovery.Thunks.SendCode)

require(AccountRecovery.Common.AccountRecoveryRequestTypes)

local AccountRecoveryActionType = require(AccountRecovery.Enums.AccountRecoveryActionType)
local AccountRecoveryPageState = require(AccountRecovery.Enums.AccountRecoveryPageState)
local Constants = require(AccountRecovery.Components.Constants)
local PhoneDropdown = require(AccountRecovery.Components.PhoneDropdown)
local RecoveryHeader = require(AccountRecovery.Components.RecoveryHeader)
local RecoveryState = require(AccountRecovery.Enums.RecoveryState)

require(AccountRecovery.Enums.ContactMethodType)

local IdentifierUtils = require(AccountRecovery.Utils.IdentifierUtils)
local IdentifierType = require(AccountRecovery.Enums.IdentifierType)

require(AccountRecovery.Components.Types)

local EventService = require(AccountRecovery.Analytics.EventService)
local GetFFlagEnable2SVRecovery = require(AccountRecovery.Flags.GetFFlagEnable2SVRecovery)
local GetFFlagEnableOverrideRecoveryIntent = require(AccountRecovery.Flags.GetFFlagEnableOverrideRecoveryIntent)
local v47 = game:DefineFastFlag("DisableRecoveryForConsole", false)

return function(t1: {[any]: any}) -- line: 74
	-- upvalues: React (copy), AccountRecoveryContext (copy), useStyle (copy), useTokens (copy), useDesignTokens (copy), useDispatch (copy), useRoactService (copy), RoactNetworking (copy), useClearFocusOnUnmount (copy), IdentifierUtils (copy), RequestRecovery (copy), SendCode (copy), Logger (copy), HttpService (copy), Constants (copy), AccountRecoveryActionType (copy), GetFFlagEnableOverrideRecoveryIntent (copy), RecoveryState (copy), IdentifierType (copy), EventService (copy), GetFFlagEnable2SVRecovery (copy), AccountRecoveryPageState (copy), v47 (copy), UserInputService (copy), GetUserByUsername (copy), useLocalization (copy), FullscreenPageWithSafeArea (copy), RecoveryHeader (copy), Loading (copy), IconSize (copy), ScrollView (copy), Visibility (copy), PhoneDropdown (copy), StyledTextLabel (copy), TextInput (copy), InputSize (copy), FoundationText (copy), Button (copy), ButtonVariant (copy), Divider (copy), DividerVariant (copy), EnumsOrientation (copy)
	local v49 = React.useContext(AccountRecoveryContext)
	local v50 = useStyle()
	local v51 = useTokens()
	local v52 = useDesignTokens()
	local v53 = useDispatch()
	local v54 = useRoactService(RoactNetworking)
	local v55, v56 = React.useState(false)
	local v57, v58 = React.useState("")
	local v59, v60 = React.useState(1)
	local v61, v62 = React.useState(false)
	local v63, v64 = React.useState("")
	local v65, v66 = React.useState(true)
	local v67, v68 = React.useState(Vector2.new(0, 0))

	useClearFocusOnUnmount()

	local function v69(s1: string, s2: string) -- line: 96
		-- upvalues: IdentifierUtils (copy), v55 (copy), v49 (copy), v53 (copy), RequestRecovery (copy), v54 (copy), v59 (copy)
		local v77 = IdentifierUtils.getIdentifierType(s2, v55)
		local t2 = {}

		if v49.state.recover2sv then
			table.insert(t2, "twostepverification")
		end

		if v49.state.recoverPassword then
			table.insert(t2, "password")
		end

		return v53(RequestRecovery(v54, {
			identifier = IdentifierUtils.formatIdentifier(s2, v77, v49.state.phonePrefixList[v59]),
			identifierType = v77,
			recoverySessionId = s1,
			requestedRecoveryTypes = t2
		}))
	end
	local function v70(s3: string, p1: ((...any) -> ...any), p2: ((...any) -> ...any), b1: boolean?) -- line: 129
		-- upvalues: v62 (copy), v64 (copy), v69 (copy), v49 (copy), Logger (copy), HttpService (copy), Constants (copy)
		v62(true)
		v64("")
		v69(v49.state.recoverySessionId, s3):andThen(function(p3) -- line: 143
			-- upvalues: Logger (copy), HttpService (copy), p2 (copy), Constants (copy), v62 (copy), p1 (copy), b1 (copy)
			if p3.isError then
				Logger:warning("Error initializing recovery: {}", HttpService:JSONEncode(p3))
				p2(p3.errorKey or Constants.UnknownErrorKey)
				v62(false)

				return
			end

			p1(p3.data, p2, b1)
		end):await()
	end
	local function v71(p4, p5: ((...any) -> ...any), b2: boolean?) -- line: 155
		-- upvalues: Constants (copy), v62 (copy), v49 (copy), AccountRecoveryActionType (copy), GetFFlagEnableOverrideRecoveryIntent (copy), RecoveryState (copy), IdentifierUtils (copy), v57 (copy), v55 (copy), IdentifierType (copy), EventService (copy), GetFFlagEnable2SVRecovery (copy), t1 (copy), AccountRecoveryPageState (copy), v59 (copy), v53 (copy), SendCode (copy), v54 (copy), Logger (copy), HttpService (copy)
		if p4 == nil then
			p5(Constants.UnknownErrorKey)
			v62(false)

			return
		end

		v49.dispatch({
			type = AccountRecoveryActionType.SET_RECOVERY_SESSION_ID,
			data = {
				recoverySessionId = p4.recoverySessionId
			}
		})

		local requestRecoveryMetadata = p4.requestRecoveryMetadata
		local recover2sv = v49.state.recover2sv
		local recoverPassword = v49.state.recoverPassword

		if GetFFlagEnableOverrideRecoveryIntent() then
			if requestRecoveryMetadata ~= nil then
				if requestRecoveryMetadata.shouldRecover2sv ~= nil then
					recover2sv = requestRecoveryMetadata.shouldRecover2sv
				end

				if requestRecoveryMetadata.shouldResetPassword ~= nil then
					recoverPassword = requestRecoveryMetadata.shouldResetPassword
				end
			end

			v49.dispatch({
				type = AccountRecoveryActionType.SET_RECOVERY_INTENT,
				data = {
					recover2sv = recover2sv,
					recoverPassword = recoverPassword
				}
			})
		end

		local v93 = requestRecoveryMetadata and requestRecoveryMetadata.userID or 0

		if p4.recoveryState == RecoveryState.RECOVERY_STATE_CONTACT_METHOD_VERIFICATION_REQUIRED then
			local v94 = IdentifierUtils.getIdentifierType(v57, v55)

			if v94 == IdentifierType.Username then
				if b2 then
					EventService.sendRecoveryInitializedFromAutofillEvent(p4.recoverySessionId, v94, "sendCode")
				else
					EventService.sendIdentifierSentEvent(p4.recoverySessionId, v94, "sendCode")
				end

				if GetFFlagEnable2SVRecovery() and recover2sv and not recoverPassword then
					t1.navigation.replace(AccountRecoveryPageState.SendCodeScreen, {
						closeRecoveryOnBack = true,
						userID = v93
					})
				else
					t1.navigation.navigate(AccountRecoveryPageState.SendCodeScreen, {
						userID = v93
					})
				end

				v62(false)

				return
			end

			local v95 = IdentifierUtils.identifierTypeToContactMethodType(v94)
			local v96 = IdentifierUtils.formatIdentifier(v57, v94, v49.state.phonePrefixList[v59])
			local recoverySessionId = p4.recoverySessionId

			v53(SendCode(v54, {
				contactMethodNumber = 0,
				recoverySessionId = recoverySessionId,
				contactMethod = v96,
				contactMethodType = v95
			})):andThen(function(p6) -- line: 226
				-- upvalues: Logger (copy), HttpService (copy), p5 (copy), Constants (copy), v62 (copy), EventService (copy), p4 (copy), v94 (copy), t1 (copy), AccountRecoveryPageState (copy), v95 (copy), v96 (copy)
				if p6.isError then
					Logger:warning("Error sending code: {}", HttpService:JSONEncode(p6))
					p5(p6.errorKey or Constants.UnknownErrorKey)
					v62(false)

					return
				end

				EventService.sendIdentifierSentEvent(p4.recoverySessionId, v94, "resendOrVerifyCode")
				t1.navigation.navigate(AccountRecoveryPageState.VerifyCodeScreen, {
					contactMethodNumber = 0,
					identifierInfo = {
						identifierType = v94,
						contactMethodType = v95,
						contactMethod = v96
					}
				})
				v62(false)
			end)

			return
		end

		if p4.recoveryState == RecoveryState.RECOVERY_STATE_ACCOUNT_VERIFIED then
			t1.navigation.navigate(AccountRecoveryPageState.AccountVerifiedConfirmationScreen, {
				userID = v93
			})

			if b2 then
				EventService.sendRecoveryInitializedFromAutofillEvent(p4.recoverySessionId, "username", "accountVerifiedConfirmation")
			else
				EventService.sendIdentifierSentEvent(p4.recoverySessionId, "username", "accountVerifiedConfirmation")
			end

			v62(false)

			return
		end

		p5(Constants.UnknownErrorKey)
		v62(false)
	end
	local function v72(n1: number, p7, p8: ((...any) -> ...any)) -- line: 274
		-- upvalues: Constants (copy), RecoveryState (copy), t1 (copy), AccountRecoveryPageState (copy)
		if p7 == nil then
			p8(Constants.UnknownErrorKey)

			return
		end

		if p7.recoveryState == RecoveryState.RECOVERY_STATE_CONTACT_METHOD_VERIFICATION_REQUIRED then
			t1.navigation.replace(AccountRecoveryPageState.SendCodeScreen, {
				isSecondContactMethodVerification = true,
				closeRecoveryOnBack = true,
				userID = n1,
				previousRecoveryMethod = p7.previousRecoveryMethod,
				previousRecoveryMethodTypes = p7.previousRecoveryMethodTypes,
				nextRecoveryMethodTypes = p7.nextRecoveryMethodTypes
			})

			return
		end

		if p7.recoveryState == RecoveryState.RECOVERY_STATE_ACCOUNT_VERIFIED then
			t1.navigation.replace(AccountRecoveryPageState.AccountVerifiedConfirmationScreen, {
				closeRecoveryOnBack = true,
				userID = n1
			})

			return
		end

		if p7.recoveryState == RecoveryState.RECOVERY_STATE_AWAITING_REEVALUATION then
			t1.navigation.navigate(AccountRecoveryPageState.CannotRecoverAccountScreen, {
				userID = n1
			})

			return
		end

		p8(Constants.UnknownErrorKey)
	end

	local v73 = GetFFlagEnable2SVRecovery() and { v49.state.deeplinkUuid } or {}

	React.useEffect(function() -- line: 309
		-- upvalues: v66 (copy), EventService (copy), v47 (copy), UserInputService (copy), t1 (copy), AccountRecoveryPageState (copy), GetFFlagEnable2SVRecovery (copy), v49 (copy), AccountRecoveryActionType (copy), v64 (copy), Constants (copy), GetUserByUsername (copy), v54 (copy), v72 (copy), Logger (copy), IdentifierUtils (copy), IdentifierType (copy), v58 (copy), v56 (copy), v70 (copy), v71 (copy)
		v66(true)
		EventService.sendPageLoadEvent()

		if v47 then
			local ok, result = pcall(function() -- line: 314
				-- upvalues: UserInputService (copy)
				return UserInputService:GetPlatform()
			end)

			if ok then
				local v103 = result == Enum.Platform.PS3 or (result == Enum.Platform.PS4 or game:GetEngineFeature("PlatformEnumPS5") and result == Enum.Platform.PS5)
				local v104 = result == Enum.Platform.XBoxOne or result == Enum.Platform.XBox360

				if v103 or v104 then
					v66(false)
					t1.navigation.replace(AccountRecoveryPageState.CannotRecoverAccountScreen, {
						isConsole = true
					})

					return
				end
			end
		end

		if GetFFlagEnable2SVRecovery() and v49.state.continuingRecovery then
			local function v105(s4: string) -- line: 333
				-- upvalues: v49 (copy), AccountRecoveryActionType (copy), v64 (copy), Constants (copy), v66 (copy)
				v49.dispatch({
					type = AccountRecoveryActionType.RESET_RECOVERY_FLOW,
					data = {
						continuingRecovery = false,
						recover2sv = false,
						recoverPassword = true,
						recoverySessionId = "",
						autofillIdentifier = "",
						deeplinkUuid = ""
					}
				})
				v64(s4 or Constants.UnknownErrorKey)
				v66(false)
			end

			local autofillIdentifier = v49.state.autofillIdentifier

			if autofillIdentifier == nil or autofillIdentifier == "" then
				v105(Constants.UnknownErrorKey)

				return
			end

			GetUserByUsername(v54, v49.state.autofillIdentifier)():andThen(function(p9) -- line: 355
				-- upvalues: v49 (copy), v72 (copy), v105 (copy), v66 (copy), Logger (copy), Constants (copy)
				local id = p9.id

				v49.utils.handleContinueRecovery(v49.state.recoverySessionId, id, function(p10) -- line: 360
					-- upvalues: v72 (copy), id (copy), v105 (copy), v66 (copy)
					v72(id, p10, v105)
					v66(false)
				end, function(s5: string) -- line: 364
					-- upvalues: v105 (copy)
					v105(s5)
				end, function() -- line: 367
					-- upvalues: Logger (copy), v105 (copy), Constants (copy)
					Logger:warning("2SV recovery abandoned when continuing 2SV recovery")
					v105(Constants.UnknownErrorKey)
				end, v49.state.recover2sv)
			end):catch(function(p11) -- line: 376
				-- upvalues: Logger (copy), v105 (copy), Constants (copy)
				Logger:warning("Error getting user info: {}", p11)
				v105(Constants.UnknownErrorKey)
			end)

			return
		end

		local autofillIdentifier = v49.state.autofillIdentifier

		if autofillIdentifier == nil or autofillIdentifier == "" then
			v66(false)

			return
		end

		local v108 = IdentifierUtils.getIdentifierType(autofillIdentifier, false)

		if v108 == IdentifierType.Phone then
			v58(autofillIdentifier)
			v56(true)
			EventService.sendRecoveryInitializedFromAutofillEvent("", v108, "identifierInput")
		elseif v108 == IdentifierType.Email then
			v58(autofillIdentifier)
			EventService.sendRecoveryInitializedFromAutofillEvent("", v108, "identifierInput")
		elseif v108 == IdentifierType.Username then
			v70(autofillIdentifier, v71, function(_: string) -- line: 399
				-- upvalues: v49 (copy), AccountRecoveryActionType (copy), EventService (copy), v108 (copy)
				v49.dispatch({
					type = AccountRecoveryActionType.RESET_RECOVERY_FLOW,
					data = {
						continuingRecovery = false,
						recover2sv = false,
						recoverPassword = true,
						recoverySessionId = "",
						autofillIdentifier = "",
						deeplinkUuid = ""
					}
				})
				EventService.sendRecoveryInitializedFromAutofillEvent("", v108, "identifierInput")
			end, true)
		end

		v66(false)
	end, v73)

	local v74 = useLocalization({
		recoveryHeadingText = "Authentication.AccountRecovery.Heading.RobloxAccountRecovery",
		usernameEmailText = "Authentication.AccountRecovery.Label.UsernameEmail",
		phoneText = "Authentication.AccountRecovery.LabelPhone",
		usePhoneInsteadText = "Authentication.AccountRecovery.Action.UsePhoneInstead",
		useUsernameEmailInsteadText = "Authentication.AccountRecovery.Action.UseUsernameEmailInstead",
		nextButtonText = "Authentication.AccountRecovery.Action.Next",
		orText = "Authentication.AccountRecovery.Label.Or",
		errorText = if v63 == "" then nil else v63
	})

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = v50.Theme.BackgroundDefault.Color
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v52.Size.Size_200),
			PaddingLeft = UDim.new(0, v52.Size.Size_300),
			PaddingRight = UDim.new(0, v52.Size.Size_300),
			PaddingBottom = UDim.new(0, v52.Size.Size_200)
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
				currentComponent = "identifierInput",
				onBackActivated = function() -- line: 455
					-- upvalues: v49 (copy)
					v49.parentNavigation.goBack()
				end,
				backButtonDisabled = v61,
				recoveryHeadingText = v74.recoveryHeadingText,
				recoverySessionId = v49.state.recoverySessionId
			}),
			Loading = v65 and React.createElement("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, v52.Size.Size_50),
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				LoadingIcon = React.createElement(Loading, {
					size = IconSize.Medium
				})
			}),
			Content = not v65 and React.createElement("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical
				}),
				PreScrollContent = React.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0),
					[React.Change.AbsoluteSize] = function(p12) -- line: 417
						-- upvalues: v67 (copy), v68 (copy)
						if v67 ~= p12.AbsoluteSize then
							v68(p12.AbsoluteSize)
						end
					end
				}, {
					UIPadding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, v52.Size.Size_200),
						PaddingRight = UDim.new(0, v52.Size.Size_200)
					}),
					UIListLayout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						Padding = UDim.new(0, v52.Size.Size_50)
					}),
					RecoveryHeadingSpacing = React.createElement("Frame", {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v52.Size.Size_500)
					})
				}),
				InputsOverflowScrollView = React.createElement(ScrollView, {
					LayoutOrder = 2,
					scroll = {
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						CanvasSize = UDim2.new(1, 0, 0, 0),
						ScrollingDirection = Enum.ScrollingDirection.Y,
						scrollBarVisibility = Visibility.Always
					},
					Size = UDim2.new(1, 0, 1, -v67.Y)
				}, {
					UIPadding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, v52.Size.Size_200),
						PaddingRight = UDim.new(0, v52.Size.Size_200)
					}),
					UIListLayout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						Padding = UDim.new(0, v52.Size.Size_50)
					}),
					PhoneDropdown = v55 and React.createElement(PhoneDropdown, {
						LayoutOrder = 2,
						value = v59,
						onChange = function(n2: number) -- line: 535
							-- upvalues: v60 (copy)
							v60(n2)
						end,
						phonePrefixList = v49.state.phonePrefixList,
						topOffset = v52.Size.Size_1600 * 3
					}),
					PhoneDropdownSpacing = v55 and React.createElement("Frame", {
						LayoutOrder = 3,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v52.Size.Size_500)
					}),
					IdentifierLabel = React.createElement(StyledTextLabel, {
						layoutOrder = 4,
						text = v55 and v74.phoneText or v74.usernameEmailText,
						fontStyle = v51.Typography.TitleMedium,
						colorStyle = v50.Theme.TextEmphasis,
						automaticSize = Enum.AutomaticSize.XY
					}),
					IdentifierLabelSpacing = React.createElement("Frame", {
						LayoutOrder = 5,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v52.Size.Size_100)
					}),
					UserIdentifierTextField = React.createElement(TextInput, {
						LayoutOrder = 6,
						label = "",
						text = v57,
						width = UDim.new(1, 0),
						textInputType = v55 and Enum.TextInputType.Phone or Enum.TextInputType.Username,
						onChanged = function(p13) -- line: 564
							-- upvalues: v63 (copy), v64 (copy), v58 (copy)
							if v63 ~= "" then
								v64("")
							end

							v58(p13)
						end,
						isDisabled = v61,
						size = InputSize.Medium
					}),
					ErrorTextSpacing = React.createElement("Frame", {
						LayoutOrder = 7,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v51.Size.Size_200)
					}),
					ErrorTextLabel = React.createElement(FoundationText, {
						LayoutOrder = 8,
						Text = v74.errorText or "",
						fontStyle = v51.Typography.CaptionSmall,
						textStyle = v51.Color.System.Alert,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center
					}),
					NextButtonSpacing = React.createElement("Frame", {
						LayoutOrder = 9,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v51.Size.Size_300)
					}),
					NextButton = React.createElement(Button, {
						LayoutOrder = 10,
						variant = ButtonVariant.Emphasis,
						size = InputSize.Medium,
						text = v74.nextButtonText,
						width = UDim.new(1, 0),
						onActivated = function() -- line: 600
							-- upvalues: v70 (copy), v57 (copy), v71 (copy), v64 (copy)
							v70(v57, v71, function(s7: string) -- line: 604
								-- upvalues: v64 (copy)
								v64(s7)
							end, false)
						end,
						isDisabled = #v57 < 3,
						isLoading = v61
					}),
					DividerSpacing = React.createElement("Frame", {
						LayoutOrder = 11,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v51.Size.Size_900)
					}),
					SwitchInputDivider = React.createElement("Frame", {
						LayoutOrder = 12,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					}, {
						LabelContainer = React.createElement("Frame", {
							BackgroundTransparency = 0,
							BorderSizePixel = 0,
							ZIndex = 2,
							BackgroundColor3 = v50.Theme.BackgroundDefault.Color,
							Position = UDim2.new(0.5, 0, 0, 0),
							AnchorPoint = Vector2.new(0.5, 0.5),
							AutomaticSize = Enum.AutomaticSize.XY
						}, {
							UIPadding = React.createElement("UIPadding", {
								PaddingLeft = UDim.new(0, v52.Size.Size_200),
								PaddingRight = UDim.new(0, v52.Size.Size_200),
								PaddingTop = UDim.new(0, v52.Size.Size_50),
								PaddingBottom = UDim.new(0, v52.Size.Size_50)
							}),
							Label = React.createElement(FoundationText, {
								Text = v74.orText,
								fontStyle = v51.Typography.LabelMedium,
								textStyle = v51.Color.ActionStandard.Foreground,
								Size = UDim2.new(1, 0, 0, 0),
								AutomaticSize = Enum.AutomaticSize.Y,
								TextXAlignment = Enum.TextXAlignment.Center,
								TextYAlignment = Enum.TextYAlignment.Center
							})
						}),
						Divider = React.createElement(Divider, {
							ZIndex = 1,
							variant = DividerVariant.Default,
							orientation = EnumsOrientation.Horizontal
						})
					}),
					SwitchInputButtonSpacing = React.createElement("Frame", {
						LayoutOrder = 13,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v51.Size.Size_700)
					}),
					SwitchInputButton = React.createElement(Button, {
						LayoutOrder = 14,
						variant = ButtonVariant.Standard,
						size = InputSize.Medium,
						text = v55 and v74.useUsernameEmailInsteadText or v74.usePhoneInsteadText,
						width = UDim.new(1, 0),
						onActivated = function() -- line: 667
							-- upvalues: EventService (copy), v55 (copy), v56 (copy), v58 (copy)
							EventService.sendSwitchedInputEvent("", not v55, "identifierInput")
							v56(not v55)
							v58("")
						end,
						isDisabled = v61
					})
				})
			})
		})
	})
end
