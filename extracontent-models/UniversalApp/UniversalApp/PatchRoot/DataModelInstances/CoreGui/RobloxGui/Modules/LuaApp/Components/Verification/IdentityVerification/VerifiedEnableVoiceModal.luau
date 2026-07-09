local CorePackages = game:GetService("CorePackages")
local IXPService = game:GetService("IXPService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local AppPermissions = require(CorePackages.Workspace.Packages.RoactServiceTags).AppPermissions
local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local withLocalization = require(Modules.LuaApp.withLocalization)
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local Url = require(Modules.LuaApp.Http.Url)
local IdentityVerificationModalContent = require(Modules.LuaApp.Components.Verification.IdentityVerification.IdentityVerificationModalContent)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v19 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local SetNetworkingErrorToast = require(Modules.LuaApp.Thunks.SetNetworkingErrorToast)
local Images = UIBlox.App.ImageSet.Images
local AppPage = require(Modules.LuaApp.AppPage)
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local PostUserOptIn = require(CorePackages.Workspace.Packages.VoiceChat).PostUserOptIn
local VoiceUpsellAnalytics = require(Modules.LuaApp.Analytics.Events.VoiceUpsellAnalytics)
local v28 = require(CorePackages.Workspace.Packages.SharedFlags).GetFStringVoiceUpsellLayer()
local v29 = Roact.PureComponent:extend("EnableVoiceModal")
local PostAgeVerificationOptOutCheckbox = require(Modules.LuaApp.Http.Requests.PostAgeVerificationOptOutCheckbox)
local GetFFlagVoiceUpsellConsentCheckbox = require(Modules.LuaApp.Flags.GetFFlagVoiceUpsellConsentCheckbox)

function v29.init(p1) -- line: 51
	-- upvalues: GetFFlagVoiceUpsellConsentCheckbox (copy), PostUserOptIn (copy), Logging (copy), PostAgeVerificationOptOutCheckbox (copy)
	p1.isMounted = false
	p1.state = {
		dontShowModalAgain = false
	}

	if GetFFlagVoiceUpsellConsentCheckbox() then
		p1.state.consentGiven = not p1.props.RequireExplicitVoiceConsent
	end

	function p1.enableVoice() -- line: 62
		-- upvalues: p1 (copy), PostUserOptIn (copy), Logging (copy)
		p1.props.voiceUpsellAnalytics.enableVoiceChatUpsell()
		PostUserOptIn(p1.props.networking, true, true):andThen(function(p2) -- line: 65
			-- upvalues: p1 (copy), Logging (copy)
			if p2 then
				p1.props.launchGame()
				p1.props.closeOverlay()
				p1.props.setShowVoiceOptIn({
					voiceEnabled = true,
					showVoiceOptInOverlay = false
				})

				return
			end

			p1.props.setNetworkingErrorToast()
			Logging.warn("Error getting UserOptIn. " .. tostring(p2))
		end):catch(function() -- line: 75
			-- upvalues: p1 (copy), Logging (copy)
			p1.props.setNetworkingErrorToast()
			Logging.warn("Exception posting PostUserOptIn")
		end)
	end
	function p1.joinAnyways() -- line: 81
		-- upvalues: p1 (copy), GetFFlagVoiceUpsellConsentCheckbox (copy)
		p1.props.voiceUpsellAnalytics.joinWithoutVoiceChat(p1.state.dontShowModalAgain == true)

		if p1.state.dontShowModalAgain or GetFFlagVoiceUpsellConsentCheckbox() then
			p1.props.setShowVoiceOptIn({
				voiceEnabled = false,
				showVoiceOptInOverlay = false
			})
		end

		p1.props.launchGame()
		p1.props.closeOverlay()
	end
	function p1.onOverlayOptOutCheckBoxActivated(p3) -- line: 90
		-- upvalues: p1 (copy), PostAgeVerificationOptOutCheckbox (copy), Logging (copy)
		if p1.isMounted then
			PostAgeVerificationOptOutCheckbox(p1.props.networking, not p3):catch(function(p4) -- line: 93
				-- upvalues: Logging (copy)
				Logging.warn("Error posting ShowOverlay for AgeVerificationOptOutCheckbox. " .. tostring(p4))
			end)
			p1:setState({
				dontShowModalAgain = p3
			})
		end
	end
	function p1.consentActivated() -- line: 106
		-- upvalues: p1 (copy)
		if p1.isMounted then
			p1:setState({
				consentGiven = not p1.state.consentGiven
			})
		end
	end
	function p1.closeEnableVoiceModal() -- line: 114
		-- upvalues: GetFFlagVoiceUpsellConsentCheckbox (copy), p1 (copy)
		if GetFFlagVoiceUpsellConsentCheckbox() then
			p1.props.setShowVoiceOptIn({
				showVoiceOptInOverlay = false
			})
		end

		p1.props.voiceUpsellAnalytics.closeEnableVoiceChatModal()
		p1.props.closeOverlay()
	end
end
function v29.didMount(p5) -- line: 123
	-- upvalues: GetFFlagVoiceUpsellConsentCheckbox (copy), Logging (copy), v28 (copy), IXPService (copy)
	p5.isMounted = true

	if GetFFlagVoiceUpsellConsentCheckbox() and p5.props.postUserSeenModal then
		p5.props.postUserSeenModal():andThen(function() -- line: 129
			-- upvalues: Logging (copy)
			Logging.warn("UserSeenModal request succeeded")
		end):catch(function(_) -- line: 132
			-- upvalues: Logging (copy)
			Logging.warn("UserSeenModal request failed")
		end)
	end

	if v28 ~= "" then
		IXPService:LogUserLayerExposure(v28)
	end

	p5.props.voiceUpsellAnalytics.showEnableVoiceChatModal()
end
function v29.willUnmount(p7) -- line: 144
	p7.isMounted = false
end
function v29.render(p8) -- line: 148
	-- upvalues: withLocalization (copy), Cryo (copy), withStyle (copy), Roact (copy), IdentityVerificationModalContent (copy), GetFFlagVoiceUpsellConsentCheckbox (copy), Images (copy), ButtonType (copy), PartialPageModal (copy)
	local showNewContent = p8.props.showNewContent

	return withLocalization(Cryo.Dictionary.join({
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
	}, (if not showNewContent then {} else {
		EnableVoiceChat = "Verification.Identity.Label.EnableMicrophone",
		SkipVoiceChat = "Verification.Identity.Label.JoinWithoutMicrophone",
		EnableVoiceContent1 = "Verification.Identity.Label.EnableChatWithVoice",
		LetsChat = "Verification.Identity.Heading.YourNewWayToChat"
	}), {
		LetsChat = "Verification.Identity.Heading.V2LetsChat",
		ClickToConsent = "Verification.Identity.Label.V2ClickToConsent",
		EnableVoiceChat = "Verification.Identity.Label.V2EnableVoiceChat",
		EnableVoiceContent1 = "Verification.Identity.Label.V2EnableVoiceChat1",
		SkipVoiceChat = "Verification.Identity.Label.V2JoinWithout"
	}))(function(p9) -- line: 179
		-- upvalues: withStyle (copy), p8 (copy), Roact (copy), IdentityVerificationModalContent (copy), Cryo (copy), GetFFlagVoiceUpsellConsentCheckbox (copy), Images (copy), ButtonType (copy), showNewContent (copy), PartialPageModal (copy)
		return withStyle(function(p10) -- line: 180
			-- upvalues: p8 (copy), Roact (copy), IdentityVerificationModalContent (copy), Cryo (copy), p9 (copy), GetFFlagVoiceUpsellConsentCheckbox (copy), Images (copy), ButtonType (copy), showNewContent (copy), PartialPageModal (copy)
			local Theme = p10.Theme
			local CaptionHeader = p10.Font.CaptionHeader
			local v55 = CaptionHeader.RelativeSize * p10.Font.BaseSize
			local v56 = not p8.props.RequireExplicitVoiceConsent
			local v57 = Roact.createElement(IdentityVerificationModalContent, Cryo.Dictionary.join({
				centerCheckbox = true,
				MainText = { p9.UsesVoiceChat },
				LocalizedOptOutText = p9.DontShowAgain,
				onActivated = p8.onOverlayOptOutCheckBoxActivated,
				checkboxSelected = p8.state.dontShowModalAgain
			}, if not GetFFlagVoiceUpsellConsentCheckbox() then {} else {
				LocalizedOptOutText = false,
				centerCheckbox = false,
				showConsentCheckbox = true,
				MainText = {
					{
						content = p9.EnableVoiceContent1,
						image = Images["icons/graphic/voicechat_large"]
					},
					"",
					{
						content = p9.EnableVoiceContent2,
						image = Images["icons/graphic/hearts_large"]
					}
				},
				consentText = if not v56 then p9.ConsentText else p9.ClickToConsent,
				consentActivated = p8.consentActivated,
				consentSelected = p8.state.consentGiven,
				hideConsent = v56
			}))
			local t1 = {
				{
					buttonType = ButtonType.Secondary,
					props = {
						onActivated = p8.joinAnyways,
						text = p9.SkipVoiceChat
					}
				},
				{
					buttonType = if not showNewContent then ButtonType.PrimarySystem else ButtonType.Secondary,
					props = {
						isDisabled = if not GetFFlagVoiceUpsellConsentCheckbox() then nil else not p8.state.consentGiven,
						onActivated = p8.enableVoice,
						text = p9.EnableVoiceChat
					}
				}
			}

			return Roact.createElement(PartialPageModal, {
				title = if not GetFFlagVoiceUpsellConsentCheckbox() then p9.EnableVoiceChat else p9.LetsChat,
				screenSize = p8.props.screenSize,
				onCloseClicked = p8.closeEnableVoiceModal,
				buttonStackProps = t1 and {
					buttonHeight = 48,
					buttons = t1
				},
				footerContent = function() -- line: 252
					-- upvalues: Roact (copy), Theme (copy), p9 (copy), p10 (copy), CaptionHeader (copy), v55 (copy), p8 (copy)
					return Roact.createFragment({
						Divider = Roact.createElement("Frame", {
							BorderSizePixel = 0,
							LayoutOrder = 2,
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.new(0.5, 0, 0, 16),
							BackgroundColor3 = Theme.Divider.Color,
							BackgroundTransparency = Theme.Divider.Transparency,
							Size = UDim2.new(1, 0, 0, 1)
						}),
						FooterText = Roact.createElement("TextButton", {
							Text = p9.LearnMoreAboutVoiceRecording or "Learn More about Voice Recording",
							AutomaticSize = Enum.AutomaticSize.X,
							Position = UDim2.new(0.5, 0, 0.5, 24),
							TextColor3 = p10.Theme.TextEmphasis.Color,
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundTransparency = 1,
							Font = CaptionHeader.Font,
							TextSize = v55,
							BorderSizePixel = 0,
							RichText = true,
							TextXAlignment = Enum.TextXAlignment.Left,
							Size = UDim2.new(0, 0, 0, 20),
							[Roact.Event.Activated] = function() -- line: 276
								-- upvalues: p8 (copy), p9 (copy)
								p8.props.openVoiceFAQ(p9.VoiceFAQ or "Voice FAQ")
								p8.props.voiceUpsellAnalytics.learnMoreAboutVoiceRecordingUpsell()
							end
						})
					})
				end
			}, {
				OuterFrame = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
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
					ContentFrame = Roact.createElement("Frame", {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					}, {
						Content = v57
					})
				})
			})
		end)
	end)
