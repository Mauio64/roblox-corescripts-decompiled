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
local ParentParent = script.Parent.Parent
local Dependencies = require(ParentParent.Dependencies)

require(Dependencies.FocusHandler)

local playerInterface = require(Dependencies.playerInterface)
local ThemedTextLabel = require(Dependencies.ThemedTextLabel)
local withLocalization = require(Dependencies.withLocalization)
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local withVoiceState = require(RobloxGui.Modules.VoiceChat.VoiceStateContext).withVoiceState
local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local GameIcon = require(Dependencies.GameIcon)

require(ParentParent.Components.BlockPlayerItem)

local EndReportFlow = require(ParentParent.Actions.EndReportFlow)

require(ParentParent.Actions.OpenBlockPlayerDialog)

local SelectReportCategory = require(ParentParent.Actions.SelectReportCategory)
local SendAnalytics = require(ParentParent.Utility.SendAnalytics)
local SessionUtility = require(ParentParent.Utility.SessionUtility)
local Constants = require(ParentParent.Resources.Constants)
local ModalDialog = require(ParentParent.Components.ModalDialog)
local Assets = require(ParentParent.Resources.Assets)

require(ParentParent.Components.GameCell)

local BarOnTopScrollingFrame = require(Dependencies.BarOnTopScrollingFrame)
local Cell = UIBlox.App.Table.Cell
local Provider = UIBlox.Core.Style.Provider
local withStyle = UIBlox.Core.Style.withStyle
local Colors = UIBlox.App.Style.Colors
local FFlagTopBarSignalizeScreenSize = require(CorePackages.Workspace.Packages.CoreGuiCommon).Flags.FFlagTopBarSignalizeScreenSize
local t1 = {
	BackgroundDefault = {
		Transparency = 1,
		Color = Colors.Flint
	},
	BackgroundOnHover = {
		Transparency = 0.666,
		Color = Colors.Graphite
	},
	BackgroundOnPress = {
		Transparency = 0,
		Color = Colors.Graphite
	}
}

local function Divider(p1) -- line: 68
	-- upvalues: Roact (copy), Cryo (copy), Colors (copy)
	return Roact.createElement("Frame", Cryo.Dictionary.join({
		Size = UDim2.new(1, 0, 0, 1)
	}, p1, {
		BorderSizePixel = 0,
		BackgroundTransparency = 0.5,
		BackgroundColor3 = Colors.Graphite,
		theme = Cryo.None
	}))
end
local function CategoryCellContent(p2) -- line: 86
	-- upvalues: Roact (copy), ImageSetLabel (copy), ThemedTextLabel (copy)
	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 72),
		AutomaticSize = Enum.AutomaticSize.XY
	}, {
		ListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		IconFrame = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(0, 68, 1, 0)
		}, {
			Layout = Roact.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			CustomIcon = p2.iconComponent or nil,
			Icon = p2.icon and Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Image = p2.icon.Image,
				Size = p2.icon.Size
			})
		}),
		TextFrame = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, -68, 1, 0)
		}, {
			ListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 2)
			}),
			Text = Roact.createElement(ThemedTextLabel, {
				themeKey = "TextEmphasis",
				fontKey = "Header2",
				AnchorPoint = Vector2.new(0, 0.5),
				Size = UDim2.new(1, 0, 0, 20),
				Text = p2.text,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			SubText = Roact.createElement(ThemedTextLabel, {
				fontKey = "CaptionBody",
				themeKey = "TextMuted",
				AnchorPoint = Vector2.new(0, 0.5),
				Size = UDim2.new(1, 0, 0, 14),
				Text = p2.subtext,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left
			})
		})
	})
end
local function CategoryCell(p3) -- line: 145
	-- upvalues: Roact (copy), Cell (copy), CategoryCellContent (copy)
	return Roact.createElement(Cell, {
		userInteractionEnabled = true,
		onActivated = p3.onActivated,
		layoutOrder = p3.layoutOrder,
		size = UDim2.new(1, 0, 0, 72),
		head = CategoryCellContent(p3),
		tail = Roact.createElement("Frame")
	})
