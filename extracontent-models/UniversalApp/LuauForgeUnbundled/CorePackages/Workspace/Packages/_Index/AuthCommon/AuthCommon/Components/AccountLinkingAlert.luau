local GuiService = game:GetService("GuiService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UIBlox")
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local withStyle = UIBlox.Style.withStyle
local buttonType = UIBlox.App.Button.Enum.ButtonType
local useScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppHooks").useScreenSize
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/LinkingProtocol").LinkingProtocol.default
local text = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Foundation").Text

local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UniversalAppPolicy").useAppPolicy
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RoactUtils").Hooks.RoactRodux.useDispatch
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Localization").Hooks.useLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Navigation").useNavigation
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppEnums").AppPage
local notificationType = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppEnums").NotificationType
local AuthAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/AuthAnalytics")
local eventStreamConstants = AuthAnalytics.EventStreamConstants
local authModalShown = AuthAnalytics.Events.authModalShown
local authButtonClick = AuthAnalytics.Events.authButtonClick
local defineFastString = game:DefineFastString(
	"IncompatibleAccountsSupportLink",
	"https://help.roblox.com/hc/articles/360000334523-Xbox-One-App-Trouble-logging-into-Roblox-account"
)

local AccountLinkingAlertType = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Enums/AccountLinkingAlertType")

local function AccountLinkingAlert(data)
	local v5 = {}

	if data.secondaryButtonText and data.secondaryButtonCallback then
		table.insert(v5, {
			buttonType = buttonType.Secondary,
			props = {
				text = data.secondaryButtonText,
				onActivated = function()
					data.secondaryButtonCallback()
				end
			}
		})
	end

	if data.primaryButtonText and data.primaryButtonCallback then
		table.insert(v5, {
			buttonType = buttonType.PrimarySystem,
			props = {
				text = data.primaryButtonText,
				onActivated = function()
					data.primaryButtonCallback()
				end
			}
		})
	end

	local v6 = useScreenSize()

	local v7 = React.useCallback(function()
		if data.footerText and data.footerCallback then
			return React.createElement(
				"Frame",
				{
					Size = UDim2.fromScale(1, 1),
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundTransparency = 1
				},
				{
					Text = React.createElement(text, {
						Text = data.footerText,
						AutomaticSize = Enum.AutomaticSize.XY,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						onActivated = data.footerCallback
					})
				}
			)
		end

		return nil
	end, { data.footerText, data.footerCallback })

	return withStyle(function(p2)
		return React.createElement(interactiveAlert, {
			title = data.titleText,
			bodyText = data.bodyText,
			buttonStackInfo = { buttons = v5 },
			footerContent = v7,
			isRoactGamepadEnabled = false,
			position = UDim2.fromScale(0.5, 0.5),
			screenSize = v6
		})
	end)
end

