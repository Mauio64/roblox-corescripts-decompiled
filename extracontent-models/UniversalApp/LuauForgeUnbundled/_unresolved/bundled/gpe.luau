local LocalizationService = game:GetService("LocalizationService")

local module = require("@luauforge/bundled/gnx")

local useLocalization = require("@luauforge/bundled/goy").Hooks.useLocalization
local useDispatch = require("@luauforge/bundled/gnC").Hooks.RoactRodux.useDispatch
local useRoactService = require("@luauforge/bundled/gnP").useRoactService

local roactNetworking = require("@luauforge/bundled/gnQ").RoactNetworking

local module2 = require("@luauforge/bundled/goz")
local buttonVariant = module2.Enums.ButtonVariant
local dialog = module2.Dialog
local dialogSize = module2.Enums.DialogSize
local iconSize = module2.Enums.IconSize
local inputSize = module2.Enums.InputSize
local iconName = module2.Enums.IconName
local orientation = module2.Enums.Orientation
local popoverAlign = module2.Enums.PopoverAlign
local popoverSide = module2.Enums.PopoverSide
local checkbox = module2.Checkbox
local educationalTooltip = module2.EducationalTooltip
local icon = module2.Icon
local iconButton = module2.IconButton
local text = module2.Text
local view = module2.View
local useTokens = module2.Hooks.useTokens

local module3 = require("@luauforge/bundled/gnU")
local module4 = require("@luauforge/bundled/gnJ")
local module5 = require("@luauforge/bundled/gnY")
local module6 = require("@luauforge/bundled/gnX")
local module7 = require("@luauforge/bundled/gpf")
local module8 = require("@luauforge/bundled/gph")
require("@luauforge/bundled/gnE")
require("@luauforge/bundled/gnK")
local module9 = require("@luauforge/bundled/goc")

local function isEmailUnavailable(value): boolean
	return value ~= nil and value:lower() == "email unavailable"
end

local function formatDate(p2)
	if p2 == nil then
		return nil
	end

	local success, result = pcall(function()
		return DateTime.fromUnixTimestampMillis(p2):FormatLocalTime(
			"ll",
			LocalizationService.RobloxLocaleId or "en-us"
		)
	end)

	if success then
		return result
	end

	return nil
end

local function formatDetailLine(p2, p3)
	local v5 = not (p2 == nil) and p2 ~= ""
	local v6 = not (p3 == nil) and p3 ~= ""

	if v5 and v6 then
		return p2 .. " • " .. p3
	end

	if v6 then
		return p3
	end

	if v5 then
		return p2
	end

	return ""
end

local v5 = {
	[module4.Email] = {
		kind = "grouped",
		headerKey = "Authentication.AccountRecovery.Heading.EmailAdded",
		showValue = true,
		redactsUnavailableEmail = true,
		iconName = iconName.Envelope
	},
	[module4.BillingEmail] = {
		kind = "grouped",
		headerKey = "Authentication.AccountRecovery.Heading.BillingEmailAdded",
		showValue = true,
		iconName = iconName.Envelope
	},
	[module4.PhoneNumber] = {
		kind = "grouped",
		headerKey = "Authentication.AccountRecovery.Heading.PhoneNumberAdded",
		showValue = true,
		iconName = iconName.Phone
	},
	[module4.TwoStepVerification] = {
		kind = "perCredential",
		headerTemplateKey = "Authentication.AccountRecovery.Heading.TwoStepMethodAdded",
		translatesValue = true,
		iconName = iconName.ShieldLock
	},
	[module4.Passkey] = {
		kind = "grouped",
		headerKey = "Authentication.AccountRecovery.Heading.PasskeyAdded",
		showValue = true,
		iconName = iconName.Key
	},
	[module4.EnhancedProtectionProgram] = {
		kind = "grouped",
		headerKey = "Authentication.AccountRecovery.Heading.EnrolledInEnhancedProtection",
		showValue = false,
		iconName = iconName.ShieldCheck
	},
	[module4.BackupCodes] = {
		kind = "grouped",
		headerKey = "Authentication.AccountRecovery.Heading.BackupCodesGenerated",
		showValue = false,
		iconName = iconName.Hashtag
	}
}

