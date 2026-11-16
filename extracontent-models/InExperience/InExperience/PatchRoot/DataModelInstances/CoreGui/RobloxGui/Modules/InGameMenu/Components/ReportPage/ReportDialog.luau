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
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle

local parent = script.Parent.Parent.Parent
local flags = parent.Flags
local GetFFlagIGMGamepadSelectionHistory = require(flags.GetFFlagIGMGamepadSelectionHistory)
local FFlagIGMDialogButtonsUseUIBloxButton = require(flags.FFlagIGMDialogButtonsUseUIBloxButton)

local FocusHandler = require(script.Parent.Parent.Connection.FocusHandler)

local Assets = require(parent.Resources.Assets)
local CloseReportDialog = require(parent.Actions.CloseReportDialog)

local withLocalization = require(parent.Localization.withLocalization)

local ThemedTextLabel = require(parent.Components.ThemedTextLabel)
local TextEntryField = require(script.Parent.TextEntryField)
local DropDownSelection = require(parent.Components.DropDownSelection)
local Constants = require(parent.Resources.Constants)
local SendAnalytics = require(parent.Utility.SendAnalytics)

local SendReport = require(parent.Thunks.SendReport)

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local Foundation = require(CorePackages.Packages.Foundation)
local Image = Foundation.Image
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation

local extended = Roact.PureComponent:extend("ReportDialog")

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

local selections = {
	"CoreScripts.InGameMenu.Report.AbuseSwearing",
	"CoreScripts.InGameMenu.Report.AbuseUsername",
	"CoreScripts.InGameMenu.Report.AbuseBullying",
	"CoreScripts.InGameMenu.Report.AbuseScamming",
	"CoreScripts.InGameMenu.Report.AbuseDating",
	"CoreScripts.InGameMenu.Report.AbuseExploiting",
	"CoreScripts.InGameMenu.Report.AbusePersonalQuestion",
	"CoreScripts.InGameMenu.Report.AbuseOffsiteLink"
}

extended.validateProps = t.strictInterface({
	isOpen = t.boolean,
	userId = t.optional(t.integer),
	userName = t.optional(t.string),
	placeName = t.string,
	dispatchCloseReportDialog = t.callback,
	dispatchSendReport = t.callback,
	canCaptureFocus = t.optional(t.boolean),
	isGamepadLastInput = t.optional(t.boolean)
})

function extended:init()
	self.state = { abuseDescription = "", typeOfAbuseIndex = 0 }

	self.selectionGroupRef = Roact.createRef()
	self.reportTextEntryRef = Roact.createRef()
	self.reportDropDownRef = Roact.createRef()
end

function extended:renderReportTitle(p, p2, text)
	p2.Title = Roact.createElement(ThemedTextLabel, {
		fontKey = "Header1",
		themeKey = "TextEmphasis",
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 48),
		Text = text
	})

	p2.Divider = Roact.createElement("Frame", {
		BackgroundColor3 = p.Theme.Divider.Color,
		BackgroundTransparency = p.Theme.Divider.Transparency,
		BorderSizePixel = 0,
		LayoutOrder = 2,
		Size = UDim2.new(0.8, 0, 0, 1)
	})
end

function extended:renderTextEntryField(p, p2, size)
	p2.ReportDescription = Roact.createElement(TextEntryField, {
		enabled = self.props.isOpen,
		text = self.state.abuseDescription,
		textChanged = function(abuseDescription)
			self:setState({ abuseDescription = abuseDescription })
		end,
		maxTextLength = 160,
		autoFocusOnEnabled = not self.props.isGamepadLastInput,
		PlaceholderText = p.textboxPlaceHolder,
		LayoutOrder = 5,
		Size = size,
		[Roact.Ref] = self.reportTextEntryRef
	})
end

