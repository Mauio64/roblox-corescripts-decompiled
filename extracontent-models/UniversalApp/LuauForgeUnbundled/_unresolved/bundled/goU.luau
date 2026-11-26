local module = require("@luauforge/bundled/gnx")

local useLocalization = require("@luauforge/bundled/goy").Hooks.useLocalization
local useDispatch = require("@luauforge/bundled/gnC").Hooks.RoactRodux.useDispatch
local useRoactService = require("@luauforge/bundled/gnP").useRoactService

local roactNetworking = require("@luauforge/bundled/gnQ").RoactNetworking

local module2 = require("@luauforge/bundled/gnU")
local module3 = require("@luauforge/bundled/goz")
local buttonVariant = module3.Enums.ButtonVariant
local dialog = module3.Dialog
local dialogSize = module3.Enums.DialogSize

local getFFlagEnableTwoStepMethodDynamicText = require("@luauforge/bundled/goV").GetFFlagEnableTwoStepMethodDynamicText

local module4 = require("@luauforge/bundled/goY")
local module5 = require("@luauforge/bundled/gpa")
require("@luauforge/bundled/gnE")
local module6 = require("@luauforge/bundled/gnY")
local module7 = require("@luauforge/bundled/gnX")

return function(props)
	local v5 = module.useContext(module2)

	local v6 = useDispatch()
	local v7 = useRoactService(roactNetworking)

	local state, setState = module.useState("")
	local state2, setState2 = module.useState(false)
	local state3, setState3 = module.useState("")
	local state4, setState4 = module.useState(true)

	module.useEffect(function()
		v6(module4(v7, v5.state.recoverySessionId)):andThen(function(p2)
			if not p2.isError then
				setState(p2.data.twoStepMethod)
			end

			setState4(false)
		end)
	end, {})

	local v8 = useLocalization({
		email = "Authentication.AccountRecovery.Label.Email2sv",
		authenticator = "Authentication.AccountRecovery.Label.Authenticator2sv",
		securityKey = "Authentication.AccountRecovery.Label.SecurityKey2sv"
	})
	local v12

	if state == "Email" then
		v12 = v8.email
	elseif state == "Authenticator" then
		v12 = v8.authenticator
	else
		v12 = state ~= "SecurityKey" and "" or v8.securityKey
	end

	local v13 = if state3 ~= "" and not not state3 then state3 else nil
	local v14 = useLocalization({
		headingText = "Authentication.AccountRecovery.Heading.SaveTwoStepMethod",
		bodyText = "Authentication.AccountRecovery.Description.SaveTwoStepMethod",
		dynamicBodyText = {
			"Authentication.AccountRecovery.Description.KeepTwoStepMethodDynamic",
			twoStepMethod = v12
		},
		saveButtonText = "Authentication.AccountRecovery.Action.Save",
		deleteButtonText = "Authentication.AccountRecovery.Action.Delete",
		requestErrorText = v13
	})

	local function fn()
		if props.shouldUpdateEmail then
			v5.dispatch({
				type = module7.SET_MODAL_STATE_AND_PROPS,
				data = {
					modalStateAndProps = {
						modalState = module6.UPDATE_EMAIL,
						props = {
							email = props.email,
							onPasswordResetSuccess = props.onPasswordResetSuccess
						}
					}
				}
			})
		else
			props.onPasswordResetSuccess()
		end
	end

	local function fn2()
		if state2 or state == "" or state4 then
			return
		end

		setState2(true)
		setState3("")
		v6(module5(v7, {
			recoverySessionId = v5.state.recoverySessionId,
			twoStepMethod = state
		})):andThen(function(p2)
			setState2(false)

			if p2.isError then
				setState3(p2.errorKey)
			else
				fn()
			end
		end)
	end

	local createElement = module.createElement
	local root = dialog.Root
	local v15 = { size = dialogSize.Small, disablePortal = false, hasBackdrop = true }

	local v16 = {
		DialogTitle = not state4 and module.createElement(dialog.Title, {
			LayoutOrder = 1,
			text = v14.headingText
		}),
		DialogContent = 0,
		DialogActions = 0
	}

	local v17 = not state4

	if v17 then
		local createElement2 = module.createElement
		local content = dialog.Content

		local v19 = {
			UIListLayout = module.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical
			}),
			DialogText = 0,
			RequestErrorText = 0
		}

		local createElement3 = module.createElement
		local text = dialog.Text

		local v21 = if getFFlagEnableTwoStepMethodDynamicText() then v14.dynamicBodyText else v14.bodyText
		v19.DialogText = createElement3(text, { LayoutOrder = 1, Text = v21 })

		v19.RequestErrorText = state3 ~= "" and module.createElement(dialog.Text, {
			LayoutOrder = 2,
			Text = v14.requestErrorText or ""
		})
		v17 = createElement2(content, { LayoutOrder = 2 }, v19)
	end

	v16.DialogContent = v17

	v16.DialogActions = not state4 and module.createElement(dialog.Actions, {
		LayoutOrder = 3,
		actions = {
			{
				text = v14.saveButtonText,
				variant = buttonVariant.Emphasis,
				onActivated = function()
					if not state2 then
						if state4 then
							return
						end

						setState2(true)
						setState3("")
						fn()
					end
				end
			},
			{
				text = v14.deleteButtonText,
				variant = buttonVariant.Standard,
				onActivated = function()
					fn2()
				end
			}
		}
	})
	return createElement(root, v15, v16)
end
