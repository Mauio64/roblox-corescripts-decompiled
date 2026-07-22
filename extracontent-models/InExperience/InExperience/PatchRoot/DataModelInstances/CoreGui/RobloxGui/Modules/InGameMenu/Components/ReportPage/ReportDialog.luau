local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t
local Cryo = InGameMenuDependencies.Cryo
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local ParentParent = script.Parent.Parent.Parent
local Flags = ParentParent.Flags
local GetFFlagIGMGamepadSelectionHistory = require(Flags.GetFFlagIGMGamepadSelectionHistory)
local FocusHandler = require(script.Parent.Parent.Connection.FocusHandler)
local Assets = require(ParentParent.Resources.Assets)
local CloseReportDialog = require(ParentParent.Actions.CloseReportDialog)
local withLocalization = require(ParentParent.Localization.withLocalization)
local ThemedTextLabel = require(ParentParent.Components.ThemedTextLabel)
local TextEntryField = require(script.Parent.TextEntryField)
local DropDownSelection = require(ParentParent.Components.DropDownSelection)
local Constants = require(ParentParent.Resources.Constants)
local SendAnalytics = require(ParentParent.Utility.SendAnalytics)
local SendReport = require(ParentParent.Thunks.SendReport)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Image = require(CorePackages.Packages.Foundation).Image
local FFlagCoreUiMigrateUIBloxToFoundation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCoreUiMigrateUIBloxToFoundation
local v29 = Roact.PureComponent:extend("ReportDialog")
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
	"CoreScripts.InGameMenu.Report.AbuseSwearing",
	"CoreScripts.InGameMenu.Report.AbuseUsername",
	"CoreScripts.InGameMenu.Report.AbuseBullying",
	"CoreScripts.InGameMenu.Report.AbuseScamming",
	"CoreScripts.InGameMenu.Report.AbuseDating",
	"CoreScripts.InGameMenu.Report.AbuseExploiting",
	"CoreScripts.InGameMenu.Report.AbusePersonalQuestion",
	"CoreScripts.InGameMenu.Report.AbuseOffsiteLink"
}

v29.validateProps = t.strictInterface({
	isOpen = t.boolean,
	userId = t.optional(t.integer),
	userName = t.optional(t.string),
	placeName = t.string,
	dispatchCloseReportDialog = t.callback,
	dispatchSendReport = t.callback,
	canCaptureFocus = t.optional(t.boolean),
	isGamepadLastInput = t.optional(t.boolean)
})

function v29.init(p1) -- line: 87
	-- upvalues: Roact (copy)
	p1.state = {
		abuseDescription = "",
		typeOfAbuseIndex = 0
	}
	p1.selectionGroupRef = Roact.createRef()
	p1.reportTextEntryRef = Roact.createRef()
	p1.reportDropDownRef = Roact.createRef()
end
function v29.renderReportTitle(_, p3, p4, p5) -- line: 98
	-- upvalues: Roact (copy), ThemedTextLabel (copy)
	p4.Title = Roact.createElement(ThemedTextLabel, {
		fontKey = "Header1",
		themeKey = "TextEmphasis",
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 48),
		Text = p5
	})
	p4.Divider = Roact.createElement("Frame", {
		BorderSizePixel = 0,
		LayoutOrder = 2,
		BackgroundColor3 = p3.Theme.Divider.Color,
		BackgroundTransparency = p3.Theme.Divider.Transparency,
		Size = UDim2.new(0.8, 0, 0, 1)
	})
end
function v29.renderTextEntryField(p6, p7, p8, p9) -- line: 117
	-- upvalues: Roact (copy), TextEntryField (copy)
	p8.ReportDescription = Roact.createElement(TextEntryField, {
		enabled = p6.props.isOpen,
		text = p6.state.abuseDescription,
		textChanged = function(p10) -- line: 121
			-- upvalues: p6 (copy)
			p6:setState({
				abuseDescription = p10
			})
		end,
		maxTextLength = 160,
		autoFocusOnEnabled = not p6.props.isGamepadLastInput,
		PlaceholderText = p7.textboxPlaceHolder,
		LayoutOrder = 5,
		Size = p9,
		[Roact.Ref] = p6.reportTextEntryRef
	})
