local LandingPage = script:FindFirstAncestor("LandingPage")
local LandingPageParent = LandingPage.Parent
local React = require(LandingPageParent.React)
local Foundation = require(LandingPageParent.Foundation)
local FullscreenPageWithSafeArea = require(LandingPageParent.AppBlox).FullscreenPageWithSafeArea
local useStyle = require(LandingPageParent.UIBlox).Core.Style.useStyle
local Enums = Foundation.Enums
local EditAccountPickerList = require(LandingPage.Components.EditAccountPickerList)
local useLocalization = require(LandingPageParent.Localization).Hooks.useLocalization
local useRoactService = require(LandingPageParent.RobloxAppHooks).useRoactService
local RoactNetworking = require(LandingPageParent.RoactServiceTags).RoactNetworking
local RemoveAccountDialog = require(script.Parent.RemoveAccountDialog)
local AuthCommon = require(LandingPageParent.AuthCommon)
local updateLoginEntryData = AuthCommon.Utils.updateLoginEntryData
local User = AuthCommon.Thunks.User
local DeleteAccount = require(LandingPageParent.AccountSwitching).DeleteAccount
local Cryo = require(LandingPageParent.Cryo)

require(script.Parent.AccountCarouselAvatar)

local GetFFlagEnableAccountCarouselEvents = require(LandingPageParent.SharedFlags).GetFFlagEnableAccountCarouselEvents
local AuthAnalytics = require(LandingPageParent.AuthAnalytics)
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local authButtonClick = AuthAnalytics.Events.authButtonClick
local authPageload = AuthAnalytics.Events.authPageload
local Sheet = Foundation.Sheet
local DialogSize = Foundation.Enums.DialogSize
local GetFFlagEnableManageAccountsRedesign = require(LandingPageParent.SharedFlags).GetFFlagEnableManageAccountsRedesign
local GetFFlagEnableAccountSwitcherSignedOutAccounts = require(LandingPageParent.SharedFlags).GetFFlagEnableAccountSwitcherSignedOutAccounts
local GetFFlagEnableLuaAccountPicker = require(LandingPageParent.SharedFlags).GetFFlagEnableLuaAccountPicker
local GetFIntAccountPickerVariantOverride = require(LandingPageParent.SharedFlags).GetFIntAccountPickerVariantOverride
local RoactAppExperiment = require(LandingPageParent.RoactAppExperiment)
local AppBtidLayers = require(LandingPageParent.ExperimentLayers).AppBtidLayers
local AuthLocalStorageKeys = AuthCommon.Enums.AuthLocalStorageKeys
local AppStorageService = game:GetService("AppStorageService")

