local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)

local parent = script.Parent.Parent
local Dependencies = require(parent.Dependencies)
local BarOnTopScrollingFrame = require(Dependencies.BarOnTopScrollingFrame)
local Divider = require(Dependencies.Divider)
local PlayerCell = require(Dependencies.PlayerCell)
local PlayerSearchPredicate = require(Dependencies.PlayerSearchPredicate)
local SearchBar = require(Dependencies.SearchBar)
require(Dependencies.ThemedTextLabel)
local withLocalization = require(Dependencies.withLocalization)

local NavigateBack = require(parent.Actions.NavigateBack)
local EndReportFlow = require(parent.Actions.EndReportFlow)
local SelectReportListing = require(parent.Actions.SelectReportListing)
require(parent.Resources.Assets)
local Constants = require(parent.Resources.Constants)
local ModalDialog = require(parent.Components.ModalDialog)
local GameCell = require(parent.Components.GameCell)
local SendAnalytics = require(parent.Utility.SendAnalytics)
local SessionUtility = require(parent.Utility.SessionUtility)

local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default
local VoiceIndicatorFunc = require(RobloxGui.Modules.VoiceChat.Components.VoiceIndicatorFunc)
local VoiceStateContext = require(RobloxGui.Modules.VoiceChat.VoiceStateContext)
local Constants2 = require(RobloxGui.Modules.VoiceChat.Constants)
local React = require(CorePackages.Packages.React)

local Colors = UIBlox.App.Style.Colors

local HeaderBar = UIBlox.App.Bar.HeaderBar
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local Provider = UIBlox.Core.Style.Provider
local Images = UIBlox.App.ImageSet.Images
local withStyle = UIBlox.Core.Style.withStyle

local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local isPlayerVerified = UserLib.Utils.isPlayerVerified
local AppHeaderBar = require(CorePackages.Workspace.Packages.AppHeaderBar)
local makeBackButton = AppHeaderBar.makeBackButton

local v = {
	BackgroundDefault = { Color = Colors.Flint, Transparency = 1 }
}

local extended = Roact.PureComponent:extend("ReportMenu")

local function fn(p)
	if React.useContext(VoiceStateContext.Context).voiceEnabled then
		return React.createElement(VoiceIndicatorFunc, Cryo.Dictionary.join(p, {}))
	end

	return nil
end

extended.validateProps = t.strictInterface({
	isReportMenuOpen = t.boolean,
	screenSize = t.Vector2,
	closeDialog = t.callback,
	openReportDialog = t.callback,
	canNavigateBack = t.boolean,
	reportCategory = t.optional(t.string),
	navigateBack = t.optional(t.callback)
})

function extended:init()
	self.scrollingFrameRef = Roact.createRef()

	self.state = { isFilterMode = false, filterText = nil }

	function self.onSearch()
		self:setState({ isFilterMode = true, filterText = "" })
	end

	function self.onTextChanged(filterText)
		self:setState({ filterText = filterText })
	end

	function self.onCancel()
		self:setState({ isFilterMode = false, filterText = Roact.None })
	end

	function self.scrollToTop()
		local value = self.scrollingFrameRef:getValue()

		if value then
			value:scrollToTop()
		end
	end

	function self.navigateBack()
		self.props.navigateBack(self.state.filterText ~= nil)
	end

	function self.closeDialog()
		self.props.closeDialog(self.state.filterText ~= nil)
	end

	self.layoutBindings = {}
	function self.getLayoutBinding(p, p2)
		local v2 = self.layoutBindings[p]

		if not v2 then
			local binding, setValue = Roact.createBinding(p2)
			v2 = { valueBinding = binding, setValue = setValue, value = p2 }

			self.layoutBindings[p] = v2
		end

		if v2.value ~= p2 then
			v2.value = p2
			v2.setValue(p2)
		end

		return v2.valueBinding
	end

	function self.playerIsVoiceActive(p: number): boolean
		return default.participants[tostring(p)] ~= nil
	end

	self.sortedUserIds = {}
