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
local SetEmail = require(AccountRecovery.Thunks.SetEmail)

require(AccountRecovery.Common.AccountRecoveryRequestTypes)

return function(t1: {[any]: any}) -- line: 27
	-- upvalues: React (copy), AccountRecoveryContext (copy), useDispatch (copy), useRoactService (copy), RoactNetworking (copy), SetEmail (copy), useLocalization (copy), Dialog (copy), DialogSize (copy), ButtonVariant (copy)
	local v15 = React.useContext(AccountRecoveryContext)
	local v16 = useDispatch()
	local v17 = useRoactService(RoactNetworking)
	local v18, v19 = React.useState(false)
	local v20 = useLocalization({
		updateEmailHeadingText = "Authentication.AccountRecovery.Heading.UpdateEmail",
		okButtonText = "Authentication.AccountRecovery.Action.Ok",
		updateEmailBodyText = {
			"Authentication.AccountRecovery.Description.UpdateEmailConfirmation",
			email = `{ t1.email }`
		}
	})

	return React.createElement(Dialog.Root, {
		disablePortal = false,
		hasBackdrop = true,
		size = DialogSize.Small
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = v20.updateEmailHeadingText
		}),
		DialogContent = React.createElement(Dialog.Content, {
			LayoutOrder = 2
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical
			}),
			DialogText = React.createElement(Dialog.Text, {
				LayoutOrder = 1,
				Text = v20.updateEmailBodyText
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = {{
				text = v20.okButtonText,
				variant = ButtonVariant.Emphasis,
				onActivated = function() -- line: 89
					-- upvalues: v18 (copy), v19 (copy), v15 (copy), v16 (copy), SetEmail (copy), v17 (copy), t1 (copy)
					if v18 then
						return
					end

					v19(true)

					local recoverySessionId = v15.state.recoverySessionId

					v16(SetEmail(v17, {
						recoverySessionId = recoverySessionId
					})):andThen(function(_) -- line: 47
						-- upvalues: t1 (copy)
						t1.onPasswordResetSuccess()
					end)
				end
			}}
		})
	})
end
