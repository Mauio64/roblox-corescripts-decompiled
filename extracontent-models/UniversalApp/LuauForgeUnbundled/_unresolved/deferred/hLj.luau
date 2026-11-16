local CorePackages = game:GetService("CorePackages")
local IXPService = game:GetService("IXPService")

local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local module = require("@luauforge/bundled/eda")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local appPermissions = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppPermissions
local Cryo = require(CorePackages.Packages.Cryo)

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local withStyle = UIBlox.Style.withStyle
local module2 = require("@luauforge/bundled/edC")
local partialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal

local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

local module4 = require("@luauforge/deferred/hLk")

local module5 = require("@luauforge/bundled/eee")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dCu").NavigationCommands
else
	navigationCommands = nil
end

local module6 = require("@luauforge/bundled/fvl")
local module7 = require("@luauforge/bundled/ecW")
local images = UIBlox.App.ImageSet.Images

local module8 = require("@luauforge/bundled/dCp")
local buttonType = UIBlox.App.Button.Enum.ButtonType
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local postUserOptIn = require("@luauforge/bundled/dyK").PostUserOptIn
local module9 = require("@luauforge/deferred/hLl")

local fStringVoiceUpsellLayer = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFStringVoiceUpsellLayer()

local extended = Roact.PureComponent:extend("EnableVoiceModal")

local module10 = require("@luauforge/deferred/hLm")

local module11 = require("@luauforge/deferred/hLn")

function extended:init()
	self.isMounted = false

	self.state = { dontShowModalAgain = false }

	if module11() then
		self.state.consentGiven = not self.props.RequireExplicitVoiceConsent
	end

	function self.enableVoice()
		self.props.voiceUpsellAnalytics.enableVoiceChatUpsell()
		postUserOptIn(self.props.networking, true, true):andThen(function(p2)
			if p2 then
				self.props.launchGame()
				self.props.closeOverlay()
				self.props.setShowVoiceOptIn({
					voiceEnabled = true,
					showVoiceOptInOverlay = false
				})
			else
				self.props.setNetworkingErrorToast()
				logging.warn("Error getting UserOptIn. " .. tostring(p2))
			end
		end):catch(function()
			self.props.setNetworkingErrorToast()
			logging.warn("Exception posting PostUserOptIn")
		end)
	end

	function self.joinAnyways()
		self.props.voiceUpsellAnalytics.joinWithoutVoiceChat(self.state.dontShowModalAgain == true)

		if self.state.dontShowModalAgain or module11() then
			self.props.setShowVoiceOptIn({
				voiceEnabled = false,
				showVoiceOptInOverlay = false
			})
		end

		self.props.launchGame()
		self.props.closeOverlay()
	end

	function self.onOverlayOptOutCheckBoxActivated(p2)
		if self.isMounted then
			module10(self.props.networking, not p2):catch(function(p3)
				logging.warn("Error posting ShowOverlay for AgeVerificationOptOutCheckbox. " .. tostring(p3))
			end)

			self:setState({ dontShowModalAgain = p2 })
		end
	end

	function self.consentActivated()
		if self.isMounted then
			self:setState({
				consentGiven = not self.state.consentGiven
			})
		end
	end

	function self.closeEnableVoiceModal()
		if module11() then
			self.props.setShowVoiceOptIn({ showVoiceOptInOverlay = false })
		end

		self.props.voiceUpsellAnalytics.closeEnableVoiceChatModal()
		self.props.closeOverlay()
	end
end

function extended:didMount()
	self.isMounted = true

	if module11() and self.props.postUserSeenModal then
		self.props.postUserSeenModal():andThen(function()
			logging.warn("UserSeenModal request succeeded")
		end):catch(function(p3)
			logging.warn("UserSeenModal request failed")
		end)
	end

	if fStringVoiceUpsellLayer ~= "" then
		IXPService:LogUserLayerExposure(fStringVoiceUpsellLayer)
	end

	self.props.voiceUpsellAnalytics.showEnableVoiceChatModal()
end

