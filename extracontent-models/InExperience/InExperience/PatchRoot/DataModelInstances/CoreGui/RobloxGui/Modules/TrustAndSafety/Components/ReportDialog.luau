local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local ParentParent = script.Parent.Parent
local Dependencies = require(ParentParent.Dependencies)
local GameIcon = require(Dependencies.GameIcon)
local PlayerCell = require(Dependencies.PlayerCell)
local ThemedTextLabel = require(Dependencies.ThemedTextLabel)
local withLocalization = require(Dependencies.withLocalization)
local playerInterface = require(Dependencies.playerInterface)
local NavigateBack = require(ParentParent.Actions.NavigateBack)
local EndReportFlow = require(ParentParent.Actions.EndReportFlow)
local Constants = require(ParentParent.Resources.Constants)
local SendReport = require(ParentParent.Thunks.SendReport)
local TextEntryField = require(ParentParent.Components.TextEntryField)
local ModalDialog = require(ParentParent.Components.ModalDialog)
local ScreenshotDialog = require(ParentParent.Components.ReportAnything.ScreenshotDialog)
local ScreenshotFlowStepHandler = require(ParentParent.Components.ReportAnything.ScreenshotFlowStepHandler)
local SendAnalytics = require(ParentParent.Utility.SendAnalytics)
local SessionUtility = require(ParentParent.Utility.SessionUtility)
local ScreenshotHelper = require(ParentParent.Utility.ScreenshotHelper)
local GetFFlagReportAnythingScreenshot = require(ParentParent.Flags.GetFFlagReportAnythingScreenshot)
local GetFFlagReportAnythingMultistepScreenshot = require(ParentParent.Flags.GetFFlagReportAnythingMultistepScreenshot)
local ScreenshotAnnotated = require(ParentParent.Actions.ScreenshotAnnotated)
local FilterIdentifiedAvatars = require(ParentParent.Thunks.FilterIdentifiedAvatars)
local Provider = UIBlox.Core.Style.Provider
local withStyle = UIBlox.Core.Style.withStyle
local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Colors = UIBlox.App.Style.Colors
local DropdownMenu = UIBlox.App.Menu.DropdownMenu
local isPlayerVerified = require(CorePackages.Workspace.Packages.UserLib).Utils.isPlayerVerified
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local VoiceIndicatorFunc = require(RobloxGui.Modules.VoiceChat.Components.VoiceIndicatorFunc)
local VoiceStateContext = require(RobloxGui.Modules.VoiceChat.VoiceStateContext)
local Constants2 = require(RobloxGui.Modules.VoiceChat.Constants)
local React = require(CorePackages.Packages.React)

local function v42(p1) -- line: 52
	-- upvalues: React (copy), VoiceStateContext (copy), VoiceIndicatorFunc (copy), Cryo (copy)
	if not React.useContext(VoiceStateContext.Context).voiceEnabled then
		return nil
	end

	return React.createElement(VoiceIndicatorFunc, Cryo.Dictionary.join(p1, {}))
end

local DsaIllegalContentReporting = require(CorePackages.Workspace.Packages.DsaIllegalContentReporting)
local isShowUKOSAIllegalContentReportingLink = DsaIllegalContentReporting.isShowUKOSAIllegalContentReportingLink
local OSAReportLink = DsaIllegalContentReporting.OSAReportLink
local t1 = {
	"Swearing",
	"Inappropriate Username",
	"Bullying",
	"Scamming",
	"Dating",
	"Cheating/Exploiting",
	"Personal Question",
	"Offsite Links"
}
local t2 = {
	BackgroundDefault = {
		Transparency = 1,
		Color = Colors.Flint
	},
	BackgroundOnHover = {
		Transparency = 1,
		Color = Colors.Flint
	},
	BackgroundOnPress = {
		Transparency = 1,
		Color = Colors.Flint
	}
}
local v48 = Roact.PureComponent:extend("ReportDialog")

v48.validateProps = t.strictInterface({
	isReportDialogOpen = t.boolean,
	reportType = t.optional(t.valueOf(Constants.ReportType)),
	targetPlayer = t.optional(playerInterface),
	placeName = t.string,
	screenSize = t.Vector2,
	screenshotAnnotationPoints = t.array(t.Vector2),
	navigateBack = t.optional(t.callback),
	canNavigateBack = t.optional(t.boolean),
	sendReport = t.callback,
	closeDialog = t.optional(t.callback),
	screenshotAnnotated = t.optional(t.callback),
	reportCategory = t.optional(t.string),
	currentPage = t.string
})