end

local v32 = RoactAppPolicy.connect(function(p11, _) -- line: 313
	return {
		showNewContent = p11.getGameInfoShowChatFeatures()
	}
end)(v29)
local v33 = RoactServices.connect({
	networking = RoactNetworking,
	permissions = AppPermissions,
	voiceUpsellAnalytics = VoiceUpsellAnalytics
})(v32)

return RoactRodux.connect(function(p13, _) -- line: 325
	return {
		formFactor = p13.FormFactor,
		screenSize = p13.ScreenSize
	}
end, function(p15) -- line: 330
	-- upvalues: CloseCentralOverlay (copy), SetNetworkingErrorToast (copy), AppPage (copy), Url (copy), FFlagSignalsNavP3Dispatch (copy), v19 (copy), NavigateDown (copy)
	return {
		closeOverlay = function() -- line: 332
			-- upvalues: p15 (copy), CloseCentralOverlay (copy)
			p15(CloseCentralOverlay())
		end,
		setNetworkingErrorToast = function(_) -- line: 335
			-- upvalues: p15 (copy), SetNetworkingErrorToast (copy)
			p15(SetNetworkingErrorToast({
				HttpError = Enum.HttpError.OK
			}))
		end,
		openVoiceFAQ = function(s1: string) -- line: 338
			-- upvalues: AppPage (copy), Url (copy), FFlagSignalsNavP3Dispatch (copy), v19 (copy), p15 (copy), NavigateDown (copy)
			local t2 = {
				name = AppPage.GenericWebPage,
				detail = string.format("%sinfo/voice-faq", Url.BASE_URL),
				extraProps = {
					title = s1
				}
			}

			if FFlagSignalsNavP3Dispatch then
				return v19.down(v19.fromLegacyPage(t2))
			end

			return p15(NavigateDown(t2))
		end
	}
end)(v33)
