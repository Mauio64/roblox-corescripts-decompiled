local IXPService = game:GetService("IXPService")
local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local getTextSize = require("@game/CorePackages/Workspace/Packages/Style").GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local useStyle = UIBlox.Core.Style.useStyle
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Roact = require(CorePackages.Packages.Roact)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local React = require(CorePackages.Packages.React)
local useEffect = React.useEffect
local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Thunks.NavigateDown
local navigateBack = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Thunks.NavigateBack
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dFz").NavigationCommands else nil

local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local useUserExperiment = RoactAppExperiment.useUserExperiment
local appUserLayers = require("@luauforge/bundled/dPQ").AppUserLayers

local setHomePageUpsellCardVariation = require("@luauforge/bundled/dtb").Modules.LuaApp.Actions.SetHomePageUpsellCardVariation

local module = require("@luauforge/bundled/hOH")
local module2 = require("@luauforge/bundled/grb")
local module3 = require("@luauforge/bundled/fzS")
local module4 = require("@luauforge/bundled/gXc")
local module5 = require("@luauforge/bundled/gXb")

local module6 = require("@luauforge/bundled/fAC")
local entryPoints = require("@luauforge/bundled/cxh").Analytics.EntryPoints
local module7 = require("@luauforge/bundled/hRl")

local module8 = require("@luauforge/bundled/hRm")

local module9 = require("@luauforge/bundled/iqH")
local module10 = require("@luauforge/bundled/iqI")
local module11 = require("@luauforge/bundled/iqJ")
local module12 = require("@luauforge/bundled/dKq")
local defineFastFlag = game:DefineFastFlag("FixBannerButtonSize", false)

local fFlagHomePhoneVerificationUpsellNewCopy = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagHomePhoneVerificationUpsellNewCopy

local iconsgraphicpasscode_large = images["icons/graphic/passcode_large"]
local iconscontrolsmicrophone = images["icons/controls/microphone"]
local iconscontrolsheadphone = if module12() then images["icons/controls/headphone"] else nil
local v5

if module12() then
	v5 = game:DefineFastString(
		"VoiceChatHelpUrl",
		"https://en.help.roblox.com/hc/en-us/articles/4405807645972-Voice-Chat"
	)
else
	v5 = nil
end

local function noOpt() end