function v48.init(p2) -- line: 114
	p2.state = {
		reasonText = nil,
		descriptionText = ""
	}

	function p2.onReasonChanged(p3) -- line: 120
		-- upvalues: p2 (copy)
		p2:setState({
			reasonText = p3
		})
	end
	function p2.onTextChanged(p4) -- line: 126
		-- upvalues: p2 (copy)
		p2:setState({
			descriptionText = p4
		})
	end
	function p2.onReport(p5, p6) -- line: 132
		-- upvalues: p2 (copy)
		local v76 = p2:getReason()

		p2.props.sendReport(p2.props.reportType, p2.props.targetPlayer, v76, p2.state.descriptionText, p2.props.reportCategory, p5, p6)
	end
	function p2.navigateBack() -- line: 146
		-- upvalues: p2 (copy)
		p2.props.navigateBack(p2.state.reasonText, p2.state.descriptionText ~= "")
	end
	function p2.onCancel() -- line: 150
		-- upvalues: p2 (copy)
		p2.props.closeDialog(p2.state.reasonText, p2.state.descriptionText ~= "")
	end
	function p2.onScreenshotAnnotated(p7) -- line: 154
		-- upvalues: p2 (copy)
		p2.props.screenshotAnnotated(p2.props.reportCategory, p2.props.reportType, p7)
	end
end
function v48.getReason(p8) -- line: 159
	-- upvalues: Constants (copy)
	if p8.props.reportType == Constants.ReportType.Player then
		return p8.state.reasonText
	end

	if p8.props.reportType == Constants.ReportType.Place then
		return "Inappropriate Content"
	end

	return nil
end
function v48.canReport(p9) -- line: 169
	local v54 = p9:getReason() ~= nil
	local v55 = utf8.len(utf8.nfcnormalize(p9.state.descriptionText))
	local v56 = v55 >= 0 and v55 <= 160

	return v54 and v56
end
function v48.renderUKOSALink(_) -- line: 176
	-- upvalues: isShowUKOSAIllegalContentReportingLink (copy), Roact (copy), OSAReportLink (copy)
	if not isShowUKOSAIllegalContentReportingLink() then
		return nil
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 99,
		Size = UDim2.new(1, 0, 0, 40),
		Position = UDim2.new(0, 0, 1, -45)
	}, {
		OSALink = Roact.createElement(OSAReportLink)
	})
end
function v48.renderPlayerInfo(p11) -- line: 191
	-- upvalues: Constants (copy), withStyle (copy), Cryo (copy), t2 (copy), Roact (copy), Provider (copy), PlayerCell (copy), isPlayerVerified (copy), v42 (copy), default (copy), Constants2 (copy)
	local v59 = p11.props.reportCategory == Constants.Category.Voice

	return withStyle(function(p12) -- line: 194
		-- upvalues: Cryo (copy), t2 (copy), v59 (copy), p11 (copy), Roact (copy), Provider (copy), PlayerCell (copy), isPlayerVerified (copy), v42 (copy), default (copy), Constants2 (copy)
		local v79 = Cryo.Dictionary.join(p12.Theme, t2)
		local v80 = Cryo.Dictionary.join(p12, {
			Theme = v79
		})
		local n1 = 0

		if v59 and p11.props.isReportDialogOpen then
			n1 += 1
		end

		return Roact.createElement(Provider, {
			style = v80
		}, { Roact.createElement(PlayerCell, {
			isOnline = true,
			isSelected = false,
			LayoutOrder = 1,
			userId = p11.props.targetPlayer.UserId,
			username = p11.props.targetPlayer.Name,
			displayName = p11.props.targetPlayer.DisplayName,
			hasVerifiedBadge = isPlayerVerified(p11.props.targetPlayer),
			key = tostring(p11.props.targetPlayer.UserId),
			memoKey = n1
		}, {
			VoiceIndicator = v59 and (not not p11.props.isReportDialogOpen and Roact.createElement(v42, {
				hideOnError = true,
				iconStyle = "SpeakerLight",
				userId = tostring(p11.props.targetPlayer.UserId),
				size = UDim2.fromOffset(36, 36),
				onClicked = function() -- line: 225
					-- upvalues: default (copy), p11 (copy), Constants2 (copy)
					default:ToggleMutePlayer(p11.props.targetPlayer.UserId, Constants2.VOICE_CONTEXT_TYPE.REPORT_MENU)
				end
			})) or nil
		}) })
	end)
