local AccountRecovery = script:FindFirstAncestor("AccountRecovery")
local AccountRecoveryParent = AccountRecovery.Parent
local HttpService = game:GetService("HttpService")
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
local ScrollView = Foundation.ScrollView
local Visibility = Foundation.Enums.Visibility
local SystemBanner = Foundation.SystemBanner
local AlertVariant = Foundation.Enums.AlertVariant
local AlertSeverity = Foundation.Enums.AlertSeverity
local Logger = require(AccountRecoveryParent.Loggers).Logger
local useClearFocusOnUnmount = require(AccountRecovery.Hooks).useClearFocusOnUnmount
local GetUserById = require(AccountRecoveryParent.AuthCommon).Thunks.GetUserById
local AccountRecoveryContext = require(AccountRecovery.Store.AccountRecoveryContext)
local SendCode = require(AccountRecovery.Thunks.SendCode)
local VerifyBackupCode = require(AccountRecovery.Thunks.VerifyBackupCode)

require(AccountRecovery.Common.AccountRecoveryRequestTypes)

local Constants = require(AccountRecovery.Components.Constants)
local PhoneDropdown = require(AccountRecovery.Components.PhoneDropdown)
local RecoveryHeader = require(AccountRecovery.Components.RecoveryHeader)
local ContactMethodType = require(AccountRecovery.Enums.ContactMethodType)
local UserHeader = require(AccountRecovery.Components.UserHeader)
local getModal = require(AccountRecovery.Components.getModal)
local IdentifierUtils = require(AccountRecovery.Utils.IdentifierUtils)
local IdentifierType = require(AccountRecovery.Enums.IdentifierType)
local RecoveryMethodType = require(AccountRecovery.Enums.RecoveryMethodType)
local RecoveryMethodInputType = require(AccountRecovery.Enums.RecoveryMethodInputType)
local AccountRecoveryPageState = require(AccountRecovery.Enums.AccountRecoveryPageState)
local RecoveryState = require(AccountRecovery.Enums.RecoveryState)

require(AccountRecovery.Components.Types)

local EventService = require(AccountRecovery.Analytics.EventService)
local GetFFlagEnableBackupCodeInput = require(AccountRecovery.Flags.GetFFlagEnableBackupCodeInput)
local GetFFlagEnableSkipPasswordReset = require(AccountRecovery.Flags.GetFFlagEnableSkipPasswordReset)

local function derivePreviousContactMethodType(b1: boolean, t1: {[any]: any}?) -- line: 70
	-- upvalues: RecoveryMethodType (copy), ContactMethodType (copy)
	if not b1 then
		return nil
	end

	if not t1 or #t1 == 0 then
		return nil
	end

	for _, v in ipairs(t1) do
		if v == RecoveryMethodType.Phone then
			return ContactMethodType.Phone
		end
	end

	return ContactMethodType.Email
end
local function recoveryMethodTypesToInputTypes(t2: {[any]: any}?) -- line: 88
	-- upvalues: RecoveryMethodType (copy), RecoveryMethodInputType (copy)
	if not t2 then
		return nil
	end

	local t3 = {}
	local v63 = false
	local v64 = false
	local v65 = false

	for _, v in ipairs(t2) do
		if v == RecoveryMethodType.CurrentEmail or v == RecoveryMethodType.BillingEmail or v == RecoveryMethodType.HistoricalEmail then
			v63 = true
		elseif v == RecoveryMethodType.Phone then
			v64 = true
		elseif v == RecoveryMethodType.BackupCode then
			v65 = true
		end
	end

	if v63 then
		table.insert(t3, RecoveryMethodInputType.Email)
	end

	if v64 then
		table.insert(t3, RecoveryMethodInputType.Phone)
	end

	if v65 then
		table.insert(t3, RecoveryMethodInputType.BackupCode)
	end

	return t3
end
local function deriveInitialRecoveryMethodInputType(b2: boolean, t4: {[any]: any}?) -- line: 126
	-- upvalues: GetFFlagEnableBackupCodeInput (copy), RecoveryMethodInputType (copy)
	if not b2 or not GetFFlagEnableBackupCodeInput() then
		return RecoveryMethodInputType.Email
	end

	if t4 and #t4 == 1 and t4[1] == RecoveryMethodInputType.BackupCode then
		return RecoveryMethodInputType.BackupCode
	end

	if t4 and table.find(t4, RecoveryMethodInputType.Phone) ~= nil then
		return RecoveryMethodInputType.Phone
	end

	return RecoveryMethodInputType.Email
