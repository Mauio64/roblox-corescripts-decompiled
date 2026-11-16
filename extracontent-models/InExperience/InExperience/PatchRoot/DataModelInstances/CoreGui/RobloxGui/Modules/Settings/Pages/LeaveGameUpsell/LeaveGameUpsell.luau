local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local GuiService = game:GetService("GuiService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default
local Constants = require(RobloxGui.Modules.VoiceChat.Constants)

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local Button = UIBlox.App.Button.Button
local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useStyle = UIBlox.Core.Style.useStyle
local PhoneUpsell = require(CorePackages.Workspace.Packages.PhoneUpsell)
local PhoneLegalDisclaimer = PhoneUpsell.PhoneLegalDisclaimer
local InExperienceContainer = require(CorePackages.Workspace.Packages.InExperienceContainer)
local InExperienceProviderContainer = InExperienceContainer.InExperienceProviderContainer

local PhoneUpsell2 = require(CorePackages.Workspace.Packages.PhoneUpsell)
local PostPhoneUpsellDisplayed = PhoneUpsell2.Http.Requests.PostPhoneUpsellDisplayed
local PhoneUpsell3 = require(CorePackages.Workspace.Packages.PhoneUpsell)
local PhoneUpsellController = PhoneUpsell3.PhoneUpsellController
local PhoneUpsell4 = require(CorePackages.Workspace.Packages.PhoneUpsell)
local constants = PhoneUpsell4.Constants
local RoactServiceTags = require(CorePackages.Workspace.Packages.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local Localization = require(CorePackages.Workspace.Packages.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RobloxAppHooks = require(CorePackages.Workspace.Packages.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useInputType = RoactUtils.Hooks.useInputType
local InputType = require(CorePackages.Workspace.Packages.InputType)
local InputTypeConstants = InputType.InputTypeConstants
local ReactUtils = require(CorePackages.Packages.ReactUtils)
local useEventConnection = ReactUtils.useEventConnection
local Analytics = require(CorePackages.Workspace.Packages.Analytics)
local getPlatformTarget = Analytics.getPlatformTarget
local AuthAnalytics = require(CorePackages.Workspace.Packages.AuthAnalytics)
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local leaveGame = require(RobloxGui.Modules.Settings.leaveGame)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)

local GetFFlagDisablePVUpsellDataConsent = SharedFlags.GetFFlagDisablePVUpsellDataConsent

local engineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")

local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagAddMorePhoneUpsellEvents = SharedFlags2.GetFFlagAddMorePhoneUpsellEvents

RobloxGui:WaitForChild("Modules"):WaitForChild("TenFootInterface")

local Constants2 = require(RobloxGui.Modules:WaitForChild("InGameMenu"):WaitForChild("Resources"):WaitForChild("Constants"))

local _ = {
	Incomplete = "Incomplete",
	Completed = "Completed",
	CompletedAndClosed = "CompletedAndClosed"
}

local function Initialize()
	local SettingsPageFactory = require(RobloxGui.Modules.Settings.SettingsPageFactory)
	local newPage = SettingsPageFactory:CreateNewPage()

	newPage.playsessionid = ""

	if engineFeature then
		newPage.playsessionid = RbxAnalyticsService:GetPlaySessionId()
	end

	function newPage.DontLeaveFunc(p)
		if newPage.HubRef then
			newPage.HubRef:PopMenu(p, true)
		end

		RbxAnalyticsService:SetRBXEventStream(
			Constants2.AnalyticsTargetName,
			Constants2.AnalyticsInGameMenuName,
			Constants2.AnalyticsLeaveGameName,
			{
				confirmed = Constants2.AnalyticsCancelledName,
				universeid = tostring(game.GameId),
				source = Constants2.AnalyticsLeaveGameSource,
				playsessionid = newPage.playsessionid
			}
		)
	end
	function newPage.DontLeaveFromHotkey(_, p, p2)
		if p == Enum.UserInputState.Begin then
			local v = p2.UserInputType == Enum.UserInputType.Gamepad1
				or p2.UserInputType == Enum.UserInputType.Gamepad2
				or p2.UserInputType == Enum.UserInputType.Gamepad3
				or p2.UserInputType == Enum.UserInputType.Gamepad4

			newPage.DontLeaveFunc(v)
		end
	end
	function newPage.DontLeaveFromButton(p)
		newPage.DontLeaveFunc(p)
	end

	newPage.TabHeader = nil

	newPage.Page.Name = "LeaveGameUpsellPage"
	newPage.ShouldShowBottomBar = false
	newPage.ShouldShowHubBar = false
	newPage.DisableTopPadding = true

	function newPage.UpsellComponent(props)
		local upsellType = newPage.upsellType
		local v = useStyle()
		local v2 = useLocalization({
			headerKey = upsellType == Constants.PHONE_UPSELL_VALUE_PROP.VoiceChat and "Feature.VerificationUpsell.Heading.UnlockVoiceChat" or "Feature.VerificationUpsell.Heading.DontLoseAccess",
			bodyKey = upsellType == Constants.PHONE_UPSELL_VALUE_PROP.VoiceChat and "Feature.VerificationUpsell.Description.UnlockVoiceChatBody" or "Feature.VerificationUpsell.Description.RecoverAccountEasily",
			voiceConsent = "Feature.VerificationUpsell.Description.VoiceLegalConsent2",
			voiceDisclaimer = "Feature.VerificationUpsell.Description.VoiceLegalDisclaimer2",
			button = "Feature.VerificationUpsell.Action.AddPhoneNumber",
			termsOfUse = "Feature.VerificationUpsell.Action.SMSTerms",
			privacyPolicy = "Feature.VerificationUpsell.Action.Privacy"
		})

		v2.voiceDisclaimer = v2.voiceDisclaimer:gsub("{buttonText}", v2.button)
		local showLegalTextCheckbox = useAppPolicy(function(p)
			return upsellType == Constants.PHONE_UPSELL_VALUE_PROP.VoiceChat and p.RequireExplicitVoiceConsent()
		end)

		local state, setState = React.useState(false)

		local createElement = React.createElement
		local v3 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = props.LayoutOrder
		}
		local v4 = {
			ListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 12)
			}),
			Header = React.createElement(StyledTextLabel, {
				text = v2.headerKey,
				fontStyle = v.Font.Header2,
				colorStyle = v.Theme.TextEmphasis,
				layoutOrder = 1
			}),
			Body = React.createElement(StyledTextLabel, {
				text = v2.bodyKey,
				textWrapped = true,
				size = UDim2.new(1, 0, 0, 0),
				automaticSize = Enum.AutomaticSize.Y,
				fontStyle = v.Font.Body,
				lineHeight = 1.1,
				colorStyle = v.Theme.TextDefault,
				layoutOrder = 2
			}),
			Button = React.createElement(Button, {
				buttonType = ButtonType.Secondary,
				size = UDim2.new(1, 0, 0, v.Tokens.Size.Size_1200),
				layoutOrder = 3,
				text = v2.button,
				onActivated = function()
					newPage.HubRef:SetVisibility(false, true)

					if GetFFlagAddMorePhoneUpsellEvents() then
						RbxAnalyticsService:SendEventDeferred(
							getPlatformTarget(),
							"verificationUpsell",
							"modalAction",
							{
								origin = props.origin,
								btn = EventStreamConstants.Button.Continue,
								section = props.section
							}
						)
					end

					PhoneUpsellController.openPhoneUpsell({
						origin = props.origin,
						eventContext = "verificationUpsell",
						onSuccessBeforeToast = function()
							default:DisablePhoneVerificationUpsell()
							props.onUpsellComplete()
							newPage.HubRef:SetVisibility(true, false)
							newPage.HubRef:SwitchToPage(newPage.HubRef.LeaveGameUpsellPage, true)
						end,
						onSuccess = function()
							if upsellType == Constants.PHONE_UPSELL_VALUE_PROP.VoiceChat then
								default:EnableVoice()
								props.setVoiceEnabled(true)
							end
						end
					})
				end,
				isDisabled = showLegalTextCheckbox and not state
			}),
			PhoneLegalDisclaimer = 0
		}
		local phoneLegalDisclaimer

		if not GetFFlagDisablePVUpsellDataConsent() then
			local createElement2 = React.createElement
			local legalText

			if showLegalTextCheckbox then
				legalText = v2.voiceConsent
			else
				legalText = v2.voiceDisclaimer
			end

			phoneLegalDisclaimer = createElement2(PhoneLegalDisclaimer, {
				legalText = legalText,
				termsOfUse = v2.termsOfUse,
				privacyPolicy = v2.privacyPolicy,
				showLegalText = upsellType == Constants.PHONE_UPSELL_VALUE_PROP.VoiceChat,
				showLegalButtons = true,
				showLegalTextCheckbox = showLegalTextCheckbox,
				legalTextChecked = state,
				setLegalTextChecked = function()
					setState(not state)
				end,
				onTermsOfUseClick = function()
					if GetFFlagAddMorePhoneUpsellEvents() then
						RbxAnalyticsService:SendEventDeferred(
							getPlatformTarget(),
							"verificationUpsell",
							"modalAction",
							{
								origin = props.origin,
								field = "termsOfService",
								section = props.section
							}
						)
					end

					props.showWebpage(constants.TERMS_OF_SERVICE_URL)
				end,
				onPrivacyPolicyClick = function()
					if GetFFlagAddMorePhoneUpsellEvents() then
						RbxAnalyticsService:SendEventDeferred(
							getPlatformTarget(),
							"verificationUpsell",
							"modalAction",
							{
								origin = props.origin,
								field = "privacyPolicy",
								section = props.section
							}
						)
					end

					props.showWebpage(constants.PRIVACY_POLICY_URL)
				end,
				LayoutOrder = 4
			})
		end

		v4.PhoneLegalDisclaimer = phoneLegalDisclaimer
		return createElement("Frame", v3, v4)
	end

	function newPage.LeaveGameComponent(props)
		local v = useStyle()
		local v2 = useLocalization({
			confirmLeave = "Feature.VerificationUpsell.Action.ConfirmLeave",
			dontLeave = "Feature.VerificationUpsell.Action.DontLeave",
			returnWithVoice = "Feature.VerificationUpsell.Action.ReturnWithVoice"
		})

		local state, setState = React.useState("Incomplete")
		local v3 = state == "Incomplete"
		local upsellType = newPage.upsellType
		local origin = upsellType == Constants.PHONE_UPSELL_VALUE_PROP.VoiceChat and "exitConfirmationScreenVoice"
			or "exitConfirmationScreenSecurity"

		local section = GetFFlagAddMorePhoneUpsellEvents()
			and (state == "Incomplete" and "entry" or "verifyPhoneSuccess")
			or nil

		local ref = React.useRef(nil)
		local state2, setState2 = React.useState(false)

		local v4 = useRoactService(RoactNetworking)

		local v5 = useInputType()

		local function fn()
			if v5 ~= InputTypeConstants.Touch then
				GuiService.SelectedCoreObject = ref.current
			end

			ContextActionService:BindCoreAction(
				"LeaveGameCancelAction",
				newPage.DontLeaveFromHotkey,
				false,
				Enum.KeyCode.ButtonB
			)

			if not newPage.postSent then
				PostPhoneUpsellDisplayed(v4, Constants.EXIT_CONFIRMATION_PHONE_UPSELL_IXP_LAYER, os.time(), true, true):catch(function(_) end)

				if GetFFlagAddMorePhoneUpsellEvents() then
					RbxAnalyticsService:SendEventDeferred(getPlatformTarget(), "verificationUpsell", "modalAction", {
						origin = props.origin,
						aType = EventStreamConstants.ActionType.Shown,
						section = props.section
					})
				end

				newPage.postSent = true
			end
		end

		local function fn2()
			ContextActionService:UnbindCoreAction("LeaveGameCancelAction")

			if state == "Completed" then
				setState("CompletedAndClosed")
			end
		end

		useEventConnection(newPage.Displayed.Event, fn)
		useEventConnection(newPage.Hidden.Event, fn2)

		local v6 = (RobloxGui.AbsoluteSize.Y < 500 or RobloxGui.AbsoluteSize.X < 500) and 0 or 200

		local createElement = React.createElement
		local v7 = {
			Size = UDim2.new(1, 0, 0, 0),
			Position = UDim2.new(0, 0, 0, v6),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1
		}

		local children = {
			ListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			LeaveGame = 0,
			TopSpacer = 0,
			UpsellComponents = 0
		}

		local createElement2 = React.createElement
		local v8 = {
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 1
		}

		local v9 = {
			ListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, v.Tokens.Size.Size_600),
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			LeaveGameButtons = 0
		}

		local createElement3 = React.createElement

		local v10 = {
			buttonType = ButtonType.PrimarySystem,
			isDefaultChild = true,
			props = {
				layoutOrder = 1,
				text = v2.confirmLeave,
				onActivated = function()
					if
						not state2
						and (state == "Completed" or state == "CompletedAndClosed")
						and upsellType == Constants.PHONE_UPSELL_VALUE_PROP.VoiceChat
					then
						default:EnableVoice()
						setState2(true)
					end

					if GetFFlagAddMorePhoneUpsellEvents() then
						RbxAnalyticsService:SendEventDeferred(
							getPlatformTarget(),
							"verificationUpsell",
							"formInteraction",
							{ origin = origin, btn = "confirmLeave", section = section }
						)
					end

					leaveGame(false)
				end,
				buttonRef = ref
			}
		}

		local v11 = { buttonType = ButtonType.Secondary, props = 0 }
		local text

		if state == "Completed" and upsellType == Constants.PHONE_UPSELL_VALUE_PROP.VoiceChat then
			text = v2.returnWithVoice
		else
			text = v2.dontLeave
		end

		v11.props = {
			layoutOrder = 2,
			text = text,
			onActivated = function()
				if GetFFlagAddMorePhoneUpsellEvents() then
					if state == "Completed" and upsellType == Constants.PHONE_UPSELL_VALUE_PROP.VoiceChat then
						RbxAnalyticsService:SendEventDeferred(
							getPlatformTarget(),
							"verificationUpsell",
							"formInteraction",
							{ origin = origin, btn = "returnWithVoice", section = section }
						)
					elseif state == "Incomplete" then
						RbxAnalyticsService:SendEventDeferred(
							getPlatformTarget(),
							"verificationUpsell",
							"modalAction",
							{
								origin = origin,
								aType = EventStreamConstants.ActionType.Dismiss,
								section = section
							}
						)
					end
				end

				newPage.DontLeaveFromButton()
			end
		}
		v9.LeaveGameButtons = createElement3(ButtonStack, {
			buttons = { v10, v11 },
			buttonHeight = v.Tokens.Size.Size_1200,
			disableGamepadRefs = true,
			isRoactGamepadEnabled = false
		})
		children.LeaveGame = createElement2("Frame", v8, v9)

		children.TopSpacer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, v.Tokens.Size.Size_600)
		})
		local upsellComponents

		if v3 then
			upsellComponents = React.createElement(React.Fragment, {}, {
				Divider = React.createElement("Frame", {
					LayoutOrder = 3,
					BackgroundColor3 = v.Tokens.Color.Stroke.Emphasis.Color3,
					BackgroundTransparency = v.Tokens.Color.Stroke.Emphasis.Transparency,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 1)
				}),
				BottomSpacer = React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 4,
					Size = UDim2.new(1, 0, 0, v.Tokens.Size.Size_600)
				}),
				Upsell = React.createElement(newPage.UpsellComponent, {
					origin = origin,
					section = section,
					LayoutOrder = 5,
					showWebpage = props.showWebpage,
					onUpsellComplete = function()
						setState("Completed")
					end,
					setVoiceEnabled = setState2
				})
			})
		end

		children.UpsellComponents = upsellComponents
		return createElement("Frame", v7, children)
	end

	local element = React.createElement(
		InExperienceProviderContainer,
		{},
		React.createElement(newPage.LeaveGameComponent, {
			showWebpage = function() end
		}, {})
	)

	newPage.handle = Roact.mount(element, newPage.Page, "LeaveGameUpsell")

	newPage.Page.Size = UDim2.new(1, 0, 0, 0)
	newPage.Page.AutomaticSize = Enum.AutomaticSize.Y

	return newPage
end

local initialize = Initialize()

function initialize:SetUpsellProp(upsellType)
	if upsellType == Constants.PHONE_UPSELL_VALUE_PROP.None then
		return
	end

	self.upsellType = upsellType
	self.handle = Roact.update(
		self.handle,
		React.createElement(InExperienceProviderContainer, {}, React.createElement(self.LeaveGameComponent, {
			showWebpage = function() end
		}, {}))
	)
end

return initialize
