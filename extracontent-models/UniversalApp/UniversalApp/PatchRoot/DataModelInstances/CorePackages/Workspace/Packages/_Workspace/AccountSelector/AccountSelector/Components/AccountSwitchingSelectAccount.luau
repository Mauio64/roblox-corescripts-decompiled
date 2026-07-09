local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local React = dependencies.React
local useLocalization = dependencies.Localization.Hooks.useLocalization
local Foundation = dependencies.Foundation
local Sheet = Foundation.Sheet
local View = Foundation.View
local FoundationText = Foundation.Text
local Avatar = Foundation.Avatar
local InputSize = Foundation.Enums.InputSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local useTokens = Foundation.Hooks.useTokens
local EditAccountPicker = dependencies.LandingPage.Components.EditAccountPicker
local AccountSwitchingAddAccount = require(script.Parent.AccountSwitchingAddAccount)
local GetFFlagEnableAccountSwitcherManageAccounts = dependencies.SharedFlags.GetFFlagEnableAccountSwitcherManageAccounts
local GetFFlagEnableAccountSwitcherSignedOutAccounts = dependencies.SharedFlags.GetFFlagEnableAccountSwitcherSignedOutAccounts
local GetFIntAccountSwitcherAccountLimit = dependencies.SharedFlags.GetFIntAccountSwitcherAccountLimit
local GetFFlagEnableAccountSwitcherAddWithMaxSignedOut = dependencies.SharedFlags.GetFFlagEnableAccountSwitcherAddWithMaxSignedOut
local GetFFlagEnableLoginDisambiguationFoundationSwitcher = dependencies.SharedFlags.GetFFlagEnableLoginDisambiguationFoundationSwitcher
local GetFFlagEnableAccountSwitcherUncheckedBadge = dependencies.SharedFlags.GetFFlagEnableAccountSwitcherUncheckedBadge
local useAppPolicy = dependencies.UniversalAppPolicy.useAppPolicy
local AnalyticsEvents = require(ParentParent.Analytics.AnalyticsEvents)
local EventConstants = require(ParentParent.Analytics.EventConstants)
local v24 = game:DefineFastFlag("FixManageAccountsUserIdBug", false)