end
local function deriveSecondContactBannerDescription(b3: boolean, p1, p2, t5: {[any]: any}) -- line: 156
	-- upvalues: RecoveryMethodInputType (copy), ContactMethodType (copy)
	if b3 then
		if p1 == RecoveryMethodInputType.BackupCode then
			return t5.enterBackupCodeText
		end

		if p1 == RecoveryMethodInputType.Phone then
			return t5.enterPhoneNumberText
		end

		return t5.enterEmailAddressText
	end

	if p2 == ContactMethodType.Phone then
		return t5.enterEmailAddressText
	end

	return t5.enterPhoneOrAnotherEmailText
end
local function resolveInitialRecoveryMethodInputType(p3, b4: boolean, t6: {[any]: any}?) -- line: 177
	-- upvalues: GetFFlagEnableBackupCodeInput (copy), deriveInitialRecoveryMethodInputType (copy)
	if b4 and (GetFFlagEnableBackupCodeInput() and p3 ~= nil and t6 and table.find(t6, p3) ~= nil) then
		return p3
	end

	return (deriveInitialRecoveryMethodInputType(b4, t6))
end
local function createElementIf(b5: boolean, p4: ((...any) -> ...any)) -- line: 197
	if not b5 then
		return nil
	end

	return p4()
end

