local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local GuiService = game:GetService("GuiService")
local React = require(AuthCommonParent.React)
local UIBlox = require(AuthCommonParent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local withStyle = UIBlox.Style.withStyle
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useScreenSize = require(AuthCommonParent.RobloxAppHooks).useScreenSize
local default = require(AuthCommonParent.LinkingProtocol).LinkingProtocol.default
local Text = require(AuthCommonParent.Foundation).Text
local useAppPolicy = require(AuthCommonParent.UniversalAppPolicy).useAppPolicy
local useDispatch = require(AuthCommonParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalization = require(AuthCommonParent.Localization).Hooks.useLocalization
local useNavigation = require(AuthCommonParent.Navigation).useNavigation
local AppPage = require(AuthCommonParent.RobloxAppEnums).AppPage
local NotificationType = require(AuthCommonParent.RobloxAppEnums).NotificationType
local AuthAnalytics = require(AuthCommonParent.AuthAnalytics)
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local authModalShown = AuthAnalytics.Events.authModalShown
local authButtonClick = AuthAnalytics.Events.authButtonClick
local v22 = game:DefineFastString("IncompatibleAccountsSupportLink", "https://help.roblox.com/hc/articles/360000334523-Xbox-One-App-Trouble-logging-into-Roblox-account")
local AccountLinkingAlertType = require(AuthCommon.Enums.AccountLinkingAlertType)

local function AccountLinkingAlert(t1: {[any]: any}) -- line: 51
	-- upvalues: ButtonType (copy), useScreenSize (copy), React (copy), Text (copy), withStyle (copy), InteractiveAlert (copy)
	local t2 = {}

	if t1.secondaryButtonText and t1.secondaryButtonCallback then
		table.insert(t2, {
			buttonType = ButtonType.Secondary,
			props = {
				text = t1.secondaryButtonText,
				onActivated = function() -- line: 59
					-- upvalues: t1 (copy)
					t1.secondaryButtonCallback()
				end
			}
		})
	end

	if t1.primaryButtonText and t1.primaryButtonCallback then
		table.insert(t2, {
			buttonType = ButtonType.PrimarySystem,
			props = {
				text = t1.primaryButtonText,
				onActivated = function() -- line: 71
					-- upvalues: t1 (copy)
					t1.primaryButtonCallback()
				end
			}
		})
	end

	local v32 = useScreenSize()
	local v33 = React.useCallback(function() -- line: 80
		-- upvalues: t1 (copy), React (copy), Text (copy)
		if t1.footerText and t1.footerCallback then
			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				AutomaticSize = Enum.AutomaticSize.XY
			}, {
				Text = React.createElement(Text, {
					Text = t1.footerText,
					AutomaticSize = Enum.AutomaticSize.XY,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					onActivated = t1.footerCallback
				})
			})
		end

		return nil
	end, {
		t1.footerText,
		t1.footerCallback
	})

	return withStyle(function(_) -- line: 99
		-- upvalues: React (copy), InteractiveAlert (copy), t1 (copy), t2 (copy), v33 (copy), v32 (copy)
		return React.createElement(InteractiveAlert, {
			isRoactGamepadEnabled = false,
			title = t1.titleText,
			bodyText = t1.bodyText,
			buttonStackInfo = {
				buttons = t2
			},
			footerContent = v33,
			position = UDim2.fromScale(0.5, 0.5),
			screenSize = v32
		})
	end)
end
local function useIncompatibleAccountsAlertProps(t3: {[any]: any}) -- line: 114
	-- upvalues: useDispatch (copy), useNavigation (copy), useAppPolicy (copy), useLocalization (copy), React (copy), GuiService (copy), NotificationType (copy), authButtonClick (copy), EventStreamConstants (copy), AppPage (copy), default (copy), v22 (copy)
	local v35 = useDispatch()
	local v36 = useNavigation()
	local v37 = useAppPolicy(function(p2) -- line: 118
		return p2.getPlatformAccountName()
	end)
	local v38 = useLocalization({
		titleText = "Authentication.Login.Heading.IncompatibleAccounts",
		secondaryButtonText = "Authentication.Login.Button.UseDifferentRobloxAccount",
		footerText = "Authentication.Login.Label.LearnMore",
		bodyText = {
			"Authentication.Login.Response.AlreadyLinked",
			platform = v37
		},
		primaryButtonText = {
			"Authentication.Login.Button.CloseAndSwitchPlatformAccount",
			platformAccountName = v37
		}
	})
	local v39 = React.useCallback(function() -- line: 133
		-- upvalues: GuiService (copy), NotificationType (copy), t3 (copy), v35 (copy), authButtonClick (copy), EventStreamConstants (copy)
		GuiService:BroadcastNotification("", NotificationType.NATIVE_EXIT)

		if t3.closeCentralOverlayThunk then
			v35(t3.closeCentralOverlayThunk())
		end

		authButtonClick(EventStreamConstants.Context.AccountLinking, EventStreamConstants.Button.PrimaryButton)
	end, { t3.closeCentralOverlayThunk })
	local v40 = React.useCallback(function() -- line: 141
		-- upvalues: v36 (copy), AppPage (copy), t3 (copy), v35 (copy), authButtonClick (copy), EventStreamConstants (copy)
		v36.navigate(AppPage.Landing)

		if t3.closeCentralOverlayThunk then
			v35(t3.closeCentralOverlayThunk())
		end

		authButtonClick(EventStreamConstants.Context.AccountLinking, EventStreamConstants.Button.SecondaryButton)
	end, {
		v36,
		t3.closeCentralOverlayThunk
	})
	local v41 = React.useCallback(function() -- line: 149
		-- upvalues: default (copy), v22 (copy), authButtonClick (copy), EventStreamConstants (copy)
		default:openURL(v22)
		authButtonClick(EventStreamConstants.Context.AccountLinking, EventStreamConstants.Button.Support)
	end, {})

	return {
		titleText = v38.titleText,
		bodyText = if not t3.userFacingMessage then v38.bodyText else t3.userFacingMessage,
		primaryButtonText = v38.primaryButtonText,
		secondaryButtonText = v38.secondaryButtonText,
		primaryButtonCallback = v39,
		secondaryButtonCallback = v40,
		footerText = v38.footerText,
		footerCallback = v41,
		closeCentralOverlayThunk = t3.closeCentralOverlayThunk
	}
