local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local ParentParent = script.Parent.Parent
local Dependencies = require(ParentParent.Dependencies)
local BarOnTopScrollingFrame = require(Dependencies.BarOnTopScrollingFrame)
local Divider = require(Dependencies.Divider)
local PlayerCell = require(Dependencies.PlayerCell)
local PlayerSearchPredicate = require(Dependencies.PlayerSearchPredicate)
local SearchBar = require(Dependencies.SearchBar)

require(Dependencies.ThemedTextLabel)

local withLocalization = require(Dependencies.withLocalization)
local NavigateBack = require(ParentParent.Actions.NavigateBack)
local EndReportFlow = require(ParentParent.Actions.EndReportFlow)
local SelectReportListing = require(ParentParent.Actions.SelectReportListing)

require(ParentParent.Resources.Assets)

local Constants = require(ParentParent.Resources.Constants)
local ModalDialog = require(ParentParent.Components.ModalDialog)
local GameCell = require(ParentParent.Components.GameCell)
local SendAnalytics = require(ParentParent.Utility.SendAnalytics)
local SessionUtility = require(ParentParent.Utility.SessionUtility)
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
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
local isPlayerVerified = require(CorePackages.Workspace.Packages.UserLib).Utils.isPlayerVerified
local makeBackButton = require(CorePackages.Workspace.Packages.AppHeaderBar).makeBackButton
local t1 = {
	BackgroundDefault = {
		Transparency = 1,
		Color = Colors.Flint
	}
}
local v40 = Roact.PureComponent:extend("ReportMenu")

local function v41(p1) -- line: 63
	-- upvalues: React (copy), VoiceStateContext (copy), VoiceIndicatorFunc (copy), Cryo (copy)
	if not React.useContext(VoiceStateContext.Context).voiceEnabled then
		return nil
	end

	return React.createElement(VoiceIndicatorFunc, Cryo.Dictionary.join(p1, {}))
end

v40.validateProps = t.strictInterface({
	isReportMenuOpen = t.boolean,
	screenSize = t.Vector2,
	closeDialog = t.callback,
	openReportDialog = t.callback,
	canNavigateBack = t.boolean,
	reportCategory = t.optional(t.string),
	navigateBack = t.optional(t.callback)
})

function v40.init(p2) -- line: 81
	-- upvalues: Roact (copy), default (copy)
	p2.scrollingFrameRef = Roact.createRef()
	p2.state = {
		isFilterMode = false,
		filterText = nil
	}

	function p2.onSearch() -- line: 89
		-- upvalues: p2 (copy)
		p2:setState({
			isFilterMode = true,
			filterText = ""
		})
	end
	function p2.onTextChanged(p3) -- line: 96
		-- upvalues: p2 (copy)
		p2:setState({
			filterText = p3
		})
	end
	function p2.onCancel() -- line: 102
		-- upvalues: p2 (copy), Roact (copy)
		p2:setState({
			isFilterMode = false,
			filterText = Roact.None
		})
	end
	function p2.scrollToTop() -- line: 109
		-- upvalues: p2 (copy)
		local v80 = p2.scrollingFrameRef:getValue()

		if v80 then
			v80:scrollToTop()
		end
	end
	function p2.navigateBack() -- line: 116
		-- upvalues: p2 (copy)
		p2.props.navigateBack(p2.state.filterText ~= nil)
	end
	function p2.closeDialog() -- line: 120
		-- upvalues: p2 (copy)
		p2.props.closeDialog(p2.state.filterText ~= nil)
	end

	p2.layoutBindings = {}

	function p2.getLayoutBinding(p4, p5) -- line: 125
		-- upvalues: p2 (copy), Roact (copy)
		local v83 = p2.layoutBindings[p4]

		if not v83 then
			local v84, v85 = Roact.createBinding(p5)

			v83 = {
				valueBinding = v84,
				setValue = v85,
				value = p5
			}
			p2.layoutBindings[p4] = v83
		end

		if p5 ~= v83.value then
			v83.value = p5
			v83.setValue(p5)
		end

		return v83.valueBinding
	end
	function p2.playerIsVoiceActive(n1: number) -- line: 145
		-- upvalues: default (copy)
		return default.participants[tostring(n1)] ~= nil
	end

	p2.sortedUserIds = {}
end

local function sortPlayers(p6, p7) -- line: 152
	return p6.DisplayName:lower() < p7.DisplayName:lower()
end

function v40.getPlayerList(p8) -- line: 156
	-- upvalues: Cryo (copy), Players (copy), sortPlayers (copy), PlayerSearchPredicate (copy)
	local t2 = {}
	local v50 = Cryo.List.sort(Players:GetPlayers(), sortPlayers)

	for _, v in ipairs(v50) do
		if v ~= Players.LocalPlayer then
			if not p8.state.isFilterMode then
				table.insert(t2, v)
			elseif PlayerSearchPredicate(p8.state.filterText, v.Name, v.DisplayName) then
				table.insert(t2, v)
			end
		end
	end

	return (Cryo.List.sort(t2, function(p9, p10) -- line: 172
		return p9.DisplayName:lower() < p10.DisplayName:lower()
	end))
