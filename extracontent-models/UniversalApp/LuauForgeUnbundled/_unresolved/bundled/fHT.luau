local module = require("@luauforge/bundled/fHU")
local module2 = require("@luauforge/bundled/fHV")
local fullscreenPageWithSafeArea = require("@luauforge/bundled/fHW").FullscreenPageWithSafeArea
local useStyle = require("@luauforge/bundled/fHO").Core.Style.useStyle
local enums = module2.Enums
local module3 = require("@luauforge/bundled/fHX")
local useLocalization = require("@luauforge/bundled/fHZ").Hooks.useLocalization
local useRoactService = require("@luauforge/bundled/fIb").useRoactService
local roactNetworking = require("@luauforge/bundled/fIc").RoactNetworking
local module4 = require("@luauforge/bundled/fId")
local module5 = require("@luauforge/bundled/fIf")
local updateLoginEntryData = module5.Utils.updateLoginEntryData
local user = module5.Thunks.User
local deleteAccount = require("@luauforge/bundled/fIe").DeleteAccount
local useModalFocus = require("@luauforge/bundled/fIe").useModalFocus
local fFlagAccountSwitcherFocusNavigation = require("@luauforge/bundled/fHR").FFlagAccountSwitcherFocusNavigation
local fFlagLandingAndAccountPickerSsoTelemetry = require("@luauforge/bundled/fIg").FFlagLandingAndAccountPickerSsoTelemetry
local module6 = require("@luauforge/bundled/fIl")
require("@luauforge/bundled/fIa")
local getFFlagEnableAccountCarouselEvents = require("@luauforge/bundled/fHR").GetFFlagEnableAccountCarouselEvents
local module7 = require("@luauforge/bundled/fIm")
local eventStreamConstants = module7.EventStreamConstants
local authButtonClick = module7.Events.authButtonClick
local authPageload = module7.Events.authPageload
local sheet = module2.Sheet
local dialogSize = module2.Enums.DialogSize
local useAppPolicy = require("@luauforge/bundled/fIn").useAppPolicy
local authLocalStorageKeys = module5.Enums.AuthLocalStorageKeys
local AppStorageService = game:GetService("AppStorageService")