local function HomePageUpsellCardWithIcon(p2)
	local titleTextOverride = nil
	local bodyTextOverride = nil
	local v7

	if p2.upsellCardVariation then
		v7 = p2.upsellCardVariation.upsellCardType

		if
			p2.upsellCardVariation.titleTextOverride ~= ""
			and p2.upsellCardVariation.bodyTextOverride ~= ""
		then
			titleTextOverride = p2.upsellCardVariation.titleTextOverride
			bodyTextOverride = p2.upsellCardVariation.bodyTextOverride
		end
	else
		v7 = ""
	end

	local v8 = (v7 == module7.ContactMethodPhoneNumberEmailHorizontalLayout or v7 == module7.ContactMethodPhoneNumberEmailVerticalLayout)
		and "emailOrPhone"
		or module12() and v7 == module7.VoiceWithoutPvTrial and "voiceTrial"
		or "phone"

	local v9 = useRoactService(module2)

	useEffect(function()
		v9.reportModalShownWithSection("verificationUpsell", "homepage", v8)
	end, {})

	local v10, v11 = useUserExperiment({ appUserLayers.PhoneVerificationEntryLayer }, function(p3)
		local v12 = p3[appUserLayers.PhoneVerificationEntryLayer] or {}
		return v12.ShouldUseLuaPhoneVerificationFlow, v12.ShouldUseUpdatedPhoneVerificationText
	end)

	local v12 = useStyle()

	local v13 = if not module11() then module6() else nil

	local v14 = useLocalization({
		addButtonText = "Feature.ContactMethodUpsell.Action.AddPhoneNumber",
		bodyText = "Feature.ContactMethodUpsell.Label.RecoverYourAccount",
		titleText = "Feature.ContactMethodUpsell.Title.HomePageUpsellCardLockOutTitle",
		addEmailInstead = "Feature.ContactUpsell.Action.AddEmailInstead",
		addPhone = "Feature.ContactMethodUpsell.Label.AddPhone",
		addEmail = "Feature.ContactMethodUpsell.Label.AddEmail",
		continueButton = module12() and "Feature.ContactMethodUpsell.Action.Continue" or nil,
		learnMore = module12() and "Feature.ContactMethodUpsell.Action.LearnMore" or nil
	})

	local v15 = useSelector(function(p3)
		return p3.FormFactor
	end)

	local v16 = useDispatch()

	local function onSuccessCallback()
		return v16(setHomePageUpsellCardVariation("", "", ""))
	end

	local fn = module12() and function()
		if fFlagSignalsNavP3Dispatch then
			navigationCommands.back()
		else
			v16(navigateBack())
		end
	end or nil

	local theme = v12.Theme
	local color = theme.TextEmphasis.Color
	local v17 = v12.Font.BaseSize * v12.Font.Header2.RelativeSize
	local color2 = theme.TextDefault.Color
	local v18 = v12.Font.BaseSize * v12.Font.CaptionBody.RelativeSize
	local v19 = Enum.VerticalAlignment.Top
	local v20 = Enum.FillDirection.Horizontal
	local v21 = 10
	local v22 = 1
	local v23 = 2

	local function onActivated()
		v9.reportButtonClickedWithSectionAndOrigin(
			module3.Context.HomepageUpsellCard,
			module3.Button.Email,
			v8,
			"homepage"
		)
		v16(module4({
			successCallback = onSuccessCallback,
			addEmailOver13TextKey = "Feature.ContactMethodUpsell.Label.PleaseAddEmail",
			addEmailTitleKey = "Feature.AccountSecurityPrompt.Action.AbortDismissForeverAddEmail",
			isEmailModalCalledFromHomePage = true,
			eventContext = "verificationUpsell",
			origin = "homepage",
			section = "addEmail"
		}))
	end

	local v24 = "Feature.VerificationUpsell.Description.VerificationCodeSmsFeesMayApply"

	local function onActivated2()
		v9.reportButtonClickedWithSectionAndOrigin(
			module3.Context.HomepageUpsellCard,
			module3.Button.Phone,
			v8,
			"homepage"
		)

		IXPService:LogUserLayerExposure(appUserLayers.PhoneVerificationEntryLayer)

		if fFlagHomePhoneVerificationUpsellNewCopy then
			v24 = "Feature.AccountSettings.Description.AddPhoneNumber"
		elseif module9() and v11 then
			v24 = "Feature.VerificationUpsell.Description.AddPhoneBody"
		end

		local v25 = v7 == module7.ContactMethodPhoneNumberVoiceOptIn or nil

		if module10() then
			v16(module5({
				onSuccess = function()
					if module11() then
						v16(setHomePageUpsellCardVariation("", "", ""))
						return
					end

					v16(setHomePageUpsellCardVariation("", "", ""))

					v13({
						isStandaloneDiscoverabilityModal = true,
						navigateOnActivated = noOpt,
						entryPoint = entryPoints.HomePage
					})
				end,
				onCancelled = noOpt,
				onAbandoned = noOpt,
				eventContext = "verificationUpsell",
				origin = "homepage",
				shouldAutofillAndroidPhoneNumberAtLaunch = true,
				addPhoneDescriptionKey = v24
			}, v25))
			return
		end

		if v10 then
			v16(module5({
				onSuccess = function()
					if module11() then
						v16(setHomePageUpsellCardVariation("", "", ""))
						return
					end

					v16(setHomePageUpsellCardVariation("", "", ""))

					v13({
						isStandaloneDiscoverabilityModal = true,
						navigateOnActivated = noOpt,
						entryPoint = entryPoints.HomePage
					})
				end,
				onCancelled = noOpt,
				onAbandoned = noOpt,
				eventContext = "verificationUpsell",
				origin = "homepage",
				shouldAutofillAndroidPhoneNumberAtLaunch = true,
				addPhoneDescriptionKey = v24
			}, v25))
			return
		end

		local v26 = {
			name = appPage.PhoneVerification,
			extraProps = { onSuccessCallback = onSuccessCallback }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v26))
		else
			v16(navigateDown(v26))
		end
	end

	local v25 = if module12() then iconsgraphicpasscode_large else nil
	local v26 = nil
	local v27 = if module12 then noOpt else nil
	local v28 = nil
	local onActivated3 = if module12 then noOpt else nil

	if module12() then
		if module8() and v7 == module7.ContactMethodEmail then
			v25 = iconsgraphicpasscode_large
			v26 = v14.addEmail
			v27 = onActivated
		elseif v7 == module7.ContactMethodPhoneNumber then
			v25 = iconsgraphicpasscode_large
			v26 = v14.addButtonText
			v27 = onActivated2
		elseif v7 == module7.ContactMethodPhoneNumberEmailHorizontalLayout then
			v25 = iconsgraphicpasscode_large
			v26 = v14.addPhone

			v28 = v14.addEmail
			v27 = onActivated2
			onActivated3 = onActivated
		elseif v7 == module7.ContactMethodPhoneNumberEmailVerticalLayout then
			v25 = iconsgraphicpasscode_large
			v26 = v14.addButtonText

			v28 = v14.addEmailInstead
			v27 = onActivated2
			onActivated3 = onActivated
		elseif v7 == module7.ContactMethodPhoneNumberVoiceOptIn then
			v25 = iconscontrolsmicrophone
			v26 = v14.addButtonText
			v27 = onActivated2
		elseif v7 == module7.VoiceWithoutPvTrial then
			v25 = iconscontrolsheadphone
			v26 = v14.continueButton
			v27 = function()
				local v29 = {
					name = appPage.VoiceTrialUpsell,
					extraProps = {
						upsellCardType = v7,
						onClose = fn,
						onCompletion = function()
							v16(setHomePageUpsellCardVariation("", "", ""))
						end
					}
				}

				if fFlagSignalsNavP3Dispatch then
					navigationCommands.down(navigationCommands.fromLegacyPage(v29))
				else
					v16(navigateDown(v29))
				end
			end
			v28 = v14.learnMore
			onActivated3 = function()
				local v29 = {
					name = appPage.GenericWebPage,
					detail = v5,
					extraProps = {}
				}

				if fFlagSignalsNavP3Dispatch then
					navigationCommands.down(navigationCommands.fromLegacyPage(v29))
				else
					v16(navigateDown(v29))
				end
			end
		end
	end

	local udim = UDim2.new(1, 0, 0, 0)
	local v29 = UDim2.new(1, 0, 0, 28)
	local udim2 = UDim2.new(0.5, 0, 0, 28)
	local v30 = 12
	local v31 = 12
	local v32 = Enum.FillDirection.Vertical
	local udim3 = UDim2.new(1, -25, 0, 0)
	local addEmail = if module8() then v14.addEmail else nil

	if v15 == formFactor.WIDE then
		v32 = Enum.FillDirection.Horizontal
		udim2 = UDim2.new(1, 0, 0, 28)

		v19 = Enum.VerticalAlignment.Center
		v20 = Enum.FillDirection.Vertical

		v14.addEmail = v14.addEmailInstead
		v14.addPhone = v14.addButtonText
		udim = UDim2.new(
			1,
			-getTextSize(
				v14.addButtonText,
				v12.Font.BaseSize * v12.Font.CaptionHeader.RelativeSize,
				v12.Tokens.Typography.CaptionLarge.Font,
				Vector2.new(10000, 10000)
			).X - 30,
			0,
			0
		)

		v29 = UDim2.new(
			0,
			getTextSize(
				v14.addButtonText,
				v12.Font.BaseSize * v12.Font.CaptionHeader.RelativeSize,
				v12.Tokens.Typography.CaptionLarge.Font,
				Vector2.new(10000, 10000)
			).X + 15,
			0,
			28
		)
		v30 = 12
		v31 = 20
		v21 = 0
		v22 = 2
		v23 = 1
	end

	local v33

	if not (module12() and (v7 == nil or v7 == "")) then
		local createElement = Roact.createElement
		local v36 = if p2.isCentered then UDim2.new(0.5, 0, 0, 0) else nil
		local v37 = if p2.isCentered then Vector2.new(0.5, 0) else nil
		local v35 = {
			Position = v36,
			AnchorPoint = v37,
			Size = UDim2.new(1, 0, 0, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 0,
			BackgroundColor3 = theme.BackgroundUIDefault.Color,
			AutomaticSize = Enum.AutomaticSize.Y
		}
		local v38 = {
			UISizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(800, 1e999)
			}),
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = v32,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, v30)
			}),
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 12)
			}),
			UIStroke = Roact.createElement("UIStroke", {
				Thickness = 1,
				Color = theme.SystemPrimaryDefault.Color,
				Transparency = 0.7
			}),
			UIPadding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 12),
				PaddingRight = UDim.new(0, v31),
				PaddingTop = UDim.new(0, 12),
				PaddingBottom = UDim.new(0, 12)
			}),
			IconAndTextFrame = 0,
			FirstVariantFrame = 0,
			SecondVariantFrame = 0,
			EmailVariantFrame = 0,
			ButtonsFrame = 0
		}

		local createElement2 = Roact.createElement
		local v40 = {
			Size = udim,
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			AutomaticSize = Enum.AutomaticSize.Y
		}
		local children = {
			HorizontalLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = v19
			}),
			ImageIcon = 0,
			TextFrame = 0
		}

		local createElement3 = Roact.createElement
		local v42 = {
			AnchorPoint = Vector2.new(1, 0.5),
			Size = UDim2.new(0, 40, 0, 40),
			Position = UDim2.new(1, 0, 0.5, 0),
			Image = 0,
			ImageColor3 = 0,
			ImageTransparency = 0,
			BackgroundTransparency = 1
		}

		if not module12() then
			if v7 == module7.ContactMethodPhoneNumberVoiceOptIn then
				v25 = iconscontrolsmicrophone
			else
				v25 = iconsgraphicpasscode_large
			end
		end

		v42.Image = v25

		v42.ImageColor3 = v12.Theme.SystemPrimaryDefault.Color
		v42.ImageTransparency = v12.Theme.SystemPrimaryDefault.Transparency
		children.ImageIcon = createElement3(imageSetLabel, v42)

		children.TextFrame = Roact.createElement(
			"Frame",
			{
				Size = udim3,
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				AutomaticSize = Enum.AutomaticSize.Y
			},
			{
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
					Size = udim3,
					LayoutOrder = 1,
					FontFace = normalizeFontFace(v12.Tokens.Typography.TitleLarge.Font),
					BorderSizePixel = 0,
					Text = titleTextOverride or v14.titleText,
					TextColor3 = color,
					TextSize = v17,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundTransparency = 0,
					BackgroundColor3 = theme.BackgroundUIDefault.Color,
					AutomaticSize = Enum.AutomaticSize.Y
				}),
				BodyTextLabel = Roact.createElement("TextLabel", {
					Size = udim3,
					LayoutOrder = 2,
					FontFace = normalizeFontFace(v12.Tokens.Typography.BodySmall.Font),
					BorderSizePixel = 0,
					Text = bodyTextOverride or v14.bodyText,
					TextColor3 = color2,
					TextSize = v18,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundTransparency = 0,
					BackgroundColor3 = theme.BackgroundUIDefault.Color,
					AutomaticSize = Enum.AutomaticSize.Y
				})
			}
		)
		v38.IconAndTextFrame = createElement2("Frame", v40, children)

		local v43 = not module12()

		if v43 then
			if v7 == module7.ContactMethodPhoneNumberEmailHorizontalLayout then
				v43 = Roact.createElement(
					"Frame",
					{ Size = v29, BackgroundTransparency = 1, LayoutOrder = 2 },
					{
						OrientationLayout = Roact.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = v20,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							Padding = UDim.new(0, 10)
						}),
						UIPadding = Roact.createElement("UIPadding", {
							PaddingRight = UDim.new(0, v21)
						}),
						HorizontalCallToActionButton = Roact.createElement(module, {
							Size = udim2,
							BackgroundTransparency = 0,
							Text = v14.addEmail,
							LayoutOrder = v22,
							Font = v12.Font.CaptionHeader.Font,
							TextSize = v12.Font.BaseSize * v12.Font.CaptionHeader.RelativeSize,
							onActivated = onActivated,
							testId = "discovery-home-upsell-email-cta",
							BackgroundColor3 = theme.BackgroundUIDefault.Color,
							themeSettings = {
								Color = theme.SystemPrimaryContent.Color,
								Transparency = theme.SystemPrimaryContent.Transparency,
								OnPressTransparency = 0.5,
								DisabledTransparency = 0.5,
								Text = {
									Color = theme.SystemPrimaryDefault.Color,
									Transparency = theme.SystemPrimaryDefault.Transparency
								},
								Border = {
									Hidden = false,
									Transparency = 0,
									Color = theme.SystemPrimaryDefault.Color
								}
							}
						}),
						SecondHorizontalCallToActionButton = Roact.createElement(button, {
							buttonType = buttonType.PrimarySystem,
							size = udim2,
							text = v14.addPhone,
							layoutOrder = v23,
							fontStyle = "CaptionHeader",
							onActivated = onActivated2
						})
					}
				)
			else
				v43 = false
			end
		end

		v38.FirstVariantFrame = v43

		local v44 = not module12()

		if v44 then
			if module8() then
				if v7 == module7.ContactMethodPhoneNumberEmailHorizontalLayout then
					v44 = false
				else
					v44 = v7 ~= module7.ContactMethodEmail
				end
			else
				v44 = v7 ~= module7.ContactMethodPhoneNumberEmailHorizontalLayout
			end

			if v44 then
				local createElement4 = Roact.createElement
				local v46 = {
					Size = v29,
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					AutomaticSize = Enum.AutomaticSize.Y
				}
				local v47 = {
					VerticalLayout = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						Padding = UDim.new(0, 10)
					}),
					CallToActionButton = Roact.createElement(button, {
						buttonType = buttonType.PrimarySystem,
						size = v29,
						text = v14.addButtonText,
						layoutOrder = 1,
						fontStyle = "CaptionHeader",
						onActivated = onActivated2
					}),
					SecondVerticalCallToActionButton = 0
				}
				local v48

				if v7 == module7.ContactMethodPhoneNumberEmailVerticalLayout then
					v48 = Roact.createElement(module, {
						Size = v29,
						BackgroundTransparency = 0,
						Text = v14.addEmailInstead,
						LayoutOrder = 2,
						Font = v12.Font.CaptionHeader.Font,
						TextSize = v12.Font.BaseSize * v12.Font.CaptionHeader.RelativeSize,
						onActivated = onActivated,
						testId = "discovery-home-upsell-email-cta",
						BackgroundColor3 = theme.BackgroundOnHover.Color,
						themeSettings = {
							Color = theme.SystemPrimaryContent.Color,
							Transparency = theme.SystemPrimaryContent.Transparency,
							OnPressTransparency = 0.5,
							DisabledTransparency = 0.5,
							Text = {
								Color = theme.SystemPrimaryDefault.Color,
								Transparency = theme.SystemPrimaryDefault.Transparency
							},
							Border = { Hidden = false, Transparency = 1 }
						}
					})
				else
					v48 = false
				end

				v47.SecondVerticalCallToActionButton = v48
				v44 = createElement4("Frame", v46, v47)
			end
		end

		v38.SecondVariantFrame = v44

		local v45 = not module12() and module8()

		if v45 then
			if v7 == module7.ContactMethodEmail then
				v45 = Roact.createElement(
					"Frame",
					{ Size = v29, BackgroundTransparency = 1, LayoutOrder = 2 },
					{
						OrientationLayout = Roact.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = v20,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							Padding = UDim.new(0, 10)
						}),
						UIPadding = Roact.createElement("UIPadding", {
							PaddingRight = UDim.new(0, v21)
						}),
						HorizontalCallToActionButton = Roact.createElement(button, {
							buttonType = buttonType.PrimarySystem,
							size = v29,
							text = addEmail,
							layoutOrder = 1,
							fontStyle = "CaptionHeader",
							onActivated = onActivated
						})
					}
				)
			else
				v45 = false
			end
		end

		v38.EmailVariantFrame = v45
		local v46

		if module12() then
			local createElement4 = Roact.createElement
			local v48 = {
				Size = v29,
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				AutomaticSize = Enum.AutomaticSize.Y
			}
			local v49 = {
				UIPadding = Roact.createElement("UIPadding", {
					PaddingRight = UDim.new(0, v21)
				}),
				VerticalLayout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = v20,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 10)
				}),
				CallToActionButton = 0,
				SecondaryButton = 0
			}
			local v50

			if not (v26 == nil or v26 == "") then
				local createElement5 = Roact.createElement
				local v52 = {
					buttonType = buttonType.PrimarySystem,
					size = 0,
					text = 0,
					layoutOrder = 0,
					fontStyle = "CaptionHeader",
					onActivated = 0
				}

				if not defineFastFlag or v28 ~= nil and v28 ~= "" then
					v29 = udim2
				end

				v52.size = v29

				v52.text = v26
				v52.layoutOrder = v23

				v52.onActivated = v27
				v50 = createElement5(button, v52)
			end

			v49.CallToActionButton = v50

			local v51 = if v28 ~= nil and v28 ~= "" then Roact.createElement(button, {
				buttonType = buttonType.Secondary,
				size = udim2,
				text = v28,
				layoutOrder = v22,
				fontStyle = "CaptionHeader",
				onActivated = onActivated3
			}) else nil
			v49.SecondaryButton = v51
			v46 = createElement4("Frame", v48, v49)
		end

		v38.ButtonsFrame = v46
		v33 = createElement("Frame", v35, v38)
	end

	return v33
end

return HomePageUpsellCardWithIcon