end
function v29.renderButtons(p11, _, p13, p14) -- line: 136
	-- upvalues: t1 (copy), Roact (copy), Button (copy), ButtonType (copy)
	local v45 = utf8.len(utf8.nfcnormalize(p11.state.abuseDescription))
	local v46 = v45 >= 0 and v45 <= 160
	local v47 = p11.state.typeOfAbuseIndex > 0 or p11.props.userId == nil

	p14.ButtonContainer = Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 6,
		Size = UDim2.new(1, 0, 0, 60)
	}, {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			Padding = UDim.new(0, 12),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Bottom
		}),
		CancelButton = Roact.createElement(Button, {
			layoutOrder = 1,
			buttonType = ButtonType.Secondary,
			size = UDim2.fromOffset(144, 36),
			text = p13.cancel,
			onActivated = p11.props.dispatchCloseReportDialog
		}),
		ConfirmButton = Roact.createElement(Button, {
			layoutOrder = 2,
			buttonType = ButtonType.PrimarySystem,
			size = UDim2.fromOffset(144, 36),
			isDisabled = not (v46 and v47),
			text = p13.report,
			onActivated = function() -- line: 141
				-- upvalues: p11 (copy), t1 (copy)
				local s1 = "Inappropriate Content"

				if p11.props.userId ~= nil then
					s1 = t1[p11.state.typeOfAbuseIndex]
				end

				p11.props.dispatchSendReport(s1, p11.state.abuseDescription, p11.props.userId)
				p11.props.dispatchCloseReportDialog()
			end
		})
	})
end
function v29.renderReportPlayer(p15, p16, p17, p18) -- line: 180
	-- upvalues: Roact (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), Image (copy), Assets (copy), ImageSetLabel (copy), Cryo (copy), ThemedTextLabel (copy), DropDownSelection (copy), t2 (copy)
	p15:renderReportTitle(p16, p18, p17.reportPlayerTitle)

	local t3 = {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0.5, -140, 0.5, 0),
		Size = UDim2.new(0, 44, 0, 44)
	}
	local userId = p15.props.userId

	p18.ReportPlayerTextContainer = Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 3,
		Size = UDim2.new(1, 0, 0, 68)
	}, {
		PlayerCutout = if not FFlagCoreUiMigrateUIBloxToFoundation then Roact.createElement(ImageSetLabel, Cryo.Dictionary.join(t3, {
			BackgroundTransparency = 1,
			ZIndex = 2,
			Image = Assets.Images.CircleCutout,
			ImageColor3 = p16.Theme.BackgroundUIDefault.Color
		})) else Roact.createElement(Image, {
			ZIndex = 2,
			AnchorPoint = t3.AnchorPoint,
			Position = t3.Position,
			Size = t3.Size,
			Image = Assets.Images.CircleCutout,
			imageStyle = {
				Transparency = 0,
				Color3 = p16.Theme.BackgroundUIDefault.Color
			}
		}),
		PlayerIcon = if not FFlagCoreUiMigrateUIBloxToFoundation then Roact.createElement(ImageSetLabel, Cryo.Dictionary.join(t3, {
			BackgroundTransparency = 1,
			Image = userId > 0 and "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=48&h=48" or ""
		})) else Roact.createElement(Image, {
			AnchorPoint = t3.AnchorPoint,
			Position = t3.Position,
			Size = t3.Size,
			Image = userId > 0 and "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=48&h=48" or ""
		}),
		PlayerBackground = Roact.createElement("Frame", Cryo.Dictionary.join(t3, {
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			ZIndex = 0,
			BackgroundColor3 = p16.Theme.UIDefault.Color
		})),
		PlayerName = Roact.createElement(ThemedTextLabel, {
			fontKey = "Body",
			themeKey = "TextEmphasis",
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0.5, -76, 0.5, 0),
			Size = UDim2.new(0.5, 76, 0, 44),
			Text = p15.props.userName,
			TextXAlignment = Enum.TextXAlignment.Left
		})
	})
	p18.AbuseTypeDropDown = Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 4,
		Size = UDim2.new(1, 0, 0, 68)
	}, {
		DropDown = Roact.createElement(DropDownSelection, {
			localize = true,
			enabled = true,
			selectionParentName = "abuseTypeDropDown",
			Size = UDim2.new(1, 0, 0, 44),
			placeHolderText = p17.selectTypeOfAbuse,
			selections = t2,
			selectedIndex = p15.state.typeOfAbuseIndex,
			canOpen = p15.props.canCaptureFocus,
			canCaptureFocus = p15.props.isGamepadLastInput,
			selectionChanged = function(p19) -- line: 266
				-- upvalues: p15 (copy)
				p15:setState({
					typeOfAbuseIndex = p19
				})
			end,
			ButtonRef = p15.reportDropDownRef
		})
	})
	p15:renderTextEntryField(p17, p18, UDim2.new(1, 0, 0, 180))
	p15:renderButtons(p16, p17, p18)
