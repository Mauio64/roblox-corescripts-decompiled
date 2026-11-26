local module = require("@luauforge/bundled/gnx")

local useLocalization = require("@luauforge/bundled/goy").Hooks.useLocalization
local useRoactService = require("@luauforge/bundled/gnP").useRoactService
local roactNetworking = require("@luauforge/bundled/gnQ").RoactNetworking

local module2 = require("@luauforge/bundled/gnT")
local registerPreauthPasskey = module2.Thunks.RegisterPreauthPasskey
local finishARPreauthPasskeyRegistration = module2.Thunks.FinishARPreauthPasskeyRegistration
local passkeyRegistrationSource = module2.Enums.PasskeyRegistrationSource

local fFlagEmitPasskeyRegistrationSourceOnFinish = require("@luauforge/bundled/god").FFlagEmitPasskeyRegistrationSourceOnFinish

local logger = require("@luauforge/bundled/gnM").Logger
local module3 = require("@luauforge/bundled/gpd")
local default = module3.CredentialsProtocol.default

local getFIntLuaAppCredentialsProtocolAvailableTimeout = module3.Flags.GetFIntLuaAppCredentialsProtocolAvailableTimeout

local module4 = require("@luauforge/bundled/gnU")
local module5 = require("@luauforge/bundled/gnY")
local module6 = require("@luauforge/bundled/gnX")
local module7 = require("@luauforge/bundled/goc")

local module8 = require("@luauforge/bundled/goz")
local buttonVariant = module8.Enums.ButtonVariant
local dialog = module8.Dialog
local dialogSize = module8.Enums.DialogSize
local text = module8.Text
local useTokens = module8.Hooks.useTokens

return function(props)
	local v5 = module.useContext(module4)
	local v6 = useRoactService(roactNetworking)
	local v7 = useTokens()

	local state, setState = module.useState(false)
	local state2, setState2 = module.useState(true)
	local state3, setState3 = module.useState(false)
	local state4, setState4 = module.useState("")

	module.useEffect(function()
		default:isAvailable(
			default.CredentialsTypes.FIDO2,
			getFIntLuaAppCredentialsProtocolAvailableTimeout()
		):andThen(function(p2)
			setState(p2.isAvailable or false)
			setState2(false)
		end):catch(function(p2)
			logger:warning("Error checking for available credential types. Error: {}", p2)
			setState(false)
			setState2(false)
		end)
	end, {})

	local function fn()
		v5.dispatch({
			type = module6.SET_MODAL_STATE_AND_PROPS,
			data = {
				modalStateAndProps = {
					modalState = module5.UPDATE_EMAIL,
					props = {
						email = props.email,
						onPasswordResetSuccess = props.onPasswordResetSuccess
					}
				}
			}
		})
	end

	local function fn2()
		if state3 then
			return
		end

		setState3(true)
		setState4("")
		registerPreauthPasskey(v6, props.username):andThen(function(p2)
			if fFlagEmitPasskeyRegistrationSourceOnFinish then
				return finishARPreauthPasskeyRegistration(
					v6,
					v5.state.recoverySessionId,
					p2.sessionId,
					props.userId,
					p2.result,
					true,
					passkeyRegistrationSource.AccountRecoveryPasswordAndPasskey
				)
			end

			return finishARPreauthPasskeyRegistration(
				v6,
				v5.state.recoverySessionId,
				p2.sessionId,
				props.userId,
				p2.result,
				true
			)
		end):andThen(function()
			setState3(false)

			if props.shouldUpdateEmail then
				fn()
			else
				props.onPasswordResetSuccess()
			end
		end):catch(function(p2)
			setState3(false)
			setState4(module7.UnknownErrorKey)
		end)
	end

	local v10 = if state4 ~= "" then state4 else nil
	local v11 = useLocalization({
		addPasskeyHeadingText = "Authentication.AccountRecovery.Heading.EnhancedProtectionPostRecoveryPasskey",
		passkeyNotSupportedHeadingText = "Authentication.AccountRecovery.Heading.EnhancedProtectionProgramPostRecoveryNoPasskey",
		addPasskeyBodyText = {
			"Authentication.AccountRecovery.Description.EnhancedProtectionAddPasskey",
			lineBreak = "\n"
		},
		passkeyNotSupportedBodyText = "Authentication.AccountRecovery.Description.DeviceDoesNotSupportPasskey",
		addPasskeyButtonText = "Authentication.AccountRecovery.Action.AddAPasskey",
		skipButtonText = "Authentication.AccountRecovery.Action.SkipAddingPasskey",
		okButtonText = "Authentication.AccountRecovery.Action.Ok",
		requestErrorText = v10
	})

	local createElement = module.createElement
	local root = dialog.Root
	local v12 = { size = dialogSize.Small, disablePortal = false, hasBackdrop = true }

	local v13 = {
		DialogTitle = not state2 and module.createElement(dialog.Title, {
			LayoutOrder = 2,
			text = state and v11.addPasskeyHeadingText or v11.passkeyNotSupportedHeadingText
		}),
		DialogContent = 0,
		DialogActionsPasskeySupported = 0,
		DialogActionsPasskeyNotSupported = 0
	}

	local v14 = not state2

	if v14 then
		local createElement2 = module.createElement
		local content = dialog.Content

		local v16 = {
			UIListLayout = module.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical
			}),
			DialogText = module.createElement(dialog.Text, {
				LayoutOrder = 1,
				Text = state and v11.addPasskeyBodyText or v11.passkeyNotSupportedBodyText
			}),
			ErrorText = 0
		}

		local v17 = if state4 ~= "" then module.createElement(text, {
			LayoutOrder = 2,
			Text = v11.requestErrorText or "",
			TextWrapped = true,
			fontStyle = v7.Typography.CaptionSmall,
			textStyle = v7.Color.System.Alert,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}) else nil
		v16.ErrorText = v17
		v14 = createElement2(content, { LayoutOrder = 3 }, v16)
	end

	v13.DialogContent = v14

	v13.DialogActionsPasskeySupported = not state2 and state and module.createElement(dialog.Actions, {
		LayoutOrder = 4,
		actions = {
			{
				text = v11.addPasskeyButtonText,
				variant = buttonVariant.Emphasis,
				onActivated = function()
					fn2()
				end
			},
			{
				text = v11.skipButtonText,
				variant = buttonVariant.Standard,
				onActivated = function()
					if props.shouldUpdateEmail then
						fn()
					else
						props.onPasswordResetSuccess()
					end
				end
			}
		}
	})

	v13.DialogActionsPasskeyNotSupported = not state2
		and not state
		and module.createElement(dialog.Actions, {
			LayoutOrder = 5,
			actions = {
				{
					text = v11.okButtonText,
					variant = buttonVariant.Emphasis,
					onActivated = function()
						if props.shouldUpdateEmail then
							fn()
						else
							props.onPasswordResetSuccess()
						end
					end
				}
			}
		})
	return createElement(root, v12, v13)
end
