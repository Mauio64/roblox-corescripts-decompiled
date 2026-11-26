local module = require("@luauforge/bundled/gnx")
local module2 = require("@luauforge/bundled/gnz")
local module3 = require("@luauforge/bundled/gow")

local useDesignTokens = require("@luauforge/bundled/gox").useDesignTokens
local useLocalization = require("@luauforge/bundled/goy").Hooks.useLocalization
local useRoactService = require("@luauforge/bundled/gnP").useRoactService

local roactNetworking = require("@luauforge/bundled/gnQ").RoactNetworking

local fullscreenPageWithSafeArea = module3.FullscreenPageWithSafeArea
local useStyle = module2.Core.Style.useStyle

local module4 = require("@luauforge/bundled/goz")

local useTokens = module4.Hooks.useTokens
local text = module4.Text
local button = module4.Button
local buttonVariant = module4.Enums.ButtonVariant
local inputSize = module4.Enums.InputSize

local logger = require("@luauforge/bundled/gnM").Logger

local getUserById = require("@luauforge/bundled/gnT").Thunks.GetUserById

local module5 = require("@luauforge/bundled/gon")
local module6 = require("@luauforge/bundled/goQ")
local module7 = require("@luauforge/bundled/gpl")

local module8 = require("@luauforge/bundled/goH")
local module9 = require("@luauforge/bundled/goO")
local module10 = require("@luauforge/bundled/gou")
local useClearFocusOnUnmount = require("@luauforge/bundled/goA").useClearFocusOnUnmount
local module11 = require("@luauforge/bundled/gnU")
local module12 = require("@luauforge/bundled/goc")
local module13 = require("@luauforge/bundled/goK")

return function(p2)
	local v5 = module.useContext(module11)

	local v6 = useStyle()
	local v7 = useTokens()
	local v8 = useDesignTokens()
	local v9 = useRoactService(roactNetworking)

	local state, setState = module.useState("")
	local state2, setState2 = module.useState("")
	local state3, setState3 = module.useState(false)
	local state4, setState4 = module.useState("")

	local param = p2.navigation.getParam("userID")
	local v10 = p2.navigation.getParam("closeRecoveryOnBack") or false

	useClearFocusOnUnmount()

	module.useEffect(function()
		if param and param ~= 0 then
			getUserById(v9, param):andThen(function(p3)
				setState2(p3.name)
				setState(p3.displayName)
			end):catch(function(p3)
				logger:warning("Error getting user info: {}", p3)
			end)
		end
	end, {})

	local v12 = {
		recoveryHeadingText = "Authentication.AccountRecovery.Heading.RobloxAccountRecovery",
		trustedLocationResetPasswordText = {
			"Authentication.AccountRecovery.Description.TrustedLocationResetPassword",
			username = `@{state2}`
		},
		trustedLocationResetPasswordSkip2svText = {
			"Authentication.AccountRecovery.Description.TrustedLocationResetPasswordSkip2SV",
			username = `@{state2}`
		},
		trustedLocationSkip2svText = {
			"Authentication.AccountRecovery.Description.TrustedLocationSkip2SV",
			username = `@{state2}`
		},
		continueButtonText = "Authentication.AccountRecovery.Action.Continue",
		resetPasswordButtonText = "Authentication.AccountRecovery.Action.ResetPassword",
		requestErrorText = 0
	}
	local v13 = if state4 ~= "" then state4 else nil
	v12.requestErrorText = v13
	local v14 = useLocalization(v12)
	local v15

	if module5() and v5.state.recover2sv and v5.state.recoverPassword then
		v15 = v14.trustedLocationResetPasswordSkip2svText
	elseif module5() and v5.state.recover2sv then
		v15 = v14.trustedLocationSkip2svText
	else
		v15 = v14.trustedLocationResetPasswordText
	end

	local v16

	if module5() and v5.state.recover2sv then
		v16 = v14.continueButtonText
	else
		v16 = v14.resetPasswordButtonText
	end

	local createElement = module.createElement
	local v18 = {
		includeStatusBar = true,
		BackgroundColor3 = v6.Theme.BackgroundDefault.Color
	}
	local v19 = {
		UIPadding = module.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v8.Size.Size_200),
			PaddingLeft = UDim.new(0, v8.Size.Size_300),
			PaddingRight = UDim.new(0, v8.Size.Size_300),
			PaddingBottom = UDim.new(0, v8.Size.Size_200)
		}),
		Wrapper = 0
	}

	local createElement2 = module.createElement
	local v21 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0)
	}

	local createElement3 = module.createElement
	local v23 = {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = 0
	}
	local v24 = if module13() then Enum.HorizontalAlignment.Center else nil
	v23.HorizontalAlignment = v24
	v19.Wrapper = createElement2("Frame", v21, {
		UIListLayout = createElement3("UIListLayout", v23),
		Header = module.createElement(module8, {
			LayoutOrder = 1,
			onBackActivated = function()
				if v10 then
					v5.parentNavigation.goBack()
				else
					p2.navigation.goBack()
				end
			end,
			backButtonDisabled = false,
			recoveryHeadingText = v14.recoveryHeadingText,
			currentComponent = "accountVerifiedConfirmation",
			recoverySessionId = v5.state.recoverySessionId
		}),
		Content = module.createElement(
			"Frame",
			{
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			},
			{
				UISizeConstraint = module13() and module.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(module12.ContentMaxWidth, 1e999)
				}),
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
				}),
				UserHeader = module.createElement(module9, {
					LayoutOrder = 2,
					userId = param or 0,
					displayName = state,
					username = state2
				}),
				UserHeaderSpacing = module.createElement("Frame", {
					LayoutOrder = 3,
					Size = UDim2.new(1, 0, 0, v7.Size.Size_400),
					BackgroundTransparency = 1
				}),
				BodyText = module.createElement(text, {
					LayoutOrder = 4,
					Text = v15,
					TextWrapped = true,
					fontStyle = v7.Typography.BodyMedium,
					textStyle = v7.Color.Content.Default,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center
				}),
				BodyTextSpacing = module.createElement("Frame", {
					LayoutOrder = 5,
					Size = UDim2.new(1, 0, 0, v8.Size.Size_300),
					BackgroundTransparency = 1
				}),
				ResetPasswordButton = module.createElement(button, {
					LayoutOrder = 6,
					variant = buttonVariant.Emphasis,
					size = inputSize.Medium,
					text = v16,
					width = UDim.new(1, 0),
					isLoading = state3,
					onActivated = function()
						if not module7() or not v5.state.recover2sv or v5.state.recoverPassword then
							p2.navigation.navigate(module10.ChooseAccountScreen, {
								userID = param
							})

							return
						end

						setState3(true)
						setState4("")

						local function fn(p3)
							setState4(p3 or module12.UnknownErrorKey)
							setState3(false)
						end
						v5.utils.handleUpdatePassword(
							v5.state.recoverySessionId,
							param,
							state2,
							"",
							"",
							fn,
							v5.utils.launchAppOrGoBack
						)
					end
				}),
				RequestErrorTextLabel = state4 ~= "" and module.createElement(text, {
					LayoutOrder = 7,
					Text = v14.requestErrorText or "",
					fontStyle = v7.Typography.CaptionSmall,
					textStyle = v7.Color.System.Alert,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					padding = { top = UDim.new(0, v7.Size.Size_200) }
				}),
				Modal = module7() and module6(v5.state.modalStateAndProps)
			}
		)
	})
	return createElement(fullscreenPageWithSafeArea, v18, v19)
end