function extended:renderButtons(_, p, p2)
	local v2 = utf8.len(utf8.nfcnormalize(self.state.abuseDescription))
	local v3

	if v2 >= 0 then
		v3 = v2 <= 160
	else
		v3 = false
	end

	local v4 = self.state.typeOfAbuseIndex > 0 or self.props.userId == nil

	local function onActivated()
		local v5 = self.props.userId == nil and "Inappropriate Content" or v[self.state.typeOfAbuseIndex]

		self.props.dispatchSendReport(v5, self.state.abuseDescription, self.props.userId)
		self.props.dispatchCloseReportDialog()
	end

	p2.ButtonContainer = Roact.createElement(
		"Frame",
		{ BackgroundTransparency = 1, LayoutOrder = 6, Size = UDim2.new(1, 0, 0, 60) },
		{
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				Padding = UDim.new(0, 12),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Bottom
			}),
			CancelButton = Roact.createElement(Button, {
				buttonType = ButtonType.Secondary,
				layoutOrder = 1,
				size = UDim2.fromOffset(144, 36),
				text = p.cancel,
				onActivated = self.props.dispatchCloseReportDialog,
				DO_NOT_USE_useUIBloxButton = FFlagIGMDialogButtonsUseUIBloxButton and true or nil
			}),
			ConfirmButton = Roact.createElement(Button, {
				buttonType = ButtonType.PrimarySystem,
				layoutOrder = 2,
				size = UDim2.fromOffset(144, 36),
				isDisabled = not (v3 and v4),
				text = p.report,
				onActivated = onActivated,
				DO_NOT_USE_useUIBloxButton = FFlagIGMDialogButtonsUseUIBloxButton and true or nil
			})
		}
	)
end

function extended:renderReportPlayer(p, p2, p3)
	self:renderReportTitle(p, p3, p2.reportPlayerTitle)

	local v2 = {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0.5, -140, 0.5, 0),
		Size = UDim2.new(0, 44, 0, 44)
	}

	local userId = self.props.userId

	local createElement = Roact.createElement
	local v3 = { BackgroundTransparency = 1, LayoutOrder = 3, Size = UDim2.new(1, 0, 0, 68) }
	local playerCutout

	if FFlagCoreUiMigrateUIBloxToFoundation then
		playerCutout = Roact.createElement(Image, {
			AnchorPoint = v2.AnchorPoint,
			Position = v2.Position,
			Size = v2.Size,
			Image = Assets.Images.CircleCutout,
			imageStyle = { Color3 = p.Theme.BackgroundUIDefault.Color, Transparency = 0 },
			ZIndex = 2
		})
	else
		playerCutout = Roact.createElement(
			ImageSetLabel,
			Cryo.Dictionary.join(v2, {
				BackgroundTransparency = 1,
				Image = Assets.Images.CircleCutout,
				ImageColor3 = p.Theme.BackgroundUIDefault.Color,
				ZIndex = 2
			})
		)
	end

	local playerIcon

	if FFlagCoreUiMigrateUIBloxToFoundation then
		playerIcon = Roact.createElement(Image, {
			AnchorPoint = v2.AnchorPoint,
			Position = v2.Position,
			Size = v2.Size,
			Image = userId > 0 and "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=48&h=48" or ""
		})
	else
		playerIcon = Roact.createElement(ImageSetLabel, Cryo.Dictionary.join(v2, {
			BackgroundTransparency = 1,
			Image = userId > 0 and "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=48&h=48" or ""
		}))
	end

	p3.ReportPlayerTextContainer = createElement("Frame", v3, {
		PlayerCutout = playerCutout,
		PlayerIcon = playerIcon,
		PlayerBackground = Roact.createElement(
			"Frame",
			Cryo.Dictionary.join(v2, {
				BackgroundColor3 = p.Theme.UIDefault.Color,
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				ZIndex = 0
			})
		),
		PlayerName = Roact.createElement(ThemedTextLabel, {
			fontKey = "Body",
			themeKey = "TextEmphasis",
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0.5, -76, 0.5, 0),
			Size = UDim2.new(0.5, 76, 0, 44),
			Text = self.props.userName,
			TextXAlignment = Enum.TextXAlignment.Left
		})
	})

	p3.AbuseTypeDropDown = Roact.createElement(
		"Frame",
		{ BackgroundTransparency = 1, LayoutOrder = 4, Size = UDim2.new(1, 0, 0, 68) },
		{
			DropDown = Roact.createElement(DropDownSelection, {
				Size = UDim2.new(1, 0, 0, 44),
				placeHolderText = p2.selectTypeOfAbuse,
				selections = selections,
				localize = true,
				selectedIndex = self.state.typeOfAbuseIndex,
				enabled = true,
				selectionParentName = "abuseTypeDropDown",
				canOpen = self.props.canCaptureFocus,
				canCaptureFocus = self.props.isGamepadLastInput,
				selectionChanged = function(typeOfAbuseIndex)
					self:setState({ typeOfAbuseIndex = typeOfAbuseIndex })
				end,
				ButtonRef = self.reportDropDownRef
			})
		}
	)

	self:renderTextEntryField(p2, p3, UDim2.new(1, 0, 0, 180))
	self:renderButtons(p, p2, p3)
