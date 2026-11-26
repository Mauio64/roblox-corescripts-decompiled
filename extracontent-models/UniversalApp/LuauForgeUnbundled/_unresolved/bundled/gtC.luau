local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/dFu")
local module2 = require("@luauforge/bundled/ggj")
local module3 = require("@luauforge/bundled/gtD")
local Models = require("@game/CorePackages/Packages/_Index/RoduxUsers/RoduxUsers/Models")
local module5 = require("@luauforge/bundled/ghR")
local module6 = require("@luauforge/bundled/gtF")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagUseSignalsForAuthenticationStatus = SharedFlags.FFlagUseSignalsForAuthenticationStatus

local getFIntAccountSwitcherAccountLimit = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFIntAccountSwitcherAccountLimit
local getAuthenticationStatusStore

if fFlagUseSignalsForAuthenticationStatus then
	getAuthenticationStatusStore = require("@luauforge/bundled/ggh").GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

local getAccountsListWithSignedOutAccounts = require("@luauforge/bundled/ghc").GetAccountsListWithSignedOutAccounts
local module8 = require("@luauforge/bundled/ehB")
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dFz").NavigationCommands else nil

local module9 = require("@luauforge/bundled/fzS")
local module10 = require("@luauforge/bundled/dzD")
local React = require(CorePackages.Packages.React)
local addAccountRow = require("@luauforge/bundled/gtG").AddAccountRow
local maxAccountsReachedText = require("@luauforge/bundled/gtG").MaxAccountsReachedText
local module11 = require("@luauforge/bundled/fCM")
local flyoutSidePanelIXP = require("@luauforge/bundled/dKM").FlyoutSidePanelIXP

local module12 = require("@luauforge/bundled/gut")

local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation

local module13 = require("@luauforge/bundled/guu")
local module14 = require("@luauforge/bundled/gfG")
local module15 = require("@luauforge/bundled/ggi")
local GuiService = game:GetService("GuiService")
local module16 = require("@luauforge/bundled/ggp")
local fFlagEnableAccountSwitcherExternalIdentityButtons = SharedFlags.FFlagEnableAccountSwitcherExternalIdentityButtons
local fFlagLuaEnableDidSwitchAccount = SharedFlags.FFlagLuaEnableDidSwitchAccount
local fFlagAccountSwitchRelaunchFallback = SharedFlags.FFlagAccountSwitchRelaunchFallback

local fFlagLuaEnableLoginAndSignupDifferentiatedStatusValues = SharedFlags.FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues

local function fn(p2, p3, object)
	if flyoutSidePanelIXP.isFlyoutSidePanelEnabled() then
		if p3 ~= module9.Origin.MoreMenu and p3 ~= module9.Origin.FlyoutSidePanel then
			return nil
		end
	elseif p3 ~= "moreMenu" then
		return nil
	end

	if p2 then
		return React.createElement(maxAccountsReachedText)
	end

	local v5 = useNavigation()
	return React.createElement(addAccountRow, {
		origin = p3,
		context = module9.Context.AccountSwitcher,
		onRowClicked = function()
			v5.replace(module.AccountSwitchingAddAccountPeekView, {
				extraProps = { origin = p3 }
			})
		end
	})
end

