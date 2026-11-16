local ContextActionService = game:GetService("ContextActionService")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)

local withStyle = UIBlox.Core.Style.withStyle

local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default

local parent = script.Parent.Parent
local Dependencies = require(parent.Dependencies)
local FocusHandler = require(Dependencies.FocusHandler)
local playerInterface = require(Dependencies.playerInterface)
local Divider = require(Dependencies.Divider)
local ThemedTextLabel = require(Dependencies.ThemedTextLabel)
local withLocalization = require(Dependencies.withLocalization)

local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType

local BlockPlayer = require(parent.Thunks.BlockPlayer)
local BlockPlayerItem = require(parent.Components.BlockPlayerItem)
local EndReportFlow = require(parent.Actions.EndReportFlow)
require(parent.Actions.OpenBlockPlayerDialog)
local ShowToast = require(parent.Actions.ShowToast)
local Constants = require(parent.Resources.Constants)
local Assets = require(parent.Resources.Assets)
local ModalDialog = require(parent.Components.ModalDialog)
local Constants2 = require(RobloxGui.Modules.VoiceChat.Constants)

local extended = Roact.PureComponent:extend("ReportSentDialog")

extended.validateProps = t.strictInterface({
	isReportSentOpen = t.boolean,
	screenSize = t.Vector2,
	inputType = t.optional(t.string),
	reportType = t.optional(t.valueOf(Constants.ReportType)),
	targetPlayer = t.optional(playerInterface),
	blockPlayer = t.callback,
	showToast = t.callback,
	closeDialog = t.callback,
	reportCategory = t.optional(t.string)
})

function isPlayerUserIdMuted(p)
	local v = false

	if default.participants then
		local participant = default.participants[tostring(p)]

		if participant then
			return participant.isMutedLocally
		end
	end

	return v
end

function extended:init()
	self:clearState()
	self.buttonRef = Roact.createRef()

	function self.onBlockCheckBoxActivated(isBlockCheckBoxSelected)
		self:setState({
			isBlockCheckBoxSelected = isBlockCheckBoxSelected,
			isMuteCheckBoxSelected = isBlockCheckBoxSelected and self:isVoiceReport() and true or self.state.isMuteCheckBoxSelected
		})
	end

	function self.onMuteCheckBoxActivated(isMuteCheckBoxSelected)
		self:setState({ isMuteCheckBoxSelected = isMuteCheckBoxSelected })
	end

	function self.hasMuteChanged(): boolean
		return self.state.isMuteCheckBoxSelected ~= self.state.wasPlayerMutedWhenDialogOpened
	end

	function self.getToastMessage(data)
		local v = { title = data.toastDefaultTitle, description = data.toastDefaultDescription }

		if self.state.isMuteCheckBoxSelected and self.state.isBlockCheckBoxSelected then
			v.title = data.toastMutedAndBlockedTitle
			v.description = data.toastMutedAndBlockedDescription
		elseif self.state.isMuteCheckBoxSelected then
			v.title = data.toastMutedTitle
			v.description = data.toastMutedDescription
		elseif self.state.isBlockCheckBoxSelected then
			v.title = data.toastBlockedTitle
			v.description = data.toastBlockedDescription
		end

		return v
	end

	function self.onConfirm(p)
		if self:isReportingPlayer() then
			local toastMessage = self.getToastMessage(p)

			if self:hasMuteChanged() then
				default:ToggleMutePlayer(self.props.targetPlayer.UserId, Constants2.VOICE_CONTEXT_TYPE.REPORT_MENU)
			end

			if self.state.isBlockCheckBoxSelected then
				self.props.blockPlayer(self.props.targetPlayer, toastMessage.title, toastMessage.description)
			else
				self.props.showToast(toastMessage.title, toastMessage.description)
			end
		end

		self.props.closeDialog()
		self:clearState()
	end

	function self.onCancel()
		self.props.closeDialog()
		self:clearState()
	end
end

function extended:clearState()
	self:setState({
		wasPlayerMutedWhenDialogOpened = false,
		isMuteCheckBoxSelected = false,
		isBlockCheckBoxSelected = false
	})
end

function extended:isVoiceReport()
	return self:isReportingPlayer() and self.props.reportCategory == Constants.Category.Voice