end

local function sortPlayers(p, p2): boolean
	return p.DisplayName:lower() < p2.DisplayName:lower()
end

function extended:getPlayerList()
	local sorted = Cryo.List.sort(Players:GetPlayers(), sortPlayers)
	local v2 = {}

	for _, v3 in ipairs(sorted) do
		if v3 == Players.LocalPlayer then
			continue
		end

		if self.state.isFilterMode then
			if PlayerSearchPredicate(self.state.filterText, v3.Name, v3.DisplayName) then
				table.insert(v2, v3)
			end
		else
			table.insert(v2, v3)
		end
	end

	return (Cryo.List.sort(v2, function(p, p2): boolean
		return p.DisplayName:lower() < p2.DisplayName:lower()
	end))
end

local v2 = {
	[Constants.Category.Voice] = "CoreScripts.InGameMenu.Report.Title.VoiceChat",
	[Constants.Category.Text] = "CoreScripts.InGameMenu.Report.Title.TextChat",
	[Constants.Category.Other] = "CoreScripts.InGameMenu.Report.Title.Other"
}

function extended:categoryTitle()
	return v2[self.props.reportCategory] or "CoreScripts.InGameMenu.Report.MenuTitle"
end

function extended:renderHeaderBar()
	local renderLeft

	if self.props.canNavigateBack then
		renderLeft = makeBackButton(self.navigateBack)
	else
		renderLeft = function()
			return Roact.createElement(IconButton, {
				iconSize = IconSize.Medium,
				icon = Images["icons/navigation/close"],
				onActivated = self.closeDialog
			})
		end
	end

	if self.state.isFilterMode then
		return Roact.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(24, 6),
				Size = UDim2.new(1, -48, 1, -12)
			},
			{ Roact.createElement(SearchBar, {
					size = UDim2.fromScale(1, 1),
					text = self.state.filterText,
					autoCaptureFocus = true,
					onTextChanged = self.onTextChanged,
					onCancelled = self.onCancel
				}) }
		)
	end

	return withLocalization({ titleText = self:categoryTitle() })(function(p)
		return Roact.createElement(HeaderBar, {
			backgroundTransparency = 1,
			barHeight = 48,
			renderLeft = renderLeft,
			renderRight = function()
				return Roact.createElement(IconButton, {
					iconSize = IconSize.Medium,
					icon = Images["icons/common/search"],
					onActivated = self.onSearch
				})
			end,
			onHeaderActivated = self.scrollToTop,
			title = p.titleText
		})
	end)
end

