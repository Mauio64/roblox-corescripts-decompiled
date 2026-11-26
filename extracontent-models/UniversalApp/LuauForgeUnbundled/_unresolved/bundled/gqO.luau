local module = require("@luauforge/bundled/gnx")
local module2 = require("@luauforge/bundled/gnz")
local module3 = require("@luauforge/bundled/gow")

local useDesignTokens = require("@luauforge/bundled/gox").useDesignTokens
local useLocalization = require("@luauforge/bundled/goy").Hooks.useLocalization

local fullscreenPageWithSafeArea = module3.FullscreenPageWithSafeArea
local useStyle = module2.Core.Style.useStyle

local module4 = require("@luauforge/bundled/goz")

local text = module4.Text
local useTokens = module4.Hooks.useTokens
local scrollView = module4.ScrollView
local visibility = module4.Enums.Visibility
local inputSize = module4.Enums.InputSize
local button = module4.Button
local buttonVariant = module4.Enums.ButtonVariant

local useClearFocusOnUnmount = require("@luauforge/bundled/goA").useClearFocusOnUnmount

local module5 = require("@luauforge/bundled/gnU")
local module6 = require("@luauforge/bundled/gnF")
local module7 = require("@luauforge/bundled/goH")
local module8 = require("@luauforge/bundled/goO")
local module9 = require("@luauforge/bundled/gou")
local module10 = require("@luauforge/bundled/goc")
local module11 = require("@luauforge/bundled/goQ")
local module12 = require("@luauforge/bundled/gpl")
local module13 = require("@luauforge/bundled/goK")
require("@luauforge/bundled/gnE")