end

function extended:renderReportGame(p, p2, p3)
	self:renderReportTitle(p, p3, "Report " .. self.props.placeName)

	local image = Assets.Images.PlaceholderGameIcon

	if game.GameId > 0 then
		image = "rbxthumb://type=GameIcon&id=" .. game.GameId .. "&w=150&h=150"
	end

	local createElement = Roact.createElement
	local v2 = { BackgroundTransparency = 1, LayoutOrder = 3, Size = UDim2.new(1, 0, 0, 126) }
	local gameIcon

	if FFlagCoreUiMigrateUIBloxToFoundation then
		gameIcon = Roact.createElement(Image, {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 17, 0.5, 0),
			Size = UDim2.new(0, 64, 0, 64),
			Image = image
		})
	else
		gameIcon = Roact.createElement(ImageSetLabel, {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 17, 0.5, 0),
			Size = UDim2.new(0, 64, 0, 64),
			BackgroundTransparency = 1,
			Image = image
		})
	end

	p3.ReportGameTextContainer = createElement("Frame", v2, {
		GameIcon = gameIcon,
		GameName = Roact.createElement(ThemedTextLabel, {
			fontKey = "Body",
			themeKey = "TextEmphasis",
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 104, 0.5, 0),
			Size = UDim2.new(1, -104, 0, 44),
			Text = p2.flagingGame,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true
		})
	})

	self:renderTextEntryField(p2, p3, UDim2.new(1, 0, 0, 191))
	self:renderButtons(p, p2, p3)
end

function extended:render()
	return withFoundationOrUIBloxStyle(function(p)
		return {
			Theme = {
				Overlay = {
					Color = p.Color.Common.Scrim.Color3,
					Transparency = p.Color.Common.Scrim.Transparency
				},
				BackgroundUIDefault = {
					Color = p.Color.Surface.Surface_300.Color3,
					Transparency = p.Color.Surface.Surface_300.Transparency
				},
				UIDefault = {
					Color = p.Color.Shift.Shift_200.Color3,
					Transparency = p.Color.Shift.Shift_200.Transparency
				},
				Divider = {
					Color = p.Color.Stroke.Emphasis.Color3,
					Transparency = p.Color.Stroke.Emphasis.Transparency
				}
			}
		}
	end, function(p)
		return withLocalization({
			flagingGame = {
				"CoreScripts.InGameMenu.Report.FlagingGame",
				RBX_NAME = self.props.placeName
			},
			reportGameTitle = {
				"CoreScripts.InGameMenu.Report.ReportGameTitle",
				RBX_NAME = self.props.placeName
			},
			reportPlayerTitle = "CoreScripts.InGameMenu.Report.ReportPlayerTitle",
			selectTypeOfAbuse = "CoreScripts.InGameMenu.Report.SelectAbuseType",
			cancel = "CoreScripts.InGameMenu.Cancel",
			report = "CoreScripts.InGameMenu.Report.SendReport",
			textboxPlaceHolder = "CoreScripts.InGameMenu.Report.AdditionalDetails"
		})(function(p2)
			local v2 = {
				["Padding"] = Roact.createElement("UIPadding", {
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

			if self.props.userId == nil then
				self:renderReportGame(p, p2, v2)
			else
				self:renderReportPlayer(p, p2, v2)
			end

			local createElement = Roact.createElement
			local selectionGroupRefsByRef = {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				ZIndex = 8,
				Visible = self.props.isOpen,
				[Roact.Ref] = self.selectionGroupRef
			}
			local v3 = {
				Overlay = Roact.createElement("TextButton", {
					AutoButtonColor = false,
					BackgroundColor3 = p.Theme.Overlay.Color,
					BackgroundTransparency = p.Theme.Overlay.Transparency,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 1, 0),
					Text = "",
					Selectable = false
				}),
				DialogMainFrame = 0,
				FocusHandler = 0
			}
			local dialogMainFrame

			if FFlagCoreUiMigrateUIBloxToFoundation then
				dialogMainFrame = Roact.createElement(Image, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Image = Assets.Images.RoundedRectImageKey,
					imageStyle = {
						Color3 = p.Theme.BackgroundUIDefault.Color,
						Transparency = p.Theme.BackgroundUIDefault.Transparency
					},
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(0, 600, 0, 450),
					slice = { center = Rect.new(8, 8, 9, 9) }
				}, v2)
			else
				dialogMainFrame = Roact.createElement(ImageSetLabel, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Image = Assets.Images.RoundedRect.Image,
					ImageColor3 = p.Theme.BackgroundUIDefault.Color,
					ImageTransparency = p.Theme.BackgroundUIDefault.Transparency,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					ScaleType = Assets.Images.RoundedRect.ScaleType,
					Size = UDim2.new(0, 600, 0, 450),
					SliceCenter = Assets.Images.RoundedRect.SliceCenter
				}, v2)
			end

			v3.DialogMainFrame = dialogMainFrame
			local focusHandler

			if GetFFlagIGMGamepadSelectionHistory() then
				focusHandler = Roact.createElement(FocusHandler, {
					isFocused = self.props.canCaptureFocus and self.props.isGamepadLastInput,
					shouldForgetPreviousSelection = not self.props.isOpen,
					didFocus = function(p3)
						local v4

						if self.props.userId then
							v4 = self.reportDropDownRef:getValue()
						else
							v4 = self.reportTextEntryRef:getValue()
						end

						GuiService.SelectedCoreObject = p3 or v4
					end
				}) or nil
			end

			v3.FocusHandler = focusHandler
			return createElement("Frame", selectionGroupRefsByRef, v3)
		end)
	end)