end
function v48.renderDropDownMenu(p13) -- line: 238
	-- upvalues: isShowUKOSAIllegalContentReportingLink (copy), Roact (copy), withLocalization (copy), t1 (copy), DropdownMenu (copy)
	local v61 = not isShowUKOSAIllegalContentReportingLink() and 72 or 64

	if not p13.props.isReportDialogOpen then
		return nil
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		ZIndex = 10,
		Position = UDim2.fromOffset(0, v61),
		Size = UDim2.new(1, 0, 0, 48)
	}, {
		DropDown = withLocalization({
			menu1 = "CoreScripts.InGameMenu.Report.AbuseSwearing",
			menu2 = "CoreScripts.InGameMenu.Report.AbuseUsername",
			menu3 = "CoreScripts.InGameMenu.Report.AbuseBullying",
			menu4 = "CoreScripts.InGameMenu.Report.AbuseScamming",
			menu5 = "CoreScripts.InGameMenu.Report.AbuseDating",
			menu6 = "CoreScripts.InGameMenu.Report.AbuseExploiting",
			menu7 = "CoreScripts.InGameMenu.Report.AbusePersonalQuestion",
			menu8 = "CoreScripts.InGameMenu.Report.AbuseOffsiteLink",
			placeHolderText = "CoreScripts.InGameMenu.Report.AbuseTypePlaceHolder"
		})(function(p14) -- line: 260
			-- upvalues: t1 (copy), p13 (copy), Roact (copy), DropdownMenu (copy)
			local t3 = {}
			local t4 = {}

			for i, v in ipairs(t1) do
				local v87 = p14["menu" .. tostring(i)]

				table.insert(t3, {
					text = v87
				})
				t4[v87] = v
			end

			local function onDropDownChanged(p15) -- line: 271
				-- upvalues: t4 (copy), p13 (copy)
				local v112 = t4[p15]

				p13.onReasonChanged(v112)
			end

			return Roact.createElement(DropdownMenu, {
				showDropShadow = true,
				fixedListHeight = 171,
				placeholder = p14.placeHolderText,
				onChange = onDropDownChanged,
				height = UDim.new(0, 48),
				screenSize = p13.props.screenSize,
				cellDatas = t3
			})
		end)
	})
end
function v48.renderPlayerContents(p16) -- line: 290
	-- upvalues: withLocalization (copy), isShowUKOSAIllegalContentReportingLink (copy), Roact (copy), TextEntryField (copy)
	return withLocalization({
		placeHolderText = "CoreScripts.InGameMenu.Report.AbuseDetailsPlaceHolder"
	})(function(p17) -- line: 293
		-- upvalues: isShowUKOSAIllegalContentReportingLink (copy), Roact (copy), p16 (copy), TextEntryField (copy)
		local v90 = not isShowUKOSAIllegalContentReportingLink() and 132 or 118
		local v91 = not isShowUKOSAIllegalContentReportingLink() and -132 or -150

		return Roact.createFragment({
			PlayerInfo = p16:renderPlayerInfo(),
			DropDownMenu = p16:renderDropDownMenu(),
			TextField = Roact.createElement(TextEntryField, {
				maxTextLength = 160,
				autoFocusOnEnabled = false,
				enabled = p16.props.isReportDialogOpen,
				text = p16.state.descriptionText,
				textChanged = p16.onTextChanged,
				PlaceholderText = p17.placeHolderText,
				Position = UDim2.fromOffset(0, v90),
				Size = UDim2.new(1, 0, 1, v91)
			}),
			OSALinkFrame = p16:renderUKOSALink()
		})
	end)