return function(t7: {[any]: any}) -- line: 209
	-- upvalues: React (copy), AccountRecoveryContext (copy), useStyle (copy), useTokens (copy), useDesignTokens (copy), useDispatch (copy), useRoactService (copy), RoactNetworking (copy), derivePreviousContactMethodType (copy), ContactMethodType (copy), RecoveryMethodInputType (copy), GetFFlagEnableBackupCodeInput (copy), recoveryMethodTypesToInputTypes (copy), deriveInitialRecoveryMethodInputType (copy), useClearFocusOnUnmount (copy), GetUserById (copy), Logger (copy), SendCode (copy), IdentifierUtils (copy), EventService (copy), HttpService (copy), Constants (copy), AccountRecoveryPageState (copy), IdentifierType (copy), RecoveryState (copy), GetFFlagEnableSkipPasswordReset (copy), VerifyBackupCode (copy), useLocalization (copy), FullscreenPageWithSafeArea (copy), RecoveryHeader (copy), ScrollView (copy), Visibility (copy), UserHeader (copy), FoundationText (copy), SystemBanner (copy), AlertSeverity (copy), AlertVariant (copy), PhoneDropdown (copy), StyledTextLabel (copy), TextInput (copy), InputSize (copy), Button (copy), ButtonVariant (copy), Divider (copy), DividerVariant (copy), EnumsOrientation (copy), getModal (copy)
	local v80 = React.useContext(AccountRecoveryContext)
	local v81 = useStyle()
	local v82 = useTokens()
	local v83 = useDesignTokens()
	local v84 = useDispatch()
	local v85 = useRoactService(RoactNetworking)
	local v86, v87 = React.useState("")
	local v88, v89 = React.useState("")
	local v90, v91 = React.useState("")
	local v92, v93 = React.useState(1)
	local v94, v95 = React.useState(false)
	local v96, v97 = React.useState("")
	local v98, v99 = React.useState(Vector2.new(0, 0))
	local v100 = t7.navigation.getParam("userID")
	local v101 = t7.navigation.getParam("isSecondContactMethodVerification") or false
	local v102 = t7.navigation.getParam("previousRecoveryMethod") or ""
	local v103 = t7.navigation.getParam("previousRecoveryMethodTypes")
	local v104 = t7.navigation.getParam("nextRecoveryMethodTypes")
	local v105 = t7.navigation.getParam("closeRecoveryOnBack") or false
	local v106 = t7.navigation.getParam("recoveryMethodInputTypeOverride")
	local v107 = derivePreviousContactMethodType(v101, v103)
	local u108 = if not v101 or v107 ~= ContactMethodType.Phone then {
		RecoveryMethodInputType.Email,
		RecoveryMethodInputType.Phone
	} else { RecoveryMethodInputType.Email }

	if GetFFlagEnableBackupCodeInput() then
		u108 = recoveryMethodTypesToInputTypes(v104)
	end

	local v109 = not v101 or u108 and table.find(u108, RecoveryMethodInputType.Phone) ~= nil
	local v110 = not v101 or u108 and table.find(u108, RecoveryMethodInputType.Email) ~= nil
	local v111 = u108
	local v112 = if not v101 or (not GetFFlagEnableBackupCodeInput() or (v106 == nil or (not v111 or table.find(v111, v106) == nil))) then deriveInitialRecoveryMethodInputType(v101, v111) else v106
	local v113, v114 = React.useState(v112)

	local function resetSendCodeFormAfterNavigate() -- line: 267
		-- upvalues: v114 (copy), v112 (copy), v91 (copy), v95 (copy), v97 (copy)
		v114(v112)
		v91("")
		v95(false)
		v97("")
	end

	React.useEffect(function() -- line: 275
		-- upvalues: t7 (copy), u108 (ref), v114 (copy), v91 (copy)
		local v127 = t7.navigation.getParam("recoveryMethodInputTypeOverride")

		if v127 ~= nil and (u108 and table.find(u108, v127) ~= nil) then
			v114(v127)
			v91("")
		end
	end, { v106 })

	local v116 = v100 ~= nil and v100 ~= 0
	local v117 = v116 and not v101
	local v118 = GetFFlagEnableBackupCodeInput() and v101

	useClearFocusOnUnmount()
	React.useEffect(function() -- line: 295
		-- upvalues: v116 (copy), GetUserById (copy), v85 (copy), v100 (copy), v89 (copy), v87 (copy), Logger (copy)
		if v116 then
			GetUserById(v85, v100):andThen(function(p5) -- line: 297
				-- upvalues: v89 (copy), v87 (copy)
				v89(p5.name)
				v87(p5.displayName)
			end):catch(function(p6) -- line: 300
				-- upvalues: Logger (copy)
				Logger:warning("Error getting user info: {}", p6)
			end)
		end
	end, {})

	local function v119(p7: ((...any) -> ...any)) -- line: 319
		-- upvalues: v95 (copy), v97 (copy), IdentifierUtils (copy), v90 (copy), v113 (copy), RecoveryMethodInputType (copy), v80 (copy), v92 (copy), EventService (copy), v84 (copy), SendCode (copy), v85 (copy), v101 (copy), Logger (copy), HttpService (copy), Constants (copy)
		v95(true)
		v97("")

		local v132 = IdentifierUtils.getIdentifierType(v90, v113 == RecoveryMethodInputType.Phone)
		local v133 = IdentifierUtils.identifierTypeToContactMethodType(v132)
		local v134 = IdentifierUtils.formatIdentifier(v90, v132, v80.state.phonePrefixList[v92])

		EventService.sendContactMethodSentEvent(v80.state.recoverySessionId, v132)

		local recoverySessionId = v80.state.recoverySessionId

		v84(SendCode(v85, {
			recoverySessionId = recoverySessionId,
			contactMethod = v134,
			contactMethodType = v133,
			contactMethodNumber = not v101 and 0 or 1
		})):andThen(function(p8) -- line: 339
			-- upvalues: Logger (copy), HttpService (copy), v97 (copy), Constants (copy), v95 (copy), p7 (copy), v132 (copy), v133 (copy), v90 (copy)
			if p8.isError then
				Logger:warning("Error sending code: {}", HttpService:JSONEncode(p8))
				v97(p8.errorKey or Constants.UnknownErrorKey)
				v95(false)

				return
			end

			p7(v132, v133, v90)
		end)
	end
	local function v120(p9, p10, s1: string) -- line: 355
		-- upvalues: v116 (copy), t7 (copy), AccountRecoveryPageState (copy), IdentifierType (copy), v100 (copy), v88 (copy), v86 (copy), v101 (copy), v114 (copy), v112 (copy), v91 (copy), v95 (copy), v97 (copy)
		if v116 then
			t7.navigation.navigate(AccountRecoveryPageState.VerifyCodeScreen, {
				identifierInfo = {
					identifierType = IdentifierType.Username,
					contactMethodType = p10,
					userId = v100,
					username = v88,
					displayName = v86
				},
				contactMethodNumber = not v101 and 0 or 1
			})
		else
			t7.navigation.navigate(AccountRecoveryPageState.VerifyCodeScreen, {
				identifierInfo = {
					identifierType = p9,
					contactMethodType = p10,
					contactMethod = s1
				},
				contactMethodNumber = not v101 and 0 or 1
			})
		end

		v114(v112)
		v91("")
		v95(false)
		v97("")
	end
	local function handleContinueRecoveryAfterBackupVerify(p11) -- line: 384
		-- upvalues: v97 (copy), Constants (copy), v95 (copy), RecoveryState (copy), v100 (copy), GetFFlagEnableSkipPasswordReset (copy), v80 (copy), v88 (copy), t7 (copy), AccountRecoveryPageState (copy), v114 (copy), v112 (copy), v91 (copy)
		if p11 == nil then
			v97(Constants.UnknownErrorKey)
			v95(false)

			return
		end

		if p11.recoveryState ~= RecoveryState.RECOVERY_STATE_ACCOUNT_VERIFIED then
			v97(Constants.UnknownErrorKey)
			v95(false)

			return
		end

		local v140 = v100

		if GetFFlagEnableSkipPasswordReset() and v80.state.recover2sv and not v80.state.recoverPassword then
			v80.utils.handleUpdatePassword(v80.state.recoverySessionId, v140, v88, "", "", function(s2: string?) -- line: 413
				-- upvalues: v97 (copy), Constants (copy), v95 (copy)
				v97(s2 or Constants.UnknownErrorKey)
				v95(false)
			end, v80.utils.launchAppOrGoBack)

			return
		end

		t7.navigation.navigate(AccountRecoveryPageState.ChooseAccountScreen, {
			userID = v140
		})
		v114(v112)
		v91("")
		v95(false)
		v97("")
	end
	local function attemptVerifyBackupCode() -- line: 428
		-- upvalues: v116 (copy), v97 (copy), Constants (copy), v95 (copy), v84 (copy), VerifyBackupCode (copy), v85 (copy), v80 (copy), v90 (copy), Logger (copy), HttpService (copy), v100 (copy), handleContinueRecoveryAfterBackupVerify (copy)
		if not v116 then
			v97(Constants.UnknownErrorKey)

			return
		end

		v95(true)
		v97("")
		v84(VerifyBackupCode(v85, {
			recoverySessionId = v80.state.recoverySessionId,
			backupCode = v90
		})):andThen(function(p12) -- line: 440
			-- upvalues: Logger (copy), HttpService (copy), v97 (copy), Constants (copy), v95 (copy), v80 (copy), v100 (copy), handleContinueRecoveryAfterBackupVerify (copy)
			if p12.isError then
				Logger:warning("Error verifying backup code: {}", HttpService:JSONEncode(p12))
				v97(p12.errorKey or Constants.UnknownErrorKey)
				v95(false)

				return
			end

			v80.utils.handleContinueRecovery(v80.state.recoverySessionId, v100, handleContinueRecoveryAfterBackupVerify, function(_: string?) -- line: 452
				-- upvalues: v97 (copy), Constants (copy), v95 (copy)
				v97(Constants.UnknownErrorKey)
				v95(false)
			end, function() -- line: 456
				-- upvalues: v97 (copy), Constants (copy), v95 (copy)
				v97(Constants.UnknownErrorKey)
				v95(false)
			end)
		end)
	end

	local v123 = useLocalization({
		recoveryHeadingText = "Authentication.AccountRecovery.Heading.RobloxAccountRecovery",
		secondMethodHeadingText = "Authentication.AccountRecovery.Heading.EnterSecondMethod",
		enterPhoneOrAnotherEmailText = "Authentication.AccountRecovery.Description.EnterPhoneOrAnotherEmail",
		enterEmailAddressText = "Authentication.AccountRecovery.Description.EnterEmailAddress",
		enterBackupCodeText = "Authentication.AccountRecovery.Description.EnterABackupCode",
		enterPhoneNumberText = "Authentication.AccountRecovery.Description.EnterPhoneNumberSecondMethod",
		phoneText = "Authentication.AccountRecovery.LabelPhone",
		emailText = "Authentication.AccountRecovery.LabelEmail",
		backupCodeText = "Authentication.AccountRecovery.Label.BackupCode",
		nextButtonText = "Authentication.AccountRecovery.Action.Next",
		sendCodeButtonText = "Authentication.AccountRecovery.Action.SendCode",
		orText = "Authentication.AccountRecovery.Label.Or",
		usePhoneInsteadText = "Authentication.AccountRecovery.Action.UsePhoneInstead",
		useEmailInsteadText = "Authentication.AccountRecovery.Action.UseEmailInstead",
		useEmailActionText = "Authentication.AccountRecovery.Action.UseEmail",
		useBackupCodeActionText = "Authentication.AccountRecovery.Action.UseBackupCode",
		usePhoneActionText = "Authentication.AccountRecovery.Action.UsePhone",
		useAnotherMethodText = "Authentication.AccountRecovery.Action.UseAnotherMethod",
		enterContactMethodAssociatedWithYourAccountText = "Authentication.AccountRecovery.Description.EnterContactMethodAssociatedWithYourAccount",
		sendCodeContactMethodConfirmation = "Authentication.AccountRecovery.Description.SendCodeContactMethodConfirmation",
		previousMethodVerifiedText = {
			"Authentication.AccountRecovery.Label.PreviousContactMethodVerification",
			contactMethod = v102
		},
		errorText = if v96 == "" then nil else v96
	})
	local t8 = {
		enterBackupCodeText = v123.enterBackupCodeText,
		enterPhoneNumberText = v123.enterPhoneNumberText,
		enterEmailAddressText = v123.enterEmailAddressText,
		enterPhoneOrAnotherEmailText = v123.enterPhoneOrAnotherEmailText
	}
	local v125 = if not v118 then if v107 ~= ContactMethodType.Phone then t8.enterPhoneOrAnotherEmailText else t8.enterEmailAddressText else if v113 ~= RecoveryMethodInputType.BackupCode then if v113 ~= RecoveryMethodInputType.Phone then t8.enterEmailAddressText else t8.enterPhoneNumberText else t8.enterBackupCodeText
	local v126 = if not v118 or v113 ~= RecoveryMethodInputType.BackupCode then #v90 < 3 else #v90 ~= Constants.BackupCodeLength

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = v81.Theme.BackgroundDefault.Color
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v83.Size.Size_200),
			PaddingLeft = UDim.new(0, v83.Size.Size_300),
			PaddingRight = UDim.new(0, v83.Size.Size_300),
			PaddingBottom = UDim.new(0, v83.Size.Size_200)
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
				currentComponent = "sendCode",
				onBackActivated = function() -- line: 608
					-- upvalues: v105 (copy), v80 (copy), t7 (copy)
					if v105 then
						v80.parentNavigation.goBack()

						return
					end

					t7.navigation.goBack()
				end,
				backButtonDisabled = v94,
				recoveryHeadingText = v101 and v123.secondMethodHeadingText or v123.recoveryHeadingText,
				recoverySessionId = v80.state.recoverySessionId
			}),
			Content = React.createElement("Frame", {
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
					[React.Change.AbsoluteSize] = function(p13) -- line: 464
						-- upvalues: v98 (copy), v99 (copy)
						if v98 ~= p13.AbsoluteSize then
							v99(p13.AbsoluteSize)
						end
					end
				}, {
					UIPadding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, v83.Size.Size_200),
						PaddingRight = UDim.new(0, v83.Size.Size_200)
					}),
					UIListLayout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						Padding = UDim.new(0, v83.Size.Size_50)
					}),
					RecoveryHeadingSpacing = React.createElement("Frame", {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v83.Size.Size_500)
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
					Size = UDim2.new(1, 0, 1, -v98.Y)
				}, {
					UIPadding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, v83.Size.Size_200),
						PaddingRight = UDim.new(0, v83.Size.Size_200)
					}),
					UIListLayout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						Padding = UDim.new(0, v83.Size.Size_50)
					}),
					UserHeader = if v117 then React.createElement(UserHeader, {
						LayoutOrder = 2,
						userId = v100,
						displayName = v86,
						username = v88
					}) else nil,
					UserHeaderSpacing = if v117 then (function() -- line: 682
						-- upvalues: React (copy), v82 (copy)
						return React.createElement("Frame", {
							LayoutOrder = 3,
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, v82.Size.Size_300)
						})
					end)() else nil,
					BodyText = not v101 and React.createElement(FoundationText, {
						LayoutOrder = 4,
						TextWrapped = true,
						Text = v117 and v123.enterContactMethodAssociatedWithYourAccountText or v123.sendCodeContactMethodConfirmation,
						fontStyle = v82.Typography.BodyMedium,
						textStyle = v82.Color.Content.Default,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						padding = {
							bottom = UDim.new(0, v82.Size.Size_300)
						}
					}),
					SecondContactMethodText = v101 and React.createElement(SystemBanner, {
						LayoutOrder = 5,
						severity = AlertSeverity.Info,
						variant = AlertVariant.Standard,
						title = v123.previousMethodVerifiedText,
						description = v125
					}),
					SecondContactMethodTextSpacing = v101 and React.createElement("Frame", {
						LayoutOrder = 6,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v82.Size.Size_400)
					}),
					PhoneDropdown = v113 == RecoveryMethodInputType.Phone and (v109 and React.createElement(PhoneDropdown, {
						LayoutOrder = 7,
						value = v92,
						onChange = function(n1: number) -- line: 724
							-- upvalues: v93 (copy)
							v93(n1)
						end,
						phonePrefixList = v80.state.phonePrefixList,
						topOffset = v83.Size.Size_1600 * 3
					})),
					PhoneDropdownSpacing = v113 == RecoveryMethodInputType.Phone and (v109 and React.createElement("Frame", {
						LayoutOrder = 8,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v83.Size.Size_500)
					})),
					ContactMethodLabel = React.createElement(StyledTextLabel, {
						layoutOrder = 9,
						text = if v113 ~= RecoveryMethodInputType.Phone then if v113 ~= RecoveryMethodInputType.BackupCode then v123.emailText else v123.backupCodeText else v123.phoneText,
						fontStyle = v82.Typography.TitleMedium,
						colorStyle = v81.Theme.TextEmphasis,
						automaticSize = Enum.AutomaticSize.XY
					}),
					ContactMethodLabelSpacing = React.createElement("Frame", {
						LayoutOrder = 10,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v83.Size.Size_100)
					}),
					ContactMethodField = React.createElement(TextInput, {
						LayoutOrder = 11,
						label = "",
						text = v90,
						width = UDim.new(1, 0),
						textInputType = if v113 ~= RecoveryMethodInputType.Phone then if v113 ~= RecoveryMethodInputType.BackupCode then Enum.TextInputType.Email else Enum.TextInputType.NoSuggestions else Enum.TextInputType.Phone,
						onChanged = function(p14) -- line: 755
							-- upvalues: v96 (copy), v97 (copy), v91 (copy)
							if v96 ~= "" then
								v97("")
							end

							v91(p14)
						end,
						isDisabled = v94,
						size = InputSize.Medium
					}),
					ErrorTextSpacing = React.createElement("Frame", {
						LayoutOrder = 12,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v82.Size.Size_200)
					}),
					ErrorTextLabel = React.createElement(FoundationText, {
						LayoutOrder = 13,
						Text = v123.errorText or "",
						fontStyle = v82.Typography.CaptionSmall,
						textStyle = v82.Color.System.Alert,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center
					}),
					NextButtonSpacing = React.createElement("Frame", {
						LayoutOrder = 14,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v82.Size.Size_300)
					}),
					NextButton = React.createElement(Button, {
						LayoutOrder = 15,
						variant = ButtonVariant.Emphasis,
						size = InputSize.Medium,
						text = v116 and v123.nextButtonText or v123.sendCodeButtonText,
						width = UDim.new(1, 0),
						onActivated = function() -- line: 790
							-- upvalues: v118 (copy), v113 (copy), RecoveryMethodInputType (copy), attemptVerifyBackupCode (copy), v119 (copy), v120 (copy)
							if v118 and v113 == RecoveryMethodInputType.BackupCode then
								attemptVerifyBackupCode()

								return
							end

							v119(v120)
						end,
						isDisabled = v126,
						isLoading = v94
					}),
					SwitchSecondMethodSpacing = v118 and (#(u108 or {}) > 1 and React.createElement("Frame", {
						LayoutOrder = 16,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v82.Size.Size_700)
					})),
					SwitchSecondMethodButton = v118 and (#(u108 or {}) > 1 and React.createElement(Button, {
						LayoutOrder = 17,
						variant = ButtonVariant.Standard,
						size = InputSize.Medium,
						text = (function() -- line: 530
							-- upvalues: u108 (ref), v123 (copy), v113 (copy), RecoveryMethodInputType (copy), v109 (copy), v110 (copy)
							if u108 and #u108 > 2 then
								return v123.useAnotherMethodText
							end

							if u108 and #u108 == 2 then
								if v113 == RecoveryMethodInputType.Email then
									return v109 and v123.usePhoneActionText or v123.useBackupCodeActionText
								end

								if v113 == RecoveryMethodInputType.BackupCode then
									return v109 and v123.usePhoneActionText or v123.useEmailActionText
								end

								return v110 and v123.useEmailActionText or v123.useBackupCodeActionText
							end

							return ""
						end)(),
						width = UDim.new(1, 0),
						onActivated = function() -- line: 548
							-- upvalues: u108 (ref), t7 (copy), AccountRecoveryPageState (copy), v100 (copy), v101 (copy), v102 (copy), v103 (copy), v104 (copy), v105 (copy), v91 (copy), v113 (copy), RecoveryMethodInputType (copy), v109 (copy), v110 (copy), EventService (copy), v80 (copy), v114 (copy)
							if u108 and #u108 > 2 then
								t7.navigation.navigate(AccountRecoveryPageState.ChooseVerificationMethodScreen, {
									sendCodeRouteParams = {
										userID = v100,
										isSecondContactMethodVerification = v101,
										previousRecoveryMethod = v102,
										previousRecoveryMethodTypes = v103,
										nextRecoveryMethodTypes = v104,
										closeRecoveryOnBack = v105
									}
								})
								v91("")

								return
							end

							if u108 and #u108 == 2 then
								local v142 = if v113 ~= RecoveryMethodInputType.Email then if v113 ~= RecoveryMethodInputType.BackupCode then v110 and RecoveryMethodInputType.Email or RecoveryMethodInputType.BackupCode else v109 and RecoveryMethodInputType.Phone or RecoveryMethodInputType.Email else v109 and RecoveryMethodInputType.Phone or RecoveryMethodInputType.BackupCode

								EventService.sendRecoveryMethodInputSwitchEvent(v80.state.recoverySessionId, v142, "sendCode")
								v114(v142)
								v91("")
							end
						end,
						isDisabled = v94
					})),
					DividerSpacing = v109 and (not v118 and React.createElement("Frame", {
						LayoutOrder = 18,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v82.Size.Size_900)
					})),
					SwitchInputDivider = v109 and (not v118 and React.createElement("Frame", {
						LayoutOrder = 19,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					}, {
						LabelContainer = React.createElement("Frame", {
							BackgroundTransparency = 0,
							BorderSizePixel = 0,
							ZIndex = 2,
							BackgroundColor3 = v81.Theme.BackgroundDefault.Color,
							Position = UDim2.new(0.5, 0, 0, 0),
							AnchorPoint = Vector2.new(0.5, 0.5),
							AutomaticSize = Enum.AutomaticSize.XY
						}, {
							UIPadding = React.createElement("UIPadding", {
								PaddingLeft = UDim.new(0, v83.Size.Size_200),
								PaddingRight = UDim.new(0, v83.Size.Size_200),
								PaddingTop = UDim.new(0, v83.Size.Size_50),
								PaddingBottom = UDim.new(0, v83.Size.Size_50)
							}),
							Label = React.createElement(FoundationText, {
								Text = v123.orText,
								fontStyle = v82.Typography.LabelMedium,
								textStyle = v82.Color.ActionStandard.Foreground,
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
					})),
					SwitchInputButtonSpacing = v109 and (not v118 and React.createElement("Frame", {
						LayoutOrder = 20,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v82.Size.Size_700)
					})),
					SwitchInputButton = v109 and (not v118 and React.createElement(Button, {
						LayoutOrder = 21,
						variant = ButtonVariant.Standard,
						size = InputSize.Medium,
						text = v113 == RecoveryMethodInputType.Phone and v123.useEmailInsteadText or v123.usePhoneInsteadText,
						width = UDim.new(1, 0),
						onActivated = function() -- line: 884
							-- upvalues: v113 (copy), RecoveryMethodInputType (copy), EventService (copy), v80 (copy), v114 (copy), v91 (copy)
							local v145 = if v113 ~= RecoveryMethodInputType.Phone then RecoveryMethodInputType.Phone else RecoveryMethodInputType.Email

							EventService.sendSwitchedInputEvent(v80.state.recoverySessionId, v145 == RecoveryMethodInputType.Phone, "sendCode")
							v114(v145)
							v91("")
						end,
						isDisabled = v94
					})),
					Modal = GetFFlagEnableSkipPasswordReset() and getModal(v80.state.modalStateAndProps)
				})
			})
		})
	})
end