end

function extended:bindActions()
	local function closeReportFunc(_, p, _)
		if p == Enum.UserInputState.Begin then
			self.props.dispatchCloseReportDialog()
		end
	end

	ContextActionService:BindCoreAction("InGameMenuReportModalClose", closeReportFunc, false, Enum.KeyCode.Escape)
end

function extended:unbindActions()
	ContextActionService:UnbindCoreAction("InGameMenuReportModalClose")
end

function extended:didMount()
	GuiService:RemoveSelectionGroup("ReportDialogGroup")
	GuiService:AddSelectionParent("ReportDialogGroup", self.selectionGroupRef:getValue())

	if self.props.isOpen then
		self:bindActions()
	end
end

function extended:didUpdate(data)
	if data.isOpen and not self.props.isOpen then
		self:setState({ typeOfAbuseIndex = 0, abuseDescription = "" })
	end

	if
		not (GetFFlagIGMGamepadSelectionHistory() or data.canCaptureFocus and data.isGamepadLastInput)
		and self.props.canCaptureFocus
		and self.props.isGamepadLastInput
	then
		local selectedCoreObject

		if self.props.userId then
			selectedCoreObject = self.reportDropDownRef:getValue()
		else
			selectedCoreObject = self.reportTextEntryRef:getValue()
		end

		GuiService.SelectedCoreObject = selectedCoreObject
	end

	if self.props.isOpen then
		self:bindActions()
	else
		self:unbindActions()
	end
end

function extended:willUnmount()
	self:unbindActions()
end

return RoactRodux.UNSTABLE_connect2(function(data, _)
	return {
		isOpen = data.report.dialogOpen,
		userId = data.report.userId,
		userName = data.report.userName,
		placeName = data.gameInfo.name,
		canCaptureFocus = data.report.dialogOpen and not data.respawn.dialogOpen,
		isGamepadLastInput = data.displayOptions.inputType == Constants.InputType.Gamepad
	}
end, function(callback)
	return {
		dispatchCloseReportDialog = function()
			callback(CloseReportDialog())
		end,
		dispatchSendReport = function(p, p2, p3)
			callback(SendReport(p, p2, p3))

			local v2 = {}

			if p == "Inappropriate Content" then
				table.insert(v2, "report_type=game")
				table.insert(v2, "reported_entity_id=" .. tostring(game.GameId))
			else
				table.insert(v2, "report_type=user")
				table.insert(v2, "reported_entity_id=" .. tostring(p3))
			end

			table.insert(v2, "report_source=ingame")
			local joined = table.concat(v2, "&")

			SendAnalytics(Constants.AnalyticsReportSubmittedName, joined, {})
		end
	}
end)(extended)