end

local v36 = Roact.PureComponent:extend("ReportCategoryDialog")

v36.validateProps = t.strictInterface({
	isReportCategoryMenuOpen = t.boolean,
	screenSize = if not FFlagTopBarSignalizeScreenSize then t.Vector2 else nil,
	inputType = t.optional(t.string),
	reportType = t.optional(t.valueOf(Constants.ReportType)),
	targetPlayer = t.optional(playerInterface),
	closeDialog = t.callback,
	selectReportCategory = t.optional(t.callback),
	playerFocusedFlow = t.boolean
})

function v36.init(p4) -- line: 169
	-- upvalues: Roact (copy), FFlagTopBarSignalizeScreenSize (copy), Display (copy), Signals (copy)
	p4.buttonRef = Roact.createRef()

	function p4.onCancel() -- line: 172
		-- upvalues: p4 (copy)
		p4.props.closeDialog()
	end

	if FFlagTopBarSignalizeScreenSize then
		local getViewportSize = Display.GetDisplayStore(false).getViewportSize

		p4.disposeScreenSize = Signals.createEffect(function(p5) -- line: 179
			-- upvalues: p4 (copy), getViewportSize (copy)
			p4:setState({
				screenSize = getViewportSize(p5)
			})
		end)
	end
end
function v36.willUnmount(p6) -- line: 187
	-- upvalues: FFlagTopBarSignalizeScreenSize (copy)
	if FFlagTopBarSignalizeScreenSize then
		p6.disposeScreenSize()
	end
end
function v36.renderContents(p7, p8, p9) -- line: 193
	-- upvalues: Roact (copy), default (copy), Cryo (copy), CategoryCell (copy), Assets (copy), Constants (copy), Divider (copy), GameIcon (copy), withStyle (copy), t1 (copy), Provider (copy), BarOnTopScrollingFrame (copy)
	local _ = p7.props
	local t2 = {
		ListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}

	if p8 then
		local v48 = default:getRecentUsersInteractionData()

		if v48 and not Cryo.isEmpty(v48) then
			if p7.props.playerFocusedFlow then
				p8 = p7.props.targetPlayer and v48[tostring(p7.props.targetPlayer.UserId)] ~= nil
			end
		else
			p8 = false
		end
	end

	if p8 then
		table.insert(t2, Roact.createElement(CategoryCell, {
			text = p9.voiceHeader,
			subtext = p9.voiceDescription,
			icon = Assets.Images.VoiceChatIcon,
			layoutOrder = #t2 + 1,
			onActivated = function() -- line: 227
				-- upvalues: p7 (copy), Constants (copy)
				p7.props.selectReportCategory(Constants.Category.Voice)
			end
		}))
		table.insert(t2, Roact.createElement(Divider, {
			LayoutOrder = #t2 + 1
		}))
	end

	table.insert(t2, Roact.createElement(CategoryCell, {
		text = p9.textHeader,
		subtext = p9.textDescription,
		icon = Assets.Images.TextChatIcon,
		layoutOrder = #t2 + 1,
		onActivated = function() -- line: 247
			-- upvalues: p7 (copy), Constants (copy)
			p7.props.selectReportCategory(Constants.Category.Text)
		end
	}))
	table.insert(t2, Roact.createElement(Divider, {
		LayoutOrder = #t2 + 1
	}))

	if not p7.props.playerFocusedFlow then
		table.insert(t2, Roact.createElement(CategoryCell, {
			iconComponent = Roact.createElement(GameIcon, {
				iconSize = 33,
				gameId = game.GameId,
				cornerRadius = UDim.new(0, 8)
			}),
			text = p9.experienceHeader,
			subtext = p9.experienceDescription,
			layoutOrder = #t2 + 1,
			onActivated = function() -- line: 271
				-- upvalues: p7 (copy), Constants (copy)
				p7.props.selectReportCategory(Constants.Category.Experience)
			end
		}))
		table.insert(t2, Roact.createElement(Divider, {
			LayoutOrder = #t2 + 1
		}))
	end

	table.insert(t2, Roact.createElement(CategoryCell, {
		text = p9.otherHeader,
		subtext = p9.otherDescription,
		icon = Assets.Images.OtherIcon,
		layoutOrder = #t2 + 1,
		onActivated = function() -- line: 292
			-- upvalues: p7 (copy), Constants (copy)
			p7.props.selectReportCategory(Constants.Category.Other)
		end
	}))
	table.insert(t2, Roact.createElement(Divider, {
		LayoutOrder = #t2 + 1
	}))

	return withStyle(function(p10) -- line: 305
		-- upvalues: Cryo (copy), t1 (copy), Roact (copy), Provider (copy), BarOnTopScrollingFrame (copy), p7 (copy), t2 (copy)
		local v55 = Cryo.Dictionary.join(p10.Theme, t1)
		local v56 = Cryo.Dictionary.join(p10, {
			Theme = v55
		})

		return Roact.createElement(Provider, {
			style = v56
		}, { Roact.createElement(BarOnTopScrollingFrame, {
			Size = UDim2.fromScale(1, 1),
			CanvasSize = UDim2.new(1, 0, 0, 72),
			scrollingFrameRef = p7.scrollingFrameRef
		}, t2) })
	end)