end

local t3 = {
	[Constants.Category.Voice] = "CoreScripts.InGameMenu.Report.Title.VoiceChat",
	[Constants.Category.Text] = "CoreScripts.InGameMenu.Report.Title.TextChat",
	[Constants.Category.Other] = "CoreScripts.InGameMenu.Report.Title.Other"
}

function v40.categoryTitle(p11) -- line: 184
	-- upvalues: t3 (copy)
	return t3[p11.props.reportCategory] or "CoreScripts.InGameMenu.Report.MenuTitle"
end
function v40.renderHeaderBar(p12) -- line: 188
	-- upvalues: makeBackButton (copy), Roact (copy), IconButton (copy), IconSize (copy), Images (copy), withLocalization (copy), HeaderBar (copy), SearchBar (copy)
	local u55 = not p12.props.canNavigateBack and function() -- line: 193
		-- upvalues: Roact (copy), IconButton (copy), IconSize (copy), Images (copy), p12 (copy)
		return Roact.createElement(IconButton, {
			iconSize = IconSize.Medium,
			icon = Images["icons/navigation/close"],
			onActivated = p12.closeDialog
		})
	end or makeBackButton(p12.navigateBack)

	if not p12.state.isFilterMode then
		return withLocalization({
			titleText = p12:categoryTitle()
		})(function(p13) -- line: 205
			-- upvalues: Roact (copy), HeaderBar (copy), u55 (ref), IconButton (copy), IconSize (copy), Images (copy), p12 (copy)
			return Roact.createElement(HeaderBar, {
				backgroundTransparency = 1,
				barHeight = 48,
				renderLeft = u55,
				renderRight = function() -- line: 210
					-- upvalues: Roact (copy), IconButton (copy), IconSize (copy), Images (copy), p12 (copy)
					return Roact.createElement(IconButton, {
						iconSize = IconSize.Medium,
						icon = Images["icons/common/search"],
						onActivated = p12.onSearch
					})
				end,
				onHeaderActivated = p12.scrollToTop,
				title = p13.titleText
			})
		end)
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(24, 6),
		Size = UDim2.new(1, -48, 1, -12)
	}, { Roact.createElement(SearchBar, {
		autoCaptureFocus = true,
		size = UDim2.fromScale(1, 1),
		text = p12.state.filterText,
		onTextChanged = p12.onTextChanged,
		onCancelled = p12.onCancel
	}) })
end
function v40.renderContents(p14) -- line: 238
	-- upvalues: Constants (copy), Roact (copy), GameCell (copy), default (copy), Divider (copy), PlayerCell (copy), isPlayerVerified (copy), v41 (copy), Constants2 (copy), withStyle (copy), Cryo (copy), t1 (copy), Provider (copy), BarOnTopScrollingFrame (copy)
	local props = p14.props
	local v58 = p14.props.reportCategory == Constants.Category.Voice
	local n2 = 0
	local t4 = {
		ListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}

	if not p14.state.isFilterMode and p14.props.reportCategory == Constants.Category.None then
		t4.GameCell = Roact.createElement(GameCell, {
			gameId = game.GameId,
			layoutOrder = p14.getLayoutBinding("GameCell", n2),
			onActivated = function() -- line: 255
				-- upvalues: props (copy), Constants (copy)
				props.openReportDialog(Constants.ReportType.Place, nil)
			end
		})
	end

	local v61 = n2 + 1
	local n3 = 72
	local v63 = p14:getPlayerList()
	local t5 = {}

	if v58 then
		t5 = default:getRecentUsersInteractionData()
	end

	p14.sortedUserIds = {}

	for _, v in pairs(v63) do
		local str = tostring(v.UserId)

		if not v58 or t5[tostring(v.UserId)] then
			table.insert(p14.sortedUserIds, v.UserId)

			local n4 = 0

			if v58 then
				n4 += 1
			end

			if p14.props.isReportMenuOpen then
				n4 += 2
			end

			t4["Divider" .. str] = Roact.createElement(Divider, {
				LayoutOrder = p14.getLayoutBinding("Divider" .. str, v61),
				Size = UDim2.new(1, 0, 0, 1)
			})

			local v69 = v61 + 1

			t4["PlayerCell" .. str] = Roact.createElement(PlayerCell, {
				isOnline = true,
				isSelected = false,
				userId = v.UserId,
				username = v.Name,
				displayName = v.DisplayName,
				hasVerifiedBadge = isPlayerVerified(v),
				LayoutOrder = p14.getLayoutBinding("PlayerCell" .. str, v69),
				onActivated = function() -- line: 300
					-- upvalues: props (copy), Constants (copy), v (copy)
					props.openReportDialog(Constants.ReportType.Player, v)
				end,
				memoKey = n4
			}, {
				VoiceIndicator = v58 and (not not p14.props.isReportMenuOpen and Roact.createElement(v41, {
					hideOnError = true,
					iconStyle = "SpeakerLight",
					userId = tostring(v.UserId),
					size = UDim2.fromOffset(36, 36),
					onClicked = function() -- line: 312
						-- upvalues: default (copy), v (copy), Constants2 (copy)
						default:ToggleMutePlayer(v.UserId, Constants2.VOICE_CONTEXT_TYPE.REPORT_MENU)
					end
				})) or nil
			})
			v61 = v69 + 1
			n3 += 73
		end
	end

	t4.DividerEnd = Roact.createElement(Divider, {
		LayoutOrder = p14.getLayoutBinding("DividerEnd", v61),
		Size = UDim2.new(1, 0, 0, 1)
	})

	local _ = v61 + 1

	return withStyle(function(p15) -- line: 332
		-- upvalues: Cryo (copy), t1 (copy), Roact (copy), Provider (copy), BarOnTopScrollingFrame (copy), n3 (ref), p14 (copy), t4 (copy)
		local v91 = Cryo.Dictionary.join(p15.Theme, t1)
		local v92 = Cryo.Dictionary.join(p15, {
			Theme = v91
		})

		return Roact.createElement(Provider, {
			style = v92
		}, { Roact.createElement(BarOnTopScrollingFrame, {
			Size = UDim2.fromScale(1, 1),
			CanvasSize = UDim2.new(1, 0, 0, n3),
			scrollingFrameRef = p14.scrollingFrameRef
		}, t4) })
	end)
