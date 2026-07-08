local ContextActionService = game:GetService("ContextActionService")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local withStyle = UIBlox.Core.Style.withStyle
local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local ParentParent = script.Parent.Parent
local Dependencies = require(ParentParent.Dependencies)
local FocusHandler = require(Dependencies.FocusHandler)
local playerInterface = require(Dependencies.playerInterface)
local Divider = require(Dependencies.Divider)
local ThemedTextLabel = require(Dependencies.ThemedTextLabel)
local withLocalization = require(Dependencies.withLocalization)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local BlockPlayer = require(ParentParent.Thunks.BlockPlayer)
local BlockPlayerItem = require(ParentParent.Components.BlockPlayerItem)
local EndReportFlow = require(ParentParent.Actions.EndReportFlow)

require(ParentParent.Actions.OpenBlockPlayerDialog)

local ShowToast = require(ParentParent.Actions.ShowToast)
local Constants = require(ParentParent.Resources.Constants)
local Assets = require(ParentParent.Resources.Assets)
local ModalDialog = require(ParentParent.Components.ModalDialog)
local Constants2 = require(RobloxGui.Modules.VoiceChat.Constants)
local v28 = Roact.PureComponent:extend("ReportSentDialog")

v28.validateProps = t.strictInterface({
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

function isPlayerUserIdMuted(p1) -- line: 55
	-- upvalues: default (copy)
	local v30 = false

	if default.participants then
		local v31 = default.participants[tostring(p1)]

		if v31 then
			v30 = v31.isMutedLocally
		end
	end

	return v30
end
function v28.init(p2) -- line: 66
	-- upvalues: Roact (copy), default (copy), Constants2 (copy)
	p2:clearState()
	p2.buttonRef = Roact.createRef()

	function p2.onBlockCheckBoxActivated(p3) -- line: 70
		-- upvalues: p2 (copy)
		p2:setState({
			isBlockCheckBoxSelected = p3,
			isMuteCheckBoxSelected = p3 and not not p2:isVoiceReport() or p2.state.isMuteCheckBoxSelected
		})
	end
	function p2.onMuteCheckBoxActivated(p4) -- line: 79
		-- upvalues: p2 (copy)
		p2:setState({
			isMuteCheckBoxSelected = p4
		})
	end
	function p2.hasMuteChanged() -- line: 85
		-- upvalues: p2 (copy)
		return p2.state.isMuteCheckBoxSelected ~= p2.state.wasPlayerMutedWhenDialogOpened
	end
	function p2.getToastMessage(p5) -- line: 89
		-- upvalues: p2 (copy)
		local t1 = {
			title = p5.toastDefaultTitle,
			description = p5.toastDefaultDescription
		}

		if p2.state.isMuteCheckBoxSelected and p2.state.isBlockCheckBoxSelected then
			t1.title = p5.toastMutedAndBlockedTitle
			t1.description = p5.toastMutedAndBlockedDescription

			return t1
		end

		if p2.state.isMuteCheckBoxSelected then
			t1.title = p5.toastMutedTitle
			t1.description = p5.toastMutedDescription

			return t1
		end

		if p2.state.isBlockCheckBoxSelected then
			t1.title = p5.toastBlockedTitle
			t1.description = p5.toastBlockedDescription
		end

		return t1
	end
	function p2.onConfirm(p6) -- line: 110
		-- upvalues: p2 (copy), default (copy), Constants2 (copy)
		if p2:isReportingPlayer() then
			local v53 = p2.getToastMessage(p6)

			if p2:hasMuteChanged() then
				default:ToggleMutePlayer(p2.props.targetPlayer.UserId, Constants2.VOICE_CONTEXT_TYPE.REPORT_MENU)
			end

			if p2.state.isBlockCheckBoxSelected then
				p2.props.blockPlayer(p2.props.targetPlayer, v53.title, v53.description)
			else
				p2.props.showToast(v53.title, v53.description)
			end
		end

		p2.props.closeDialog()
		p2:clearState()
	end
	function p2.onCancel() -- line: 131
		-- upvalues: p2 (copy)
		p2.props.closeDialog()
		p2:clearState()
	end
end
function v28.clearState(p7) -- line: 137
	p7:setState({
		wasPlayerMutedWhenDialogOpened = false,
		isMuteCheckBoxSelected = false,
		isBlockCheckBoxSelected = false
	})
end
function v28.isVoiceReport(p8) -- line: 145
	-- upvalues: Constants (copy)
	return p8:isReportingPlayer() and p8.props.reportCategory == Constants.Category.Voice
end
function v28.doesRequireConfirmation(p9) -- line: 149
	return p9.state.isBlockCheckBoxSelected or p9:hasMuteChanged()
end
function v28.isReportingPlayer(p10) -- line: 154
	-- upvalues: Constants (copy)
	return p10.props.reportType == Constants.ReportType.Player and p10.props.targetPlayer ~= nil
end
function v28.renderFocusHandler(p11) -- line: 158
	-- upvalues: Roact (copy), FocusHandler (copy), Constants (copy), GuiService (copy), ContextActionService (copy)
	return Roact.createElement(FocusHandler, {
		isFocused = p11.props.inputType == Constants.InputType.Gamepad and p11.props.isReportSentOpen,
		didFocus = function() -- line: 161
			-- upvalues: GuiService (copy), p11 (copy), ContextActionService (copy)
			GuiService:RemoveSelectionGroup("ReportSentDialogGroup")
			GuiService:AddSelectionParent("ReportSentDialogGroup", p11.buttonRef:getValue())
			GuiService.SelectedCoreObject = p11.buttonRef:getValue()
			ContextActionService:BindCoreAction("ReporSentDialogSinkAction", function(_, _) -- line: 166
				return Enum.ContextActionResult.Sink
			end, false, Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonY, Enum.KeyCode.ButtonX)
		end,
		didBlur = function() -- line: 170
			-- upvalues: ContextActionService (copy), GuiService (copy)
			ContextActionService:UnbindCoreAction("ReporSentDialogSinkAction")
			GuiService:RemoveSelectionGroup("ReportSentDialogGroup")
		end
	})
end
function v28.renderBlockFrame(p14) -- line: 177
	-- upvalues: withLocalization (copy), Roact (copy), Divider (copy), BlockPlayerItem (copy), Assets (copy)
	if not p14:isReportingPlayer() then
		return nil
	end

	return withLocalization({
		mutePlayerText = "CoreScripts.InGameMenu.Report.Mute",
		mutePlayerDescription = "CoreScripts.InGameMenu.Report.MuteDescription",
		blockPlayerText = "CoreScripts.InGameMenu.Report.Block",
		blockPlayerDescription = "CoreScripts.InGameMenu.Report.BlockDescription"
	})(function(p15) -- line: 186
		-- upvalues: Roact (copy), Divider (copy), p14 (copy), BlockPlayerItem (copy), Assets (copy)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Divider = Roact.createElement(Divider, {
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 1)
			}),
			MutePlayerItem = if not p14:isVoiceReport() then nil else Roact.createElement(BlockPlayerItem, {
				layoutOrder = 2,
				size = UDim2.new(1, 0, 0, 72),
				text = p15.mutePlayerText,
				description = p15.mutePlayerDescription,
				icon = Assets.Images.MuteIcon.Image,
				iconSize = Assets.Images.MuteIcon.Size,
				isDisabled = p14.state.isBlockCheckBoxSelected,
				isCheckBoxSelected = p14.state.isMuteCheckBoxSelected,
				onCheckBoxActivated = p14.onMuteCheckBoxActivated
			}),
			BlockPlayerItem = Roact.createElement(BlockPlayerItem, {
				layoutOrder = 3,
				size = UDim2.new(1, 0, 0, 72),
				text = p15.blockPlayerText,
				description = p15.blockPlayerDescription,
				icon = Assets.Images.BlockIcon.Image,
				iconSize = Assets.Images.BlockIcon.Size,
				isCheckBoxSelected = p14.state.isBlockCheckBoxSelected,
				onCheckBoxActivated = p14.onBlockCheckBoxActivated
			})
		})
	end)
