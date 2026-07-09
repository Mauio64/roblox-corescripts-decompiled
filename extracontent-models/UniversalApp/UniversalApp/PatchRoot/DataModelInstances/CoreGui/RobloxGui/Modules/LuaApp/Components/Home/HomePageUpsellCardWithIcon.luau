local IXPService = game:GetService("IXPService")
local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useStyle = UIBlox.Core.Style.useStyle
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Roact = require(CorePackages.Packages.Roact)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local Text = require(CorePackages.Workspace.Packages.AppCommonLib).Text
local useEffect = require(CorePackages.Packages.React).useEffect
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local NavigateDown = require(CorePackages.Workspace.Packages.NavigationRodux).Thunks.NavigateDown
local NavigateBack = require(CorePackages.Workspace.Packages.NavigationRodux).Thunks.NavigateBack
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v21 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local useUserExperiment = require(CorePackages.Packages.RoactAppExperiment).useUserExperiment
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local SetHomePageUpsellCardVariation = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.LuaApp.Actions.SetHomePageUpsellCardVariation
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local GenericTextButton = require(Modules.LuaApp.Components.GenericTextButton)
local RoactAnalyticsAuthEvents = require(Modules.LuaApp.Services.RoactAnalyticsAuthEvents)
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local OpenEmailUpsellModal = require(Modules.LuaApp.Thunks.Verification.OpenEmailUpsellModal)
local OpenPhoneUpsellModal = require(Modules.LuaApp.Thunks.Verification.OpenPhoneUpsellModal)
local useNavigateToDiscoverabilityModal = require(Modules.LuaApp.Components.DiscoverabilityModal.useNavigateToDiscoverabilityModal)
local EntryPoints = require(CorePackages.Workspace.Packages.DiscoverabilityModal).Analytics.EntryPoints
local OptionalContactMethodUpsellTypes = require(Modules.LuaApp.Enum.OptionalContactMethodUpsellTypes)
local GetFFlagEnableHomePageEmailUpsellCard = require(Modules.LuaApp.Flags.GetFFlagEnableHomePageEmailUpsellCard)
local GetFFlagEnableUpdateAddPhoneDescriptionTextExperiment = require(Modules.LuaApp.Flags.GetFFlagEnableUpdateAddPhoneDescriptionTextExperiment)
local GetFFlagRemovePhoneUpsellWebview = require(Modules.LuaApp.Flags.GetFFlagRemovePhoneUpsellWebview)
local GetFFlagRemoveDiscoverabilityModal = require(Modules.LuaApp.Flags.GetFFlagRemoveDiscoverabilityModal)
local GetFFlagEnableVoiceTrialUpsellCard = require(Modules.LuaApp.Flags.GetFFlagEnableVoiceTrialUpsellCard)
local v39 = game:DefineFastFlag("FixBannerButtonSize", false)
local FFlagHomePhoneVerificationUpsellNewCopy = require(CorePackages.Workspace.Packages.SharedFlags).FFlagHomePhoneVerificationUpsellNewCopy
local v41 = Images["icons/graphic/passcode_large"]
local v42 = Images["icons/controls/microphone"]
local v43 = if not GetFFlagEnableVoiceTrialUpsellCard() then nil else Images["icons/controls/headphone"]
local v44 = if not GetFFlagEnableVoiceTrialUpsellCard() then nil else game:DefineFastString("VoiceChatHelpUrl", "https://en.help.roblox.com/hc/en-us/articles/4405807645972-Voice-Chat")

