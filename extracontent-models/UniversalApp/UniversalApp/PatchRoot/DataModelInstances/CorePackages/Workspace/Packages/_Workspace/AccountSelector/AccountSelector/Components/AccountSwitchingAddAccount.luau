local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local dependencies = require(ParentParent.dependencies)
local React = dependencies.React
local RoactRodux = dependencies.RoactRodux
local useLocalization = dependencies.Localization.Hooks.useLocalization
local Foundation = dependencies.Foundation
local Sheet = Foundation.Sheet
local View = Foundation.View
local FoundationText = Foundation.Text
local ButtonVariant = Foundation.Enums.ButtonVariant
local AppPage = dependencies.RobloxAppEnums.AppPage
local NavigateDown = dependencies.NavigationRodux.Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = dependencies.SharedFlags.FFlagSignalsNavP3Dispatch
local v15 = if not FFlagSignalsNavP3Dispatch then nil else require(ParentParentParent.RobloxAppNavigation).NavigationCommands
local RoactAppExperiment = dependencies.RoactAppExperiment
local FFlagEnableLuaLoginRevamp = dependencies.SharedFlags.FFlagEnableLuaLoginRevamp
local FStringLuaLoginRevampIxpLayer = dependencies.SharedFlags.FStringLuaLoginRevampIxpLayer
local GetFFlagEnableMultiPageSignup = dependencies.SharedFlags.GetFFlagEnableMultiPageSignup
local AppBtidLayers = dependencies.ExperimentLayers.AppBtidLayers
local AnalyticsEvents = require(ParentParent.Analytics.AnalyticsEvents)
local EventConstants = require(ParentParent.Analytics.EventConstants)

local function AccountSwitchingAddAccount(t1: {[any]: any}) -- line: 40
	-- upvalues: useLocalization (copy), React (copy), AnalyticsEvents (copy), EventConstants (copy), FFlagEnableLuaLoginRevamp (copy), RoactAppExperiment (copy), FStringLuaLoginRevampIxpLayer (copy), GetFFlagEnableMultiPageSignup (copy), Sheet (copy), FoundationText (copy), View (copy), Foundation (copy), ButtonVariant (copy)
	local v26 = useLocalization({
		titleText = "Authentication.AccountSwitch.Action.AddAnAccount",
		loginText = "Authentication.AccountSwitch.Action.SignInToExistingAccount",
		createText = "Authentication.AccountPicker.Button.CreateAccount"
	})
	local v27, v28 = React.useState(true)
	local t2 = {
		showLoginRevamp = false
	}

	React.useEffect(function() -- line: 50
		-- upvalues: t1 (copy), AnalyticsEvents (copy), EventConstants (copy)
		if t1.origin then
			AnalyticsEvents.sendModalShownEvent(EventConstants.ctx.accountSwitcherAddAccount, t1.origin)
		end
	end, {})

	if FFlagEnableLuaLoginRevamp then
		t2 = RoactAppExperiment.useBrowserTrackerExperiment({ FStringLuaLoginRevampIxpLayer }, function(p1) -- line: 59
			-- upvalues: FStringLuaLoginRevampIxpLayer (copy)
			return {
				showLoginRevamp = (p1[FStringLuaLoginRevampIxpLayer] or {}).showLoginRevamp
			}
		end)
	end

	return React.createElement(React.Fragment, nil, {
		AddAccountSheet = React.createElement(Sheet.Root, {
			preferCenterSheet = true,
			onClose = function() -- line: 69
				-- upvalues: v28 (copy), t1 (copy)
				v28(false)

				if t1.onClose then
					t1.onClose(true)
				end
			end,
			isOpen = v27
		}, {
			Header = React.createElement(Sheet.Header, nil, {
				Title = React.createElement(FoundationText, {
					tag = "auto-xy text-heading-small content-emphasis",
					Text = v26.titleText
				})
			}),
			StandardButtons = React.createElement(Sheet.Content, {
				tag = "col auto-y gap-small"
			}, {
				ActionList = React.createElement(View, {
					tag = "col auto-y gap-small size-full-0 padding-bottom-medium"
				}, {
					LoginButton = React.createElement(Foundation.Button, {
						tag = "col size-full-0",
						text = v26.loginText,
						variant = ButtonVariant.Standard,
						onActivated = function() -- line: 76
							-- upvalues: t1 (copy), AnalyticsEvents (copy), EventConstants (copy), v28 (copy), FFlagEnableLuaLoginRevamp (copy), t2 (ref)
							if t1.origin then
								AnalyticsEvents.sendButtonClickEvent(EventConstants.ctx.accountSwitcherAddAccount, t1.origin, EventConstants.btn.login)
							end

							v28(false)

							if t1.onClose then
								t1.onClose()
							end

							if FFlagEnableLuaLoginRevamp and t2.showLoginRevamp then
								if t1.navigateToLoginV2 then
									t1.navigateToLoginV2()

									return
								end
							elseif t1.navigateToLogin then
								t1.navigateToLogin()
							end
						end,
						width = UDim.new(1, 0)
					}),
					SignUpButton = React.createElement(Foundation.Button, {
						tag = "col size-full-0",
						text = v26.createText,
						variant = ButtonVariant.Standard,
						onActivated = function() -- line: 99
							-- upvalues: t1 (copy), AnalyticsEvents (copy), EventConstants (copy), v28 (copy), GetFFlagEnableMultiPageSignup (copy)
							if t1.origin then
								AnalyticsEvents.sendButtonClickEvent(EventConstants.ctx.accountSwitcherAddAccount, t1.origin, EventConstants.btn.signup)
							end

							v28(false)

							if t1.onClose then
								t1.onClose()
							end

							if GetFFlagEnableMultiPageSignup() and t1.shouldEnableMultiPageSignup then
								if t1.navigateToMultiPageSignUp then
									t1.navigateToMultiPageSignUp()

									return
								end
							elseif t1.navigateToSignUp then
								t1.navigateToSignUp()
							end
						end,
						width = UDim.new(1, 0)
					})
				})
			})
		})
	})
