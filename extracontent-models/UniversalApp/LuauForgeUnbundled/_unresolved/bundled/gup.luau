local module = require("@luauforge/bundled/gtJ")

local react = module.React
local useLocalization = module.Localization.Hooks.useLocalization
local foundation = module.Foundation
local sheet = foundation.Sheet
local view = foundation.View
local text = foundation.Text
local avatar = foundation.Avatar
local inputSize = foundation.Enums.InputSize
local buttonVariant = foundation.Enums.ButtonVariant
local useTokens = foundation.Hooks.useTokens
local editAccountPicker = module.LandingPage.Components.EditAccountPicker
local module2 = require("@luauforge/bundled/guq")

local v5 = game:DefineFastFlag("AccountSelectorUseProfileFrameThumbnail", false)
	and module.SharedFlags.GetFFlagProfileFrameThumbnailEnabled()
local getFIntAccountSwitcherAccountLimit = module.SharedFlags.GetFIntAccountSwitcherAccountLimit
local getFFlagEnableAccountSwitcherUncheckedBadge = module.SharedFlags.GetFFlagEnableAccountSwitcherUncheckedBadge
local useAppPolicy = module.UniversalAppPolicy.useAppPolicy

local useModalFocus = module.AccountSwitching.useModalFocus

local module3 = require("@luauforge/bundled/guk")
local module4 = require("@luauforge/bundled/gul")
local fFlagAccountSwitcherFocusNavigation = module.SharedFlags.FFlagAccountSwitcherFocusNavigation

local fFlagEnableAccountSwitcherExternalIdentityButtons = module.SharedFlags.FFlagEnableAccountSwitcherExternalIdentityButtons

