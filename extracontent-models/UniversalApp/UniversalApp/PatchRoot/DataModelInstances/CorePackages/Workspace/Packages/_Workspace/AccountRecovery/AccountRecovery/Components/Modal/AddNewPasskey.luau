local AccountRecovery = script:FindFirstAncestor("AccountRecovery")
local AccountRecoveryParent = AccountRecovery.Parent
local React = require(AccountRecoveryParent.React)
local useLocalization = require(AccountRecoveryParent.Localization).Hooks.useLocalization
local useRoactService = require(AccountRecoveryParent.RobloxAppHooks).useRoactService
local RoactNetworking = require(AccountRecoveryParent.RoactServiceTags).RoactNetworking
local AuthCommon = require(AccountRecoveryParent.AuthCommon)
local RegisterPreauthPasskey = AuthCommon.Thunks.RegisterPreauthPasskey
local FinishARPreauthPasskeyRegistration = AuthCommon.Thunks.FinishARPreauthPasskeyRegistration
local Logger = require(AccountRecoveryParent.Loggers).Logger
local CredentialsProtocol = require(AccountRecoveryParent.CredentialsProtocol)
local default = CredentialsProtocol.CredentialsProtocol.default
local GetFIntLuaAppCredentialsProtocolAvailableTimeout = CredentialsProtocol.Flags.GetFIntLuaAppCredentialsProtocolAvailableTimeout
local AccountRecoveryContext = require(AccountRecovery.Store.AccountRecoveryContext)
local ModalState = require(AccountRecovery.Enums.ModalState)
local AccountRecoveryActionType = require(AccountRecovery.Enums.AccountRecoveryActionType)
local Constants = require(AccountRecovery.Components.Constants)
local Foundation = require(AccountRecoveryParent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

return function(t1: {[any]: any}) -- line: 43
	-- upvalues: React (copy), AccountRecoveryContext (copy), useRoactService (copy), RoactNetworking (copy), useTokens (copy), default (copy), GetFIntLuaAppCredentialsProtocolAvailableTimeout (copy), Logger (copy), AccountRecoveryActionType (copy), ModalState (copy), RegisterPreauthPasskey (copy), FinishARPreauthPasskeyRegistration (copy), Constants (copy), useLocalization (copy), Dialog (copy), DialogSize (copy), FoundationText (copy), ButtonVariant (copy)
	local v25 = React.useContext(AccountRecoveryContext)
	local v26 = useRoactService(RoactNetworking)
	local v27 = useTokens()
	local v28, v29 = React.useState(false)
	local v30, v31 = React.useState(true)
	local v32, v33 = React.useState(false)
	local v34, v35 = React.useState("")

	React.useEffect(function() -- line: 53
		-- upvalues: default (copy), GetFIntLuaAppCredentialsProtocolAvailableTimeout (copy), v29 (copy), v31 (copy), Logger (copy)
		default:isAvailable(default.CredentialsTypes.FIDO2, GetFIntLuaAppCredentialsProtocolAvailableTimeout()):andThen(function(p1) -- line: 56
			-- upvalues: v29 (copy), v31 (copy)
			v29(p1.isAvailable or false)
			v31(false)
		end):catch(function(p2) -- line: 60
			-- upvalues: Logger (copy), v29 (copy), v31 (copy)
			Logger:warning("Error checking for available credential types. Error: {}", p2)
			v29(false)
			v31(false)
		end)
	end, {})

	local function v36() -- line: 67
		-- upvalues: v25 (copy), AccountRecoveryActionType (copy), ModalState (copy), t1 (copy)
		v25.dispatch({
			type = AccountRecoveryActionType.SET_MODAL_STATE_AND_PROPS,
			data = {
				modalStateAndProps = {
					modalState = ModalState.UPDATE_EMAIL,
					props = {
						email = t1.email,
						onPasswordResetSuccess = t1.onPasswordResetSuccess
					}
				}
			}
		})
	end
	local function v37() -- line: 82
		-- upvalues: v32 (copy), v33 (copy), v35 (copy), RegisterPreauthPasskey (copy), v26 (copy), t1 (copy), FinishARPreauthPasskeyRegistration (copy), v25 (copy), v36 (copy), Constants (copy)
		if v32 then
			return
		end

		v33(true)
		v35("")
		RegisterPreauthPasskey(v26, t1.username):andThen(function(p3) -- line: 89
			-- upvalues: FinishARPreauthPasskeyRegistration (copy), v26 (copy), v25 (copy), t1 (copy)
			return FinishARPreauthPasskeyRegistration(v26, v25.state.recoverySessionId, p3.sessionId, t1.userId, p3.result, true)
		end):andThen(function() -- line: 99
			-- upvalues: v33 (copy), t1 (copy), v36 (copy)
			v33(false)

			if t1.shouldUpdateEmail then
				v36()

				return
			end

			t1.onPasswordResetSuccess()
		end):catch(function(_) -- line: 107
			-- upvalues: v33 (copy), v35 (copy), Constants (copy)
			v33(false)
			v35(Constants.UnknownErrorKey)
		end)
	end

	local v38 = useLocalization({
		addPasskeyHeadingText = "Authentication.AccountRecovery.Heading.EnhancedProtectionPostRecoveryPasskey",
		passkeyNotSupportedHeadingText = "Authentication.AccountRecovery.Heading.EnhancedProtectionProgramPostRecoveryNoPasskey",
		passkeyNotSupportedBodyText = "Authentication.AccountRecovery.Description.DeviceDoesNotSupportPasskey",
		addPasskeyButtonText = "Authentication.AccountRecovery.Action.AddAPasskey",
		skipButtonText = "Authentication.AccountRecovery.Action.SkipAddingPasskey",
		okButtonText = "Authentication.AccountRecovery.Action.Ok",
		addPasskeyBodyText = {
			"Authentication.AccountRecovery.Description.EnhancedProtectionAddPasskey",
			lineBreak = "\n"
		},
		requestErrorText = if v34 == "" then nil else v34
	})

	return React.createElement(Dialog.Root, {
		disablePortal = false,
		hasBackdrop = true,
		size = DialogSize.Small
	}, {
		DialogTitle = not v30 and React.createElement(Dialog.Title, {
			LayoutOrder = 2,
			text = v28 and v38.addPasskeyHeadingText or v38.passkeyNotSupportedHeadingText
		}),
		DialogContent = not v30 and React.createElement(Dialog.Content, {
			LayoutOrder = 3
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical
			}),
			DialogText = React.createElement(Dialog.Text, {
				LayoutOrder = 1,
				Text = v28 and v38.addPasskeyBodyText or v38.passkeyNotSupportedBodyText
			}),
			ErrorText = if v34 == "" then nil else React.createElement(FoundationText, {
				LayoutOrder = 2,
				TextWrapped = true,
				Text = v38.requestErrorText or "",
				fontStyle = v27.Typography.CaptionSmall,
				textStyle = v27.Color.System.Alert,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			})
		}),
		DialogActionsPasskeySupported = not v30 and (v28 and React.createElement(Dialog.Actions, {
			LayoutOrder = 4,
			actions = {
				{
					text = v38.addPasskeyButtonText,
					variant = ButtonVariant.Emphasis,
					onActivated = function() -- line: 175
						-- upvalues: v37 (copy)
						v37()
					end
				},
				{
					text = v38.skipButtonText,
					variant = ButtonVariant.Standard,
					onActivated = function() -- line: 182
						-- upvalues: t1 (copy), v36 (copy)
						if t1.shouldUpdateEmail then
							v36()

							return
						end

						t1.onPasswordResetSuccess()
					end
				}
			}
		})),
		DialogActionsPasskeyNotSupported = not v30 and (not v28 and React.createElement(Dialog.Actions, {
			LayoutOrder = 5,
			actions = {{
				text = v38.okButtonText,
				variant = ButtonVariant.Emphasis,
				onActivated = function() -- line: 196
					-- upvalues: t1 (copy), v36 (copy)
					if t1.shouldUpdateEmail then
						v36()

						return
					end

					t1.onPasswordResetSuccess()
				end
			}}
		}))
	})
end