end
function v28.renderContents(p16) -- line: 228
	-- upvalues: withStyle (copy), withLocalization (copy), Roact (copy), ThemedTextLabel (copy)
	return withStyle(function(_) -- line: 229
		-- upvalues: withLocalization (copy), p16 (copy), Roact (copy), ThemedTextLabel (copy)
		return withLocalization({
			bodyText = "CoreScripts.InGameMenu.Report.ThanksForReportDescription",
			otherStepsText = {
				"CoreScripts.InGameMenu.Report.OtherStepsTitle",
				RBX_NAME = p16.props.targetPlayer.Name
			}
		})(function(p18) -- line: 236
			-- upvalues: Roact (copy), ThemedTextLabel (copy), p16 (copy)
			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				BodyFrame = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					Size = UDim2.new(1, 0, 0, 0)
				}, {
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
						themeKey = "TextEmphasis",
						TextWrapped = true,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.new(1, 0, 0, 0),
						Text = p18.bodyText,
						TextXAlignment = Enum.TextXAlignment.Left
					}),
					OtherStepsText = Roact.createElement(ThemedTextLabel, {
						LayoutOrder = 2,
						fontKey = "Footer",
						themeKey = "TextDefault",
						TextWrapped = true,
						AutomaticSize = Enum.AutomaticSize.Y,
						Position = UDim2.new(0, 0, 0, 12),
						Size = UDim2.new(1, 0, 0, 0),
						Text = p18.otherStepsText,
						TextXAlignment = Enum.TextXAlignment.Left
					})
				}),
				BlockFrame = p16:renderBlockFrame()
			})
		end)
	end)
