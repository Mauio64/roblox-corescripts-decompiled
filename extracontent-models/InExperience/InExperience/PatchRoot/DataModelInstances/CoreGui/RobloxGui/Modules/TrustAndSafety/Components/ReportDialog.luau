local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)

local parent = script.Parent.Parent
local Dependencies = require(parent.Dependencies)

local GameIcon = require(Dependencies.GameIcon)
local PlayerCell = require(Dependencies.PlayerCell)
local ThemedTextLabel = require(Dependencies.ThemedTextLabel)
local withLocalization = require(Dependencies.withLocalization)
local playerInterface = require(Dependencies.playerInterface)

local NavigateBack = require(parent.Actions.NavigateBack)
local EndReportFlow = require(parent.Actions.EndReportFlow)
local Constants = require(parent.Resources.Constants)
local SendReport = require(parent.Thunks.SendReport)
local TextEntryField = require(parent.Components.TextEntryField)
local ModalDialog = require(parent.Components.ModalDialog)
local SendAnalytics = require(parent.Utility.SendAnalytics)
local SessionUtility = require(parent.Utility.SessionUtility)

local Provider = UIBlox.Core.Style.Provider
local withStyle = UIBlox.Core.Style.withStyle
local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Colors = UIBlox.App.Style.Colors
local DropdownMenu = UIBlox.App.Menu.DropdownMenu

local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local isPlayerVerified = UserLib.Utils.isPlayerVerified

local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default
local VoiceIndicatorFunc = require(RobloxGui.Modules.VoiceChat.Components.VoiceIndicatorFunc)
local VoiceStateContext = require(RobloxGui.Modules.VoiceChat.VoiceStateContext)
local Constants2 = require(RobloxGui.Modules.VoiceChat.Constants)
local React = require(CorePackages.Packages.React)
local function fn(p)
	if React.useContext(VoiceStateContext.Context).voiceEnabled then
		return React.createElement(VoiceIndicatorFunc, Cryo.Dictionary.join(p, {}))
	end

	return nil
end

local DsaIllegalContentReporting = require(CorePackages.Workspace.Packages.DsaIllegalContentReporting)
local isShowUKOSAIllegalContentReportingLink = DsaIllegalContentReporting.isShowUKOSAIllegalContentReportingLink
local OSAReportLink = DsaIllegalContentReporting.OSAReportLink

local v = {
	"Swearing",
	"Inappropriate Username",
	"Bullying",
	"Scamming",
	"Dating",
	"Cheating/Exploiting",
	"Personal Question",
	"Offsite Links"
}

local v2 = {
	BackgroundDefault = { Color = Colors.Flint, Transparency = 1 },
	BackgroundOnHover = { Color = Colors.Flint, Transparency = 1 },
	BackgroundOnPress = { Color = Colors.Flint, Transparency = 1 }
}

local extended = Roact.PureComponent:extend("ReportDialog")

extended.validateProps = t.strictInterface({
	isReportDialogOpen = t.boolean,
	reportType = t.optional(t.valueOf(Constants.ReportType)),
	targetPlayer = t.optional(playerInterface),
	placeName = t.string,
	screenSize = t.Vector2,
	navigateBack = t.optional(t.callback),
	canNavigateBack = t.optional(t.boolean),
	sendReport = t.callback,
	closeDialog = t.optional(t.callback),
	reportCategory = t.optional(t.string)
})

function extended:init()
	self.state = { reasonText = nil, descriptionText = "" }

	function self.onReasonChanged(reasonText)
		self:setState({ reasonText = reasonText })
	end

	function self.onTextChanged(descriptionText)
		self:setState({ descriptionText = descriptionText })
	end

	function self.onReport(p, p2)
		local reason = self:getReason()
		self.props.sendReport(
			self.props.reportType,
			self.props.targetPlayer,
			reason,
			self.state.descriptionText,
			self.props.reportCategory,
			p,
			p2
		)
	end

	function self.navigateBack()
		self.props.navigateBack(self.state.reasonText, self.state.descriptionText ~= "")
	end

	function self.onCancel()
		self.props.closeDialog(self.state.reasonText, self.state.descriptionText ~= "")
	end
end

function extended:getReason()
	if self.props.reportType == Constants.ReportType.Player then
		return self.state.reasonText
	end

	if self.props.reportType == Constants.ReportType.Place then
		return "Inappropriate Content"
	end

	return nil
end

function extended:canReport()
	local v3 = self:getReason() ~= nil
	local v4 = utf8.len(utf8.nfcnormalize(self.state.descriptionText))
	local v5 = v4 >= 0 and v4 <= 160
	return v3 and v5
end