end
function v40.render(p16) -- line: 349
	-- upvalues: Roact (copy), ModalDialog (copy)
	local v72 = p16.props.reportCategory ~= nil

	return Roact.createFragment({
		ModalDialog = Roact.createElement(ModalDialog, {
			visible = p16.props.isReportMenuOpen,
			screenSize = p16.props.screenSize,
			headerBar = p16:renderHeaderBar(),
			showCloseButton = not v72,
			contents = p16:renderContents(),
			onDismiss = p16.closeDialog
		})
	})
end
function v40.didUpdate(p17, p18) -- line: 365
	-- upvalues: Roact (copy)
	if p18.isReportMenuOpen and not p17.props.isReportMenuOpen then
		p17:setState({
			isFilterMode = false,
			filterText = Roact.None
		})

		local v75 = p17.scrollingFrameRef:getValue()

		if v75 and v75.CanvasPosition.Y > 0 then
			v75.CanvasPosition = Vector2.new(0, 0)
		end
	end
end

return RoactRodux.UNSTABLE_connect2(function(p19, _) -- line: 379
	-- upvalues: Constants (copy)
	return {
		isReportMenuOpen = p19.report.currentPage == Constants.Page.Listing,
		screenSize = p19.displayOptions.screenSize,
		reportCategory = p19.report.reportCategory,
		canNavigateBack = #p19.report.history > 1
	}
end, function(p21) -- line: 387
	-- upvalues: NavigateBack (copy), SendAnalytics (copy), Constants (copy), EndReportFlow (copy), SessionUtility (copy), SelectReportListing (copy)
	return {
		navigateBack = function(p22) -- line: 389
			-- upvalues: p21 (copy), NavigateBack (copy), SendAnalytics (copy), Constants (copy)
			p21(NavigateBack())
			SendAnalytics(Constants.Page.Listing, Constants.Analytics.ReportFlowBack, {
				source = Constants.Page.Listing,
				filterTextChanged = p22
			})
		end,
		closeDialog = function(p23) -- line: 396
			-- upvalues: p21 (copy), EndReportFlow (copy), SendAnalytics (copy), Constants (copy), SessionUtility (copy)
			p21(EndReportFlow())
			SendAnalytics(Constants.Page.Listing, Constants.Analytics.ReportFlowAbandoned, {
				source = Constants.Page.Listing,
				filterTextChanged = p23
			})
			SessionUtility.endAbuseReportSession()
		end,
		openReportDialog = function(p24, p25, p26) -- line: 404
			-- upvalues: p21 (copy), SelectReportListing (copy), SendAnalytics (copy), Constants (copy)
			p21(SelectReportListing(p24, p25, p26))
			SendAnalytics(Constants.Page.Listing, Constants.Analytics.ReportFlowAdvance, {
				source = Constants.Page.Listing,
				reportType = p24
			})
		end
	}
end)(v40)