local function countCredentials(items)
	local total = 0

	for k, item in items do
		if v5[item.category] ~= nil then
			total += #item.credentials
		end
	end

	return total
end

local function groupedHeaderKey(p2)
	return `header_{p2}`
end

local function credentialHeaderKey(p2, p3)
	return `header_{p2}_{p3}`
end

local function buildChangeRowRequests(state, fn)
	local changeRowRequests = {}

	for k, item in state do
		local v6 = v5[item.category]

		if v6 == nil then
			continue
		end

		if v6.kind == "grouped" then
			changeRowRequests[`header_{k}`] = v6.headerKey
		else
			for k2, credential in item.credentials do
				local v7 = if v6.translatesValue then fn(credential.value) else credential.value
				changeRowRequests[`header_{k}_{k2}`] = {
					v6.headerTemplateKey,
					value = v7
				}
			end
		end
	end

	return changeRowRequests
end

local function assembleChangeRows(state, p2, unavailableEmail)
	local result = {}

	for k, item in state do
		local v6 = v5[item.category]

		if v6 == nil then
			continue
		end

		if v6.kind == "grouped" then
			local v7 = {}
			local v8 = false

			for k2, credential in item.credentials do
				local timeAdded = credential.timeAdded
				local result2

				if timeAdded ~= nil then
					local success
					success, result2 = pcall(function()
						return DateTime.fromUnixTimestampMillis(timeAdded):FormatLocalTime(
							"ll",
							LocalizationService.RobloxLocaleId or "en-us"
						)
					end)

					if not success then
						result2 = nil
					end
				end

				local v9 = credential.value

				if v6.redactsUnavailableEmail then
					local v10 = not (v9 == nil) and v9:lower() == "email unavailable"

					if v10 then
						v9 = unavailableEmail
						v8 = true
					end
				end

				if v6.showValue then
					local v10 = not (v9 == nil) and v9 ~= ""
					local v11 = not (result2 == nil) and result2 ~= ""

					if v10 and v11 then
						result2 = v9 .. " • " .. result2
					elseif not v11 then
						result2 = not v10 and "" or v9
					end
				else
					result2 = (result2 == nil or result2 == "") and "" or result2
				end

				if result2 ~= "" then
					table.insert(v7, result2)
				end
			end

			if #v7 > 0 then
				table.insert(result, {
					header = p2[`header_{k}`],
					body = table.concat(v7, "\n"),
					iconName = v6.iconName,
					hasUnavailableEmail = v8
				})
			end
		else
			for k2, credential in item.credentials do
				local timeAdded = credential.timeAdded
				local result2

				if timeAdded ~= nil then
					local success
					success, result2 = pcall(function()
						return DateTime.fromUnixTimestampMillis(timeAdded):FormatLocalTime(
							"ll",
							LocalizationService.RobloxLocaleId or "en-us"
						)
					end)

					if not success then
						result2 = nil
					end
				end

				local v7 = result2 or ""

				if v7 ~= "" then
					table.insert(result, {
						header = p2[`header_{k}_{k2}`],
						body = v7,
						iconName = v6.iconName
					})
				end
			end
		end
	end

	return result
end

local function UnavailableEmailInfo(p2)
	local state, setState = module.useState(false)

	return module.createElement(educationalTooltip, {
		LayoutOrder = 2,
		title = "",
		text = p2.text,
		isOpen = state,
		side = popoverSide.Bottom,
		align = popoverAlign.End,
		onClose = function()
			setState(false)
		end
	}, module.createElement(iconButton, {
		icon = iconName.CircleI,
		size = inputSize.XSmall,
		onActivated = function()
			setState(function(p3): boolean
				return not p3
			end)
		end
	}))
end