function extended:willUnmount()
	self.isMounted = false
end

function extended.render(data)
	local showNewContent = data.props.showNewContent
	return module2(Cryo.Dictionary.join({
		EnableVoiceChat = "Verification.Identity.Label.EnableVoiceChat",
		LearnMoreAboutVoiceRecording = "Verification.Identity.Label.LearnMoreAboutVoiceRecording",
		SkipVoiceChat = "Verification.Identity.Action.SkipVoiceChat",
		UsesVoiceChat = "Verification.Identity.Label.UsesVoiceChat",
		DontShowAgain = "Verification.Identity.Label.DontShowAgain",
		ConsentText = "Verification.Identity.Label.VoiceCollectionConsent",
		EnableVoiceContent1 = "Verification.Identity.Label.EnableVoiceChat1",
		EnableVoiceContent2 = "Verification.Identity.Label.EnableVoiceChat2",
		ClickToConsent = "Verification.Identity.Label.VoiceCollectionConsent2",
		LetsChat = "Verification.Identity.Heading.LetsChat",
		VoiceFAQ = "InGame.CommonUI.Label.FAQWebviewTitle"
	}, showNewContent and {
		EnableVoiceChat = "Verification.Identity.Label.EnableMicrophone",
		SkipVoiceChat = "Verification.Identity.Label.JoinWithoutMicrophone",
		EnableVoiceContent1 = "Verification.Identity.Label.EnableChatWithVoice",
		LetsChat = "Verification.Identity.Heading.YourNewWayToChat"
	} or {}, {
		LetsChat = "Verification.Identity.Heading.V2LetsChat",
		ClickToConsent = "Verification.Identity.Label.V2ClickToConsent",
		EnableVoiceChat = "Verification.Identity.Label.V2EnableVoiceChat",
		EnableVoiceContent1 = "Verification.Identity.Label.V2EnableVoiceChat1",
		SkipVoiceChat = "Verification.Identity.Label.V2JoinWithout"
	}))(function(data2)
		return withStyle(function(props)
			local theme = props.Theme
			local captionHeader = props.Font.CaptionHeader
			local v5 = captionHeader.RelativeSize * props.Font.BaseSize
			local v6 = not data.props.RequireExplicitVoiceConsent

			local createElement = Roact.createElement

			local join = Cryo.Dictionary.join
			local v8 = {
				MainText = { data2.UsesVoiceChat },
				LocalizedOptOutText = data2.DontShowAgain,
				centerCheckbox = true,
				onActivated = data.onOverlayOptOutCheckBoxActivated,
				checkboxSelected = data.state.dontShowModalAgain
			}
			local v9

			if module11() then
				v9 = {
					MainText = {
						{
							content = data2.EnableVoiceContent1,
							image = images["icons/graphic/voicechat_large"]
						},
						"",
						{
							content = data2.EnableVoiceContent2,
							image = images["icons/graphic/hearts_large"]
						}
					},
					LocalizedOptOutText = false,
					centerCheckbox = false,
					showConsentCheckbox = true,
					consentText = 0,
					consentActivated = 0,
					consentSelected = 0,
					hideConsent = 0
				}

				local v10 = if v6 then data2.ClickToConsent else data2.ConsentText
				v9.consentText = v10

				v9.consentActivated = data.consentActivated
				v9.consentSelected = data.state.consentGiven
				v9.hideConsent = v6
			else
				v9 = {}
			end

			local element = createElement(module4, join(v8, v9))

			local v11 = {
				buttonType = buttonType.Secondary,
				props = { onActivated = data.joinAnyways, text = data2.SkipVoiceChat }
			}

			local v13 = if showNewContent then buttonType.Secondary else buttonType.PrimarySystem

			local v15 = if module11() then not data.state.consentGiven else nil
			local v10 = {
				v11,
				{
					buttonType = v13,
					props = {
						isDisabled = v15,
						onActivated = data.enableVoice,
						text = data2.EnableVoiceChat
					}
				}
			}

			local createElement2 = Roact.createElement
			local v18 = if module11() then data2.LetsChat else data2.EnableVoiceChat
			return createElement2(partialPageModal, {
				title = v18,
				screenSize = data.props.screenSize,
				onCloseClicked = data.closeEnableVoiceModal,
				buttonStackProps = v10 and { buttonHeight = 48, buttons = v10 },
				footerContent = function()
					local createFragment = Roact.createFragment
					local v19 = {
						Divider = Roact.createElement("Frame", {
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.new(0.5, 0, 0, 16),
							BorderSizePixel = 0,
							BackgroundColor3 = theme.Divider.Color,
							BackgroundTransparency = theme.Divider.Transparency,
							LayoutOrder = 2,
							Size = UDim2.new(1, 0, 0, 1)
						}),
						FooterText = 0
					}

					local createElement3 = Roact.createElement
					local v21 = {}
					v21.Text = data2.LearnMoreAboutVoiceRecording or "Learn More about Voice Recording"
					v21.AutomaticSize = Enum.AutomaticSize.X
					v21.Position = UDim2.new(0.5, 0, 0.5, 24)
					v21.TextColor3 = props.Theme.TextEmphasis.Color
					v21.AnchorPoint = Vector2.new(0.5, 0.5)
					v21.BackgroundTransparency = 1
					local v22 = if not foundationFontFaceMigration then captionHeader.Font else nil
					v21.Font = v22

					local v23 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.CaptionLarge.Font) else nil
					v21.FontFace = v23

					v21.TextSize = v5
					v21.BorderSizePixel = 0
					v21.RichText = true
					v21.TextXAlignment = Enum.TextXAlignment.Left
					v21.Size = UDim2.new(0, 0, 0, 20)
					v21[Roact.Event.Activated] = function()
						data.props.openVoiceFAQ(data2.VoiceFAQ or "Voice FAQ")
						data.props.voiceUpsellAnalytics.learnMoreAboutVoiceRecordingUpsell()
					end

					v19.FooterText = createElement3("TextButton", v21)
					return createFragment(v19)
				end
			}, {
				OuterFrame = Roact.createElement(
					"Frame",
					{
						Size = UDim2.new(1, 0, 0, 0),
						BackgroundTransparency = 1,
						AutomaticSize = Enum.AutomaticSize.Y
					},
					{
						ListLayout = Roact.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Vertical,
							Padding = UDim.new(0, 24),
							SortOrder = Enum.SortOrder.LayoutOrder,
							HorizontalAlignment = Enum.HorizontalAlignment.Center
						}),
						Padding = Roact.createElement("UIPadding", {
							PaddingTop = UDim.new(0, 24),
							PaddingBottom = UDim.new(0, 24)
						}),
						ContentFrame = Roact.createElement(
							"Frame",
							{
								LayoutOrder = 2,
								Size = UDim2.new(1, 0, 0, 0),
								AutomaticSize = Enum.AutomaticSize.Y,
								BackgroundTransparency = 1
							},
							{ Content = element }
						)
					}
				)
			})
		end)
	end)
end

local v5 = roactAppPolicy.connect(function(p2, p3)
	return {
		showNewContent = p2.getGameInfoShowChatFeatures()
	}
end)(extended)

local v6 = roactServices.connect({
	networking = module,
	permissions = appPermissions,
	voiceUpsellAnalytics = module9
})(v5)

return RoactRodux.connect(function(p2, p3)
	return { formFactor = p2.FormFactor, screenSize = p2.ScreenSize }
end, function(callback)
	return {
		closeOverlay = function()
			callback(module6())
		end,
		setNetworkingErrorToast = function(p2)
			callback(module7({ HttpError = Enum.HttpError.OK }))
		end,
		openVoiceFAQ = function(p2)
			local v7 = {
				name = module8.GenericWebPage,
				detail = string.format("%sinfo/voice-faq", Url.BASE_URL),
				extraProps = { title = p2 }
			}

			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.down(navigationCommands.fromLegacyPage(v7))
			end

			return callback(module5(v7))
		end
	}
end)(v6)