end
function v48.renderPlaceContents(p18) -- line: 314
	-- upvalues: withLocalization (copy), isShowUKOSAIllegalContentReportingLink (copy), Roact (copy), GameIcon (copy), ThemedTextLabel (copy), TextEntryField (copy)
	return withLocalization({
		placeHolderText = "CoreScripts.InGameMenu.Report.AbuseDetailsPlaceHolder",
		labelText = {
			"CoreScripts.InGameMenu.Report.ReportingGame",
			RBX_NAME = p18.props.placeName
		}
	})(function(p19) -- line: 321
		-- upvalues: isShowUKOSAIllegalContentReportingLink (copy), Roact (copy), GameIcon (copy), ThemedTextLabel (copy), TextEntryField (copy), p18 (copy)
		local v93 = not isShowUKOSAIllegalContentReportingLink() and 24 or 12
		local v94 = not isShowUKOSAIllegalContentReportingLink() and 112 or 90
		local v95 = not isShowUKOSAIllegalContentReportingLink() and -112 or -135

		return Roact.createFragment({
			PlaceInfo = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(0, v93),
				Size = UDim2.new(1, 0, 0, 64)
			}, {
				GameIcon = Roact.createElement(GameIcon, {
					iconSize = 64,
					gameId = game.GameId,
					cornerRadius = UDim.new(0, 8)
				}),
				Label = Roact.createElement(ThemedTextLabel, {
					fontKey = "Body",
					themeKey = "TextDefault",
					BackgroundTransparency = 1,
					TextWrapped = true,
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 76, 0.5, 0),
					Size = UDim2.new(1, -76, 0, 40),
					Text = p19.labelText,
					TextXAlignment = Enum.TextXAlignment.Left
				})
			}),
			TextField = Roact.createElement(TextEntryField, {
				maxTextLength = 160,
				autoFocusOnEnabled = false,
				enabled = p18.props.isReportDialogOpen,
				text = p18.state.descriptionText,
				textChanged = p18.onTextChanged,
				PlaceholderText = p19.placeHolderText,
				Position = UDim2.fromOffset(0, v94),
				Size = UDim2.new(1, 0, 1, v95)
			}),
			OSALinkFrame = p18:renderUKOSALink()
		})
	end)
end
function v48.renderContents(p20) -- line: 363
	-- upvalues: Constants (copy)
	if p20.props.reportType == Constants.ReportType.Player then
		return p20:renderPlayerContents()
	end

	if p20.props.reportType == Constants.ReportType.Place then
		return p20:renderPlaceContents()
	end

	return nil
end

local t5 = {
	[Constants.Category.Voice] = "CoreScripts.InGameMenu.Report.Title.VoiceChat",
	[Constants.Category.Text] = "CoreScripts.InGameMenu.Report.Title.TextChat",
	[Constants.Category.Other] = "CoreScripts.InGameMenu.Report.Title.Other",
	[Constants.Category.Experience] = "CoreScripts.InGameMenu.Report.Title.Experience"
}

function v48.categoryTitle(p21) -- line: 380
	-- upvalues: Constants (copy), t5 (copy)
	if p21.props.reportType == Constants.ReportType.Place then
		return t5[Constants.Category.Experience]
	end

	return t5[p21.props.reportCategory] or "CoreScripts.InGameMenu.Report.ReportTitle"
end
function v48.render(p22) -- line: 387
	-- upvalues: withLocalization (copy), GetFFlagReportAnythingScreenshot (copy), Constants (copy), GetFFlagReportAnythingMultistepScreenshot (copy), React (copy), ScreenshotFlowStepHandler (copy), ScreenshotHelper (copy), ScreenshotDialog (copy), Roact (copy), ModalDialog (copy), ButtonStack (copy), ButtonType (copy)
	return withLocalization({
		cancelText = "CoreScripts.InGameMenu.Cancel",
		reportText = "CoreScripts.InGameMenu.Report.SendReport",
		toastDefaultTitle = "CoreScripts.InGameMenu.Report.Confirmation.ThanksForReport",
		toastDefaultDescription = "CoreScripts.InGameMenu.Report.Confirmation.ThanksForReportDescription",
		titleText = p22:categoryTitle()
	})(function(p23) -- line: 394
		-- upvalues: GetFFlagReportAnythingScreenshot (copy), p22 (copy), Constants (copy), GetFFlagReportAnythingMultistepScreenshot (copy), React (copy), ScreenshotFlowStepHandler (copy), ScreenshotHelper (copy), ScreenshotDialog (copy), Roact (copy), ModalDialog (copy), ButtonStack (copy), ButtonType (copy)
		if GetFFlagReportAnythingScreenshot() and p22.props.currentPage == Constants.Page.ScreenshotDialog then
			if GetFFlagReportAnythingMultistepScreenshot() then
				return React.createElement(ScreenshotFlowStepHandler, {
					titleText = "Highlight What's Wrong",
					entryPoint = "experience",
					dismissAction = p22.onCancel,
					screenshot = ScreenshotHelper:GetScreenshotContentId(),
					skipAnnotationAction = function() -- line: 403
					end,
					restartAction = function() -- line: 404
					end,
					reportAction = function() -- line: 405
					end
				})
			end

			return React.createElement(ScreenshotDialog, {
				titleText = "Highlight What's Wrong",
				screenshot = ScreenshotHelper:GetScreenshotContentId(),
				backAction = if not p22.props.canNavigateBack then nil else p22.navigateBack,
				dismissAction = p22.onCancel,
				reportAction = p22.onScreenshotAnnotated,
				initialAnnotationPoints = p22.props.screenshotAnnotationPoints
			})
		end

		return Roact.createElement(ModalDialog, {
			visible = p22.props.isReportDialogOpen,
			screenSize = p22.props.screenSize,
			titleText = p23.titleText,
			contents = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1)
			}, {
				Padding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 24),
					PaddingRight = UDim.new(0, 24)
				}),
				Contents = p22:renderContents()
			}),
			actionButtons = Roact.createElement(ButtonStack, {
				buttonHeight = 48,
				buttons = {
					{
						buttonType = ButtonType.Secondary,
						props = {
							onActivated = p22.onCancel,
							text = p23.cancelText
						}
					},
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							isDisabled = not p22:canReport(),
							onActivated = function() -- line: 447
								-- upvalues: p22 (copy), p23 (copy)
								return p22.onReport(p23.toastDefaultTitle, p23.toastDefaultDescription)
							end,
							text = p23.reportText
						}
					}
				}
			}),
			onDismiss = p22.onCancel,
			onBackButtonActivated = if not p22.props.canNavigateBack then nil else p22.navigateBack
		})
	end)