end
function v36.render(p11) -- line: 322
	-- upvalues: withVoiceState (copy), withLocalization (copy), Roact (copy), ModalDialog (copy), FFlagTopBarSignalizeScreenSize (copy)
	return withVoiceState(function(p12) -- line: 323
		-- upvalues: withLocalization (copy), Roact (copy), ModalDialog (copy), p11 (copy), FFlagTopBarSignalizeScreenSize (copy)
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
		})(function(p13) -- line: 335
			-- upvalues: Roact (copy), ModalDialog (copy), p11 (copy), FFlagTopBarSignalizeScreenSize (copy), p12 (copy)
			return Roact.createFragment({
				ModalDialog = Roact.createElement(ModalDialog, {
					showCloseButton = true,
					visible = p11.props.isReportCategoryMenuOpen,
					screenSize = if not FFlagTopBarSignalizeScreenSize then p11.props.screenSize else p11.state.screenSize,
					titleText = p13.titleText,
					contents = p11:renderContents(p12.voiceEnabled, p13),
					onDismiss = p11.onCancel
				})
			})
		end)
	end)
end

return RoactRodux.UNSTABLE_connect2(function(p14, _) -- line: 350
	-- upvalues: Constants (copy), FFlagTopBarSignalizeScreenSize (copy)
	return {
		isReportCategoryMenuOpen = p14.report.currentPage == Constants.Page.Category,
		reportType = p14.report.reportType,
		targetPlayer = p14.report.targetPlayer,
		screenSize = if not FFlagTopBarSignalizeScreenSize then p14.displayOptions.screenSize else nil,
		playerFocusedFlow = p14.report.beginningReportType == Constants.ReportType.Player
	}
end, function(p16) -- line: 359
	-- upvalues: SelectReportCategory (copy), EndReportFlow (copy), SendAnalytics (copy), Constants (copy), SessionUtility (copy)
	return {
		selectReportCategory = function(p17) -- line: 361
			-- upvalues: p16 (copy), SelectReportCategory (copy)
			p16(SelectReportCategory(p17))
		end,
		closeDialog = function() -- line: 364
			-- upvalues: p16 (copy), EndReportFlow (copy), SendAnalytics (copy), Constants (copy), SessionUtility (copy)
			p16(EndReportFlow())
			SendAnalytics(Constants.Analytics.ReportType, Constants.Analytics.ReportFlowAbandoned, {
				source = Constants.Analytics.ReportType
			})
			SessionUtility.endAbuseReportSession()
		end
	}
end)(v36)
