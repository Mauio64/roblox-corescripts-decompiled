local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent
local GuiService = game:GetService("GuiService")

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local withStyle = UIBlox.Style.withStyle
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useScreenSize = RobloxAppHooks.useScreenSize
local LinkingProtocol = require(parent.LinkingProtocol)
local default = LinkingProtocol.LinkingProtocol.default
local Foundation = require(parent.Foundation)
local Text = Foundation.Text

local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local RobloxAppEnums2 = require(parent.RobloxAppEnums)
local NotificationType = RobloxAppEnums2.NotificationType
local AuthAnalytics = require(parent.AuthAnalytics)
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local authModalShown = AuthAnalytics.Events.authModalShown
local authButtonClick = AuthAnalytics.Events.authButtonClick
local defineFastString = game:DefineFastString(
	"IncompatibleAccountsSupportLink",
	"https://help.roblox.com/hc/articles/360000334523-Xbox-One-App-Trouble-logging-into-Roblox-account"
)

local AccountLinkingAlertType = require(AuthCommon.Enums.AccountLinkingAlertType)

local function AccountLinkingAlert(data)
	local buttons = {}

	if data.secondaryButtonText and data.secondaryButtonCallback then
		table.insert(buttons, {
			buttonType = ButtonType.Secondary,
			props = {
				text = data.secondaryButtonText,
				onActivated = function()
					data.secondaryButtonCallback()
				end
			}
		})
	end

	if data.primaryButtonText and data.primaryButtonCallback then
		table.insert(buttons, {
			buttonType = ButtonType.PrimarySystem,
			props = {
				text = data.primaryButtonText,
				onActivated = function()
					data.primaryButtonCallback()
				end
			}
		})
	end

	local screenSize = useScreenSize()

	local footerContent = React.useCallback(function()
		if data.footerText and data.footerCallback then
			return React.createElement(
				"Frame",
				{
					Size = UDim2.fromScale(1, 1),
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundTransparency = 1
				},
				{
					Text = React.createElement(Text, {
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

	return withStyle(function(_)
		return React.createElement(InteractiveAlert, {
			title = data.titleText,
			bodyText = data.bodyText,
			buttonStackInfo = { buttons = buttons },
			footerContent = footerContent,
			isRoactGamepadEnabled = false,
			position = UDim2.fromScale(0.5, 0.5),
			screenSize = screenSize
		})
	end)
end

local function useIncompatibleAccountsAlertProps(p)
	local v = useDispatch()
	local v2 = useNavigation()

	local v3 = useAppPolicy(function(p2)
		return p2.getPlatformAccountName()
	end)

	local v4 = useLocalization({
		titleText = "Authentication.Login.Heading.IncompatibleAccounts",
		bodyText = {
			"Authentication.Login.Response.AlreadyLinked",
			platform = v3
		},
		primaryButtonText = {
			"Authentication.Login.Button.CloseAndSwitchPlatformAccount",
			platformAccountName = v3
		},
		secondaryButtonText = "Authentication.Login.Button.UseDifferentRobloxAccount",
		footerText = "Authentication.Login.Label.LearnMore"
	})

	local primaryButtonCallback = React.useCallback(function()
		GuiService:BroadcastNotification("", NotificationType.NATIVE_EXIT)

		if p.closeCentralOverlayThunk then
			v(p.closeCentralOverlayThunk())
		end

		authButtonClick(EventStreamConstants.Context.AccountLinking, EventStreamConstants.Button.PrimaryButton)
	end, { p.closeCentralOverlayThunk })

	local secondaryButtonCallback = React.useCallback(function()
		v2.navigate(AppPage.Landing)

		if p.closeCentralOverlayThunk then
			v(p.closeCentralOverlayThunk())
		end

		authButtonClick(EventStreamConstants.Context.AccountLinking, EventStreamConstants.Button.SecondaryButton)
	end, { v2, p.closeCentralOverlayThunk })

	local footerCallback = React.useCallback(function()
		default:openURL(defineFastString)
		authButtonClick(EventStreamConstants.Context.AccountLinking, EventStreamConstants.Button.Support)
	end, {})

	local v5 = {
		titleText = v4.titleText,
		bodyText = 0,
		primaryButtonText = 0,
		secondaryButtonText = 0,
		primaryButtonCallback = 0,
		secondaryButtonCallback = 0,
		footerText = 0,
		footerCallback = 0,
		closeCentralOverlayThunk = 0
	}
	local bodyText

	if p.userFacingMessage then
		bodyText = p.userFacingMessage
	else
		bodyText = v4.bodyText
	end

	v5.bodyText = bodyText
	v5.primaryButtonText = v4.primaryButtonText
	v5.secondaryButtonText = v4.secondaryButtonText
	v5.primaryButtonCallback = primaryButtonCallback
	v5.secondaryButtonCallback = secondaryButtonCallback
	v5.footerText = v4.footerText
	v5.footerCallback = footerCallback
	v5.closeCentralOverlayThunk = p.closeCentralOverlayThunk
	return v5
end

local function IncompatibleAccountsAlert(p)
	local v = useIncompatibleAccountsAlertProps(p)
	return React.createElement(AccountLinkingAlert, v)
end

local function useRetryLogInAlertProps(p)
	local v = useDispatch()
	local v2 = useNavigation()

	local platformAccountName = useAppPolicy(function(p2)
		return p2.getPlatformAccountName()
	end)

	local v3 = useLocalization({
		titleText = "Authentication.SignUp.Heading.RetryLogIn",
		bodyText = p.alertType == AccountLinkingAlertType.RetryLogInAlreadyLinked and {
			"Authentication.SignUp.Description.AccountAlreadyLinked",
			platformAccountName = platformAccountName
		} or p.alertType == AccountLinkingAlertType.RetryLogInConnectionFailure and "Authentication.Login.Error.PlatformAccountConnectionFailure" or "Authentication.SignUp.Response.ErrorTryAgain",
		primaryButtonText = "Authentication.SignUp.Button.RetryLogIn"
	})

	local primaryButtonCallback = React.useCallback(function()
		v2.navigate(AppPage.PlatformAccountRouter)

		if p.closeCentralOverlayThunk then
			v(p.closeCentralOverlayThunk())
		end
	end, { v2, p.closeCentralOverlayThunk })

	return {
		titleText = v3.titleText,
		bodyText = v3.bodyText,
		primaryButtonText = v3.primaryButtonText,
		primaryButtonCallback = primaryButtonCallback,
		closeCentralOverlayThunk = p.closeCentralOverlayThunk
	}
end

local function RetryLogInAlert(p)
	local v = useRetryLogInAlertProps(p)
	return React.createElement(AccountLinkingAlert, v)
end

local function AccountLinkingAlertContainer(p)
	React.useEffect(function()
		authModalShown(EventStreamConstants.Context.AccountLinking, nil, p.alertType)
	end, { p.alertType })

	if p.alertType == AccountLinkingAlertType.IncompatibleAccounts then
		return React.createElement(IncompatibleAccountsAlert, p)
	end

	if
		p.alertType == AccountLinkingAlertType.RetryLogInAlreadyLinked
		or p.alertType == AccountLinkingAlertType.RetryLogInConnectionFailure
		or p.alertType == AccountLinkingAlertType.RetryLogInGenericError
	then
		return React.createElement(RetryLogInAlert, p)
	end

	warn("AccountLinkingAlert: Unknown alert type: " .. tostring(p.alertType))
	return nil
end

return AccountLinkingAlertContainer