local function noOpt() -- line: 77
end
local function HomePageUpsellCardWithIcon(t1: {[any]: any}) -- line: 91
	-- upvalues: OptionalContactMethodUpsellTypes (copy), GetFFlagEnableVoiceTrialUpsellCard (copy), useRoactService (copy), RoactAnalyticsAuthEvents (copy), useEffect (copy), useUserExperiment (copy), AppUserLayers (copy), useStyle (copy), GetFFlagRemoveDiscoverabilityModal (copy), useNavigateToDiscoverabilityModal (copy), useLocalization (copy), useSelector (copy), useDispatch (copy), SetHomePageUpsellCardVariation (copy), OpenEmailUpsellModal (copy), OpenPhoneUpsellModal (copy), noOpt (copy), FFlagSignalsNavP3Dispatch (copy), v21 (copy), NavigateDown (copy), NavigateBack (copy), EventStreamConstants (copy), IXPService (copy), FFlagHomePhoneVerificationUpsellNewCopy (copy), GetFFlagEnableUpdateAddPhoneDescriptionTextExperiment (copy), GetFFlagRemovePhoneUpsellWebview (copy), EntryPoints (copy), AppPage (copy), v41 (copy), GetFFlagEnableHomePageEmailUpsellCard (copy), v42 (copy), v43 (copy), v44 (copy), FormFactor (copy), Text (copy), Roact (copy), ImageSetLabel (copy), GenericTextButton (copy), Button (copy), ButtonType (copy), v39 (copy)
	local s1 = "phone"
	local s2 = ""
	local titleTextOverride = nil
	local bodyTextOverride = nil

	if t1.upsellCardVariation then
		s2 = t1.upsellCardVariation.upsellCardType

		if t1.upsellCardVariation.titleTextOverride ~= "" and t1.upsellCardVariation.bodyTextOverride ~= "" then
			titleTextOverride = t1.upsellCardVariation.titleTextOverride
			bodyTextOverride = t1.upsellCardVariation.bodyTextOverride
		end
	end

	if s2 == OptionalContactMethodUpsellTypes.ContactMethodPhoneNumberEmailHorizontalLayout or s2 == OptionalContactMethodUpsellTypes.ContactMethodPhoneNumberEmailVerticalLayout then
		s1 = "emailOrPhone"
	elseif GetFFlagEnableVoiceTrialUpsellCard() and s2 == OptionalContactMethodUpsellTypes.VoiceWithoutPvTrial then
		s1 = "voiceTrial"
	end

	local v52 = useRoactService(RoactAnalyticsAuthEvents)

	useEffect(function() -- line: 118
		-- upvalues: v52 (copy), s1 (ref)
		v52.reportModalShownWithSection("verificationUpsell", "homepage", s1)
	end, {})

	local v53, v54 = useUserExperiment({ AppUserLayers.PhoneVerificationEntryLayer }, function(p1) -- line: 124
		-- upvalues: AppUserLayers (copy)
		local v92 = p1[AppUserLayers.PhoneVerificationEntryLayer] or {}

		return v92.ShouldUseLuaPhoneVerificationFlow, v92.ShouldUseUpdatedPhoneVerificationText
	end)
	local v55 = useStyle()
	local v56 = if not GetFFlagRemoveDiscoverabilityModal() then useNavigateToDiscoverabilityModal() else nil
	local v57 = useLocalization({
		addButtonText = "Feature.ContactMethodUpsell.Action.AddPhoneNumber",
		bodyText = "Feature.ContactMethodUpsell.Label.RecoverYourAccount",
		titleText = "Feature.ContactMethodUpsell.Title.HomePageUpsellCardLockOutTitle",
		addEmailInstead = "Feature.ContactUpsell.Action.AddEmailInstead",
		addPhone = "Feature.ContactMethodUpsell.Label.AddPhone",
		addEmail = "Feature.ContactMethodUpsell.Label.AddEmail",
		continueButton = if not GetFFlagEnableVoiceTrialUpsellCard() then nil else "Feature.ContactMethodUpsell.Action.Continue",
		learnMore = if not GetFFlagEnableVoiceTrialUpsellCard() then nil else "Feature.ContactMethodUpsell.Action.LearnMore"
	})
	local v58 = useSelector(function(p2) -- line: 152
		return p2.FormFactor
	end)
	local v59 = useDispatch()

	local function v60() -- line: 158
		-- upvalues: v59 (copy), SetHomePageUpsellCardVariation (copy)
		return v59(SetHomePageUpsellCardVariation("", "", ""))
	end

	local v61 = if not GetFFlagEnableVoiceTrialUpsellCard() then nil else function() -- line: 195
		-- upvalues: FFlagSignalsNavP3Dispatch (copy), v21 (copy), v59 (copy), NavigateBack (copy)
		if FFlagSignalsNavP3Dispatch then
			v21.back()

			return
		end

		v59(NavigateBack())
	end
	local Theme = v55.Theme
	local TextEmphasisColor = Theme.TextEmphasis.Color
	local Font = v55.Font
	local Header2Font = Font.Header2.Font
	local v66 = v55.Font.BaseSize * v55.Font.Header2.RelativeSize
	local TextDefaultColor = Theme.TextDefault.Color
	local CaptionBodyFont = Font.CaptionBody.Font
	local v69 = v55.Font.BaseSize * v55.Font.CaptionBody.RelativeSize
	local Top = Enum.VerticalAlignment.Top
	local Horizontal = Enum.FillDirection.Horizontal
	local n1 = 10
	local n2 = 1
	local n3 = 2

	local function v75() -- line: 218
		-- upvalues: v52 (copy), EventStreamConstants (copy), s1 (ref), v60 (copy), v59 (copy), OpenEmailUpsellModal (copy)
		v52.reportButtonClickedWithSectionAndOrigin(EventStreamConstants.Context.HomepageUpsellCard, EventStreamConstants.Button.Email, s1, "homepage")

		local v99 = v60

		v59(OpenEmailUpsellModal({
			addEmailOver13TextKey = "Feature.ContactMethodUpsell.Label.PleaseAddEmail",
			addEmailTitleKey = "Feature.AccountSecurityPrompt.Action.AbortDismissForeverAddEmail",
			isEmailModalCalledFromHomePage = true,
			eventContext = "verificationUpsell",
			origin = "homepage",
			section = "addEmail",
			successCallback = v99
		}))
	end

	local s3 = "Feature.VerificationUpsell.Description.VerificationCodeSmsFeesMayApply"

	local function v77() -- line: 230
		-- upvalues: v52 (copy), EventStreamConstants (copy), s1 (ref), IXPService (copy), AppUserLayers (copy), FFlagHomePhoneVerificationUpsellNewCopy (copy), s3 (ref), GetFFlagEnableUpdateAddPhoneDescriptionTextExperiment (copy), v54 (copy), s2 (ref), OptionalContactMethodUpsellTypes (copy), GetFFlagRemovePhoneUpsellWebview (copy), GetFFlagRemoveDiscoverabilityModal (copy), v59 (copy), SetHomePageUpsellCardVariation (copy), v56 (copy), noOpt (copy), EntryPoints (copy), OpenPhoneUpsellModal (copy), v53 (copy), AppPage (copy), v60 (copy), FFlagSignalsNavP3Dispatch (copy), v21 (copy), NavigateDown (copy)
		v52.reportButtonClickedWithSectionAndOrigin(EventStreamConstants.Context.HomepageUpsellCard, EventStreamConstants.Button.Phone, s1, "homepage")
		IXPService:LogUserLayerExposure(AppUserLayers.PhoneVerificationEntryLayer)

		if FFlagHomePhoneVerificationUpsellNewCopy then
			s3 = "Feature.AccountSettings.Description.AddPhoneNumber"
		elseif GetFFlagEnableUpdateAddPhoneDescriptionTextExperiment() and v54 then
			s3 = "Feature.VerificationUpsell.Description.AddPhoneBody"
		end

		local v100 = nil

		if s2 == OptionalContactMethodUpsellTypes.ContactMethodPhoneNumberVoiceOptIn then
			v100 = true
		end

		if GetFFlagRemovePhoneUpsellWebview() then
			local v101 = s3

			v59(OpenPhoneUpsellModal({
				eventContext = "verificationUpsell",
				origin = "homepage",
				shouldAutofillAndroidPhoneNumberAtLaunch = true,
				onSuccess = function() -- line: 251
					-- upvalues: GetFFlagRemoveDiscoverabilityModal (copy), v59 (copy), SetHomePageUpsellCardVariation (copy), v56 (copy), noOpt (copy), EntryPoints (copy)
					if GetFFlagRemoveDiscoverabilityModal() then
						v59(SetHomePageUpsellCardVariation("", "", ""))

						return
					end

					v59(SetHomePageUpsellCardVariation("", "", ""))
					v56({
						isStandaloneDiscoverabilityModal = true,
						navigateOnActivated = noOpt,
						entryPoint = EntryPoints.HomePage
					})
				end,
				onCancelled = noOpt,
				onAbandoned = noOpt,
				addPhoneDescriptionKey = v101
			}, v100))

			return
		end

		if v53 then
			local v102 = s3

			v59(OpenPhoneUpsellModal({
				eventContext = "verificationUpsell",
				origin = "homepage",
				shouldAutofillAndroidPhoneNumberAtLaunch = true,
				onSuccess = function() -- line: 265
					-- upvalues: GetFFlagRemoveDiscoverabilityModal (copy), v59 (copy), SetHomePageUpsellCardVariation (copy), v56 (copy), noOpt (copy), EntryPoints (copy)
					if GetFFlagRemoveDiscoverabilityModal() then
						v59(SetHomePageUpsellCardVariation("", "", ""))

						return
					end

					v59(SetHomePageUpsellCardVariation("", "", ""))
					v56({
						isStandaloneDiscoverabilityModal = true,
						navigateOnActivated = noOpt,
						entryPoint = EntryPoints.HomePage
					})
				end,
				onCancelled = noOpt,
				onAbandoned = noOpt,
				addPhoneDescriptionKey = v102
			}, v100))

			return
		end

		local t2 = {
			name = AppPage.PhoneVerification,
			extraProps = {
				onSuccessCallback = v60
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v21.down(v21.fromLegacyPage(t2))

			return
		end

		v59(NavigateDown(t2))
	end

	local v78 = if not GetFFlagEnableVoiceTrialUpsellCard() then nil else v41
	local addEmail = nil
	local v80 = if not GetFFlagEnableVoiceTrialUpsellCard then nil else noOpt
	local addEmail2 = nil
	local v82 = if not GetFFlagEnableVoiceTrialUpsellCard then nil else noOpt

	if GetFFlagEnableVoiceTrialUpsellCard() then
		if GetFFlagEnableHomePageEmailUpsellCard() and s2 == OptionalContactMethodUpsellTypes.ContactMethodEmail then
			v78 = v41
			addEmail = v57.addEmail
			v80 = v75
		elseif s2 == OptionalContactMethodUpsellTypes.ContactMethodPhoneNumber then
			v78 = v41
			addEmail = v57.addButtonText
			v80 = v77
		elseif s2 == OptionalContactMethodUpsellTypes.ContactMethodPhoneNumberEmailHorizontalLayout then
			v78 = v41
			addEmail = v57.addPhone
			v80 = v77
			addEmail2 = v57.addEmail
			v82 = v75
		elseif s2 == OptionalContactMethodUpsellTypes.ContactMethodPhoneNumberEmailVerticalLayout then
			v78 = v41
			addEmail = v57.addButtonText
			v80 = v77
			addEmail2 = v57.addEmailInstead
			v82 = v75
		elseif s2 == OptionalContactMethodUpsellTypes.ContactMethodPhoneNumberVoiceOptIn then
			v78 = v42
			addEmail = v57.addButtonText
			v80 = v77
		elseif s2 == OptionalContactMethodUpsellTypes.VoiceWithoutPvTrial then
			v78 = v43
			addEmail = v57.continueButton

			function v80() -- line: 328
				-- upvalues: AppPage (copy), s2 (ref), v61 (copy), v59 (copy), SetHomePageUpsellCardVariation (copy), FFlagSignalsNavP3Dispatch (copy), v21 (copy), NavigateDown (copy)
				local t3 = {
					name = AppPage.VoiceTrialUpsell,
					extraProps = {
						upsellCardType = s2,
						onClose = v61,
						onCompletion = function() -- line: 334
							-- upvalues: v59 (copy), SetHomePageUpsellCardVariation (copy)
							v59(SetHomePageUpsellCardVariation("", "", ""))
						end
					}
				}

				if FFlagSignalsNavP3Dispatch then
					v21.down(v21.fromLegacyPage(t3))

					return
				end

				v59(NavigateDown(t3))
			end

			addEmail2 = v57.learnMore

			function v82() -- line: 341
				-- upvalues: AppPage (copy), v44 (copy), FFlagSignalsNavP3Dispatch (copy), v21 (copy), v59 (copy), NavigateDown (copy)
				local t4 = {
					name = AppPage.GenericWebPage,
					detail = v44,
					extraProps = {}
				}

				if FFlagSignalsNavP3Dispatch then
					v21.down(v21.fromLegacyPage(t4))

					return
				end

				v59(NavigateDown(t4))
			end
		end
	end

	local uDim2 = UDim2.new(1, 0, 0, 0)
	local uDim2_2 = UDim2.new(1, 0, 0, 28)
	local uDim2_3 = UDim2.new(0.5, 0, 0, 28)
	local n4 = 12
	local n5 = 12
	local Vertical = Enum.FillDirection.Vertical
	local uDim2_4 = UDim2.new(1, -25, 0, 0)
	local v90 = if not GetFFlagEnableHomePageEmailUpsellCard() then nil else v57.addEmail

	if v58 == FormFactor.WIDE then
		n4 = 12
		Vertical = Enum.FillDirection.Horizontal
		uDim2_3 = UDim2.new(1, 0, 0, 28)
		n5 = 20
		Top = Enum.VerticalAlignment.Center
		Horizontal = Enum.FillDirection.Vertical
		n1 = 0
		n2 = 2
		n3 = 1
		v57.addEmail = v57.addEmailInstead
		v57.addPhone = v57.addButtonText
		uDim2 = UDim2.new(1, -Text.GetTextWidth(v57.addButtonText, v55.Font.CaptionHeader.Font, v55.Font.BaseSize * v55.Font.CaptionHeader.RelativeSize) - 30, 0, 0)
		uDim2_2 = UDim2.new(0, Text.GetTextWidth(v57.addButtonText, v55.Font.CaptionHeader.Font, v55.Font.BaseSize * v55.Font.CaptionHeader.RelativeSize) + 15, 0, 28)
	end

	return if not not GetFFlagEnableVoiceTrialUpsellCard() and (s2 == nil or s2 == "") then nil else Roact.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 0,
		Position = if not t1.isCentered then nil else UDim2.new(0.5, 0, 0, 0),
		AnchorPoint = if not t1.isCentered then nil else Vector2.new(0.5, 0),
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundColor3 = Theme.BackgroundUIDefault.Color,
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		UISizeConstraint = Roact.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(800, 1e999)
		}),
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, n4)
		}),
		UICorner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, 12)
		}),
		UIStroke = Roact.createElement("UIStroke", {
			Thickness = 1,
			Transparency = 0.7,
			Color = Theme.SystemPrimaryDefault.Color
		}),
		UIPadding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, n5),
			PaddingTop = UDim.new(0, 12),
			PaddingBottom = UDim.new(0, 12)
		}),
		IconAndTextFrame = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = uDim2,
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			HorizontalLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Top
			}),
			ImageIcon = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0.5),
				Size = UDim2.new(0, 40, 0, 40),
				Position = UDim2.new(1, 0, 0.5, 0),
				Image = if not GetFFlagEnableVoiceTrialUpsellCard() then if s2 ~= OptionalContactMethodUpsellTypes.ContactMethodPhoneNumberVoiceOptIn then v41 else v42 else v78,
				ImageColor3 = v55.Theme.SystemPrimaryDefault.Color,
				ImageTransparency = v55.Theme.SystemPrimaryDefault.Transparency
			}),
			TextFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = uDim2_4,
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				VerticalLayout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 4)
				}),
				UIPadding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 12)
				}),
				TitleTextLabel = Roact.createElement("TextLabel", {
					LayoutOrder = 1,
					BorderSizePixel = 0,
					TextWrapped = true,
					BackgroundTransparency = 0,
					Size = uDim2_4,
					Font = Header2Font,
					Text = titleTextOverride or v57.titleText,
					TextColor3 = TextEmphasisColor,
					TextSize = v66,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundColor3 = Theme.BackgroundUIDefault.Color,
					AutomaticSize = Enum.AutomaticSize.Y
				}),
				BodyTextLabel = Roact.createElement("TextLabel", {
					LayoutOrder = 2,
					BorderSizePixel = 0,
					TextWrapped = true,
					BackgroundTransparency = 0,
					Size = uDim2_4,
					Font = CaptionBodyFont,
					Text = bodyTextOverride or v57.bodyText,
					TextColor3 = TextDefaultColor,
					TextSize = v69,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundColor3 = Theme.BackgroundUIDefault.Color,
					AutomaticSize = Enum.AutomaticSize.Y
				})
			})
		}),
		FirstVariantFrame = not GetFFlagEnableVoiceTrialUpsellCard() and (s2 == OptionalContactMethodUpsellTypes.ContactMethodPhoneNumberEmailHorizontalLayout and Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = uDim2_2
		}, {
			OrientationLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 10)
			}),
			UIPadding = Roact.createElement("UIPadding", {
				PaddingRight = UDim.new(0, n1)
			}),
			HorizontalCallToActionButton = Roact.createElement(GenericTextButton, {
				BackgroundTransparency = 0,
				Size = uDim2_3,
				Text = v57.addEmail,
				LayoutOrder = n2,
				Font = v55.Font.CaptionHeader.Font,
				TextSize = v55.Font.BaseSize * v55.Font.CaptionHeader.RelativeSize,
				onActivated = v75,
				BackgroundColor3 = Theme.BackgroundUIDefault.Color,
				themeSettings = {
					OnPressTransparency = 0.5,
					DisabledTransparency = 0.5,
					Color = Theme.SystemPrimaryContent.Color,
					Transparency = Theme.SystemPrimaryContent.Transparency,
					Text = {
						Color = Theme.SystemPrimaryDefault.Color,
						Transparency = Theme.SystemPrimaryDefault.Transparency
					},
					Border = {
						Hidden = false,
						Transparency = 0,
						Color = Theme.SystemPrimaryDefault.Color
					}
				}
			}),
			SecondHorizontalCallToActionButton = Roact.createElement(Button, {
				fontStyle = "CaptionHeader",
				buttonType = ButtonType.PrimarySystem,
				size = uDim2_3,
				text = v57.addPhone,
				layoutOrder = n3,
				onActivated = v77
			})
		})),
		SecondVariantFrame = not GetFFlagEnableVoiceTrialUpsellCard() and (((if not GetFFlagEnableHomePageEmailUpsellCard() then s2 ~= OptionalContactMethodUpsellTypes.ContactMethodPhoneNumberEmailHorizontalLayout else s2 ~= OptionalContactMethodUpsellTypes.ContactMethodPhoneNumberEmailHorizontalLayout and s2 ~= OptionalContactMethodUpsellTypes.ContactMethodEmail)) and Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = uDim2_2,
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			VerticalLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 10)
			}),
			CallToActionButton = Roact.createElement(Button, {
				layoutOrder = 1,
				fontStyle = "CaptionHeader",
				buttonType = ButtonType.PrimarySystem,
				size = uDim2_2,
				text = v57.addButtonText,
				onActivated = v77
			}),
			SecondVerticalCallToActionButton = s2 == OptionalContactMethodUpsellTypes.ContactMethodPhoneNumberEmailVerticalLayout and Roact.createElement(GenericTextButton, {
				BackgroundTransparency = 0,
				LayoutOrder = 2,
				Size = uDim2_2,
				Text = v57.addEmailInstead,
				Font = v55.Font.CaptionHeader.Font,
				TextSize = v55.Font.BaseSize * v55.Font.CaptionHeader.RelativeSize,
				onActivated = v75,
				BackgroundColor3 = Theme.BackgroundOnHover.Color,
				themeSettings = {
					OnPressTransparency = 0.5,
					DisabledTransparency = 0.5,
					Color = Theme.SystemPrimaryContent.Color,
					Transparency = Theme.SystemPrimaryContent.Transparency,
					Text = {
						Color = Theme.SystemPrimaryDefault.Color,
						Transparency = Theme.SystemPrimaryDefault.Transparency
					},
					Border = {
						Hidden = false,
						Transparency = 1
					}
				}
			})
		})),
		EmailVariantFrame = not GetFFlagEnableVoiceTrialUpsellCard() and (GetFFlagEnableHomePageEmailUpsellCard() and (s2 == OptionalContactMethodUpsellTypes.ContactMethodEmail and Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = uDim2_2
		}, {
			OrientationLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 10)
			}),
			UIPadding = Roact.createElement("UIPadding", {
				PaddingRight = UDim.new(0, n1)
			}),
			HorizontalCallToActionButton = Roact.createElement(Button, {
				layoutOrder = 1,
				fontStyle = "CaptionHeader",
				buttonType = ButtonType.PrimarySystem,
				size = uDim2_2,
				text = v90,
				onActivated = v75
			})
		}))),
		ButtonsFrame = if not GetFFlagEnableVoiceTrialUpsellCard() then nil else Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = uDim2_2,
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			UIPadding = Roact.createElement("UIPadding", {
				PaddingRight = UDim.new(0, n1)
			}),
			VerticalLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 10)
			}),
			CallToActionButton = if addEmail == nil or addEmail == "" then nil else Roact.createElement(Button, {
				fontStyle = "CaptionHeader",
				buttonType = ButtonType.PrimarySystem,
				size = if not v39 or addEmail2 ~= nil and addEmail2 ~= "" then uDim2_3 else uDim2_2,
				text = addEmail,
				layoutOrder = n3,
				onActivated = v80
			}),
			SecondaryButton = if addEmail2 == nil or addEmail2 == "" then nil else Roact.createElement(Button, {
				fontStyle = "CaptionHeader",
				buttonType = ButtonType.Secondary,
				size = uDim2_3,
				text = addEmail2,
				layoutOrder = n2,
				onActivated = v82
			})
		})
	})
end

return HomePageUpsellCardWithIcon
