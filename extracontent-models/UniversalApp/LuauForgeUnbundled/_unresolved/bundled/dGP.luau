local module = require("@luauforge/bundled/dFV")
local UIBlox = require("@game/CorePackages/Workspace/Packages/UIBlox")
local module3 = require("@luauforge/bundled/dFW")
local navigateDown = require("@luauforge/bundled/dFY").Thunks.NavigateDown
local navigateFromWebView = require("@luauforge/bundled/dFY").Thunks.NavigateFromWebView
local fFlagSignalsNavP3Dispatch = require("@luauforge/bundled/dFZ").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dGa").NavigationCommands else nil

local appPage = require("@luauforge/bundled/dGb").AppPage
local url = require("@luauforge/bundled/dGg").Url
local useLocalization = require("@luauforge/bundled/dGo").Hooks.useLocalization

local module4 = require("@luauforge/bundled/dGw")
local module5 = require("@luauforge/bundled/dGp")
local module6 = require("@luauforge/bundled/dGq")
local module7 = require("@luauforge/bundled/dGv")
local module8 = require("@luauforge/bundled/dGA")
local module9 = require("@luauforge/bundled/dGu")

local buttonType = UIBlox.App.Button.Enum.ButtonType

local v5 = url.BASE_URL .. "my/account#!/info"

local v6 = {
	changePassword = "Authentication.TwoStepVerification.Action.ChangePassword",
	header = "Authentication.TwoStepVerification.Header.AttemptDenied",
	passwordWarning = "Authentication.TwoStepVerification.Label.SomeoneMightHavePassword",
	passwordChangeRecommended = "Authentication.TwoStepVerification.Label.PasswordChangeRecommended",
	helpMessage = "Authentication.TwoStepVerification.Label.NeedHelpMessage"
}

return module3.connect(function(p2, p3)
	return {}
end, function(callback)
	return {
		navigateToPage = function(p2)
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.down(navigationCommands.fromLegacyPage(p2))
			end

			return callback(navigateDown(p2))
		end,
		navigateFromWebView = function(p2)
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.fromWebView(navigationCommands.fromLegacyPage(p2))
			end

			return callback(navigateFromWebView(p2))
		end
	}
end)(function(props)
	local state, setState = module.useState(false)

	local v7 = useLocalization(v6)

	local function onActivated()
		setState(true)

		props.navigateFromWebView({
			name = appPage.SettingsSubPage,
			detail = v5,
			extraProps = {
				titleKey = "Feature.AccountSettings.Heading.Tab.Security.AccountInfo"
			}
		})
	end

	return module.createElement(module4, {
		title = v7.header,
		closeModal = props.closeModal,
		makeBodyFragment = function(p2)
			return module.createElement(module.Fragment, nil, {
				Lock = module.createElement(module5, { layoutOrder = 1 }),
				SomeoneMightHaveYourPassword = module.createElement(module6, {
					layoutOrder = 2,
					contentWidth = p2,
					useBold = true,
					useEmphasis = true,
					text = v7.passwordWarning
				}),
				ChangeYourPassword = module.createElement(module6, {
					layoutOrder = 3,
					contentWidth = p2,
					useBold = true,
					useEmphasis = true,
					text = v7.passwordChangeRecommended
				})
			})
		end,
		buttonConfig = module7({
			{
				isDisabled = state,
				isLoading = state,
				onActivated = onActivated,
				text = v7.changePassword,
				type = buttonType.Secondary
			}
		}),
		footerContent = module8(function(p2)
			return module.createElement(module6, {
				BackgroundTransparency = 0,
				layoutOrder = 1,
				text = v7.helpMessage,
				contentWidth = p2,
				size = module9.Footer,
				onActivated = function()
					props.navigateToPage({
						name = appPage.GenericWebPage,
						detail = "https://en.help.roblox.com/hc/en-us/articles/212459863-Add-2-Step-Verification-to-Your-Account",
						extraProps = { title = "" }
					})
				end
			})
		end)
	})
end)
