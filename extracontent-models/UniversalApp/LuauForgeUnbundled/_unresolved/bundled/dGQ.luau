local module = require("@luauforge/bundled/dFV")
local UIBlox = require("@game/CorePackages/Workspace/Packages/UIBlox")
local module3 = require("@luauforge/bundled/dFW")
local module4 = require("@luauforge/bundled/dFX")
local navigateDown = require("@luauforge/bundled/dFY").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@luauforge/bundled/dFZ").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dGa").NavigationCommands else nil

local appPage = require("@luauforge/bundled/dGb").AppPage
local useLocalization = require("@luauforge/bundled/dGo").Hooks.useLocalization

local module5 = require("@luauforge/bundled/dGw")
local module6 = require("@luauforge/bundled/dGp")
local module7 = require("@luauforge/bundled/dGq")
local module8 = require("@luauforge/bundled/dGv")
local module9 = require("@luauforge/bundled/dGA")
local module10 = require("@luauforge/bundled/dGF")
local module11 = require("@luauforge/bundled/dGJ")
local module12 = require("@luauforge/bundled/dGD")
local module13 = require("@luauforge/bundled/dGL")
local module14 = require("@luauforge/bundled/dGu")
local fFlagLuaAppDefaultHttpRetry = require("@luauforge/bundled/dFZ").FFlagLuaAppDefaultHttpRetry

local buttonType = UIBlox.App.Button.Enum.ButtonType

local config = module4.config
local v5 = {
	requestFunction = module4.requestFunctions.RequestInternal,
	maxRetryCount = 0
}

local v6 = if fFlagLuaAppDefaultHttpRetry then game:DefineFastInt(
	"ModalChallengeDialogExpiredHttpRetryCount",
	4
) else nil
v5.maxRetryCount = v6
local v7 = config(v5)

local function fn(kind)
	return {
		okay = "Authentication.TwoStepVerification.Action.Okay",
		header = kind == module11.toRawValue(module11.DIALOG_TYPE_APPROVAL_2SV_GENERIC) and "Authentication.TwoStepVerification.Header.AttemptExpired" or "Authentication.TwoStepVerification.Header.LoginAttemptExpired",
		loginExpired = kind == module11.toRawValue(module11.DIALOG_TYPE_APPROVAL_2SV_GENERIC) and "Authentication.TwoStepVerification.Label.Expired" or "Authentication.TwoStepVerification.Label.LoginExpired",
		helpMessage = "Authentication.TwoStepVerification.Label.NeedHelpMessage"
	}
end

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
		finishDialog = function(p2, p3, p4)
			return callback(module12(p2, p3, p4))
		end
	}
end)(function(props)
	local state, setState = module.useState(false)
	local v8 = useLocalization(fn(props.dialogItem.type))

	local function onActivated()
		setState(true)

		props.finishDialog(
			v7,
			{
				type = props.dialogItem.type,
				typeInternalId = props.dialogItem.typeInternalId
			},
			module10.Deny
		):await()
		setState(false)
		props.closeModal()
	end

	local function fn2()
		module13.sendDialogAbandonedEvent(props.dialogItem.type, props.dialogItem.typeInternalId)
		onActivated()
	end

	return module.createElement(module5, {
		title = v8.header,
		closeModal = fn2,
		makeBodyFragment = function(p2)
			return module.createElement(module.Fragment, nil, {
				Lock = module.createElement(module6, { layoutOrder = 1 }),
				ChangeYourPassword = module.createElement(module7, {
					layoutOrder = 2,
					contentWidth = p2,
					useBold = true,
					useEmphasis = true,
					text = v8.loginExpired
				})
			})
		end,
		buttonConfig = module8({
			{
				isDisabled = state,
				isLoading = state,
				onActivated = onActivated,
				text = v8.okay,
				type = buttonType.PrimarySystem
			}
		}),
		footerContent = module9(function(p2)
			return module.createElement(module7, {
				BackgroundTransparency = 0,
				layoutOrder = 1,
				text = v8.helpMessage,
				contentWidth = p2,
				size = module14.Footer,
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