function extended:renderUKOSALink()
	if isShowUKOSAIllegalContentReportingLink() then
		return Roact.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 40),
				Position = UDim2.new(0, 0, 1, -45),
				LayoutOrder = 99
			},
			{
				OSALink = Roact.createElement(OSAReportLink)
			}
		)
	end

	return nil
end

function extended:renderPlayerInfo()
	local v3 = self.props.reportCategory == Constants.Category.Voice

	return withStyle(function(p)
		local joined = Cryo.Dictionary.join(p.Theme, v2)
		local joined2 = Cryo.Dictionary.join(p, { Theme = joined })

		local count = 0

		if v3 and self.props.isReportDialogOpen then
			count += 1
		end

		return Roact.createElement(Provider, { style = joined2 }, { Roact.createElement(PlayerCell, {
				userId = self.props.targetPlayer.UserId,
				username = self.props.targetPlayer.Name,
				displayName = self.props.targetPlayer.DisplayName,
				hasVerifiedBadge = isPlayerVerified(self.props.targetPlayer),
				isOnline = true,
				isSelected = false,
				LayoutOrder = 1,
				key = tostring(self.props.targetPlayer.UserId),
				memoKey = count
			}, {
				VoiceIndicator = v3 and self.props.isReportDialogOpen and Roact.createElement(fn, {
					userId = tostring(self.props.targetPlayer.UserId),
					hideOnError = true,
					iconStyle = "SpeakerLight",
					size = UDim2.fromOffset(36, 36),
					onClicked = function()
						default:ToggleMutePlayer(
							self.props.targetPlayer.UserId,
							Constants2.VOICE_CONTEXT_TYPE.REPORT_MENU
						)
					end
				}) or nil
			}) })
	end)
end

function extended:renderDropDownMenu()
	local v3 = isShowUKOSAIllegalContentReportingLink() and 64 or 72

	if self.props.isReportDialogOpen then
		return Roact.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(0, v3),
				Size = UDim2.new(1, 0, 0, 48),
				ZIndex = 10
			},
			{
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
				})(function(p)
					local cellDatas = {}
					local v4 = {}

					for i, v5 in ipairs(v) do
						local text = p["menu" .. tostring(i)]
						table.insert(cellDatas, { text = text })

						v4[text] = v5
					end

					local function onDropDownChanged(p2)
						local v5 = v4[p2]
						self.onReasonChanged(v5)
					end

					return Roact.createElement(DropdownMenu, {
						placeholder = p.placeHolderText,
						onChange = onDropDownChanged,
						height = UDim.new(0, 48),
						screenSize = self.props.screenSize,
						cellDatas = cellDatas,
						showDropShadow = true,
						fixedListHeight = 171
					})
				end)
			}
		)
	end

	return nil
end

function extended:renderPlayerContents()
	return withLocalization({
		placeHolderText = "CoreScripts.InGameMenu.Report.AbuseDetailsPlaceHolder"
	})(function(p)
		local v3 = isShowUKOSAIllegalContentReportingLink() and 118 or 132
		local v4 = isShowUKOSAIllegalContentReportingLink() and -150 or -132
		return Roact.createFragment({
			PlayerInfo = self:renderPlayerInfo(),
			DropDownMenu = self:renderDropDownMenu(),
			TextField = Roact.createElement(TextEntryField, {
				enabled = self.props.isReportDialogOpen,
				text = self.state.descriptionText,
				textChanged = self.onTextChanged,
				maxTextLength = 160,
				autoFocusOnEnabled = false,
				PlaceholderText = p.placeHolderText,
				Position = UDim2.fromOffset(0, v3),
				Size = UDim2.new(1, 0, 1, v4)
			}),
			OSALinkFrame = self:renderUKOSALink()
		})
	end)
end

function extended:renderPlaceContents()
	return withLocalization({
		labelText = {
			"CoreScripts.InGameMenu.Report.ReportingGame",
			RBX_NAME = self.props.placeName
		},
		placeHolderText = "CoreScripts.InGameMenu.Report.AbuseDetailsPlaceHolder"
	})(function(p)
		local v3 = isShowUKOSAIllegalContentReportingLink() and 12 or 24
		local v4 = isShowUKOSAIllegalContentReportingLink() and 90 or 112
		local v5 = isShowUKOSAIllegalContentReportingLink() and -135 or -112
		return Roact.createFragment({
			PlaceInfo = Roact.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					Position = UDim2.fromOffset(0, v3),
					Size = UDim2.new(1, 0, 0, 64)
				},
				{
					GameIcon = Roact.createElement(GameIcon, {
						gameId = game.GameId,
						iconSize = 64,
						cornerRadius = UDim.new(0, 8)
					}),
					Label = Roact.createElement(ThemedTextLabel, {
						fontKey = "Body",
						themeKey = "TextDefault",
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 76, 0.5, 0),
						Size = UDim2.new(1, -76, 0, 40),
						Text = p.labelText,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left
					})
				}
			),
			TextField = Roact.createElement(TextEntryField, {
				enabled = self.props.isReportDialogOpen,
				text = self.state.descriptionText,
				textChanged = self.onTextChanged,
				maxTextLength = 160,
				autoFocusOnEnabled = false,
				PlaceholderText = p.placeHolderText,
				Position = UDim2.fromOffset(0, v4),
				Size = UDim2.new(1, 0, 1, v5)
			}),
			OSALinkFrame = self:renderUKOSALink()
		})
	end)
