local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AppPage = require(Modules.LuaApp.AppPage)
local LoginStatus = require(Modules.LuaApp.Enum.LoginStatus)
local GetAccountsList = require(Modules.LuaApp.Thunks.Authentication.AccountSwitcher.GetAccountsList)
local User = require(Modules.LuaApp.Thunks.Authentication.User)
local FFlagEnableLuaAccountSwitch = require(Modules.LuaApp.Flags.FFlagEnableLuaAccountSwitch)
local OpenAccountSelector = require(Modules.LuaApp.Thunks.Authentication.OpenAccountSelector)
local GetFFlagEnableAccountSwitcherFoundationDesign = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableAccountSwitcherFoundationDesign
local GetFFlagEnableAccountSwitcherSignedOutAccounts = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableAccountSwitcherSignedOutAccounts
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableLuaLoginRevamp = SharedFlags.FFlagEnableLuaLoginRevamp
local FFlagEnableLoginV1ForcedUsernameOverride = SharedFlags.FFlagEnableLoginV1ForcedUsernameOverride
local FFlagEnableLoginV2ForcedUsernameOverride = SharedFlags.FFlagEnableLoginV2ForcedUsernameOverride
local GetFFlagEnableAccountSwitcherAddWithMaxSignedOut = SharedFlags.GetFFlagEnableAccountSwitcherAddWithMaxSignedOut
local GetFIntAccountSwitcherAccountLimit = require(CorePackages.Workspace.Packages.SharedFlags).GetFIntAccountSwitcherAccountLimit
local GetAccountsListWithSignedOutAccounts = require(CorePackages.Workspace.Packages.AccountSwitching).GetAccountsListWithSignedOutAccounts
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local v20 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local Constants = require(Modules.LuaApp.Constants)
local React = require(CorePackages.Packages.React)
local AddAccountRow = require(CorePackages.Workspace.Packages.AccountSelector).AddAccountRow
local MaxAccountsReachedText = require(CorePackages.Workspace.Packages.AccountSelector).MaxAccountsReachedText
local CloseCentralOverlay = require(script.Parent.Parent.CloseCentralOverlay)
local FlyoutSidePanelIXP = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).FlyoutSidePanelIXP
local OpenAccountSwitchingErrorOverlay = require(script.Parent.OpenAccountSwitchingErrorOverlay)
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local SwitchToAccount = require(script.Parent.AccountSwitcher.SwitchToAccount)
local AppStorageUtilities = require(script.Parent.AppStorageUtilities)
local Logout = require(script.Parent.Logout)
local GuiService = game:GetService("GuiService")
local luaLogoutReasonNames = require(Modules.LuaApp.Analytics.Events.Auth.luaLogoutReasonNames)

local function v35(b1: boolean, s1: string, _) -- line: 56
	-- upvalues: FlyoutSidePanelIXP (copy), EventStreamConstants (copy), React (copy), MaxAccountsReachedText (copy), useNavigation (copy), AddAccountRow (copy), AppPage (copy)
	if FlyoutSidePanelIXP.isFlyoutSidePanelEnabled() then
		if s1 ~= EventStreamConstants.Origin.MoreMenu and s1 ~= EventStreamConstants.Origin.FlyoutSidePanel then
			return nil
		end
	elseif s1 ~= "moreMenu" then
		return nil
	end

	if b1 then
		return React.createElement(MaxAccountsReachedText)
	end

	local v39 = useNavigation()

	return React.createElement(AddAccountRow, {
		origin = s1,
		context = EventStreamConstants.Context.AccountSwitcher,
		onRowClicked = function() -- line: 75
			-- upvalues: v39 (copy), AppPage (copy), s1 (copy)
			v39.replace(AppPage.AccountSwitchingAddAccountPeekView, {
				extraProps = {
					origin = s1
				}
			})
		end
	})
end