return function(p2)
	local v5 = module.useContext(module5)

	local v6 = useStyle()
	local v7 = useTokens()
	local v8 = useDesignTokens()

	local param = p2.navigation.getParam("userID")
	local param2 = p2.navigation.getParam("displayName")
	local param3 = p2.navigation.getParam("username")
	local param4 = p2.navigation.getParam("didAbandon2SV")
	local param5 = p2.navigation.getParam("contactMethodNumber")

	local state, setState = module.useState("")
	local state2, setState2 = module.useState(false)

	local state3, setState3 = module.useState(Vector2.new(0, 0))

	useClearFocusOnUnmount()

	local function fn(param6, data, fn2)
		if data == nil then
			fn2(module10.UnknownErrorKey)
		elseif data.recoveryState == module6.RECOVERY_STATE_CONTACT_METHOD_VERIFICATION_REQUIRED then
			p2.navigation.navigate(module9.SendCodeScreen, {
				userID = param6,
				isSecondContactMethodVerification = true,
				previousRecoveryMethod = data.previousRecoveryMethod,
				previousRecoveryMethodTypes = data.previousRecoveryMethodTypes,
				nextRecoveryMethodTypes = data.nextRecoveryMethodTypes
			})
		elseif data.recoveryState == module6.RECOVERY_STATE_ACCOUNT_VERIFIED then
			if param5 == 0 and v5.state.recover2sv then
				p2.navigation.replace(module9.AccountVerifiedConfirmationScreen, {
					userID = param6
				})
			elseif module12() and v5.state.recover2sv and not v5.state.recoverPassword then
				v5.utils.handleUpdatePassword(
					v5.state.recoverySessionId,
					param6,
					param3,
					"",
					"",
					fn2,
					v5.utils.launchAppOrGoBack
				)
			else
				p2.navigation.replace(module9.ChooseAccountScreen, { userID = param6 })
			end
		elseif data.recoveryState == module6.RECOVERY_STATE_AWAITING_REEVALUATION then
			p2.navigation.navigate(module9.CannotRecoverAccountScreen, {
				userID = param6
			})
		else
			fn2(module10.UnknownErrorKey)
		end
	end

	local function fn2(p3)
		if state3 ~= p3.AbsoluteSize then
			setState3(p3.AbsoluteSize)
		end
	end

	if state == "" then
		state = nil
	end

	local v11 = useLocalization({
		recoveryHeadingText = "Authentication.AccountRecovery.Heading.RobloxAccountRecovery",
		verifyAgainBodyText = "Authentication.AccountRecovery.Description.VerifyAgain",
		somethingWentWrongVerifyAgainText = "Authentication.AccountRecovery.Description.SomethingWentWrongVerifyAgain",
		continueButtonText = "Authentication.AccountRecovery.Action.Continue",
		requestErrorText = state
	})

	local createElement = module.createElement
	local v13 = {
		includeStatusBar = true,
		BackgroundColor3 = v6.Theme.BackgroundDefault.Color
	}
	local v14 = {
		UIPadding = module.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v8.Size.Size_200),
			PaddingLeft = UDim.new(0, v8.Size.Size_300),
			PaddingRight = UDim.new(0, v8.Size.Size_300),
			PaddingBottom = UDim.new(0, v8.Size.Size_200)
		}),
		Wrapper = 0
	}

	local createElement2 = module.createElement
	local v16 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0)
	}

	local createElement3 = module.createElement
	local v18 = {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Vertical,
		Padding = UDim.new(0, v8.Size.Size_500),
		HorizontalAlignment = 0
	}
	local v19 = if module13() then Enum.HorizontalAlignment.Center else nil
	v18.HorizontalAlignment = v19
	v14.Wrapper = createElement2("Frame", v16, {
		UIListLayout = createElement3("UIListLayout", v18),
		PreScrollContent = module.createElement("Frame", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			[module.Change.AbsoluteSize] = fn2
		}, {
			Header = module.createElement(module7, {
				LayoutOrder = 1,
				onBackActivated = function()
					p2.navigation.goBack()
				end,
				backButtonDisabled = state2,
				recoveryHeadingText = v11.recoveryHeadingText,
				currentComponent = "continueFallback",
				recoverySessionId = v5.state.recoverySessionId
			})
		}),
		ContentScrollView = module.createElement(scrollView, {
			LayoutOrder = 2,
			sizeConstraint = module13() and {
				MaxSize = Vector2.new(module10.ContentMaxWidth, 1e999)
			} or nil,
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(1, 0, 0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y,
				scrollBarVisibility = visibility.Auto
			},
			Size = UDim2.new(1, 0, 1, -state3.Y)
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
			UserHeader = module.createElement(module8, {
				LayoutOrder = 1,
				userId = param,
				displayName = param2,
				username = param3
			}),
			BodyText = module.createElement(text, {
				LayoutOrder = 2,
				Text = param4 and v11.verifyAgainBodyText or v11.somethingWentWrongVerifyAgainText,
				TextWrapped = true,
				fontStyle = v7.Typography.BodyMedium,
				textStyle = v7.Color.Content.Default,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				padding = {
					top = UDim.new(0, v7.Size.Size_300),
					bottom = UDim.new(0, v7.Size.Size_300)
				}
			}),
			ContinueButton = module.createElement(button, {
				LayoutOrder = 3,
				variant = buttonVariant.Emphasis,
				size = inputSize.Medium,
				text = v11.continueButtonText,
				width = UDim.new(1, 0),
				onActivated = function()
					setState2(true)
					setState("")

					local function fn3(p3)
						setState(p3 or module10.UnknownErrorKey)
						setState2(false)
					end
					v5.utils.handleContinueRecovery(v5.state.recoverySessionId, param, function(p3)
						fn(param, p3, fn3)
					end, fn3, function()
						setState2(false)
					end)
				end,
				isLoading = state2
			}),
			RequestErrorTextLabel = module.createElement(text, {
				LayoutOrder = 4,
				Text = v11.requestErrorText or "",
				fontStyle = v7.Typography.CaptionSmall,
				textStyle = v7.Color.System.Alert,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				padding = { top = UDim.new(0, v7.Size.Size_200) }
			}),
			Modal = module12() and module11(v5.state.modalStateAndProps)
		})
	})
	return createElement(fullscreenPageWithSafeArea, v13, v14)
end
