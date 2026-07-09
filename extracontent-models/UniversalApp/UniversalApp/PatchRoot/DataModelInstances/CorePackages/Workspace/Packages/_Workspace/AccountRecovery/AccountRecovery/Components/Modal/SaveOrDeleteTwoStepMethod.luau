local AccountRecovery = script:FindFirstAncestor("AccountRecovery")
local AccountRecoveryParent = AccountRecovery.Parent
local React = require(AccountRecoveryParent.React)
local useLocalization = require(AccountRecoveryParent.Localization).Hooks.useLocalization
local useDispatch = require(AccountRecoveryParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(AccountRecoveryParent.RobloxAppHooks).useRoactService
local RoactNetworking = require(AccountRecoveryParent.RoactServiceTags).RoactNetworking
local AccountRecoveryContext = require(AccountRecovery.Store.AccountRecoveryContext)
local Foundation = require(AccountRecoveryParent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local GetFFlagEnableTwoStepMethodDynamicText = require(AccountRecovery.Flags).GetFFlagEnableTwoStepMethodDynamicText
local GetCurrentTwoStepMethod = require(AccountRecovery.Thunks.GetCurrentTwoStepMethod)
local DisableTwoStepMethod = require(AccountRecovery.Thunks.DisableTwoStepMethod)

require(AccountRecovery.Common.AccountRecoveryRequestTypes)

local ModalState = require(AccountRecovery.Enums.ModalState)
local AccountRecoveryActionType = require(AccountRecovery.Enums.AccountRecoveryActionType)

return function(t1: {[any]: any}) -- line: 36
	-- upvalues: React (copy), AccountRecoveryContext (copy), useDispatch (copy), useRoactService (copy), RoactNetworking (copy), GetCurrentTwoStepMethod (copy), useLocalization (copy), AccountRecoveryActionType (copy), ModalState (copy), DisableTwoStepMethod (copy), Dialog (copy), DialogSize (copy), GetFFlagEnableTwoStepMethodDynamicText (copy), ButtonVariant (copy)
	local v19 = React.useContext(AccountRecoveryContext)
	local v20 = useDispatch()
	local v21 = useRoactService(RoactNetworking)
	local v22, v23 = React.useState("")
	local v24, v25 = React.useState(false)
	local v26, v27 = React.useState("")
	local v28, v29 = React.useState(true)

	React.useEffect(function() -- line: 47
		-- upvalues: v20 (copy), GetCurrentTwoStepMethod (copy), v21 (copy), v19 (copy), v23 (copy), v29 (copy)
		v20(GetCurrentTwoStepMethod(v21, v19.state.recoverySessionId)):andThen(function(p1) -- line: 49
			-- upvalues: v23 (copy), v29 (copy)
			if not p1.isError then
				v23(p1.data.twoStepMethod)
			end

			v29(false)
		end)
	end, {})

	local v30 = useLocalization({
		email = "Authentication.AccountRecovery.Label.Email2sv",
		authenticator = "Authentication.AccountRecovery.Label.Authenticator2sv",
		securityKey = "Authentication.AccountRecovery.Label.SecurityKey2sv"
	})
	local v31 = useLocalization({
		headingText = "Authentication.AccountRecovery.Heading.SaveTwoStepMethod",
		bodyText = "Authentication.AccountRecovery.Description.SaveTwoStepMethod",
		saveButtonText = "Authentication.AccountRecovery.Action.Save",
		deleteButtonText = "Authentication.AccountRecovery.Action.Delete",
		dynamicBodyText = {
			"Authentication.AccountRecovery.Description.KeepTwoStepMethodDynamic",
			twoStepMethod = if v22 ~= "Email" then if v22 ~= "Authenticator" then v22 ~= "SecurityKey" and "" or v30.securityKey else v30.authenticator else v30.email
		},
		requestErrorText = v26 ~= "" and v26 or nil
	})

	local function v32() -- line: 87
		-- upvalues: t1 (copy), v19 (copy), AccountRecoveryActionType (copy), ModalState (copy)
		if t1.shouldUpdateEmail then
			v19.dispatch({
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

			return
		end

		t1.onPasswordResetSuccess()
	end
	local function v33() -- line: 106
		-- upvalues: v24 (copy), v22 (copy), v28 (copy), v25 (copy), v27 (copy), v20 (copy), DisableTwoStepMethod (copy), v21 (copy), v19 (copy), v32 (copy)
		if v24 or (v22 == "" or v28) then
			return
		end

		v25(true)
		v27("")
		v20(DisableTwoStepMethod(v21, {
			recoverySessionId = v19.state.recoverySessionId,
			twoStepMethod = v22
		})):andThen(function(p2) -- line: 115
			-- upvalues: v25 (copy), v27 (copy), v32 (copy)
			v25(false)

			if p2.isError then
				v27(p2.errorKey)

				return
			end

			v32()
		end)
	end

	return React.createElement(Dialog.Root, {
		disablePortal = false,
		hasBackdrop = true,
		size = DialogSize.Small
	}, {
		DialogTitle = not v28 and React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = v31.headingText
		}),
		DialogContent = not v28 and React.createElement(Dialog.Content, {
			LayoutOrder = 2
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical
			}),
			DialogText = React.createElement(Dialog.Text, {
				LayoutOrder = 1,
				Text = if not GetFFlagEnableTwoStepMethodDynamicText() then v31.bodyText else v31.dynamicBodyText
			}),
			RequestErrorText = v26 ~= "" and React.createElement(Dialog.Text, {
				LayoutOrder = 2,
				Text = v31.requestErrorText or ""
			})
		}),
		DialogActions = not v28 and React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = {
				{
					text = v31.saveButtonText,
					variant = ButtonVariant.Emphasis,
					onActivated = function() -- line: 167
						-- upvalues: v24 (copy), v28 (copy), v25 (copy), v27 (copy), v32 (copy)
						if not v24 then
							if v28 then
								return
							end

							v25(true)
							v27("")
							v32()
						end
					end
				},
				{
					text = v31.deleteButtonText,
					variant = ButtonVariant.Standard,
					onActivated = function() -- line: 174
						-- upvalues: v33 (copy)
						v33()
					end
				}
			}
		})
	})
end