end

function extended:doesRequireConfirmation()
	return self.state.isBlockCheckBoxSelected or self:hasMuteChanged()
end

function extended:isReportingPlayer(): boolean
	return self.props.reportType == Constants.ReportType.Player and self.props.targetPlayer ~= nil
end

function extended:renderFocusHandler()
	return Roact.createElement(FocusHandler, {
		isFocused = self.props.inputType == Constants.InputType.Gamepad and self.props.isReportSentOpen,
		didFocus = function()
			GuiService:RemoveSelectionGroup("ReportSentDialogGroup")
			GuiService:AddSelectionParent("ReportSentDialogGroup", self.buttonRef:getValue())
			GuiService.SelectedCoreObject = self.buttonRef:getValue()

			ContextActionService:BindCoreAction("ReporSentDialogSinkAction", function(_, _)
				return Enum.ContextActionResult.Sink
			end, false, Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonY, Enum.KeyCode.ButtonX)
		end,
		didBlur = function()
			ContextActionService:UnbindCoreAction("ReporSentDialogSinkAction")
			GuiService:RemoveSelectionGroup("ReportSentDialogGroup")
		end
	})
end

function extended:renderBlockFrame()
	if self:isReportingPlayer() then
		return withLocalization({
			mutePlayerText = "CoreScripts.InGameMenu.Report.Mute",
			mutePlayerDescription = "CoreScripts.InGameMenu.Report.MuteDescription",
			blockPlayerText = "CoreScripts.InGameMenu.Report.Block",
			blockPlayerDescription = "CoreScripts.InGameMenu.Report.BlockDescription"
		})(function(props)
			local createElement = Roact.createElement
			local v = { BackgroundTransparency = 1, LayoutOrder = 2, Size = UDim2.new(1, 0, 1, 0) }
			local v2 = {
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Divider = Roact.createElement(Divider, {
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, 1)
				}),
				MutePlayerItem = 0,
				BlockPlayerItem = 0
			}
			local mutePlayerItem

			if self:isVoiceReport() then
				mutePlayerItem = Roact.createElement(BlockPlayerItem, {
					layoutOrder = 2,
					size = UDim2.new(1, 0, 0, 72),
					text = props.mutePlayerText,
					description = props.mutePlayerDescription,
					icon = Assets.Images.MuteIcon.Image,
					iconSize = Assets.Images.MuteIcon.Size,
					isDisabled = self.state.isBlockCheckBoxSelected,
					isCheckBoxSelected = self.state.isMuteCheckBoxSelected,
					onCheckBoxActivated = self.onMuteCheckBoxActivated
				})
			end

			v2.MutePlayerItem = mutePlayerItem

			v2.BlockPlayerItem = Roact.createElement(BlockPlayerItem, {
				layoutOrder = 3,
				size = UDim2.new(1, 0, 0, 72),
				text = props.blockPlayerText,
				description = props.blockPlayerDescription,
				icon = Assets.Images.BlockIcon.Image,
				iconSize = Assets.Images.BlockIcon.Size,
				isCheckBoxSelected = self.state.isBlockCheckBoxSelected,
				onCheckBoxActivated = self.onBlockCheckBoxActivated
			})
			return createElement("Frame", v, v2)
		end)
	end

	return nil
end

function extended:renderContents()
	return withStyle(function(_)
		return withLocalization({
			bodyText = "CoreScripts.InGameMenu.Report.ThanksForReportDescription",
			otherStepsText = {
				"CoreScripts.InGameMenu.Report.OtherStepsTitle",
				RBX_NAME = self.props.targetPlayer.Name
			}
		})(function(p)
			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				BodyFrame = Roact.createElement(
					"Frame",
					{
						BackgroundTransparency = 1,
						AutomaticSize = Enum.AutomaticSize.XY,
						Size = UDim2.new(1, 0, 0, 0),
						LayoutOrder = 1
					},
					{
						Layout = Roact.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Vertical,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, 12)
						}),
						Padding = Roact.createElement("UIPadding", {
							PaddingTop = UDim.new(0, 12),
							PaddingBottom = UDim.new(0, 12),
							PaddingLeft = UDim.new(0, 24),
							PaddingRight = UDim.new(0, 24)
						}),
						BodyText = Roact.createElement(ThemedTextLabel, {
							LayoutOrder = 1,
							AutomaticSize = Enum.AutomaticSize.Y,
							Size = UDim2.new(1, 0, 0, 0),
							themeKey = "TextEmphasis",
							Text = p.bodyText,
							TextWrapped = true,
							TextXAlignment = Enum.TextXAlignment.Left
						}),
						OtherStepsText = Roact.createElement(ThemedTextLabel, {
							LayoutOrder = 2,
							AutomaticSize = Enum.AutomaticSize.Y,
							Position = UDim2.new(0, 0, 0, 12),
							Size = UDim2.new(1, 0, 0, 0),
							fontKey = "Footer",
							themeKey = "TextDefault",
							Text = p.otherStepsText,
							TextWrapped = true,
							TextXAlignment = Enum.TextXAlignment.Left
						})
					}
				),
				BlockFrame = self:renderBlockFrame()
			})
		end)
	end)