return function(props)
	local state, setState = module.useState(props.accounts)

	local state2, setState2 = module.useState(nil)
	local v5 = useRoactService(roactNetworking)

	local v6 = useLocalization({
		EditAccounts = "Authentication.AccountPicker.Label.ManageAccounts"
	})

	local v7 = useModalFocus(state2 == nil)

	local v8 = user.fromLocalStorage()

	local v9 = useAppPolicy(function(p2)
		return p2.getAccountPickerEnabled()
	end)

	local enableSignedOutAccounts = props.enableSignedOutAccounts

	local function fn(): boolean
		if not (enableSignedOutAccounts and state2 ~= nil) then
			return false
		end

		local v10 = not (state2 == nil) and tostring(v8.userId) == state2.user_id

		if not v10 then
			return false
		end

		for i, v11 in ipairs(state) do
			if v11.user_id ~= state2.user_id and v11.has_valid_session then
				return false
			end
		end

		return true
	end

	local function fn2()
		if state2 == nil then
			return
		end

		if getFFlagEnableAccountCarouselEvents() then
			authButtonClick(
				eventStreamConstants.Context.AccountPickerManageAccountsScreen,
				eventStreamConstants.Button.AccountPickerDeleteAccount,
				state2.user_id,
				nil
			)
		end

		if state2.has_valid_session then
			local v10 = not (state2 == nil) and tostring(v8.userId) == state2.user_id

			if v10 then
				if props.logout then
					props.logout()
				end

				AppStorageService:SetItem(authLocalStorageKeys.CredentialValue, "")
				AppStorageService:Flush()

				local v11 = not v9 and fn()

				if enableSignedOutAccounts then
					for i, v12 in ipairs(state) do
						if v11 or v12.user_id == state2.user_id then
							updateLoginEntryData(v12.user_id, {
								showInAccountPicker = false
							})
						end
					end
				end
			else
				deleteAccount(v5, {
					username = state2.username,
					user_id = state2.user_id,
					display_name = state2.display_name
				}):andThen(function(p2)
					local filtered = module6.List.filter(state, function(p3): boolean
						return p3.user_id ~= state2.user_id
					end)

					setState(filtered)

					if props.onAccountsUpdated then
						props.onAccountsUpdated(filtered)
					end

					setState2(nil)

					updateLoginEntryData(state2.user_id, { showInAccountPicker = false })
				end):catch(function(p2)
					warn(p2)
				end)
			end
		else
			updateLoginEntryData(state2.user_id, { showInAccountPicker = false })

			local filtered = module6.List.filter(state, function(p2): boolean
				return p2.user_id ~= state2.user_id
			end)

			setState(filtered)

			if props.onAccountsUpdated then
				props.onAccountsUpdated(filtered)
			end

			setState2(nil)
		end
	end

	local v10 = enableSignedOutAccounts and "sheetRedesign" or "fullscreen"
	local accountPickerManageAccountsScreen = eventStreamConstants.Context.AccountPickerManageAccountsScreen

	local function fn3()
		if fFlagLandingAndAccountPickerSsoTelemetry then
			authButtonClick(
				eventStreamConstants.Context.AccountPickerManageAccountsScreen,
				eventStreamConstants.Button.AccountPickerManageAccountsClosed,
				v10,
				nil,
				nil,
				accountPickerManageAccountsScreen
			)
		end

		props.onClose()
	end

	local function fn4()
		if getFFlagEnableAccountCarouselEvents() then
			authButtonClick(
				eventStreamConstants.Context.AccountPickerManageAccountsScreen,
				eventStreamConstants.Button.AccountPickerManageAccountsClosed,
				nil,
				nil
			)
		end

		setState2(nil)
	end

	module.useEffect(function()
		if fFlagLandingAndAccountPickerSsoTelemetry then
			authPageload(
				eventStreamConstants.Context.AccountPickerManageAccountsScreen,
				v10,
				nil,
				accountPickerManageAccountsScreen
			)
		elseif getFFlagEnableAccountCarouselEvents() then
			authPageload(eventStreamConstants.Context.AccountPickerManageAccountsScreen)
		end
	end, {})

	local v11 = useStyle()

	if enableSignedOutAccounts then
		local createElement = module.createElement
		local fragment = module.Fragment
		local createElement2 = module.createElement
		local root = sheet.Root
		local v14 = {
			preferCenterSheet = true,
			size = dialogSize.Medium,
			onClose = fn3,
			snapPoints = { 1 },
			ref = 0
		}

		if not fFlagAccountSwitcherFocusNavigation then
			v7 = nil
		end

		v14.ref = v7
		local v13 = {
			Sheet = createElement2(root, v14, {
				Header = module.createElement(
					sheet.Header,
					{
						tag = "row items-center size-full-0 auto-y padding-x-small padding-bottom-large padding-top-medium",
						hasCloseAffordance = true
					},
					{
						Title = module.createElement(module2.Text, {
							LayoutOrder = 1,
							Text = v6.EditAccounts,
							tag = "fill auto-xy padding-x-small text-heading-small text-align-x-left content-emphasis"
						})
					}
				),
				Content = module.createElement(sheet.Content, nil, {
					EditAccountPickerList = module.createElement(module3, {
						onClose = props.onClose,
						accounts = state,
						setRemoveAccount = setState2,
						enableSignedOutAccounts = props.enableSignedOutAccounts
					})
				})
			}),
			RemoveAccountDialog = 0
		}
		local v15

		if state2 then
			v15 = module.createElement(module4, {
				hideAllAccounts = not v9 and fn(),
				isCurrentUser = state2 ~= nil and tostring(v8.userId) == state2.user_id,
				onRemove = fn2,
				onClose = fn4
			}) or nil
		end

		v13.RemoveAccountDialog = v15
		return createElement(fragment, nil, v13)
	else
		local createElement = module.createElement
		local v13 = {
			includeStatusBar = true,
			BackgroundColor3 = v11.Theme.BackgroundDefault.Color
		}
		local v15

		if state2 then
			v15 = module.createElement(module4, {
				hideAllAccounts = false,
				isCurrentUser = state2 ~= nil and tostring(v8.userId) == state2.user_id,
				onRemove = fn2,
				onClose = fn4
			}) or nil
		end

		return createElement(fullscreenPageWithSafeArea, v13, {
			RemoveAccountDialog = v15,
			OuterContainer = module.createElement(
				module2.View,
				{ tag = "col size-full-0 auto-xy", Size = UDim2.new(1, 0, 1, 0) },
				{
					TopBar = module.createElement(
						module2.View,
						{
							tag = "row items-center size-full-0 auto-y padding-x-small padding-bottom-large padding-top-medium"
						},
						{
							CloseButtonContainer = module.createElement(
								module2.View,
								{
									LayoutOrder = 0,
									tag = "col size-0 auto-xy padding-x-small",
									onActivated = fn3
								},
								{
									CloseButton = module.createElement(module2.Icon, {
										name = enums.IconName.X,
										size = enums.IconSize.Large,
										tag = "auto-xy"
									})
								}
							),
							Title = module.createElement(module2.Text, {
								LayoutOrder = 1,
								Text = v6.EditAccounts,
								tag = "fill auto-xy padding-right-small text-heading-small content-emphasis"
							}),
							SpaceContainer = module.createElement(
								module2.View,
								{
									LayoutOrder = 2,
									tag = "col size-0 auto-xy padding-x-small"
								},
								{
									Space = module.createElement(module2.Icon, {
										name = enums.IconName.X,
										size = enums.IconSize.Large,
										tag = "col size-0 auto-xy",
										Visible = false
									})
								}
							)
						}
					),
					EditAccountPickerList = module.createElement(module3, {
						onClose = props.onClose,
						accounts = state,
						setRemoveAccount = setState2,
						enableSignedOutAccounts = props.enableSignedOutAccounts
					})
				}
			)
		})
	end
end