local function useIncompatibleAccountsAlertProps(p2)
	local v5 = useDispatch()
	local v6 = useNavigation()

	local v7 = useAppPolicy(function(p3)
		return p3.getPlatformAccountName()
	end)

	local v8 = useLocalization({
		titleText = "Authentication.Login.Heading.IncompatibleAccounts",
		bodyText = {
			"Authentication.Login.Response.AlreadyLinked",
			platform = v7
		},
		primaryButtonText = {
			"Authentication.Login.Button.CloseAndSwitchPlatformAccount",
			platformAccountName = v7
		},
		secondaryButtonText = "Authentication.Login.Button.UseDifferentRobloxAccount",
		footerText = "Authentication.Login.Label.LearnMore"
	})

	local v9 = React.useCallback(function()
		GuiService:BroadcastNotification("", notificationType.NATIVE_EXIT)

		if p2.closeCentralOverlayThunk then
			v5(p2.closeCentralOverlayThunk())
		end

		authButtonClick(
			eventStreamConstants.Context.AccountLinking,
			eventStreamConstants.Button.PrimaryButton
		)
	end, { p2.closeCentralOverlayThunk })

	local v10 = React.useCallback(function()
		v6.navigate(appPage.Landing)

		if p2.closeCentralOverlayThunk then
			v5(p2.closeCentralOverlayThunk())
		end

		authButtonClick(
			eventStreamConstants.Context.AccountLinking,
			eventStreamConstants.Button.SecondaryButton
		)
	end, { v6, p2.closeCentralOverlayThunk })

	local v11 = React.useCallback(function()
		default:openURL(defineFastString)
		authButtonClick(eventStreamConstants.Context.AccountLinking, eventStreamConstants.Button.Support)
	end, {})

	local v12 = {
		titleText = v8.titleText,
		bodyText = 0,
		primaryButtonText = 0,
		secondaryButtonText = 0,
		primaryButtonCallback = 0,
		secondaryButtonCallback = 0,
		footerText = 0,
		footerCallback = 0,
		closeCentralOverlayThunk = 0
	}
	local v13 = if p2.userFacingMessage then p2.userFacingMessage else v8.bodyText
	v12.bodyText = v13
	v12.primaryButtonText = v8.primaryButtonText
	v12.secondaryButtonText = v8.secondaryButtonText
	v12.primaryButtonCallback = v9
	v12.secondaryButtonCallback = v10
	v12.footerText = v8.footerText
	v12.footerCallback = v11
	v12.closeCentralOverlayThunk = p2.closeCentralOverlayThunk
	return v12
end

local function IncompatibleAccountsAlert(p2)
	local v5 = useIncompatibleAccountsAlertProps(p2)
	return React.createElement(AccountLinkingAlert, v5)
end

local function useRetryLogInAlertProps(p2)
	local v5 = useDispatch()
	local v6 = useNavigation()

	local v7 = useAppPolicy(function(p3)
		return p3.getPlatformAccountName()
	end)

	local v9 = useLocalization({
		titleText = "Authentication.SignUp.Heading.RetryLogIn",
		bodyText = p2.alertType == AccountLinkingAlertType.RetryLogInAlreadyLinked and {
			"Authentication.SignUp.Description.AccountAlreadyLinked",
			platformAccountName = v7
		} or p2.alertType == AccountLinkingAlertType.RetryLogInConnectionFailure and "Authentication.Login.Error.PlatformAccountConnectionFailure" or "Authentication.SignUp.Response.ErrorTryAgain",
		primaryButtonText = "Authentication.SignUp.Button.RetryLogIn"
	})

	local v10 = React.useCallback(function()
		v6.navigate(appPage.PlatformAccountRouter)

		if p2.closeCentralOverlayThunk then
			v5(p2.closeCentralOverlayThunk())
		end
	end, { v6, p2.closeCentralOverlayThunk })

	return {
		titleText = v9.titleText,
		bodyText = v9.bodyText,
		primaryButtonText = v9.primaryButtonText,
		primaryButtonCallback = v10,
		closeCentralOverlayThunk = p2.closeCentralOverlayThunk
	}
end

local function RetryLogInAlert(p2)
	local v5 = useRetryLogInAlertProps(p2)
	return React.createElement(AccountLinkingAlert, v5)
end

local function AccountLinkingAlertContainer(p2)
	React.useEffect(function()
		authModalShown(eventStreamConstants.Context.AccountLinking, nil, p2.alertType)
	end, { p2.alertType })

	if p2.alertType == AccountLinkingAlertType.IncompatibleAccounts then
		return React.createElement(IncompatibleAccountsAlert, p2)
	end

	if
		p2.alertType == AccountLinkingAlertType.RetryLogInAlreadyLinked
		or p2.alertType == AccountLinkingAlertType.RetryLogInConnectionFailure
		or p2.alertType == AccountLinkingAlertType.RetryLogInGenericError
	then
		return React.createElement(RetryLogInAlert, p2)
	end

	warn("AccountLinkingAlert: Unknown alert type: " .. tostring(p2.alertType))
	return nil
end

return AccountLinkingAlertContainer