local function AccountSwitchingSelectAccount(t1: {[any]: any}) -- line: 59
	-- upvalues: GetFFlagEnableLoginDisambiguationFoundationSwitcher (copy), useLocalization (copy), useTokens (copy), React (copy), GetFFlagEnableAccountSwitcherSignedOutAccounts (copy), GetFFlagEnableAccountSwitcherUncheckedBadge (copy), useAppPolicy (copy), AnalyticsEvents (copy), EventConstants (copy), v24 (copy), GetFFlagEnableAccountSwitcherAddWithMaxSignedOut (copy), GetFIntAccountSwitcherAccountLimit (copy), Avatar (copy), InputSize (copy), View (copy), FoundationText (copy), Foundation (copy), Sheet (copy), ButtonVariant (copy), GetFFlagEnableAccountSwitcherManageAccounts (copy), AccountSwitchingAddAccount (copy), EditAccountPicker (copy)
	local v27 = GetFFlagEnableLoginDisambiguationFoundationSwitcher() and t1.showFoundationDisambiguationSelector
	local v28 = not v27 and "Authentication.AccountSwitch.Header.SwitchAccountSentenceCase" or (t1.titleTextKey or "Authentication.AccountSwitch.Header.SwitchAccountSentenceCase")
	local v29 = v27 and t1.hideActions == true
	local v30 = useLocalization({
		manageAccountsText = "Authentication.AccountPicker.Label.ManageAccounts",
		addAccountText = "Authentication.AccountSwitch.Action.AddAnAccount",
		signedOutText = "Authentication.AccountPicker.Label.SignedOut",
		maxAccountsReachedText = "Authentication.AccountSwitch.Description.AccountLimit.2",
		signedOut = "Authentication.AccountPicker.Label.SignedOut",
		uncheckedLabel = "CommonUI.Features.Label.Unchecked",
		titleText = v28
	})
	local v31 = useTokens()
	local v32, v33 = React.useState(true)
	local v34, v35 = React.useState(false)
	local v36, v37 = React.useState(false)
	local v38, v39 = React.useState(t1.isMaxAccountsReached)
	local v40 = React.useRef(false)
	local v41 = React.useRef(v29)
	local v42 = React.useRef(t1.onAccountSelectionAbandoned)

	v41.current = v29
	v42.current = t1.onAccountSelectionAbandoned

	local v43 = GetFFlagEnableAccountSwitcherSignedOutAccounts() and t1.enableSignedOutAccounts
	local v44 = not not GetFFlagEnableAccountSwitcherUncheckedBadge() and useAppPolicy(function(p1) -- line: 96
		return p1.getShowUncheckedBadgeForAccountSwitcher()
	end)

	React.useEffect(function() -- line: 101
		-- upvalues: t1 (copy), AnalyticsEvents (copy)
		local t2 = {}

		for _, v59 in t1.users do
			table.insert(t2, (tostring(v59.id)))
		end

		if t1.context and t1.origin then
			AnalyticsEvents.sendPageLoadEvent(t1.context, t1.origin, table.concat(t2, ","))
		end
	end, {})
	React.useEffect(function() -- line: 111
		-- upvalues: v41 (copy), v40 (copy), v42 (copy)
		return function() -- line: 112
			-- upvalues: v41 (copy), v40 (copy), v42 (copy)
			if v41.current and not v40.current then
				local current = v42.current

				if current then
					current()
				end
			end
		end
	end, {})

	local v45, v46 = React.useState(t1.users)
	local t3 = {}
	local v48 = not GetFFlagEnableAccountSwitcherUncheckedBadge() and "col items-end size-full-0 auto-xy" or "row align-y-center align-x-right gap-xsmall size-full-0 auto-xy"

	for v49, v50 in v45 do
		local v51 = v50.name or ""
		local v52 = v44 and v50.isUnselectable == true
		local v53 = assert(tonumber(v50.id), "Expected account user id to be numeric")
		local t4 = {
			Avatar = React.createElement(Avatar, {
				LayoutOrder = 0,
				tag = "auto-y",
				userId = v53,
				size = InputSize.Large,
				backgroundStyle = {
					Color3 = v31.Color.Shift.Shift_300.Color3,
					Transparency = v31.Color.Shift.Shift_300.Transparency
				}
			}),
			AccountInfo = React.createElement(View, {
				tag = "col items-start fill auto-y",
				LayoutOrder = 1
			}, {
				DisplayName = React.createElement(FoundationText, {
					tag = "size-full-0 auto-y text-title-large text-align-x-left",
					LayoutOrder = 0,
					Text = v50.displayName or v51,
					TextTruncate = Enum.TextTruncate.SplitWord
				}),
				Username = React.createElement(FoundationText, {
					tag = "size-full-0 auto-y text-body-small text-align-x-left",
					LayoutOrder = 1,
					Text = "@" .. v51,
					TextTruncate = Enum.TextTruncate.SplitWord
				})
			}),
			RightStatus = React.createElement(View, {
				LayoutOrder = 2,
				tag = v48
			}, {
				UncheckedBadge = if not v52 then nil else React.createElement(Foundation.Badge, {
					LayoutOrder = 1,
					testId = "AccountSwitcherActiveUserUncheckedBadge",
					text = v30.uncheckedLabel,
					variant = Foundation.Enums.BadgeVariant.Neutral
				}),
				Status = if not v50.iconKey and not v50.isUnselectable then if v29 or v50.hasValidSession then nil else React.createElement(Foundation.View, {
					tag = "col auto-xy padding-x-small padding-y-xsmall radius-small bg-action-alert",
					LayoutOrder = 2
				}, {
					PillText = React.createElement(Foundation.Text, {
						tag = "auto-xy text-caption-large text-align-x-center text-title-medium",
						Text = v30.signedOut
					})
				}) else React.createElement(Foundation.Icon, {
					name = Foundation.Enums.IconName.CircleCheck,
					size = Foundation.Enums.IconSize.Large,
					variant = Foundation.Enums.IconVariant.Filled,
					LayoutOrder = if not GetFFlagEnableAccountSwitcherUncheckedBadge() then nil else 2
				})
			})
		}

		t3[`Row_{ v49 }`] = React.createElement(View, {
			tag = "row wrap align-y-center gap-small size-full-0 auto-y padding-x-large padding-y-medium",
			LayoutOrder = v49,
			onActivated = function() -- line: 211
				-- upvalues: v50 (copy), t1 (copy), AnalyticsEvents (copy), v40 (copy)
				if not v50.isUnselectable then
					if t1.context and t1.origin then
						AnalyticsEvents.sendSelectEvent(t1.context, t1.origin, (tostring(v50.id)))
					end

					v40.current = true
					t1.onAccountSelection(v50.id)
				end
			end
		}, t4)
	end

	local v55 = v31.Padding.Small + v31.Padding.Medium

	t3._NegPadding = React.createElement("UIPadding", {
		PaddingLeft = UDim.new(0, -v55),
		PaddingRight = UDim.new(0, -v55)
	})

	return React.createElement(React.Fragment, nil, {
		SelectAccountSheet = v32 and React.createElement(Sheet.Root, {
			preferCenterSheet = true,
			tag = "col auto-y size-full",
			onClose = function() -- line: 122
				-- upvalues: v40 (copy), v33 (copy), t1 (copy)
				v40.current = true
				v33(false)

				if t1.onAccountSelectionAbandoned then
					t1.onAccountSelectionAbandoned()
				end

				if t1.onClose then
					t1.onClose()
				end
			end
		}, {
			Header = React.createElement(Sheet.Header, {
				hasCloseAffordance = true
			}, {
				Title = React.createElement(FoundationText, {
					tag = "auto-xy text-heading-small content-emphasis",
					Text = v30.titleText
				})
			}),
			Content = React.createElement(Sheet.Content, nil, {
				Accounts = React.createElement(View, {
					tag = "col size-full-0 auto-y"
				}, t3)
			}),
			Actions = if not v29 then React.createElement(Sheet.Actions, nil, {
				ActionList = React.createElement(View, {
					tag = "col auto-y gap-small size-full-0"
				}, {
					LimitReached = v38 and React.createElement(View, {
						tag = "col size-full-0 padding-bottom-small auto-y",
						LayoutOrder = 0
					}, {
						AccountLimitReachedText = React.createElement(Foundation.Text, {
							RichText = true,
							tag = "size-full-0 text-wrap auto-y text-caption-medium content-default text-align-x-left",
							Text = v30.maxAccountsReachedText
						})
					}),
					AddAccountButton = React.createElement(Foundation.Button, {
						LayoutOrder = 1,
						text = v30.addAccountText,
						variant = ButtonVariant.Standard,
						onActivated = function() -- line: 133
							-- upvalues: t1 (copy), AnalyticsEvents (copy), EventConstants (copy), v33 (copy), v35 (copy)
							if t1.context and t1.origin then
								AnalyticsEvents.sendButtonClickEvent(t1.context, t1.origin, EventConstants.btn.addAccount)
							end

							v33(false)
							v35(true)
						end,
						onClose = t1.onClose,
						isDisabled = v38,
						width = UDim.new(1, 0)
					}),
					ManageAccountsButton = GetFFlagEnableAccountSwitcherManageAccounts() and (not not v43 and React.createElement(Foundation.Button, {
						tag = "col size-full-0",
						LayoutOrder = 2,
						text = v30.manageAccountsText,
						variant = ButtonVariant.Standard,
						onActivated = function() -- line: 151
							-- upvalues: t1 (copy), AnalyticsEvents (copy), EventConstants (copy), v33 (copy), v37 (copy)
							if t1.context and t1.origin then
								AnalyticsEvents.sendButtonClickEvent(t1.context, t1.origin, EventConstants.btn.manageAccounts)
							end

							v33(false)
							v37(true)
						end,
						width = UDim.new(1, 0)
					})) or nil
				})
			}) else nil
		}),
		AddAccountModal = v34 and React.createElement(AccountSwitchingAddAccount, {
			onClose = function(b1: boolean?) -- line: 141
				-- upvalues: v35 (copy), v33 (copy), t1 (copy)
				local v61 = b1 or false

				v35(false)

				if v61 then
					v33(true)

					return
				end

				if t1.onClose then
					t1.onClose()
				end
			end,
			origin = t1.origin
		}) or nil,
		ManageAccountsModal = v36 and React.createElement(EditAccountPicker, {
			accounts = (function() -- line: 167
				-- upvalues: v45 (copy)
				local t5 = {}

				for _, v in ipairs(v45 or {}) do
					table.insert(t5, {
						user_id = tostring(v.id),
						username = v.name,
						display_name = v.displayName,
						has_valid_session = v.hasValidSession,
						is_current_user = v.isUnselectable
					})
				end

				return t5
			end)(),
			onClose = function() -- line: 159
				-- upvalues: v37 (copy), v33 (copy)
				v37(false)
				v33(true)
			end,
			onAccountsUpdated = function(p2) -- line: 181
				-- upvalues: v24 (copy), v46 (copy), GetFFlagEnableAccountSwitcherAddWithMaxSignedOut (copy), v38 (copy), GetFIntAccountSwitcherAccountLimit (copy), v39 (copy)
				local t6 = {}

				for _, v in ipairs(p2) do
					table.insert(t6, {
						id = if not v24 then tonumber(v.user_id) else v.user_id,
						name = v.username,
						displayName = v.display_name,
						hasValidSession = v.has_valid_session,
						isUnselectable = v.is_current_user
					})
				end

				v46(t6)

				local v69 = #t6

				if GetFFlagEnableAccountSwitcherAddWithMaxSignedOut() then
					v69 = 0

					for _, v in ipairs(t6) do
						if v.hasValidSession then
							v69 += 1
						end
					end
				end

				if v38 and v69 < GetFIntAccountSwitcherAccountLimit() then
					v39(false)
				end
			end,
			logout = t1.logout,
			enableSignedOutAccounts = t1.enableSignedOutAccounts
		}) or nil
	})
end

return React.memo(AccountSwitchingSelectAccount)