local function AccountSwitchingSelectAccount(props)
	local showFoundationDisambiguationSelector = props.showFoundationDisambiguationSelector

	local titleTextKey = showFoundationDisambiguationSelector and props.titleTextKey
		or "Authentication.AccountSwitch.Header.SwitchAccountSentenceCase"

	local v6 = showFoundationDisambiguationSelector and props.hideActions == true

	local v7 = useLocalization({
		titleText = titleTextKey,
		manageAccountsText = "Authentication.AccountPicker.Label.ManageAccounts",
		addAccountText = "Authentication.AccountSwitch.Action.AddAnAccount",
		signedOutText = "Authentication.AccountPicker.Label.SignedOut",
		maxAccountsReachedText = "Authentication.AccountSwitch.Description.AccountLimit.2",
		signedOut = "Authentication.AccountPicker.Label.SignedOut",
		uncheckedLabel = "CommonUI.Features.Label.Unchecked"
	})

	local v8 = useTokens()
	local state, setState = react.useState(true)
	local state2, setState2 = react.useState(false)
	local state3, setState3 = react.useState(false)
	local v9 = useModalFocus(not (state2 or state3))
	local state4, setState4 = react.useState(props.isMaxAccountsReached)
	local ref = react.useRef(false)
	local ref2 = react.useRef(v6)
	local ref3 = react.useRef(props.onAccountSelectionAbandoned)
	ref2.current = v6
	ref3.current = props.onAccountSelectionAbandoned

	local enableSignedOutAccounts = props.enableSignedOutAccounts
	local v10

	if getFFlagEnableAccountSwitcherUncheckedBadge() then
		v10 = useAppPolicy(function(p2)
			return p2.getShowUncheckedBadgeForAccountSwitcher()
		end)
	else
		v10 = false
	end

	react.useEffect(function()
		local ids = {}

		for k, user in props.users do
			table.insert(ids, (tostring(user.id)))
		end

		if props.context and props.origin then
			module3.sendPageLoadEvent(props.context, props.origin, table.concat(ids, ","))
		end
	end, {})

	react.useEffect(function()
		return function()
			local current = ref2.current and not ref.current and ref3.current

			if current then
				current()
			end
		end
	end, {})

	local function onActivated()
		if props.context and props.origin then
			module3.sendButtonClickEvent(props.context, props.origin, module4.btn.addAccount)
		end

		setState(false)
		setState2(true)
	end

	local function onActivated2()
		if props.context and props.origin then
			module3.sendButtonClickEvent(props.context, props.origin, module4.btn.manageAccounts)
		end

		setState(false)
		setState3(true)
	end

	local state5, setState5 = react.useState(props.users)

	local function onAccountsUpdated(list)
		local v11 = {}

		for i, item in ipairs(list) do
			table.insert(v11, {
				id = item.user_id,
				name = item.username,
				displayName = item.display_name,
				hasValidSession = item.has_valid_session,
				isUnselectable = item.is_current_user
			})
		end

		setState5(v11)
		local count = #v11
		local count2 = 0

		for i, v12 in ipairs(v11) do
			if v12.hasValidSession then
				count2 += 1
			end
		end

		if state4 and count2 < getFIntAccountSwitcherAccountLimit() then
			setState4(false)
		end
	end

	local v11 = getFFlagEnableAccountSwitcherUncheckedBadge()
		and "row align-y-center align-x-right gap-xsmall size-full-0 auto-xy"
		or "col items-end size-full-0 auto-xy"
	local children = {}

	local function onClose()
		ref.current = true
		setState(false)

		if props.onAccountSelectionAbandoned then
			props.onAccountSelectionAbandoned()
		end

		if props.onClose then
			props.onClose()
		end
	end

	local function onClose2(p2)
		setState2(false)

		if p2 then
			setState(true)
		elseif props.onClose then
			props.onClose()
		end
	end

	local function fn()
		local result = {}

		for i, v12 in ipairs(state5 or {}) do
			table.insert(result, {
				user_id = tostring(v12.id),
				username = v12.name,
				display_name = v12.displayName,
				has_valid_session = v12.hasValidSession,
				is_current_user = v12.isUnselectable
			})
		end

		return result
	end

	local function onClose3()
		setState3(false)
		setState(true)
	end

	for k, v12 in state5 do
		local name = v12.name or ""
		local v13 = v10 and v12.isUnselectable == true
		local v14 = assert(tonumber(v12.id), "Expected account user id to be numeric")
		local children2 = {
			Avatar = react.createElement(avatar, {
				LayoutOrder = 0,
				userId = v14,
				size = inputSize.Large,
				includeProfileFrame = v5,
				backgroundStyle = {
					Color3 = v8.Color.Shift.Shift_300.Color3,
					Transparency = v8.Color.Shift.Shift_300.Transparency
				},
				tag = "auto-y"
			}),
			AccountInfo = react.createElement(
				view,
				{ tag = "col items-start fill auto-y", LayoutOrder = 1 },
				{
					DisplayName = react.createElement(text, {
						Text = v12.displayName or name,
						tag = "size-full-0 auto-y text-title-large text-align-x-left",
						LayoutOrder = 0,
						TextTruncate = Enum.TextTruncate.SplitWord
					}),
					Username = react.createElement(text, {
						Text = "@" .. name,
						tag = "size-full-0 auto-y text-body-small text-align-x-left",
						LayoutOrder = 1,
						TextTruncate = Enum.TextTruncate.SplitWord
					})
				}
			),
			RightStatus = 0
		}

		local createElement = react.createElement

		local v18 = if v13 then react.createElement(foundation.Badge, {
			text = v7.uncheckedLabel,
			variant = foundation.Enums.BadgeVariant.Neutral,
			LayoutOrder = 1,
			testId = "AccountSwitcherActiveUserUncheckedBadge"
		}) else nil
		local v19

		if v12.iconKey or v12.isUnselectable then
			v19 = react.createElement(foundation.Icon, {
				name = foundation.Enums.IconName.CircleCheck,
				size = foundation.Enums.IconSize.Large,
				variant = foundation.Enums.IconVariant.Filled,
				LayoutOrder = getFFlagEnableAccountSwitcherUncheckedBadge() and 2 or nil
			})
		elseif not (v6 or v12.hasValidSession) then
			v19 = react.createElement(
				foundation.View,
				{
					tag = "col auto-xy padding-x-small padding-y-xsmall radius-small bg-action-alert",
					LayoutOrder = 2
				},
				{
					PillText = react.createElement(foundation.Text, {
						Text = v7.signedOut,
						tag = "auto-xy text-caption-large text-align-x-center text-title-medium"
					})
				}
			)
		end

		children2.RightStatus = createElement(view, { LayoutOrder = 2, tag = v11 }, {
			UncheckedBadge = v18,
			Status = v19
		})
		children[`Row_{k}`] = react.createElement(view, {
			tag = "row wrap align-y-center gap-small size-full-0 auto-y padding-x-large padding-y-medium",
			LayoutOrder = k,
			onActivated = function()
				if not v12.isUnselectable then
					if props.context and props.origin then
						module3.sendSelectEvent(props.context, props.origin, (tostring(v12.id)))
					end

					ref.current = true
					props.onAccountSelection(v12.id)
				end
			end
		}, children2)
	end

	local v12 = v8.Padding.Small + v8.Padding.Medium
	children._NegPadding = react.createElement("UIPadding", {
		PaddingLeft = UDim.new(0, -v12),
		PaddingRight = UDim.new(0, -v12)
	})

	local createElement = react.createElement
	local fragment = react.Fragment

	if state then
		local createElement2 = react.createElement
		local root = sheet.Root

		if not fFlagAccountSwitcherFocusNavigation then
			v9 = nil
		end

		local v16 = {
			Header = react.createElement(sheet.Header, { hasCloseAffordance = true }, {
				Title = react.createElement(text, {
					Text = v7.titleText,
					tag = "auto-xy text-heading-small content-emphasis"
				})
			}),
			Content = react.createElement(sheet.Content, nil, {
				Accounts = react.createElement(view, { tag = "col size-full-0 auto-y" }, children)
			}),
			Actions = 0
		}

		local v17 = if not v6 then react.createElement(sheet.Actions, nil, {
			ActionList = react.createElement(view, {
				tag = "col auto-y gap-small size-full-0"
			}, {
				LimitReached = state4 and react.createElement(
					view,
					{
						tag = "col size-full-0 padding-bottom-small auto-y",
						LayoutOrder = 0
					},
					{
						AccountLimitReachedText = react.createElement(foundation.Text, {
							Text = v7.maxAccountsReachedText,
							RichText = true,
							tag = "size-full-0 text-wrap auto-y text-caption-medium content-default text-align-x-left"
						})
					}
				),
				AddAccountButton = react.createElement(foundation.Button, {
					text = v7.addAccountText,
					variant = buttonVariant.Standard,
					onActivated = onActivated,
					onClose = props.onClose,
					isDisabled = state4,
					width = UDim.new(1, 0),
					LayoutOrder = 1
				}),
				ManageAccountsButton = enableSignedOutAccounts and react.createElement(foundation.Button, {
					text = v7.manageAccountsText,
					variant = buttonVariant.Standard,
					onActivated = onActivated2,
					tag = "col size-full-0",
					width = UDim.new(1, 0),
					LayoutOrder = 2
				}) or nil
			})
		}) else nil
		v16.Actions = v17
		state = createElement2(
			root,
			{
				onClose = onClose,
				preferCenterSheet = true,
				tag = "col auto-y size-full",
				ref = v9
			},
			v16
		)
	end

	local v15

	if state2 then
		local createElement2 = react.createElement
		local v17 = {
			onClose = onClose2,
			origin = props.origin,
			getExternalIdentityCapabilities = 0,
			authenticateWithExternalIdentity = 0,
			onExternalIdentityFailed = 0,
			openDesktopLoginDialog = 0,
			openDesktopSignupDialog = 0
		}

		local v18 = if fFlagEnableAccountSwitcherExternalIdentityButtons then props.getExternalIdentityCapabilities else nil
		v17.getExternalIdentityCapabilities = v18

		local v19 = if fFlagEnableAccountSwitcherExternalIdentityButtons then props.authenticateWithExternalIdentity else nil
		v17.authenticateWithExternalIdentity = v19

		local v20 = if fFlagEnableAccountSwitcherExternalIdentityButtons then props.onExternalIdentityFailed else nil
		v17.onExternalIdentityFailed = v20

		v17.openDesktopLoginDialog = props.openDesktopLoginDialog
		v17.openDesktopSignupDialog = props.openDesktopSignupDialog
		v15 = createElement2(module2, v17) or nil
	end

	return createElement(fragment, nil, {
		SelectAccountSheet = state,
		AddAccountModal = v15,
		ManageAccountsModal = state3 and react.createElement(editAccountPicker, {
			accounts = fn(),
			onClose = onClose3,
			onAccountsUpdated = onAccountsUpdated,
			logout = props.logout,
			enableSignedOutAccounts = props.enableSignedOutAccounts
		}) or nil
	})
end

return react.memo(AccountSwitchingSelectAccount)