end
function v29.renderReportGame(p20, p21, p22, p23) -- line: 279
	-- upvalues: Assets (copy), Roact (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), Image (copy), ImageSetLabel (copy), ThemedTextLabel (copy)
	p20:renderReportTitle(p21, p23, "Report " .. p20.props.placeName)

	local PlaceholderGameIcon = Assets.Images.PlaceholderGameIcon

	if game.GameId > 0 then
		PlaceholderGameIcon = "rbxthumb://type=GameIcon&id=" .. game.GameId .. "&w=150&h=150"
	end

	p23.ReportGameTextContainer = Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 3,
		Size = UDim2.new(1, 0, 0, 126)
	}, {
		GameIcon = if not FFlagCoreUiMigrateUIBloxToFoundation then Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 17, 0.5, 0),
			Size = UDim2.new(0, 64, 0, 64),
			Image = PlaceholderGameIcon
		}) else Roact.createElement(Image, {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 17, 0.5, 0),
			Size = UDim2.new(0, 64, 0, 64),
			Image = PlaceholderGameIcon
		}),
		GameName = Roact.createElement(ThemedTextLabel, {
			fontKey = "Body",
			themeKey = "TextEmphasis",
			TextWrapped = true,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 104, 0.5, 0),
			Size = UDim2.new(1, -104, 0, 44),
			Text = p22.flagingGame,
			TextXAlignment = Enum.TextXAlignment.Left
		})
	})
	p20:renderTextEntryField(p22, p23, UDim2.new(1, 0, 0, 191))
	p20:renderButtons(p21, p22, p23)
end
function v29.render(p24) -- line: 324
	-- upvalues: withFoundationOrUIBloxStyle (copy), withLocalization (copy), Roact (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), Image (copy), Assets (copy), ImageSetLabel (copy), GetFFlagIGMGamepadSelectionHistory (copy), FocusHandler (copy), GuiService (copy)
	return withFoundationOrUIBloxStyle(function(p25) -- line: 325
		return {
			Theme = {
				Overlay = {
					Color = p25.Color.Common.Scrim.Color3,
					Transparency = p25.Color.Common.Scrim.Transparency
				},
				BackgroundUIDefault = {
					Color = p25.Color.Surface.Surface_300.Color3,
					Transparency = p25.Color.Surface.Surface_300.Transparency
				},
				UIDefault = {
					Color = p25.Color.Shift.Shift_200.Color3,
					Transparency = p25.Color.Shift.Shift_200.Transparency
				},
				Divider = {
					Color = p25.Color.Stroke.Emphasis.Color3,
					Transparency = p25.Color.Stroke.Emphasis.Transparency
				}
			}
		}
	end, function(p26) -- line: 334
		-- upvalues: withLocalization (copy), p24 (copy), Roact (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), Image (copy), Assets (copy), ImageSetLabel (copy), GetFFlagIGMGamepadSelectionHistory (copy), FocusHandler (copy), GuiService (copy)
		return withLocalization({
			reportPlayerTitle = "CoreScripts.InGameMenu.Report.ReportPlayerTitle",
			selectTypeOfAbuse = "CoreScripts.InGameMenu.Report.SelectAbuseType",
			cancel = "CoreScripts.InGameMenu.Cancel",
			report = "CoreScripts.InGameMenu.Report.SendReport",
			textboxPlaceHolder = "CoreScripts.InGameMenu.Report.AdditionalDetails",
			flagingGame = {
				"CoreScripts.InGameMenu.Report.FlagingGame",
				RBX_NAME = p24.props.placeName
			},
			reportGameTitle = {
				"CoreScripts.InGameMenu.Report.ReportGameTitle",
				RBX_NAME = p24.props.placeName
			}
		})(function(p27) -- line: 346
			-- upvalues: Roact (copy), p24 (copy), p26 (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), Image (copy), Assets (copy), ImageSetLabel (copy), GetFFlagIGMGamepadSelectionHistory (copy), FocusHandler (copy), GuiService (copy)
			local t4 = {
				Padding = Roact.createElement("UIPadding", {
					PaddingBottom = UDim.new(0, 24),
					PaddingLeft = UDim.new(0, 24),
					PaddingRight = UDim.new(0, 24)
				}),
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				})
			}

			if p24.props.userId == nil then
				p24:renderReportGame(p26, p27, t4)
			else
				p24:renderReportPlayer(p26, p27, t4)
			end

			return Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				ZIndex = 8,
				Visible = p24.props.isOpen,
				[Roact.Ref] = p24.selectionGroupRef
			}, {
				Overlay = Roact.createElement("TextButton", {
					AutoButtonColor = false,
					BorderSizePixel = 0,
					Text = "",
					Selectable = false,
					BackgroundColor3 = p26.Theme.Overlay.Color,
					BackgroundTransparency = p26.Theme.Overlay.Transparency,
					Size = UDim2.new(1, 0, 1, 0)
				}),
				DialogMainFrame = if not FFlagCoreUiMigrateUIBloxToFoundation then Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Image = Assets.Images.RoundedRect.Image,
					ImageColor3 = p26.Theme.BackgroundUIDefault.Color,
					ImageTransparency = p26.Theme.BackgroundUIDefault.Transparency,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					ScaleType = Assets.Images.RoundedRect.ScaleType,
					Size = UDim2.new(0, 600, 0, 450),
					SliceCenter = Assets.Images.RoundedRect.SliceCenter
				}, t4) else Roact.createElement(Image, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Image = Assets.Images.RoundedRectImageKey,
					imageStyle = {
						Color3 = p26.Theme.BackgroundUIDefault.Color,
						Transparency = p26.Theme.BackgroundUIDefault.Transparency
					},
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(0, 600, 0, 450),
					slice = {
						center = Rect.new(8, 8, 9, 9)
					}
				}, t4),
				FocusHandler = GetFFlagIGMGamepadSelectionHistory() and Roact.createElement(FocusHandler, {
					isFocused = p24.props.canCaptureFocus and p24.props.isGamepadLastInput,
					shouldForgetPreviousSelection = not p24.props.isOpen,
					didFocus = function(p28) -- line: 408
						-- upvalues: p24 (copy), GuiService (copy)
						local v86 = if not p24.props.userId then p24.reportTextEntryRef:getValue() else p24.reportDropDownRef:getValue()

						GuiService.SelectedCoreObject = p28 or v86
					end
				}) or nil
			})
		end)
	end)