end
local function IncompatibleAccountsAlert(t4: {[any]: any}) -- line: 167
	-- upvalues: useIncompatibleAccountsAlertProps (copy), React (copy), AccountLinkingAlert (copy)
	local v43 = useIncompatibleAccountsAlertProps(t4)

	return React.createElement(AccountLinkingAlert, v43)
end
local function useRetryLogInAlertProps(t5: {[any]: any}) -- line: 172
	-- upvalues: useDispatch (copy), useNavigation (copy), useAppPolicy (copy), AccountLinkingAlertType (copy), useLocalization (copy), React (copy), AppPage (copy)
	local v45 = useDispatch()
	local v46 = useNavigation()
	local v47 = useAppPolicy(function(p3) -- line: 176
		return p3.getPlatformAccountName()
	end)
	local v48 = if t5.alertType ~= AccountLinkingAlertType.RetryLogInAlreadyLinked then t5.alertType ~= AccountLinkingAlertType.RetryLogInConnectionFailure and "Authentication.SignUp.Response.ErrorTryAgain" or "Authentication.Login.Error.PlatformAccountConnectionFailure" else {
		"Authentication.SignUp.Description.AccountAlreadyLinked",
		platformAccountName = v47
	}
	local v49 = useLocalization({
		titleText = "Authentication.SignUp.Heading.RetryLogIn",
		primaryButtonText = "Authentication.SignUp.Button.RetryLogIn",
		bodyText = v48
	})
	local v50 = React.useCallback(function() -- line: 196
		-- upvalues: v46 (copy), AppPage (copy), t5 (copy), v45 (copy)
		v46.navigate(AppPage.PlatformAccountRouter)

		if t5.closeCentralOverlayThunk then
			v45(t5.closeCentralOverlayThunk())
		end
	end, {
		v46,
		t5.closeCentralOverlayThunk
	})

	return {
		titleText = v49.titleText,
		bodyText = v49.bodyText,
		primaryButtonText = v49.primaryButtonText,
		primaryButtonCallback = v50,
		closeCentralOverlayThunk = t5.closeCentralOverlayThunk
	}
end
local function RetryLogInAlert(t6: {[any]: any}) -- line: 212
	-- upvalues: useRetryLogInAlertProps (copy), React (copy), AccountLinkingAlert (copy)
	local v52 = useRetryLogInAlertProps(t6)

	return React.createElement(AccountLinkingAlert, v52)
end
local function AccountLinkingAlertContainer(t7: {[any]: any}) -- line: 217
	-- upvalues: React (copy), authModalShown (copy), EventStreamConstants (copy), AccountLinkingAlertType (copy), IncompatibleAccountsAlert (copy), RetryLogInAlert (copy)
	React.useEffect(function() -- line: 218
		-- upvalues: authModalShown (copy), EventStreamConstants (copy), t7 (copy)
		authModalShown(EventStreamConstants.Context.AccountLinking, nil, t7.alertType)
	end, { t7.alertType })

	if t7.alertType == AccountLinkingAlertType.IncompatibleAccounts then
		return React.createElement(IncompatibleAccountsAlert, t7)
	end

	if t7.alertType == AccountLinkingAlertType.RetryLogInAlreadyLinked or t7.alertType == AccountLinkingAlertType.RetryLogInConnectionFailure or t7.alertType == AccountLinkingAlertType.RetryLogInGenericError then
		return React.createElement(RetryLogInAlert, t7)
	end

	warn("AccountLinkingAlert: Unknown alert type: " .. tostring(t7.alertType))

	return nil
end

return AccountLinkingAlertContainer