end

function extended:renderContents()
	if self.props.reportType == Constants.ReportType.Player then
		return self:renderPlayerContents()
	end

	if self.props.reportType == Constants.ReportType.Place then
		return self:renderPlaceContents()
	end

	return nil
end

local v3 = {
	[Constants.Category.Voice] = "CoreScripts.InGameMenu.Report.Title.VoiceChat",
	[Constants.Category.Text] = "CoreScripts.InGameMenu.Report.Title.TextChat",
	[Constants.Category.Other] = "CoreScripts.InGameMenu.Report.Title.Other",
	[Constants.Category.Experience] = "CoreScripts.InGameMenu.Report.Title.Experience"
}

function extended:categoryTitle()
	if self.props.reportType == Constants.ReportType.Place then
		return v3[Constants.Category.Experience]
	end

	return v3[self.props.reportCategory] or "CoreScripts.InGameMenu.Report.ReportTitle"
end

function extended:render()
	return withLocalization({
		titleText = self:categoryTitle(),
		cancelText = "CoreScripts.InGameMenu.Cancel",
		reportText = "CoreScripts.InGameMenu.Report.SendReport",
		toastDefaultTitle = "CoreScripts.InGameMenu.Report.Confirmation.ThanksForReport",
		toastDefaultDescription = "CoreScripts.InGameMenu.Report.Confirmation.ThanksForReportDescription"
	})(function(props)
		local createElement = Roact.createElement
		local v4 = {
			visible = self.props.isReportDialogOpen,
			screenSize = self.props.screenSize,
			titleText = props.titleText,
			contents = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1)
			}, {
				Padding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 24),
					PaddingRight = UDim.new(0, 24)
				}),
				Contents = self:renderContents()
			}),
			actionButtons = Roact.createElement(ButtonStack, {
				buttonHeight = 48,
				buttons = {
					{
						buttonType = ButtonType.Secondary,
						props = { onActivated = self.onCancel, text = props.cancelText }
					},
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							isDisabled = not self:canReport(),
							onActivated = function()
								return self.onReport(props.toastDefaultTitle, props.toastDefaultDescription)
							end,
							text = props.reportText
						}
					}
				}
			}),
			onDismiss = self.onCancel,
			onBackButtonActivated = 0
		}
		local onBackButtonActivated

		if self.props.canNavigateBack then
			onBackButtonActivated = self.navigateBack
		end

		v4.onBackButtonActivated = onBackButtonActivated
		return createElement(ModalDialog, v4)
	end)
end

function extended.didUpdate(object, p)
	if p.isReportDialogOpen and not object.props.isReportDialogOpen then
		object:setState({ reasonText = Roact.None, descriptionText = "" })
	end
end

return RoactRodux.UNSTABLE_connect2(function(data, _)
	return {
		reportCategory = data.report.reportCategory,
		isReportDialogOpen = data.report.currentPage == Constants.Page.ReportForm,
		reportType = data.report.reportType,
		targetPlayer = data.report.targetPlayer,
		canNavigateBack = #data.report.history > 1,
		placeName = data.placeInfo.name,
		screenSize = data.displayOptions.screenSize
	}
end, function(callback)
	return {
		navigateBack = function(reason, descriptionTextChanged)
			callback(NavigateBack())
			SendAnalytics(Constants.Page.ReportForm, Constants.Analytics.ReportFlowBack, {
				source = Constants.Page.ReportForm,
				reason = reason,
				descriptionTextChanged = descriptionTextChanged
			})
		end,
		closeDialog = function(reason, descriptionTextChanged)
			callback(EndReportFlow())
			SendAnalytics(Constants.Page.ReportForm, Constants.Analytics.ReportFlowAbandoned, {
				source = Constants.Page.ReportForm,
				reason = reason,
				descriptionTextChanged = descriptionTextChanged
			})

			SessionUtility.endAbuseReportSession()
		end,
		sendReport = function(p, p2, p3, p4, p5, p6, p7)
			callback(SendReport(p, p2, p3, p4, p5, p6, p7))
		end
	}
end)(extended)