end

if GetFFlagEnableMultiPageSignup() then
	AccountSwitchingAddAccount = RoactAppExperiment.connectBrowserTrackerLayer({ AppBtidLayers.SignupLayer }, function(p2, _) -- line: 163
		-- upvalues: AppBtidLayers (copy)
		return {
			shouldEnableMultiPageSignup = (p2[AppBtidLayers.SignupLayer] or {}).shouldEnableMultiPageSignup
		}
	end)(AccountSwitchingAddAccount)
end

local v24 = RoactRodux.connect(nil, function(p4) -- line: 173
	-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v15 (copy), NavigateDown (copy)
	return {
		navigateToLogin = function() -- line: 175
			-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v15 (copy), p4 (copy), NavigateDown (copy)
			local t3 = {
				name = AppPage.Login
			}

			if FFlagSignalsNavP3Dispatch then
				v15.down(v15.fromLegacyPage(t3))

				return
			end

			p4(NavigateDown(t3))
		end,
		navigateToLoginV2 = function() -- line: 184
			-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v15 (copy), p4 (copy), NavigateDown (copy)
			local t4 = {
				name = AppPage.LoginV2
			}

			if FFlagSignalsNavP3Dispatch then
				v15.down(v15.fromLegacyPage(t4))

				return
			end

			p4(NavigateDown(t4))
		end,
		navigateToSignUp = function() -- line: 193
			-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v15 (copy), p4 (copy), NavigateDown (copy)
			local t5 = {
				name = AppPage.SinglePageSignUp
			}

			if FFlagSignalsNavP3Dispatch then
				v15.down(v15.fromLegacyPage(t5))

				return
			end

			p4(NavigateDown(t5))
		end,
		navigateToMultiPageSignUp = function() -- line: 202
			-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v15 (copy), p4 (copy), NavigateDown (copy)
			local t6 = {
				name = AppPage.MultiPageSignup,
				extraProps = {
					enforceResetState = true
				}
			}

			if FFlagSignalsNavP3Dispatch then
				v15.down(v15.fromLegacyPage(t6))

				return
			end

			p4(NavigateDown(t6))
		end
	}
end)(AccountSwitchingAddAccount)

return React.memo(v24)
