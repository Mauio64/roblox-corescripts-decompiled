game:GetService("ContextActionService")
local CorePackages = game:GetService("CorePackages")
game:GetService("GuiService")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local Signals = require(CorePackages.Packages.Signals)
local Display = require(CorePackages.Workspace.Packages.Display)

local parent = script.Parent.Parent
local Dependencies = require(parent.Dependencies)
require(Dependencies.FocusHandler)
local playerInterface = require(Dependencies.playerInterface)
local ThemedTextLabel = require(Dependencies.ThemedTextLabel)
local withLocalization = require(Dependencies.withLocalization)

local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local VoiceStateContext = require(RobloxGui.Modules.VoiceChat.VoiceStateContext)
local withVoiceState = VoiceStateContext.withVoiceState
local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local GameIcon = require(Dependencies.GameIcon)
require(parent.Components.BlockPlayerItem)
local EndReportFlow = require(parent.Actions.EndReportFlow)
require(parent.Actions.OpenBlockPlayerDialog)
local SelectReportCategory = require(parent.Actions.SelectReportCategory)
local SendAnalytics = require(parent.Utility.SendAnalytics)
local SessionUtility = require(parent.Utility.SessionUtility)

local Constants = require(parent.Resources.Constants)
local ModalDialog = require(parent.Components.ModalDialog)
local Assets = require(parent.Resources.Assets)
require(parent.Components.GameCell)
local BarOnTopScrollingFrame = require(Dependencies.BarOnTopScrollingFrame)
local Cell = UIBlox.App.Table.Cell
local Provider = UIBlox.Core.Style.Provider
local withStyle = UIBlox.Core.Style.withStyle
local Colors = UIBlox.App.Style.Colors

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagTopBarSignalizeScreenSize = CoreGuiCommon.Flags.FFlagTopBarSignalizeScreenSize

local v = {
	BackgroundDefault = { Color = Colors.Flint, Transparency = 1 },
	BackgroundOnHover = { Color = Colors.Graphite, Transparency = 0.666 },
	BackgroundOnPress = { Color = Colors.Graphite, Transparency = 0 }
}

local function Divider(p)
	return Roact.createElement(
		"Frame",
		Cryo.Dictionary.join({ Size = UDim2.new(1, 0, 0, 1) }, p, {
			BorderSizePixel = 0,
			BackgroundColor3 = Colors.Graphite,
			BackgroundTransparency = 0.5,
			theme = Cryo.None
		})
	)
end

local function CategoryCellContent(props)
	return Roact.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 72),
			AutomaticSize = Enum.AutomaticSize.XY
		},
		{
			ListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			IconFrame = Roact.createElement(
				"Frame",
				{ BackgroundTransparency = 1, Size = UDim2.new(0, 68, 1, 0), LayoutOrder = 1 },
				{
					Layout = Roact.createElement("UIListLayout", {
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}),
					CustomIcon = props.iconComponent or nil,
					Icon = props.icon and Roact.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						Image = props.icon.Image,
						Size = props.icon.Size
					})
				}
			),
			TextFrame = Roact.createElement(
				"Frame",
				{ BackgroundTransparency = 1, Size = UDim2.new(1, -68, 1, 0), LayoutOrder = 2 },
				{
					ListLayout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						Padding = UDim.new(0, 2)
					}),
					Text = Roact.createElement(ThemedTextLabel, {
						AnchorPoint = Vector2.new(0, 0.5),
						themeKey = "TextEmphasis",
						fontKey = "Header2",
						Size = UDim2.new(1, 0, 0, 20),
						Text = props.text,
						TextTruncate = Enum.TextTruncate.AtEnd,
						TextXAlignment = Enum.TextXAlignment.Left
					}),
					SubText = Roact.createElement(ThemedTextLabel, {
						AnchorPoint = Vector2.new(0, 0.5),
						fontKey = "CaptionBody",
						themeKey = "TextMuted",
						Size = UDim2.new(1, 0, 0, 14),
						Text = props.subtext,
						TextTruncate = Enum.TextTruncate.AtEnd,
						TextXAlignment = Enum.TextXAlignment.Left
					})
				}
			)
		}
	)