end
function v29.bindActions(p29) -- line: 423
	-- upvalues: ContextActionService (copy)
	local function closeReportFunc(_, p31, _) -- line: 424
		-- upvalues: p29 (copy)
		if p31 == Enum.UserInputState.Begin then
			p29.props.dispatchCloseReportDialog()
		end
	end

	ContextActionService:BindCoreAction("InGameMenuReportModalClose", closeReportFunc, false, Enum.KeyCode.Escape)
end
function v29.unbindActions(_) -- line: 433
	-- upvalues: ContextActionService (copy)
	ContextActionService:UnbindCoreAction("InGameMenuReportModalClose")
end
function v29.didMount(p34) -- line: 437
	-- upvalues: GuiService (copy)
	GuiService:RemoveSelectionGroup("ReportDialogGroup")
	GuiService:AddSelectionParent("ReportDialogGroup", p34.selectionGroupRef:getValue())

	if p34.props.isOpen then
		p34:bindActions()
	end
end
function v29.didUpdate(p35, p36) -- line: 446
	-- upvalues: GetFFlagIGMGamepadSelectionHistory (copy), GuiService (copy)
	if p36.isOpen and not p35.props.isOpen then
		p35:setState({
			typeOfAbuseIndex = 0,
			abuseDescription = ""
		})
	end

	if not GetFFlagIGMGamepadSelectionHistory() and ((not p36.canCaptureFocus or not p36.isGamepadLastInput) and p35.props.canCaptureFocus and p35.props.isGamepadLastInput) then
		GuiService.SelectedCoreObject = if not p35.props.userId then p35.reportTextEntryRef:getValue() else p35.reportDropDownRef:getValue()
	end

	if p35.props.isOpen then
		p35:bindActions()

		return
	end

	p35:unbindActions()
end
function v29.willUnmount(p37) -- line: 478
	p37:unbindActions()
end

return RoactRodux.UNSTABLE_connect2(function(p38, _) -- line: 482
	-- upvalues: Constants (copy)
	return {
		isOpen = p38.report.dialogOpen,
		userId = p38.report.userId,
		userName = p38.report.userName,
		placeName = p38.gameInfo.name,
		canCaptureFocus = p38.report.dialogOpen and not p38.respawn.dialogOpen,
		isGamepadLastInput = p38.displayOptions.inputType == Constants.InputType.Gamepad
	}
end, function(p40) -- line: 491
	-- upvalues: CloseReportDialog (copy), SendReport (copy), SendAnalytics (copy), Constants (copy)
	return {
		dispatchCloseReportDialog = function() -- line: 493
			-- upvalues: p40 (copy), CloseReportDialog (copy)
			p40(CloseReportDialog())
		end,
		dispatchSendReport = function(p41, p42, p43) -- line: 496
			-- upvalues: p40 (copy), SendReport (copy), SendAnalytics (copy), Constants (copy)
			p40(SendReport(p41, p42, p43))

			local t5 = {}

			if p41 == "Inappropriate Content" then
				table.insert(t5, "report_type=game")
				table.insert(t5, "reported_entity_id=" .. tostring(game.GameId))
			else
				table.insert(t5, "report_type=user")
				table.insert(t5, "reported_entity_id=" .. tostring(p43))
			end

			table.insert(t5, "report_source=ingame")

			local v82 = table.concat(t5, "&")

			SendAnalytics(Constants.AnalyticsReportSubmittedName, v82, {})
		end
	}
end)(v29)