return function(props)
	local v6 = useTokens()
	local v7 = module.useContext(module3)
	local v8 = useDispatch()
	local v9 = useRoactService(roactNetworking)

	local state, setState = module.useState({})
	local state2, setState2 = module.useState(true)
	local state3, setState3 = module.useState(false)
	local state4, setState4 = module.useState("")
	local state5, setState5 = module.useState(false)
	local total = 0

	for k, v10 in state do
		if v5[v10.category] ~= nil then
			total += #v10.credentials
		end
	end

	local v10 = total == 1
	local v11 = total > 0
	local v14 = if state4 ~= "" then state4 else nil
	local v15 = useLocalization({
		heading = v10 and "Authentication.AccountRecovery.Heading.InvalidateCredential" or "Authentication.AccountRecovery.Heading.InvalidateCredentials",
		intro = v10 and "Authentication.AccountRecovery.Description.InvalidateCredentialInfo" or "Authentication.AccountRecovery.Description.InvalidateCredentialsIntro",
		warning = "Authentication.AccountRecovery.Description.InvalidateCredentialsWarning",
		deleteButton = "Authentication.AccountRecovery.Action.DeleteAll",
		dontDeleteButton = "Authentication.AccountRecovery.Action.DontDeleteCredentials",
		unavailableEmail = "Authentication.AccountRecovery.Label.EmailUnavailable",
		unavailableEmailInfo = "Authentication.AccountRecovery.Description.EmailUnavailableInfo",
		requestErrorText = v14
	})

	local v16 = useLocalization({
		email = "Authentication.AccountRecovery.Label.Email2svCapitalized",
		authenticator = "Authentication.AccountRecovery.Label.Authenticator2svCapitalized",
		securityKey = "Authentication.AccountRecovery.Label.SecurityKey2svCapitalized"
	})

	local v18 = assembleChangeRows(state, useLocalization(buildChangeRowRequests(state, function(p2)
		if p2 == "Email" then
			return v16.email
		elseif p2 == "Authenticator" then
			return v16.authenticator
		elseif p2 == "SecurityKey" then
			return v16.securityKey
		end

		return p2
	end)), v15.unavailableEmail)

	module.useEffect(function()
		v8(module7(v9, v7.state.recoverySessionId)):andThen(function(data)
			if data.isError then
				setState4(data.errorKey or module9.UnknownErrorKey)
				setState2(false)
			else
				setState(data.data.credentialsToInvalidate)
				setState2(false)
			end
		end):catch(function()
			setState4(module9.UnknownErrorKey)
			setState2(false)
		end)
	end, {})

	local function fn(p2)
		v7.dispatch({
			type = module6.SET_MODAL_STATE_AND_PROPS,
			data = { modalStateAndProps = p2 }
		})
	end

	local function fn2()
		if state3 or not (state5 and v11) then
			return
		end

		setState3(true)
		setState4("")
		v8(module8(v9, {
			recoverySessionId = v7.state.recoverySessionId,
			shouldInvalidateCredentials = true
		})):andThen(function(p2)
			setState3(false)

			if p2.isError then
				setState4(p2.errorKey or module9.UnknownErrorKey)
			else
				fn({
					modalState = module5.ACCOUNT_SECURED,
					props = { onPasswordResetSuccess = props.onPasswordResetSuccess }
				})
			end
		end)
	end

	local function fn3()
		if state3 or not state5 then
			return
		end

		v8(module8(v9, {
			recoverySessionId = v7.state.recoverySessionId,
			shouldInvalidateCredentials = false
		})):catch(function() end)
		fn({
			modalState = module5.NO_CHANGES_MADE,
			props = {
				onPasswordResetSuccess = props.onPasswordResetSuccess,
				shouldPromptPasskeyAddition = props.shouldPromptPasskeyAddition,
				shouldPrompt2svRemoval = props.shouldPrompt2svRemoval,
				shouldUpdateEmail = props.shouldUpdateEmail,
				email = props.email,
				userId = props.userId,
				username = props.username
			}
		})
	end

	local children = {}

	for k, v19 in v18 do
		local formatted = `Change_{k}`
		local createElement = module.createElement

		local v22 = if v19.iconName then module.createElement(icon, {
			LayoutOrder = 1,
			name = v19.iconName,
			size = iconSize.Medium,
			style = v6.Color.Content.Muted
		}) else nil

		local createElement2 = module.createElement

		local createElement3 = module.createElement

		local v27 = {
			HeaderText = module.createElement(text, {
				LayoutOrder = 1,
				Text = v19.header,
				tag = "shrink auto-xy text-title-medium text-wrap text-align-x-left content-emphasis"
			}),
			UnavailableEmailInfo = 0
		}

		local v28 = if v19.hasUnavailableEmail then module.createElement(UnavailableEmailInfo, {
			text = v15.unavailableEmailInfo
		}) else nil
		v27.UnavailableEmailInfo = v28
		children[formatted] = createElement(
			view,
			{
				LayoutOrder = k,
				tag = "row align-x-left align-y-top gap-small size-full-0 auto-y"
			},
			{
				ChangeIcon = v22,
				ChangeText = createElement2(
					view,
					{
						LayoutOrder = 2,
						tag = "col align-x-left shrink gap-xxsmall size-full-0 auto-y"
					},
					{
						Header = createElement3(
							view,
							{
								LayoutOrder = 1,
								tag = "row align-x-left align-y-center gap-xsmall size-full-0 auto-y"
							},
							v27
						),
						BodyText = module.createElement(text, {
							LayoutOrder = 2,
							Text = v19.body,
							tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-muted"
						})
					}
				)
			}
		)
	end

	local createElement = module.createElement
	local root = dialog.Root
	local v19 = { size = dialogSize.Small, disablePortal = false, hasBackdrop = true }

	local v20 = {
		Heading = not state2 and module.createElement(view, {
			LayoutOrder = 0,
			tag = "size-full-0 auto-y",
			padding = { top = UDim.new(0, v6.Size.Size_500) }
		}, {
			HeadingText = module.createElement(text, {
				Text = v15.heading,
				tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-left content-emphasis"
			})
		}),
		IntroText = not state2 and module.createElement(text, {
			LayoutOrder = 1,
			Text = v15.intro,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-muted"
		}),
		DialogContent = not state2 and module.createElement(dialog.Content, {
			LayoutOrder = 2
		}, {
			Body = module.createElement(
				view,
				{ tag = "col align-x-left gap-large size-full-0 auto-y" },
				children
			)
		}),
		WarningAcknowledgment = not state2 and module.createElement(view, {
			LayoutOrder = 3,
			tag = "size-full-0 auto-y",
			padding = {
				right = UDim.new(0, v6.Size.Size_600 + v6.Gap.Medium)
			}
		}, {
			WarningCheckbox = module.createElement(checkbox, {
				isChecked = state5,
				onActivated = function(p2)
					setState5(p2)
				end,
				label = v15.warning,
				size = inputSize.Small
			})
		}),
		ErrorText = 0,
		DialogActions = 0
	}

	local v21 = not state2

	if v21 then
		if state4 == "" then
			v21 = false
		else
			v21 = module.createElement(text, {
				LayoutOrder = 4,
				Text = v15.requestErrorText or "",
				tag = "size-full-0 auto-y text-caption-small text-wrap text-align-x-left content-system-alert"
			})
		end
	end

	v20.ErrorText = v21

	v20.DialogActions = not state2 and module.createElement(dialog.Actions, {
		LayoutOrder = 5,
		orientation = orientation.Vertical,
		actions = {
			{
				text = v15.deleteButton,
				variant = buttonVariant.Emphasis,
				isDisabled = not (state5 and v11),
				onActivated = function()
					fn2()
				end
			},
			{
				text = v15.dontDeleteButton,
				variant = buttonVariant.Standard,
				isDisabled = not state5,
				onActivated = function()
					fn3()
				end
			}
		}
	})
	return createElement(root, v19, v20)
end