return function(_, p3, p4, p5, p6, p7, p8, p9, b2: boolean?) -- line: 82
	-- upvalues: FFlagEnableLuaAccountSwitch (copy), LoginStatus (copy), CloseCentralOverlay (copy), GetFFlagEnableAccountSwitcherSignedOutAccounts (copy), GetAccountsListWithSignedOutAccounts (copy), User (copy), GetAccountsList (copy), OpenAccountSwitchingErrorOverlay (copy), GetFFlagEnableAccountSwitcherFoundationDesign (copy), Constants (copy), EventStreamConstants (copy), GetFFlagEnableAccountSwitcherAddWithMaxSignedOut (copy), GetFIntAccountSwitcherAccountLimit (copy), Logout (copy), GuiService (copy), luaLogoutReasonNames (copy), FFlagEnableLuaLoginRevamp (copy), AppPage (copy), FFlagEnableLoginV2ForcedUsernameOverride (copy), FFlagSignalsNavP3Dispatch (copy), v20 (copy), NavigateDown (copy), FFlagEnableLoginV1ForcedUsernameOverride (copy), AppStorageUtilities (copy), SwitchToAccount (copy), v35 (copy), OpenAccountSelector (copy)
	return function(p10) -- line: 94
		-- upvalues: FFlagEnableLuaAccountSwitch (copy), LoginStatus (copy), CloseCentralOverlay (copy), GetFFlagEnableAccountSwitcherSignedOutAccounts (copy), p9 (copy), GetAccountsListWithSignedOutAccounts (copy), p3 (copy), User (copy), GetAccountsList (copy), OpenAccountSwitchingErrorOverlay (copy), GetFFlagEnableAccountSwitcherFoundationDesign (copy), Constants (copy), p5 (copy), EventStreamConstants (copy), GetFFlagEnableAccountSwitcherAddWithMaxSignedOut (copy), GetFIntAccountSwitcherAccountLimit (copy), p4 (copy), Logout (copy), GuiService (copy), luaLogoutReasonNames (copy), FFlagEnableLuaLoginRevamp (copy), b2 (copy), AppPage (copy), FFlagEnableLoginV2ForcedUsernameOverride (copy), FFlagSignalsNavP3Dispatch (copy), v20 (copy), NavigateDown (copy), FFlagEnableLoginV1ForcedUsernameOverride (copy), AppStorageUtilities (copy), SwitchToAccount (copy), p6 (copy), p7 (copy), v35 (copy), OpenAccountSelector (copy), p8 (copy)
		if not FFlagEnableLuaAccountSwitch then
			return nil
		end

		local v50 = p10:getState().AuthenticationStatus.status == LoginStatus.LOGGED_IN

		local function v51() -- line: 101
			-- upvalues: p10 (copy), CloseCentralOverlay (copy)
			p10:dispatch(CloseCentralOverlay())
		end

		local v52 = GetFFlagEnableAccountSwitcherSignedOutAccounts() and p9

		return ((if not v52 then GetAccountsList(p3, v50) else GetAccountsListWithSignedOutAccounts(p3, {
			filterUnauthenticatedSessionsForAccountPicker = true,
			useAccountSwitcherSignedOutAccountsLimit = true,
			isAuthenticated = v50
		}):andThen(function(p11) -- line: 113
			-- upvalues: User (copy)
			return {
				active_user_id = tostring(User.fromLocalStorage().userId),
				logged_in_users_metadata = p11
			}
		end))):andThen(function(t1: {[any]: any}) -- line: 125
			-- upvalues: v50 (copy), p10 (copy), OpenAccountSwitchingErrorOverlay (copy), GetFFlagEnableAccountSwitcherFoundationDesign (copy), v51 (copy), Constants (copy), v52 (copy), User (copy), p5 (copy), EventStreamConstants (copy), GetFFlagEnableAccountSwitcherAddWithMaxSignedOut (copy), GetFIntAccountSwitcherAccountLimit (copy), p4 (copy), p9 (copy), Logout (copy), p3 (copy), GuiService (copy), luaLogoutReasonNames (copy), CloseCentralOverlay (copy), FFlagEnableLuaLoginRevamp (copy), b2 (copy), AppPage (copy), FFlagEnableLoginV2ForcedUsernameOverride (copy), FFlagSignalsNavP3Dispatch (copy), v20 (copy), NavigateDown (copy), FFlagEnableLoginV1ForcedUsernameOverride (copy), AppStorageUtilities (copy), SwitchToAccount (copy), p6 (copy), p7 (copy), v35 (copy), OpenAccountSelector (copy), p8 (copy)
			local logged_in_users_metadata = t1.logged_in_users_metadata

			if #logged_in_users_metadata == 0 then
				if v50 == true then
					p10:dispatch(OpenAccountSwitchingErrorOverlay(not GetFFlagEnableAccountSwitcherFoundationDesign() and "Authentication.AccountSwitch.Header.CantSwitchAccounts" or "Authentication.AccountSwitch.Header.CantSwitchAccountsSentenceCase", "Authentication.AccountSwitch.Description.PleaseTryAgainLater", "CommonUI.Messages.Action.OK", "", v51, nil, Constants.Auth.AccountSwitcherUnavailableError))
				end

				return 0
			end

			local n1 = 0

			if v52 then
				for _, v in ipairs(logged_in_users_metadata) do
					if v.has_valid_session then
						n1 += 1
					end
				end
			else
				n1 = #logged_in_users_metadata
			end

			local active_user_id = t1.active_user_id
			local str = tostring(User.fromLocalStorage().userId)

			if p5 ~= nil and active_user_id ~= nil and active_user_id ~= "" and active_user_id ~= str then
				local v61 = active_user_id .. "," .. str

				p5.reportAuthClientError(EventStreamConstants.Context.AccountSwitcherMismatch, v61)
			end

			local v62 = ((if not GetFFlagEnableAccountSwitcherAddWithMaxSignedOut() then #logged_in_users_metadata else n1)) >= GetFIntAccountSwitcherAccountLimit()
			local t2 = {}

			for _, v65 in logged_in_users_metadata do
				local v66 = active_user_id == v65.user_id

				table.insert(t2, {
					id = v65.user_id,
					name = v65.username,
					displayName = v65.display_name,
					iconKey = if not v66 then nil else "icons/status/success_large",
					isUnselectable = v66,
					hasValidSession = not v52 or v65.has_valid_session
				})
			end

			table.sort(t2, function(p12, p13) -- line: 190
				-- upvalues: t1 (copy)
				if p12.id == t1.active_user_id then
					return true
				end

				return p12.hasValidSession and not p13.hasValidSession
			end)

			local t5 = {
				titleTextKey = "Authentication.AccountSwitch.Heading.SwitchAccount",
				origin = p4,
				context = EventStreamConstants.Context.AccountSwitcher,
				users = t2,
				actionRows = {},
				isMaxAccountsReached = v62,
				enableSignedOutAccounts = p9,
				logout = function() -- line: 208
					-- upvalues: p10 (copy), Logout (copy), p3 (copy), GuiService (copy), luaLogoutReasonNames (copy)
					p10:dispatch(Logout(p3, GuiService, luaLogoutReasonNames.ManageAccountsRemoveCurrentUser, nil))
				end,
				onAccountSelection = function(p14) -- line: 213
					-- upvalues: t2 (copy), v52 (copy), p10 (copy), CloseCentralOverlay (copy), FFlagEnableLuaLoginRevamp (copy), b2 (copy), AppPage (copy), FFlagEnableLoginV2ForcedUsernameOverride (copy), FFlagSignalsNavP3Dispatch (copy), v20 (copy), NavigateDown (copy), FFlagEnableLoginV1ForcedUsernameOverride (copy), AppStorageUtilities (copy), SwitchToAccount (copy), p3 (copy), p6 (copy), p7 (copy), p5 (copy)
					local v72 = nil

					for _, v in ipairs(t2) do
						if p14 == v.id then
							v72 = v

							break
						end
					end

					if v52 and v72 and not v72.hasValidSession then
						p10:dispatch(CloseCentralOverlay())

						if FFlagEnableLuaLoginRevamp and b2 then
							local t3 = {
								name = AppPage.LoginV2,
								extraProps = {
									forcedUsernameOverride = if not FFlagEnableLoginV2ForcedUsernameOverride then nil else v72.name
								}
							}

							if FFlagSignalsNavP3Dispatch then
								v20.down(v20.fromLegacyPage(t3))

								return
							end

							p10:dispatch(NavigateDown(t3))

							return
						end

						local t4 = {
							name = AppPage.Login,
							extraProps = {
								forcedUsernameOverride = if not FFlagEnableLoginV1ForcedUsernameOverride then nil else v72.name
							}
						}

						if FFlagSignalsNavP3Dispatch then
							v20.down(v20.fromLegacyPage(t4))

							return
						end

						p10:dispatch(NavigateDown(t4))

						return
					end

					AppStorageUtilities.setAccountSwitchTargetUsername(v72.name)
					AppStorageUtilities.flush()
					p10:dispatch(SwitchToAccount(p3, p14, p6, p7, p5))
				end,
				onClose = v51,
				onAccountSelectionAbandoned = function() -- line: 270
				end,
				renderFooterComponent = function() -- line: 274
					-- upvalues: v35 (copy), v62 (copy), p4 (copy), p10 (copy)
					return v35(v62, p4, p10)
				end
			}

			if n1 > 0 then
				p10:dispatch(OpenAccountSelector(t5, true, GetFFlagEnableAccountSwitcherFoundationDesign() and p8))
			end

			return n1
		end):catch(function(_) -- line: 291
			-- upvalues: p10 (copy), OpenAccountSwitchingErrorOverlay (copy), GetFFlagEnableAccountSwitcherFoundationDesign (copy), v51 (copy), Constants (copy)
			p10:dispatch(OpenAccountSwitchingErrorOverlay(not GetFFlagEnableAccountSwitcherFoundationDesign() and "Authentication.AccountSwitch.Header.CantSwitchAccounts" or "Authentication.AccountSwitch.Header.CantSwitchAccountsSentenceCase", "Authentication.AccountSwitch.Description.PleaseTryAgainLater", "CommonUI.Messages.Action.OK", "", v51, nil, Constants.Auth.AccountSwitcherUnavailableError))
		end)
	end
end