end
function v48.didUpdate(p24, p25) -- line: 461
	-- upvalues: Roact (copy)
	if p25.isReportDialogOpen and not p24.props.isReportDialogOpen then
		p24:setState({
			descriptionText = "",
			reasonText = Roact.None
		})
	end
end

return RoactRodux.UNSTABLE_connect2(function(p26, _) -- line: 471
	-- upvalues: Constants (copy)
	return {
		reportCategory = p26.report.reportCategory,
		isReportDialogOpen = p26.report.currentPage == Constants.Page.ReportForm,
		currentPage = p26.report.currentPage,
		reportType = p26.report.reportType,
		targetPlayer = p26.report.targetPlayer,
		canNavigateBack = #p26.report.history > 1,
		placeName = p26.placeInfo.name,
		screenSize = p26.displayOptions.screenSize,
		screenshotAnnotationPoints = p26.report.screenshotAnnotationPoints
	}
end, function(p28) -- line: 483
	-- upvalues: NavigateBack (copy), SendAnalytics (copy), Constants (copy), EndReportFlow (copy), SessionUtility (copy), FilterIdentifiedAvatars (copy), ScreenshotAnnotated (copy), SendReport (copy)
	return {
		navigateBack = function(p29, p30) -- line: 485
			-- upvalues: p28 (copy), NavigateBack (copy), SendAnalytics (copy), Constants (copy)
			p28(NavigateBack())
			SendAnalytics(Constants.Page.ReportForm, Constants.Analytics.ReportFlowBack, {
				source = Constants.Page.ReportForm,
				reason = p29,
				descriptionTextChanged = p30
			})
		end,
		closeDialog = function(p31, p32) -- line: 493
			-- upvalues: p28 (copy), EndReportFlow (copy), SendAnalytics (copy), Constants (copy), SessionUtility (copy)
			p28(EndReportFlow())
			SendAnalytics(Constants.Page.ReportForm, Constants.Analytics.ReportFlowAbandoned, {
				source = Constants.Page.ReportForm,
				reason = p31,
				descriptionTextChanged = p32
			})
			SessionUtility.endAbuseReportSession()
		end,
		screenshotAnnotated = function(p33, p34, p35) -- line: 503
			-- upvalues: p28 (copy), FilterIdentifiedAvatars (copy), ScreenshotAnnotated (copy)
			p28(FilterIdentifiedAvatars(p35))
			p28(ScreenshotAnnotated(p33, p34, p35))
		end,
		sendReport = function(p36, p37, p38, p39, p40, p41, p42) -- line: 507
			-- upvalues: p28 (copy), SendReport (copy)
			p28(SendReport(p36, p37, p38, p39, p40, p41, p42))
		end
	}
end)(v48)
