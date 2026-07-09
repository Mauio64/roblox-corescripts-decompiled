local ChallengeDialog = script:FindFirstAncestor("ChallengeDialog")
local ChallengeDialogParent = ChallengeDialog.Parent
local React = require(ChallengeDialogParent.React)
local UIBlox = require(ChallengeDialogParent.UIBlox)
local RoactRodux = require(ChallengeDialogParent.RoactRodux)
local NavigateDown = require(ChallengeDialogParent.NavigationRodux).Thunks.NavigateDown
local NavigateFromWebView = require(ChallengeDialogParent.NavigationRodux).Thunks.NavigateFromWebView
local FFlagSignalsNavP3Dispatch = require(ChallengeDialogParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v9 = if not FFlagSignalsNavP3Dispatch then nil else require(ChallengeDialogParent.RobloxAppNavigation).NavigationCommands
local AppPage = require(ChallengeDialogParent.RobloxAppEnums).AppPage
local Url = require(ChallengeDialogParent.Http).Url
local useLocalization = require(ChallengeDialogParent.Localization).Hooks.useLocalization
local FullPageModalWrapper = require(ChallengeDialog.Common.FullPageModalWrapper)
local Lock = require(ChallengeDialog.Common.Lock)
local ModalTextComponent = require(ChallengeDialog.Common.ModalTextComponent)
local ModalButtonConfig = require(ChallengeDialog.Common.ModalButtonConfig)
local ModalFooter = require(ChallengeDialog.Common.ModalFooter)
local ModalTextSizes = require(ChallengeDialog.Common.ModalTextSizes)
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local v20 = Url.BASE_URL .. "my/account#!/info"
local t1 = {
	changePassword = "Authentication.TwoStepVerification.Action.ChangePassword",
	header = "Authentication.TwoStepVerification.Header.AttemptDenied",
	passwordWarning = "Authentication.TwoStepVerification.Label.SomeoneMightHavePassword",
	passwordChangeRecommended = "Authentication.TwoStepVerification.Label.PasswordChangeRecommended",
	helpMessage = "Authentication.TwoStepVerification.Label.NeedHelpMessage"
}

return RoactRodux.connect(function(_, _) -- line: 108
	return {}
end, function(p3) -- line: 110
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v9 (copy), NavigateDown (copy), NavigateFromWebView (copy)
	return {
		navigateToPage = function(p4) -- line: 112
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v9 (copy), p3 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				return v9.down(v9.fromLegacyPage(p4))
			end

			return p3(NavigateDown(p4))
		end,
		navigateFromWebView = function(p5) -- line: 119
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v9 (copy), p3 (copy), NavigateFromWebView (copy)
			if FFlagSignalsNavP3Dispatch then
				return v9.fromWebView(v9.fromLegacyPage(p5))
			end

			return p3(NavigateFromWebView(p5))
		end
	}
end)(function(p6) -- line: 36
	-- upvalues: React (copy), useLocalization (copy), t1 (copy), AppPage (copy), v20 (copy), FullPageModalWrapper (copy), Lock (copy), ModalTextComponent (copy), ModalButtonConfig (copy), ButtonType (copy), ModalFooter (copy), ModalTextSizes (copy)
	local v23, v24 = React.useState(false)
	local v25 = useLocalization(t1)

	return React.createElement(FullPageModalWrapper, {
		title = v25.header,
		closeModal = p6.closeModal,
		makeBodyFragment = function(p7) -- line: 57
			-- upvalues: React (copy), Lock (copy), ModalTextComponent (copy), v25 (copy)
			return React.createElement(React.Fragment, nil, {
				Lock = React.createElement(Lock, {
					layoutOrder = 1
				}),
				SomeoneMightHaveYourPassword = React.createElement(ModalTextComponent, {
					layoutOrder = 2,
					useBold = true,
					useEmphasis = true,
					contentWidth = p7,
					text = v25.passwordWarning
				}),
				ChangeYourPassword = React.createElement(ModalTextComponent, {
					layoutOrder = 3,
					useBold = true,
					useEmphasis = true,
					contentWidth = p7,
					text = v25.passwordChangeRecommended
				})
			})
		end,
		buttonConfig = ModalButtonConfig({{
			isDisabled = v23,
			isLoading = v23,
			onActivated = function() -- line: 41
				-- upvalues: v24 (copy), p6 (copy), AppPage (copy), v20 (copy)
				v24(true)
				p6.navigateFromWebView({
					name = AppPage.SettingsSubPage,
					detail = v20,
					extraProps = {
						titleKey = "Feature.AccountSettings.Heading.Tab.Security.AccountInfo"
					}
				})
			end,
			text = v25.changePassword,
			type = ButtonType.Secondary
		}}),
		footerContent = ModalFooter(function(p8) -- line: 87
			-- upvalues: React (copy), ModalTextComponent (copy), v25 (copy), ModalTextSizes (copy), p6 (copy), AppPage (copy)
			return React.createElement(ModalTextComponent, {
				BackgroundTransparency = 0,
				layoutOrder = 1,
				text = v25.helpMessage,
				contentWidth = p8,
				size = ModalTextSizes.Footer,
				onActivated = function() -- line: 94
					-- upvalues: p6 (copy), AppPage (copy)
					p6.navigateToPage({
						detail = "https://en.help.roblox.com/hc/en-us/articles/212459863-Add-2-Step-Verification-to-Your-Account",
						name = AppPage.GenericWebPage,
						extraProps = {
							title = ""
						}
					})
				end
			})
		end)
	})
end)