end

local function CategoryCell(p)
	return Roact.createElement(Cell, {
		userInteractionEnabled = true,
		onActivated = p.onActivated,
		layoutOrder = p.layoutOrder,
		size = UDim2.new(1, 0, 0, 72),
		head = CategoryCellContent(p),
		tail = Roact.createElement("Frame")
	})
end

local extended = Roact.PureComponent:extend("ReportCategoryDialog")

local strictInterface = t.strictInterface
local v2 = {
	isReportCategoryMenuOpen = t.boolean,
	screenSize = 0,
	inputType = 0,
	reportType = 0,
	targetPlayer = 0,
	closeDialog = 0,
	selectReportCategory = 0,
	playerFocusedFlow = 0
}
local screenSize

if not FFlagTopBarSignalizeScreenSize then
	screenSize = t.Vector2
end

v2.screenSize = screenSize
v2.inputType = t.optional(t.string)
v2.reportType = t.optional(t.valueOf(Constants.ReportType))
v2.targetPlayer = t.optional(playerInterface)
v2.closeDialog = t.callback
v2.selectReportCategory = t.optional(t.callback)
v2.playerFocusedFlow = t.boolean
extended.validateProps = strictInterface(v2)

function extended:init()
	self.buttonRef = Roact.createRef()

	function self.onCancel()
		self.props.closeDialog()
	end

	if FFlagTopBarSignalizeScreenSize then
		local getViewportSize = Display.GetDisplayStore(false).getViewportSize

		self.disposeScreenSize = Signals.createEffect(function(p)
			self:setState({ screenSize = getViewportSize(p) })
		end)
	end
end

function extended.willUnmount(p)
	if FFlagTopBarSignalizeScreenSize then
		p.disposeScreenSize()
	end
end

function extended:renderContents(p, props)
	local _props = self.props
	local v3 = {
		ListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}

	if p then
		local recentUsersInteractionData = default:getRecentUsersInteractionData()

		if recentUsersInteractionData and not Cryo.isEmpty(recentUsersInteractionData) then
			if self.props.playerFocusedFlow then
				p = self.props.targetPlayer
					and recentUsersInteractionData[tostring(self.props.targetPlayer.UserId)] ~= nil
			end
		else
			p = false
		end
	end

	if p then
		table.insert(v3, Roact.createElement(CategoryCell, {
			text = props.voiceHeader,
			subtext = props.voiceDescription,
			icon = Assets.Images.VoiceChatIcon,
			layoutOrder = #v3 + 1,
			onActivated = function()
				self.props.selectReportCategory(Constants.Category.Voice)
			end
		}))

		table.insert(v3, Roact.createElement(Divider, {
			LayoutOrder = #v3 + 1
		}))
	end

	table.insert(v3, Roact.createElement(CategoryCell, {
		text = props.textHeader,
		subtext = props.textDescription,
		icon = Assets.Images.TextChatIcon,
		layoutOrder = #v3 + 1,
		onActivated = function()
			self.props.selectReportCategory(Constants.Category.Text)
		end
	}))

	table.insert(v3, Roact.createElement(Divider, {
		LayoutOrder = #v3 + 1
	}))

	if not self.props.playerFocusedFlow then
		table.insert(v3, Roact.createElement(CategoryCell, {
			iconComponent = Roact.createElement(GameIcon, {
				gameId = game.GameId,
				iconSize = 33,
				cornerRadius = UDim.new(0, 8)
			}),
			text = props.experienceHeader,
			subtext = props.experienceDescription,
			layoutOrder = #v3 + 1,
			onActivated = function()
				self.props.selectReportCategory(Constants.Category.Experience)
			end
		}))

		table.insert(v3, Roact.createElement(Divider, {
			LayoutOrder = #v3 + 1
		}))
	end

	table.insert(v3, Roact.createElement(CategoryCell, {
		text = props.otherHeader,
		subtext = props.otherDescription,
		icon = Assets.Images.OtherIcon,
		layoutOrder = #v3 + 1,
		onActivated = function()
			self.props.selectReportCategory(Constants.Category.Other)
		end
	}))

	table.insert(v3, Roact.createElement(Divider, {
		LayoutOrder = #v3 + 1
	}))

	return withStyle(function(p2)
		local joined = Cryo.Dictionary.join(p2.Theme, v)
		local joined2 = Cryo.Dictionary.join(p2, { Theme = joined })

		return Roact.createElement(Provider, { style = joined2 }, {
			Roact.createElement(
				BarOnTopScrollingFrame,
				{
					Size = UDim2.fromScale(1, 1),
					CanvasSize = UDim2.new(1, 0, 0, 72),
					scrollingFrameRef = self.scrollingFrameRef
				},
				v3
			)
		})
	end)