return function(t1: {[any]: any}) -- line: 46
	-- upvalues: React (copy), useRoactService (copy), RoactNetworking (copy), useLocalization (copy), User (copy), RoactAppExperiment (copy), AppBtidLayers (copy), GetFIntAccountPickerVariantOverride (copy), GetFFlagEnableLuaAccountPicker (copy), GetFFlagEnableAccountSwitcherSignedOutAccounts (copy), GetFFlagEnableAccountCarouselEvents (copy), authButtonClick (copy), EventStreamConstants (copy), updateLoginEntryData (copy), Cryo (copy), AppStorageService (copy), AuthLocalStorageKeys (copy), DeleteAccount (copy), authPageload (copy), GetFFlagEnableManageAccountsRedesign (copy), useStyle (copy), FullscreenPageWithSafeArea (copy), RemoveAccountDialog (copy), Foundation (copy), Enums (copy), EditAccountPickerList (copy), Sheet (copy), DialogSize (copy)
	local v34, v35 = React.useState(t1.accounts)
	local v36, v37 = React.useState(nil)
	local v38 = useRoactService(RoactNetworking)
	local v39 = useLocalization({
		EditAccounts = "Authentication.AccountPicker.Label.ManageAccounts"
	})
	local v40 = User.fromLocalStorage()
	local u41 = false

	if v40.userId ~= nil then
		local v42 = RoactAppExperiment.useBrowserTrackerExperiment({ AppBtidLayers.LandingLayer }, function(p1) -- line: 64
			-- upvalues: AppBtidLayers (copy), GetFIntAccountPickerVariantOverride (copy)
			local v50 = p1[AppBtidLayers.LandingLayer] or {}

			return {
				accountPickerVariantEnabled = v50.accountPickerVariantEnabled and tonumber(v50.accountPickerVariantEnabled) or GetFIntAccountPickerVariantOverride()
			}
		end)
		local v43 = v42.accountPickerVariantEnabled ~= nil and v42.accountPickerVariantEnabled ~= 0

		u41 = GetFFlagEnableLuaAccountPicker() and v43
	end

	local v44 = GetFFlagEnableAccountSwitcherSignedOutAccounts() and t1.enableSignedOutAccounts

	local function v45() -- line: 88
		-- upvalues: v44 (copy), v36 (copy), v40 (copy), v34 (copy)
		if not v44 then
			return false
		end

		if v36 == nil or (v36 == nil or tostring(v40.userId) ~= v36.user_id) then
			return false
		end

		for _, v in ipairs(v34) do
			if v.user_id ~= v36.user_id and v.has_valid_session then
				return false
			end
		end

		return true
	end
	local function v46() -- line: 103
		-- upvalues: v36 (copy), GetFFlagEnableAccountCarouselEvents (copy), authButtonClick (copy), EventStreamConstants (copy), updateLoginEntryData (copy), Cryo (copy), v34 (copy), v35 (copy), t1 (copy), v37 (copy), v40 (copy), AppStorageService (copy), AuthLocalStorageKeys (copy), u41 (ref), v45 (copy), v44 (copy), DeleteAccount (copy), v38 (copy)
		if v36 == nil then
			return
		end

		if GetFFlagEnableAccountCarouselEvents() then
			authButtonClick(EventStreamConstants.Context.AccountPickerManageAccountsScreen, EventStreamConstants.Button.AccountPickerDeleteAccount, v36.user_id, nil)
		end

		if not v36.has_valid_session then
			updateLoginEntryData(v36.user_id, {
				showInAccountPicker = false
			})

			local v53 = Cryo.List.filter(v34, function(p2) -- line: 119
				-- upvalues: v36 (copy)
				return p2.user_id ~= v36.user_id
			end)

			v35(v53)

			if t1.onAccountsUpdated then
				t1.onAccountsUpdated(v53)
			end

			v37(nil)

			return
		end

		if v36 ~= nil and tostring(v40.userId) == v36.user_id then
			if t1.logout then
				t1.logout()
			end

			AppStorageService:SetItem(AuthLocalStorageKeys.CredentialValue, "")
			AppStorageService:Flush()

			local v54 = not u41 and v45()

			if v44 then
				for _, v in ipairs(v34) do
					if v54 or v.user_id == v36.user_id then
						updateLoginEntryData(v.user_id, {
							showInAccountPicker = false
						})
					end
				end

				return
			end
		else
			DeleteAccount(v38, {
				username = v36.username,
				user_id = v36.user_id,
				display_name = v36.display_name
			}):andThen(function(_) -- line: 151
				-- upvalues: Cryo (copy), v34 (copy), v36 (copy), v35 (copy), t1 (copy), v37 (copy), updateLoginEntryData (copy)
				local v59 = Cryo.List.filter(v34, function(p4) -- line: 152
					-- upvalues: v36 (copy)
					return p4.user_id ~= v36.user_id
				end)

				v35(v59)

				if t1.onAccountsUpdated then
					t1.onAccountsUpdated(v59)
				end

				v37(nil)
				updateLoginEntryData(v36.user_id, {
					showInAccountPicker = false
				})
			end):catch(function(p5) -- line: 164
				warn(p5)
			end)
		end
	end
	local function v47() -- line: 171
		-- upvalues: GetFFlagEnableAccountCarouselEvents (copy), authButtonClick (copy), EventStreamConstants (copy), v37 (copy)
		if GetFFlagEnableAccountCarouselEvents() then
			authButtonClick(EventStreamConstants.Context.AccountPickerManageAccountsScreen, EventStreamConstants.Button.AccountPickerManageAccountsClosed, nil, nil)
		end

		v37(nil)
	end

	React.useEffect(function() -- line: 183
		-- upvalues: GetFFlagEnableAccountCarouselEvents (copy), authPageload (copy), EventStreamConstants (copy)
		if GetFFlagEnableAccountCarouselEvents() then
			authPageload(EventStreamConstants.Context.AccountPickerManageAccountsScreen)
		end
	end, {})

	if not GetFFlagEnableManageAccountsRedesign() or not v44 then
		local v48 = useStyle()

		React.useEffect(function() -- line: 194
			-- upvalues: GetFFlagEnableAccountCarouselEvents (copy), authPageload (copy), EventStreamConstants (copy)
			if GetFFlagEnableAccountCarouselEvents() then
				authPageload(EventStreamConstants.Context.AccountPickerManageAccountsScreen)
			end
		end, {})

		return React.createElement(FullscreenPageWithSafeArea, {
			includeStatusBar = true,
			BackgroundColor3 = v48.Theme.BackgroundDefault.Color
		}, {
			RemoveAccountDialog = v36 and React.createElement(RemoveAccountDialog, {
				hideAllAccounts = false,
				isCurrentUser = v36 ~= nil and tostring(v40.userId) == v36.user_id,
				onRemove = v46,
				onClose = v47
			}) or nil,
			OuterContainer = React.createElement(Foundation.View, {
				tag = "col auto-xy size-full-0",
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				TopBar = React.createElement(Foundation.View, {
					tag = "row size-full-0 auto-y items-center padding-x-small padding-bottom-large padding-top-medium"
				}, {
					CloseButtonContainer = React.createElement(Foundation.View, {
						LayoutOrder = 0,
						tag = "col size-0 auto-xy padding-x-small",
						onActivated = t1.onClose
					}, {
						CloseButton = React.createElement(Foundation.Icon, {
							tag = "auto-xy",
							name = Enums.IconName.X,
							size = Enums.IconSize.Large
						})
					}),
					Title = React.createElement(Foundation.Text, {
						LayoutOrder = 1,
						tag = "fill auto-xy text-heading-small content-emphasis padding-right-small",
						Text = v39.EditAccounts
					}),
					SpaceContainer = React.createElement(Foundation.View, {
						LayoutOrder = 2,
						tag = "col size-0 auto-xy padding-x-small"
					}, {
						Space = React.createElement(Foundation.Icon, {
							tag = "col size-0 auto-xy",
							Visible = false,
							name = Enums.IconName.X,
							size = Enums.IconSize.Large
						})
					})
				}),
				EditAccountPickerList = React.createElement(EditAccountPickerList, {
					onClose = t1.onClose,
					accounts = v34,
					setRemoveAccount = v37,
					enableSignedOutAccounts = t1.enableSignedOutAccounts
				})
			})
		})
	end

	return React.createElement(React.Fragment, nil, {
		Sheet = React.createElement(Sheet.Root, {
			preferCenterSheet = true,
			size = DialogSize.Medium,
			onClose = t1.onClose,
			snapPoints = { 1 }
		}, {
			Header = React.createElement(Sheet.Header, {
				tag = "row size-full-0 auto-y items-center padding-x-small padding-bottom-large padding-top-medium",
				hasCloseAffordance = true
			}, {
				Title = React.createElement(Foundation.Text, {
					LayoutOrder = 1,
					tag = "fill auto-xy text-heading-small content-emphasis padding-x-small text-align-x-left",
					Text = v39.EditAccounts
				})
			}),
			Content = React.createElement(Sheet.Content, nil, {
				EditAccountPickerList = React.createElement(EditAccountPickerList, {
					onClose = t1.onClose,
					accounts = v34,
					setRemoveAccount = v37,
					enableSignedOutAccounts = t1.enableSignedOutAccounts
				})
			})
		}),
		RemoveAccountDialog = v36 and React.createElement(RemoveAccountDialog, {
			hideAllAccounts = not u41 and v45(),
			isCurrentUser = v36 ~= nil and tostring(v40.userId) == v36.user_id,
			onRemove = v46,
			onClose = v47
		}) or nil
	})
end
