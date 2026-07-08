local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local GuiService = game:GetService("GuiService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local Constants = require(RobloxGui.Modules.VoiceChat.Constants)
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local Button = UIBlox.App.Button.Button
local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useStyle = UIBlox.Core.Style.useStyle
local PhoneLegalDisclaimer = require(CorePackages.Workspace.Packages.PhoneUpsell).PhoneLegalDisclaimer
local InExperienceProviderContainer = require(CorePackages.Workspace.Packages.InExperienceContainer).InExperienceProviderContainer
local PostPhoneUpsellDisplayed = require(CorePackages.Workspace.Packages.PhoneUpsell).Http.Requests.PostPhoneUpsellDisplayed
local PhoneUpsellController = require(CorePackages.Workspace.Packages.PhoneUpsell).PhoneUpsellController
local Constants2 = require(CorePackages.Workspace.Packages.PhoneUpsell).Constants
local RoactNetworking = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactNetworking
local useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local useInputType = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.useInputType
local InputTypeConstants = require(CorePackages.Workspace.Packages.InputType).InputTypeConstants
local useEventConnection = require(CorePackages.Packages.ReactUtils).useEventConnection
local getPlatformTarget = require(CorePackages.Workspace.Packages.Analytics).getPlatformTarget
local EventStreamConstants = require(CorePackages.Workspace.Packages.AuthAnalytics).EventStreamConstants
local leaveGame = require(RobloxGui.Modules.Settings.leaveGame)
local GetFFlagDisablePVUpsellDataConsent = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagDisablePVUpsellDataConsent
local EngineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")
local GetFFlagAddMorePhoneUpsellEvents = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagAddMorePhoneUpsellEvents

RobloxGui:WaitForChild("Modules"):WaitForChild("TenFootInterface")

local Constants3 = require(RobloxGui.Modules:WaitForChild("InGameMenu"):WaitForChild("Resources"):WaitForChild("Constants"))
local _ = {
	Incomplete = "Incomplete",
	Completed = "Completed",
	CompletedAndClosed = "CompletedAndClosed"
}

local function Initialize() -- line: 65
	-- upvalues: RobloxGui (copy), EngineFeature (copy), RbxAnalyticsService (copy), Constants3 (copy), useStyle (copy), useLocalization (copy), Constants (copy), useAppPolicy (copy), React (copy), StyledTextLabel (copy), Button (copy), ButtonType (copy), GetFFlagAddMorePhoneUpsellEvents (copy), getPlatformTarget (copy), EventStreamConstants (copy), PhoneUpsellController (copy), default (copy), GetFFlagDisablePVUpsellDataConsent (copy), PhoneLegalDisclaimer (copy), Constants2 (copy), useRoactService (copy), RoactNetworking (copy), useInputType (copy), InputTypeConstants (copy), GuiService (copy), ContextActionService (copy), PostPhoneUpsellDisplayed (copy), useEventConnection (copy), ButtonStack (copy), leaveGame (copy), InExperienceProviderContainer (copy), Roact (copy)
	local v39 = require(RobloxGui.Modules.Settings.SettingsPageFactory):CreateNewPage()

	v39.playsessionid = ""

	if EngineFeature then
		v39.playsessionid = RbxAnalyticsService:GetPlaySessionId()
	end

	function v39.DontLeaveFunc(p1) -- line: 74
		-- upvalues: v39 (copy), RbxAnalyticsService (copy), Constants3 (copy)
		if v39.HubRef then
			v39.HubRef:PopMenu(p1, true)
		end

		RbxAnalyticsService:SetRBXEventStream(Constants3.AnalyticsTargetName, Constants3.AnalyticsInGameMenuName, Constants3.AnalyticsLeaveGameName, {
			confirmed = Constants3.AnalyticsCancelledName,
			universeid = tostring(game.GameId),
			source = Constants3.AnalyticsLeaveGameSource,
			playsessionid = v39.playsessionid
		})
	end
	function v39.DontLeaveFromHotkey(_, p3, p4) -- line: 91
		-- upvalues: v39 (copy)
		if p3 == Enum.UserInputState.Begin then
			local v47 = p4.UserInputType == Enum.UserInputType.Gamepad1 or (p4.UserInputType == Enum.UserInputType.Gamepad2 or (p4.UserInputType == Enum.UserInputType.Gamepad3 or p4.UserInputType == Enum.UserInputType.Gamepad4))

			v39.DontLeaveFunc(v47)
		end
	end
	function v39.DontLeaveFromButton(p5) -- line: 101
		-- upvalues: v39 (copy)
		v39.DontLeaveFunc(p5)
	end

	v39.TabHeader = nil
	v39.Page.Name = "LeaveGameUpsellPage"
	v39.ShouldShowBottomBar = false
	v39.ShouldShowHubBar = false
	v39.DisableTopPadding = true

	function v39.UpsellComponent(p6) -- line: 114
		-- upvalues: v39 (copy), useStyle (copy), useLocalization (copy), Constants (copy), useAppPolicy (copy), React (copy), StyledTextLabel (copy), Button (copy), ButtonType (copy), GetFFlagAddMorePhoneUpsellEvents (copy), RbxAnalyticsService (copy), getPlatformTarget (copy), EventStreamConstants (copy), PhoneUpsellController (copy), default (copy), GetFFlagDisablePVUpsellDataConsent (copy), PhoneLegalDisclaimer (copy), Constants2 (copy)
		local upsellType = v39.upsellType
		local v51 = useStyle()
		local v52 = useLocalization({
			voiceConsent = "Feature.VerificationUpsell.Description.VoiceLegalConsent2",
			voiceDisclaimer = "Feature.VerificationUpsell.Description.VoiceLegalDisclaimer2",
			button = "Feature.VerificationUpsell.Action.AddPhoneNumber",
			termsOfUse = "Feature.VerificationUpsell.Action.SMSTerms",
			privacyPolicy = "Feature.VerificationUpsell.Action.Privacy",
			headerKey = upsellType ~= Constants.PHONE_UPSELL_VALUE_PROP.VoiceChat and "Feature.VerificationUpsell.Heading.DontLoseAccess" or "Feature.VerificationUpsell.Heading.UnlockVoiceChat",
			bodyKey = upsellType ~= Constants.PHONE_UPSELL_VALUE_PROP.VoiceChat and "Feature.VerificationUpsell.Description.RecoverAccountEasily" or "Feature.VerificationUpsell.Description.UnlockVoiceChatBody"
		})

		v52.voiceDisclaimer = v52.voiceDisclaimer:gsub("{buttonText}", v52.button)

		local v53 = useAppPolicy(function(p7) -- line: 131
			-- upvalues: upsellType (copy), Constants (copy)
			return upsellType == Constants.PHONE_UPSELL_VALUE_PROP.VoiceChat and p7.RequireExplicitVoiceConsent()
		end)
		local v54, v55 = React.useState(false)

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = p6.LayoutOrder
		}, {
			ListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 12)
			}),
			Header = React.createElement(StyledTextLabel, {
				layoutOrder = 1,
				text = v52.headerKey,
				fontStyle = v51.Font.Header2,
				colorStyle = v51.Theme.TextEmphasis
			}),
			Body = React.createElement(StyledTextLabel, {
				textWrapped = true,
				lineHeight = 1.1,
				layoutOrder = 2,
				text = v52.bodyKey,
				size = UDim2.new(1, 0, 0, 0),
				automaticSize = Enum.AutomaticSize.Y,
				fontStyle = v51.Font.Body,
				colorStyle = v51.Theme.TextDefault
			}),
			Button = React.createElement(Button, {
				layoutOrder = 3,
				buttonType = ButtonType.Secondary,
				size = UDim2.new(1, 0, 0, v51.Tokens.Size.Size_1200),
				text = v52.button,
				onActivated = function() -- line: 169
					-- upvalues: v39 (copy), GetFFlagAddMorePhoneUpsellEvents (copy), RbxAnalyticsService (copy), getPlatformTarget (copy), p6 (copy), EventStreamConstants (copy), PhoneUpsellController (copy), default (copy), upsellType (copy), Constants (copy)
					v39.HubRef:SetVisibility(false, true)

					if GetFFlagAddMorePhoneUpsellEvents() then
						RbxAnalyticsService:SendEventDeferred(getPlatformTarget(), "verificationUpsell", "modalAction", {
							origin = p6.origin,
							btn = EventStreamConstants.Button.Continue,
							section = p6.section
						})
					end

					PhoneUpsellController.openPhoneUpsell({
						eventContext = "verificationUpsell",
						origin = p6.origin,
						onSuccessBeforeToast = function() -- line: 181
							-- upvalues: default (copy), p6 (copy), v39 (copy)
							default:DisablePhoneVerificationUpsell()
							p6.onUpsellComplete()
							v39.HubRef:SetVisibility(true, false)
							v39.HubRef:SwitchToPage(v39.HubRef.LeaveGameUpsellPage, true)
						end,
						onSuccess = function() -- line: 187
							-- upvalues: upsellType (copy), Constants (copy), default (copy), p6 (copy)
							if upsellType == Constants.PHONE_UPSELL_VALUE_PROP.VoiceChat then
								default:EnableVoice()
								p6.setVoiceEnabled(true)
							end
						end
					})
				end,
				isDisabled = v53 and not v54
			}),
			PhoneLegalDisclaimer = if GetFFlagDisablePVUpsellDataConsent() then nil else React.createElement(PhoneLegalDisclaimer, {
				showLegalButtons = true,
				LayoutOrder = 4,
				legalText = if not v53 then v52.voiceDisclaimer else v52.voiceConsent,
				termsOfUse = v52.termsOfUse,
				privacyPolicy = v52.privacyPolicy,
				showLegalText = upsellType == Constants.PHONE_UPSELL_VALUE_PROP.VoiceChat,
				showLegalTextCheckbox = v53,
				legalTextChecked = v54,
				setLegalTextChecked = function() -- line: 208
					-- upvalues: v55 (copy), v54 (copy)
					v55(not v54)
				end,
				onTermsOfUseClick = function() -- line: 211
					-- upvalues: GetFFlagAddMorePhoneUpsellEvents (copy), RbxAnalyticsService (copy), getPlatformTarget (copy), p6 (copy), Constants2 (copy)
					if GetFFlagAddMorePhoneUpsellEvents() then
						RbxAnalyticsService:SendEventDeferred(getPlatformTarget(), "verificationUpsell", "modalAction", {
							field = "termsOfService",
							origin = p6.origin,
							section = p6.section
						})
					end

					p6.showWebpage(Constants2.TERMS_OF_SERVICE_URL)
				end,
				onPrivacyPolicyClick = function() -- line: 222
					-- upvalues: GetFFlagAddMorePhoneUpsellEvents (copy), RbxAnalyticsService (copy), getPlatformTarget (copy), p6 (copy), Constants2 (copy)
					if GetFFlagAddMorePhoneUpsellEvents() then
						RbxAnalyticsService:SendEventDeferred(getPlatformTarget(), "verificationUpsell", "modalAction", {
							field = "privacyPolicy",
							origin = p6.origin,
							section = p6.section
						})
					end

					p6.showWebpage(Constants2.PRIVACY_POLICY_URL)
				end
			})
		})
	end
	function v39.LeaveGameComponent(p8) -- line: 239
		-- upvalues: useStyle (copy), useLocalization (copy), React (copy), v39 (copy), Constants (copy), GetFFlagAddMorePhoneUpsellEvents (copy), useRoactService (copy), RoactNetworking (copy), useInputType (copy), InputTypeConstants (copy), GuiService (copy), ContextActionService (copy), PostPhoneUpsellDisplayed (copy), RbxAnalyticsService (copy), getPlatformTarget (copy), EventStreamConstants (copy), useEventConnection (copy), RobloxGui (copy), ButtonStack (copy), ButtonType (copy), default (copy), leaveGame (copy)
		local v57 = useStyle()
		local v58 = useLocalization({
			confirmLeave = "Feature.VerificationUpsell.Action.ConfirmLeave",
			dontLeave = "Feature.VerificationUpsell.Action.DontLeave",
			returnWithVoice = "Feature.VerificationUpsell.Action.ReturnWithVoice"
		})
		local v59, v60 = React.useState("Incomplete")
		local v61 = v59 == "Incomplete"
		local upsellType = v39.upsellType
		local v63 = upsellType ~= Constants.PHONE_UPSELL_VALUE_PROP.VoiceChat and "exitConfirmationScreenSecurity" or "exitConfirmationScreenVoice"
		local v64 = if not GetFFlagAddMorePhoneUpsellEvents() then nil else v59 ~= "Incomplete" and "verifyPhoneSuccess" or "entry"
		local v65 = React.useRef(nil)
		local v66, v67 = React.useState(false)
		local v68 = useRoactService(RoactNetworking)
		local v69 = useInputType()

		useEventConnection(v39.Displayed.Event, function() -- line: 262
			-- upvalues: v69 (copy), InputTypeConstants (copy), GuiService (copy), v65 (copy), ContextActionService (copy), v39 (copy), PostPhoneUpsellDisplayed (copy), v68 (copy), Constants (copy), GetFFlagAddMorePhoneUpsellEvents (copy), RbxAnalyticsService (copy), getPlatformTarget (copy), p8 (copy), EventStreamConstants (copy)
			if v69 ~= InputTypeConstants.Touch then
				GuiService.SelectedCoreObject = v65.current
			end

			ContextActionService:BindCoreAction("LeaveGameCancelAction", v39.DontLeaveFromHotkey, false, Enum.KeyCode.ButtonB)

			if not v39.postSent then
				PostPhoneUpsellDisplayed(v68, Constants.EXIT_CONFIRMATION_PHONE_UPSELL_IXP_LAYER, os.time(), true, true):catch(function(_) -- line: 281
				end)

				if GetFFlagAddMorePhoneUpsellEvents() then
					RbxAnalyticsService:SendEventDeferred(getPlatformTarget(), "verificationUpsell", "modalAction", {
						origin = p8.origin,
						aType = EventStreamConstants.ActionType.Shown,
						section = p8.section
					})
				end

				v39.postSent = true
			end
		end)
		useEventConnection(v39.Hidden.Event, function() -- line: 296
			-- upvalues: ContextActionService (copy), v59 (copy), v60 (copy)
			ContextActionService:UnbindCoreAction("LeaveGameCancelAction")

			if v59 == "Completed" then
				v60("CompletedAndClosed")
			end
		end)

		local v70 = not (RobloxGui.AbsoluteSize.Y < 500) and not (RobloxGui.AbsoluteSize.X < 500) and 200 or 0

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			Position = UDim2.new(0, 0, 0, v70),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			ListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			LeaveGame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				ListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, v57.Tokens.Size.Size_600),
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				LeaveGameButtons = React.createElement(ButtonStack, {
					disableGamepadRefs = true,
					isRoactGamepadEnabled = false,
					buttons = {
						{
							isDefaultChild = true,
							buttonType = ButtonType.PrimarySystem,
							props = {
								layoutOrder = 1,
								text = v58.confirmLeave,
								onActivated = function() -- line: 340
									-- upvalues: v66 (copy), v59 (copy), upsellType (copy), Constants (copy), default (copy), v67 (copy), GetFFlagAddMorePhoneUpsellEvents (copy), RbxAnalyticsService (copy), getPlatformTarget (copy), v63 (copy), v64 (copy), leaveGame (copy)
									if not v66 and ((v59 == "Completed" or v59 == "CompletedAndClosed") and upsellType == Constants.PHONE_UPSELL_VALUE_PROP.VoiceChat) then
										default:EnableVoice()
										v67(true)
									end

									if GetFFlagAddMorePhoneUpsellEvents() then
										RbxAnalyticsService:SendEventDeferred(getPlatformTarget(), "verificationUpsell", "formInteraction", {
											btn = "confirmLeave",
											origin = v63,
											section = v64
										})
									end

									leaveGame(false)
								end,
								buttonRef = v65
							}
						},
						{
							buttonType = ButtonType.Secondary,
							props = {
								layoutOrder = 2,
								text = if v59 ~= "Completed" or upsellType ~= Constants.PHONE_UPSELL_VALUE_PROP.VoiceChat then v58.dontLeave else v58.returnWithVoice,
								onActivated = function() -- line: 371
									-- upvalues: GetFFlagAddMorePhoneUpsellEvents (copy), v59 (copy), upsellType (copy), Constants (copy), RbxAnalyticsService (copy), getPlatformTarget (copy), v63 (copy), v64 (copy), EventStreamConstants (copy), v39 (copy)
									if GetFFlagAddMorePhoneUpsellEvents() then
										if v59 == "Completed" and upsellType == Constants.PHONE_UPSELL_VALUE_PROP.VoiceChat then
											RbxAnalyticsService:SendEventDeferred(getPlatformTarget(), "verificationUpsell", "formInteraction", {
												btn = "returnWithVoice",
												origin = v63,
												section = v64
											})
										elseif v59 == "Incomplete" then
											RbxAnalyticsService:SendEventDeferred(getPlatformTarget(), "verificationUpsell", "modalAction", {
												origin = v63,
												aType = EventStreamConstants.ActionType.Dismiss,
												section = v64
											})
										end
									end

									v39.DontLeaveFromButton()
								end
							}
						}
					},
					buttonHeight = v57.Tokens.Size.Size_1200
				})
			}),
			TopSpacer = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, v57.Tokens.Size.Size_600)
			}),
			UpsellComponents = if not v61 then nil else React.createElement(React.Fragment, {}, {
				Divider = React.createElement("Frame", {
					LayoutOrder = 3,
					BorderSizePixel = 0,
					BackgroundColor3 = v57.Tokens.Color.Stroke.Emphasis.Color3,
					BackgroundTransparency = v57.Tokens.Color.Stroke.Emphasis.Transparency,
					Size = UDim2.new(1, 0, 0, 1)
				}),
				BottomSpacer = React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 4,
					Size = UDim2.new(1, 0, 0, v57.Tokens.Size.Size_600)
				}),
				Upsell = React.createElement(v39.UpsellComponent, {
					LayoutOrder = 5,
					origin = v63,
					section = v64,
					showWebpage = p8.showWebpage,
					onUpsellComplete = function() -- line: 430
						-- upvalues: v60 (copy)
						v60("Completed")
					end,
					setVoiceEnabled = v67
				})
			})
		})
	end

	local v40 = React.createElement(InExperienceProviderContainer, {}, React.createElement(v39.LeaveGameComponent, {
		showWebpage = function() -- line: 443
		end
	}, {}))

	v39.handle = Roact.mount(v40, v39.Page, "LeaveGameUpsell")
	v39.Page.Size = UDim2.new(1, 0, 0, 0)
	v39.Page.AutomaticSize = Enum.AutomaticSize.Y

	return v39
end

local v38 = Initialize()

function v38.SetUpsellProp(p10, p11) -- line: 457
	-- upvalues: Constants (copy), Roact (copy), React (copy), InExperienceProviderContainer (copy)
	if p11 == Constants.PHONE_UPSELL_VALUE_PROP.None then
		return
	end

	p10.upsellType = p11
	p10.handle = Roact.update(p10.handle, React.createElement(InExperienceProviderContainer, {}, React.createElement(p10.LeaveGameComponent, {
		showWebpage = function() -- line: 470
		end
	}, {})))
end

return v38