end

function extended:render()
	if self:isReportingPlayer() then
		return withLocalization({
			titleText = "CoreScripts.InGameMenu.Report.ThanksForReport",
			dismissText = self:doesRequireConfirmation() and "CoreScripts.InGameMenu.Report.Confirm" or "CoreScripts.InGameMenu.Report.Done",
			toastDefaultTitle = "CoreScripts.InGameMenu.Report.Confirmation.ThanksForReport",
			toastDefaultDescription = "CoreScripts.InGameMenu.Report.Confirmation.ThanksForReportDescription",
			toastMutedTitle = "CoreScripts.InGameMenu.Report.Confirmation.Muted",
			toastMutedDescription = {
				"CoreScripts.InGameMenu.Report.Confirmation.MutedDescriptionWithUser",
				RBX_NAME = self.props.targetPlayer.Name
			},
			toastMutedAndBlockedTitle = "CoreScripts.InGameMenu.Report.Confirmation.MutedAndBlocked",
			toastMutedAndBlockedDescription = {
				"CoreScripts.InGameMenu.Report.Confirmation.MutedAndBlockedDescriptionWithUser",
				RBX_NAME = self.props.targetPlayer.Name
			},
			toastBlockedTitle = "CoreScripts.InGameMenu.Report.Confirmation.Blocked",
			toastBlockedDescription = {
				"CoreScripts.InGameMenu.Report.Confirmation.MutedAndBlockedDescriptionWithUser",
				RBX_NAME = self.props.targetPlayer.Name
			}
		})(function(p)
			return Roact.createFragment({
				ModalDialog = Roact.createElement(ModalDialog, {
					visible = self.props.isReportSentOpen,
					screenSize = self.props.screenSize,
					titleText = p.titleText,
					contents = self:renderContents(),
					actionButtons = Roact.createElement(Button, {
						buttonType = ButtonType.PrimarySystem,
						size = UDim2.new(1, 0, 1, 0),
						onActivated = function()
							return self.onConfirm(p)
						end,
						text = p.dismissText,
						[Roact.Ref] = self.buttonRef
					}),
					onDismiss = self.onCancel
				}),
				FocusHandler = self:renderFocusHandler()
			})
		end)
	end

	return nil
end

function extended:didUpdate(p, _)
	if not p.isReportSentOpen and self.props.isReportSentOpen and self:isVoiceReport() then
		local playerUserIdMuted = isPlayerUserIdMuted(self.props.targetPlayer.UserId)
		self:setState({
			wasPlayerMutedWhenDialogOpened = playerUserIdMuted,
			isMuteCheckBoxSelected = playerUserIdMuted
		})
	end
end

return RoactRodux.UNSTABLE_connect2(function(p, _)
	return {
		isReportSentOpen = p.report.currentPage == Constants.Page.ReportSent,
		reportType = p.report.reportType,
		targetPlayer = p.report.targetPlayer,
		screenSize = p.displayOptions.screenSize,
		reportCategory = p.report.reportCategory
	}
end, function(callback)
	return {
		closeDialog = function()
			callback(EndReportFlow())
		end,
		blockPlayer = function(p, p2, p3)
			callback(BlockPlayer(p, p2, p3))
		end,
		showToast = function(p, p2)
			callback(ShowToast(p, p2))
		end
	}
end)(extended)