end
function v28.render(p19) -- line: 291
	-- upvalues: withLocalization (copy), Roact (copy), ModalDialog (copy), Button (copy), ButtonType (copy)
	if not p19:isReportingPlayer() then
		return nil
	end

	return withLocalization({
		titleText = "CoreScripts.InGameMenu.Report.ThanksForReport",
		toastDefaultTitle = "CoreScripts.InGameMenu.Report.Confirmation.ThanksForReport",
		toastDefaultDescription = "CoreScripts.InGameMenu.Report.Confirmation.ThanksForReportDescription",
		toastMutedTitle = "CoreScripts.InGameMenu.Report.Confirmation.Muted",
		toastMutedAndBlockedTitle = "CoreScripts.InGameMenu.Report.Confirmation.MutedAndBlocked",
		toastBlockedTitle = "CoreScripts.InGameMenu.Report.Confirmation.Blocked",
		dismissText = not p19:doesRequireConfirmation() and "CoreScripts.InGameMenu.Report.Done" or "CoreScripts.InGameMenu.Report.Confirm",
		toastMutedDescription = {
			"CoreScripts.InGameMenu.Report.Confirmation.MutedDescriptionWithUser",
			RBX_NAME = p19.props.targetPlayer.Name
		},
		toastMutedAndBlockedDescription = {
			"CoreScripts.InGameMenu.Report.Confirmation.MutedAndBlockedDescriptionWithUser",
			RBX_NAME = p19.props.targetPlayer.Name
		},
		toastBlockedDescription = {
			"CoreScripts.InGameMenu.Report.Confirmation.MutedAndBlockedDescriptionWithUser",
			RBX_NAME = p19.props.targetPlayer.Name
		}
	})(function(p20) -- line: 317
		-- upvalues: Roact (copy), ModalDialog (copy), p19 (copy), Button (copy), ButtonType (copy)
		return Roact.createFragment({
			ModalDialog = Roact.createElement(ModalDialog, {
				visible = p19.props.isReportSentOpen,
				screenSize = p19.props.screenSize,
				titleText = p20.titleText,
				contents = p19:renderContents(),
				actionButtons = Roact.createElement(Button, {
					buttonType = ButtonType.PrimarySystem,
					size = UDim2.new(1, 0, 1, 0),
					onActivated = function() -- line: 327
						-- upvalues: p19 (copy), p20 (copy)
						return p19.onConfirm(p20)
					end,
					text = p20.dismissText,
					[Roact.Ref] = p19.buttonRef
				}),
				onDismiss = p19.onCancel
			}),
			FocusHandler = p19:renderFocusHandler()
		})
	end)
end
function v28.didUpdate(p21, p22, _) -- line: 340
	if not p22.isReportSentOpen and (p21.props.isReportSentOpen and p21:isVoiceReport()) then
		local v44 = isPlayerUserIdMuted(p21.props.targetPlayer.UserId)

		p21:setState({
			wasPlayerMutedWhenDialogOpened = v44,
			isMuteCheckBoxSelected = v44
		})
	end
end

return RoactRodux.UNSTABLE_connect2(function(p24, _) -- line: 350
	-- upvalues: Constants (copy)
	return {
		isReportSentOpen = p24.report.currentPage == Constants.Page.ReportSent,
		reportType = p24.report.reportType,
		targetPlayer = p24.report.targetPlayer,
		screenSize = p24.displayOptions.screenSize,
		reportCategory = p24.report.reportCategory
	}
end, function(p26) -- line: 359
	-- upvalues: EndReportFlow (copy), BlockPlayer (copy), ShowToast (copy)
	return {
		closeDialog = function() -- line: 361
			-- upvalues: p26 (copy), EndReportFlow (copy)
			p26(EndReportFlow())
		end,
		blockPlayer = function(p27, p28, p29) -- line: 364
			-- upvalues: p26 (copy), BlockPlayer (copy)
			p26(BlockPlayer(p27, p28, p29))
		end,
		showToast = function(p30, p31) -- line: 367
			-- upvalues: p26 (copy), ShowToast (copy)
			p26(ShowToast(p30, p31))
		end
	}
end)(v28)