end

function extended:render()
	return withVoiceState(function(p)
		return withLocalization({
			titleText = "CoreScripts.InGameMenu.Report.MenuTitle",
			dismissText = "CoreScripts.InGameMenu.Report.Done",
			voiceHeader = "CoreScripts.InGameMenu.Report.Category.Header.Voice",
			voiceDescription = "CoreScripts.InGameMenu.Report.Category.Description.Voice",
			textHeader = "CoreScripts.InGameMenu.Report.Category.Header.Text",
			textDescription = "CoreScripts.InGameMenu.Report.Category.Description.Text",
			experienceHeader = "CoreScripts.InGameMenu.Report.Category.Header.Experience",
			experienceDescription = "CoreScripts.InGameMenu.Report.Category.Description.Experience",
			otherHeader = "CoreScripts.InGameMenu.Report.Category.Header.Other",
			otherDescription = "CoreScripts.InGameMenu.Report.Category.Description.Other"
		})(function(p2)
			local createFragment = Roact.createFragment
			local createElement = Roact.createElement
			local v3 = {
				visible = self.props.isReportCategoryMenuOpen,
				screenSize = 0,
				titleText = 0,
				contents = 0,
				showCloseButton = true,
				onDismiss = 0
			}
			local screenSize2

			if FFlagTopBarSignalizeScreenSize then
				screenSize2 = self.state.screenSize
			else
				screenSize2 = self.props.screenSize
			end

			v3.screenSize = screenSize2
			v3.titleText = p2.titleText
			v3.contents = self:renderContents(p.voiceEnabled, p2)

			v3.onDismiss = self.onCancel
			return createFragment({ ModalDialog = createElement(ModalDialog, v3) })
		end)
	end)
end

return RoactRodux.UNSTABLE_connect2(function(p, _)
	local v3 = {
		isReportCategoryMenuOpen = p.report.currentPage == Constants.Page.Category,
		reportType = p.report.reportType,
		targetPlayer = p.report.targetPlayer,
		screenSize = 0,
		playerFocusedFlow = 0
	}
	local screenSize2

	if not FFlagTopBarSignalizeScreenSize then
		screenSize2 = p.displayOptions.screenSize
	end

	v3.screenSize = screenSize2
	v3.playerFocusedFlow = p.report.beginningReportType == Constants.ReportType.Player
	return v3
end, function(callback)
	return {
		selectReportCategory = function(p)
			callback(SelectReportCategory(p))
		end,
		closeDialog = function()
			callback(EndReportFlow())
			SendAnalytics(Constants.Analytics.ReportType, Constants.Analytics.ReportFlowAbandoned, {
				source = Constants.Analytics.ReportType
			})

			SessionUtility.endAbuseReportSession()
		end
	}
end)(extended)