function extended:renderContents()
	local props = self.props
	local v3 = self.props.reportCategory == Constants.Category.Voice

	local v4 = 0
	local children = {
		ListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}

	if not self.state.isFilterMode and self.props.reportCategory == Constants.Category.None then
		children.GameCell = Roact.createElement(GameCell, {
			gameId = game.GameId,
			layoutOrder = self.getLayoutBinding("GameCell", v4),
			onActivated = function()
				props.openReportDialog(Constants.ReportType.Place, nil)
			end
		})
	end

	local v5 = v4 + 1

	local playerList = self:getPlayerList()
	local v6 = not v3 and {} or default:getRecentUsersInteractionData()

	self.sortedUserIds = {}
	local total = 72

	for _, player in pairs(playerList) do
		local userId = tostring(player.UserId)

		if not (not v3 or v6[tostring(player.UserId)]) then
			continue
		end

		table.insert(self.sortedUserIds, player.UserId)

		local total2 = 0

		if v3 then
			total2 += 1
		end

		if self.props.isReportMenuOpen then
			total2 += 2
		end

		children["Divider" .. userId] = Roact.createElement(Divider, {
			LayoutOrder = self.getLayoutBinding("Divider" .. userId, v5),
			Size = UDim2.new(1, 0, 0, 1)
		})

		v5 += 1

		local v7 = "PlayerCell" .. userId
		local createElement = Roact.createElement
		local v8 = {
			userId = player.UserId,
			username = player.Name,
			displayName = player.DisplayName,
			hasVerifiedBadge = isPlayerVerified(player),
			isOnline = true,
			isSelected = false,
			LayoutOrder = self.getLayoutBinding("PlayerCell" .. userId, v5),
			onActivated = function()
				props.openReportDialog(Constants.ReportType.Player, player)
			end,
			memoKey = total2
		}
		local voiceIndicator

		if v3 and self.props.isReportMenuOpen then
			voiceIndicator = Roact.createElement(fn, {
				userId = tostring(player.UserId),
				hideOnError = true,
				iconStyle = "SpeakerLight",
				size = UDim2.fromOffset(36, 36),
				onClicked = function()
					default:ToggleMutePlayer(player.UserId, Constants2.VOICE_CONTEXT_TYPE.REPORT_MENU)
				end
			}) or nil
		end

		children[v7] = createElement(PlayerCell, v8, { VoiceIndicator = voiceIndicator })

		v5 += 1

		total += 73
	end

	children.DividerEnd = Roact.createElement(Divider, {
		LayoutOrder = self.getLayoutBinding("DividerEnd", v5),
		Size = UDim2.new(1, 0, 0, 1)
	})

	v5 += 1

	return withStyle(function(p)
		local joined = Cryo.Dictionary.join(p.Theme, v)
		local joined2 = Cryo.Dictionary.join(p, { Theme = joined })

		return Roact.createElement(Provider, { style = joined2 }, {
			Roact.createElement(
				BarOnTopScrollingFrame,
				{
					Size = UDim2.fromScale(1, 1),
					CanvasSize = UDim2.new(1, 0, 0, total),
					scrollingFrameRef = self.scrollingFrameRef
				},
				children
			)
		})
	end)
end

function extended:render()
	local v3 = self.props.reportCategory ~= nil

	return Roact.createFragment({
		ModalDialog = Roact.createElement(ModalDialog, {
			visible = self.props.isReportMenuOpen,
			screenSize = self.props.screenSize,
			headerBar = self:renderHeaderBar(),
			showCloseButton = not v3,
			contents = self:renderContents(),
			onDismiss = self.closeDialog
		})
	})
end

function extended.didUpdate(object, p)
	if p.isReportMenuOpen and not object.props.isReportMenuOpen then
		object:setState({ isFilterMode = false, filterText = Roact.None })

		local value = object.scrollingFrameRef:getValue()

		if value and value.CanvasPosition.Y > 0 then
			value.CanvasPosition = Vector2.new(0, 0)
		end
	end
end

return RoactRodux.UNSTABLE_connect2(function(p, _)
	return {
		isReportMenuOpen = p.report.currentPage == Constants.Page.Listing,
		screenSize = p.displayOptions.screenSize,
		reportCategory = p.report.reportCategory,
		canNavigateBack = #p.report.history > 1
	}
end, function(callback)
	return {
		navigateBack = function(filterTextChanged)
			callback(NavigateBack())
			SendAnalytics(Constants.Page.Listing, Constants.Analytics.ReportFlowBack, {
				source = Constants.Page.Listing,
				filterTextChanged = filterTextChanged
			})
		end,
		closeDialog = function(filterTextChanged)
			callback(EndReportFlow())
			SendAnalytics(Constants.Page.Listing, Constants.Analytics.ReportFlowAbandoned, {
				source = Constants.Page.Listing,
				filterTextChanged = filterTextChanged
			})

			SessionUtility.endAbuseReportSession()
		end,
		openReportDialog = function(reportType, p, p2)
			callback(SelectReportListing(reportType, p, p2))
			SendAnalytics(Constants.Page.Listing, Constants.Analytics.ReportFlowAdvance, {
				source = Constants.Page.Listing,
				reportType = reportType
			})
		end
	}
end)(extended)