return function(p2, networking, p3, p4, p5, p6, p7, p8, p9, p10)
	return function(object)
		if not module5 then
			return nil
		end

		local v6 = (if fFlagUseSignalsForAuthenticationStatus then getAuthenticationStatusStore(false).getStatus(false) else object:getState().AuthenticationStatus.status) == module2.LOGGED_IN
		local function onClose()
			object:dispatch(module11())
		end

		local v7 = p7
		local v8

		if v7 then
			v8 = getAccountsListWithSignedOutAccounts(networking, {
				isAuthenticated = v6,
				filterUnauthenticatedSessionsForAccountPicker = true,
				useAccountSwitcherSignedOutAccountsLimit = true
			}):andThen(function(p11)
				return {
					active_user_id = tostring(Models.fromLocalStorage().userId),
					logged_in_users_metadata = p11
				}
			end)
		else
			v8 = module3(networking, v6)
		end

		return v8:andThen(function(p11)
			local logged_in_users_metadata = p11.logged_in_users_metadata

			if #logged_in_users_metadata == 0 then
				if v6 == true then
					object:dispatch(module12(
						"Authentication.AccountSwitch.Header.CantSwitchAccountsSentenceCase",
						"Authentication.AccountSwitch.Description.PleaseTryAgainLater",
						"CommonUI.Messages.Action.OK",
						"",
						onClose,
						nil,
						module10.Auth.AccountSwitcherUnavailableError
					))
				end

				return 0
			else
				local v9 = 0

				if v7 then
					for i, v10 in ipairs(logged_in_users_metadata) do
						if v10.has_valid_session then
							v9 += 1
						end
					end
				else
					v9 = #logged_in_users_metadata
				end

				local active_user_id = p11.active_user_id
				local userId = tostring(Models.fromLocalStorage().userId)

				if
					p4 ~= nil
					and active_user_id ~= nil
					and active_user_id ~= ""
					and active_user_id ~= userId
				then
					local v10 = active_user_id .. "," .. userId

					p4.reportAuthClientError(module9.Context.AccountSwitcherMismatch, v10)
				end

				local v10 = getFIntAccountSwitcherAccountLimit() <= v9
				local iconEntries = {}

				for k, v11 in logged_in_users_metadata do
					local v12 = v11.user_id == active_user_id
					table.insert(iconEntries, {
						id = v11.user_id,
						name = v11.username,
						displayName = v11.display_name,
						iconKey = v12 and "icons/status/success_large" or nil,
						isUnselectable = v12,
						hasValidSession = not v7 or v11.has_valid_session
					})
				end

				table.sort(iconEntries, function(a, b)
					if a.id == p11.active_user_id then
						return true
					end

					return a.hasValidSession and not b.hasValidSession
				end)

				local function navigateToLoginWithUsername(name)
					object:dispatch(module11())

					local v12 = if p8 then module.LoginV2 else module.Login
					local v11 = {
						name = v12,
						extraProps = { forcedUsernameOverride = name }
					}

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v11))
					else
						object:dispatch(module8(v11))
					end
				end

				local v11 = {
					origin = p3,
					context = module9.Context.AccountSwitcher,
					users = iconEntries,
					actionRows = {},
					isMaxAccountsReached = v10,
					enableSignedOutAccounts = p7,
					logout = function()
						object:dispatch(module15(
							networking,
							GuiService,
							module16.ManageAccountsRemoveCurrentUser,
							nil
						))
					end,
					onAccountSelection = function(p12)
						local v12 = nil

						for i, v14 in ipairs(iconEntries) do
							if v14.id == p12 then
								v12 = v14
								break
							end
						end

						if v7 and v12 and not v12.hasValidSession then
							navigateToLoginWithUsername(v12.name)
						else
							module14.setAccountSwitchTargetUsername(v12.name)
							module14.flush()
							object:dispatch(module13(networking, p12, p5, p6, p4, function()
								navigateToLoginWithUsername(v12.name)
							end))
						end
					end,
					onClose = onClose,
					onAccountSelectionAbandoned = function() end,
					titleTextKey = "Authentication.AccountSwitch.Heading.SwitchAccount",
					renderFooterComponent = function()
						return fn(v10, p3, object)
					end,
					openDesktopSignupDialog = p9,
					openDesktopLoginDialog = p10
				}

				if fFlagEnableAccountSwitcherExternalIdentityButtons then
					local function completeExternalIdentitySwitch(p12): boolean
						local module17 = require("@game/CorePackages/Workspace/Packages/AuthCommon")
						local module18 = require("@luauforge/bundled/geZ")
						local module19 = require("@luauforge/bundled/gfH")
						local module20 = require("@luauforge/bundled/fvN")
						local module21 = require("@luauforge/bundled/ggs")

						if p12 == nil or p12 == "" then
							p12 = module14.getAccountBlob()
						end

						local v12 = Models.fromLocalStorage()
						object:dispatch(module11())

						local function launchApp()
							object:dispatch(module18(networking, p6, p4, p5, module19.Login))
						end

						if v12.userId == -1 then
							if p12 ~= nil and p12 ~= "" then
								module14.setAccountBlob(p12)
								module14.flush()
							end

							object:dispatch(module18(networking, p6, p4, p5, module19.Login))
						else
							object:dispatch(module21())

							local v13 = if fFlagLuaEnableLoginAndSignupDifferentiatedStatusValues then module17.Common.AccountSwitcherConstants.AccountSwitcherSwitchedFromLoginStatus else module10.Auth.AccountSwitcherSwitchedStatus
							module14.setAccountSwitchStatus(v13)

							if p12 ~= nil and p12 ~= "" then
								module14.setAccountBlob(p12)
							end

							module14.flush()

							if fFlagLuaEnableDidSwitchAccount then
								GuiService:BroadcastNotification("", module20.DID_SWITCH_ACCOUNT)
							else
								GuiService:BroadcastNotification("", module20.DID_LOG_OUT)
							end

							if fFlagAccountSwitchRelaunchFallback then
								module17.Utils.scheduleAccountSwitchRelaunchFallback(launchApp)
							end
						end

						return true
					end

					local function acquireExternalIdentityClient()
						local module17 = require("@luauforge/bundled/guy")

						return require("@luauforge/bundled/guz").acquire({
							getNetworking = function()
								return networking
							end,
							isBrowserSignInEnabled = module17.isDesktopBrowserSignInEnabled,
							completeSession = completeExternalIdentitySwitch
						})
					end

					local function startExternalIdentityFromSwitcher(p12)
						local module17 = require("@luauforge/bundled/fzT")
						local authOperationTiming = module17.Events.authOperationTiming
						local authClientError = module17.Events.authClientError

						local v12 = p3 or module9.Context.AccountSwitcher
						local lastTime = os.clock()
						local authenticate = acquireExternalIdentityClient().authenticate(p12)
						authenticate.promise:andThen(function(p13)
							authOperationTiming(
								"accountSwitcherAddAccount",
								os.clock() - lastTime,
								`externalIdentity.{p12}.{p13.status}`
							)

							if p13.status == "failed" or p13.status == "unavailable" then
								local errorClass = p13.errorClass
									or p13.status == "unavailable" and "unavailable"
									or "unknown"
								authClientError(
									"accountSwitcherAddAccount",
									`externalIdentity.{p12}.{errorClass}`,
									nil,
									v12
								)
							end
						end)
						return authenticate
					end

					function v11.getExternalIdentityCapabilities()
						return require("@luauforge/bundled/guz").getCapabilitiesAsync()
					end

					v11.authenticateWithExternalIdentity = startExternalIdentityFromSwitcher
					function v11.onExternalIdentityFailed()
						object:dispatch(require("@luauforge/bundled/egt")({
							HttpError = Enum.HttpError.OK
						}))
					end
				end

				if v9 > 0 then
					object:dispatch(module6(v11, true, true))
				end

				return v9
			end
		end):catch(function(p11)
			object:dispatch(module12(
				"Authentication.AccountSwitch.Header.CantSwitchAccountsSentenceCase",
				"Authentication.AccountSwitch.Description.PleaseTryAgainLater",
				"CommonUI.Messages.Action.OK",
				"",
				onClose,
				nil,
				module10.Auth.AccountSwitcherUnavailableError
			))
		end)
	end
end
