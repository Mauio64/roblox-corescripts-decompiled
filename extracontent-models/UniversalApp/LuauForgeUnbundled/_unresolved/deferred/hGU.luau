local CorePackages = game:GetService("CorePackages")
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local navigationEvents = RoactNavigation.NavigationEvents
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagLoginV2FullFlowDevOverride = SharedFlags.FFlagLoginV2FullFlowDevOverride
local module2 = require("@luauforge/bundled/dHu")

local UserInputService = game:GetService("UserInputService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local module3 = require("@luauforge/deferred/hGV")
local module4 = require("@luauforge/deferred/hGW")
local module5 = require("@luauforge/bundled/hHa")

local fFlagEnableMorePageExitButtonSupport = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableMorePageExitButtonSupport

local v5 = if fFlagEnableMorePageExitButtonSupport then require("@luauforge/deferred/hHq") else nil

local module6 = require("@luauforge/deferred/hHr")
local module7 = require("@luauforge/deferred/hHs")
local module8 = require("@luauforge/deferred/hHu")
local module9 = require("@luauforge/bundled/ecR")
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module10 = require("@luauforge/bundled/fMG")
local module11 = require("@luauforge/bundled/fsy")
local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local getFFlagUIBloxUseFoundationButton = SharedFlags.UIBlox.GetFFlagUIBloxUseFoundationButton
local module12 = require("@luauforge/bundled/dwA")

local module13 = require("@luauforge/bundled/fDx")
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local appBtidLayers = require("@luauforge/bundled/dMA").AppBtidLayers
local module14 = require("@luauforge/deferred/hHv")

local fFlagEnableMorePageDirectionalLayoutRolloutFix = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableMorePageDirectionalLayoutRolloutFix
local fStringLuaLoginRevampIxpLayer = SharedFlags.FStringLuaLoginRevampIxpLayer

local gridMetrics = UIBlox.App.Grid.GridMetrics
local verticalScrollViewWithMargin = UIBlox.App.Container.VerticalScrollViewWithMargin

local v6 = getFFlagUIBloxUseFoundationButton() and 2 or 0

local extended = module9.PureComponent:extend("MorePageContent")
local Models = require("@game/CorePackages/Packages/_Index/RoduxUsers/RoduxUsers/Models")

local strictInterface = t.strictInterface
local v7 = {
	isWideView = t.boolean,
	itemTable = t.table,
	topBarHeight = t.integer,
	isDirectional = t.optional(t.boolean),
	isExitButtonSupported = t.optional(t.boolean),
	isAccountSwitcherEnabled = t.optional(t.boolean),
	enableSignedOutAccounts = t.optional(t.boolean),
	showLoginRevamp = t.optional(t.boolean),
	navBarPlacement = 0,
	excludeAccountSwitcher = 0,
	defaultFocusRef = 0,
	authAnalytics = 0
}
local v8 = if module14 then t.valueOf(module2.Placement) else nil
v7.navBarPlacement = v8
v7.excludeAccountSwitcher = t.optional(t.boolean)
v7.defaultFocusRef = t.optional(t.callback)
v7.authAnalytics = t.table
extended.validateProps = strictInterface(v7)

function extended:init()
	self.shouldResize = true

	self.scrollviewRef = module9.createRef()

	self.contentRef = module9.createRef()

	function self.onWillFocus()
		if self.scrollviewRef.current then
			local absoluteCanvasSize = self.scrollviewRef.current.AbsoluteCanvasSize
		end
	end

	function self.onResize(p2)
		if not self.shouldResize then
			return
		end

		local x

		if self.contentRef.current then
			x = self.contentRef.current.AbsoluteSize.X
		elseif p2 then
			x = p2.AbsoluteSize.X
		else
			return
		end

		local isWideView = self.props.isWideView

		if self.props.isDirectional then
			local v9, v10

			if #self.props.itemTable[1] <= 4 then
				v9 = 4
				v10 = 36
			else
				v9 = 5
				v10 = 48
			end

			local v11 = 96
			self:setState({
				gridCellSize = math.floor((x - (v9 - 1) * v10 - 2 * v11) / v9),
				gridCellsInARow = v9,
				gutter = v10,
				paddingHorizontal = v11
			})
		else
			local v9, v10

			if isWideView then
				v9 = 24

				v10 = if x > 1020 then (x - 924) / 2 else 48
			else
				v9 = 12
				v10 = if x < 360 then 12 else 24
			end

			local v11 = x - 2 * v10

			if v11 <= 0 then
				return
			end

			local mediumMetrics = gridMetrics.getMediumMetrics(v11, v9)

			self:setState({
				gridCellSize = mediumMetrics.itemWidth,
				gridCellsInARow = mediumMetrics.itemsPerRow,
				gutter = v9,
				paddingHorizontal = v10
			})
		end
	end

	function self.renderGridItem(p2, p3)
		local createElement = module9.createElement

		local v11 = if fFlagEnableMorePageDirectionalLayoutRolloutFix then self.props.isDirectional else nil
		return createElement(module4, {
			item = p2,
			layoutOrder = p3,
			isDirectional = v11
		})
	end

	self.statusBarTappedConnection = UserInputService.StatusBarTapped:Connect(function()
		local current = self.scrollviewRef.current

		if not current then
			return
		end

		if UserGameSettings.ReducedMotion then
			current.CanvasPosition = Vector2.new(0, 0)
		else
			current:ScrollToTop()
		end
	end)

	self:setState({
		gridCellSize = 1,
		gridCellsInARow = 1,
		gutter = 12,
		paddingHorizontal = 12
	})
end

function extended:willUnmount()
	self.shouldResize = false
	self.statusBarTappedConnection:Disconnect()
end

function extended.didUpdate(p2, p3, p4)
	if p3.isWideView ~= p2.props.isWideView then
		p2.onResize(nil)
	end
end

function extended:render()
	local gridCellSize = self.state.gridCellSize
	local gridCellsInARow = self.state.gridCellsInARow
	local gutter = self.state.gutter
	local paddingHorizontal = self.state.paddingHorizontal

	local v9 = self.props.itemTable[1]
	local v10 = self.props.itemTable[2][1]
	local topBarHeight = self.props.topBarHeight

	local v11 = #v9
	local isDirectional = self.props.isDirectional

	local v12 = math.ceil(v11 / (isDirectional and (#v9 <= 4 and 4 or 5) or gridCellsInARow)) * (gridCellSize + gutter) - gutter

	local v13 = Models.fromLocalStorage().isUnder13 ~= true
	local v14, v15

	if module13 then
		local isAccountSwitcherEnabled = self.props.isAccountSwitcherEnabled
		v14 = self.props.excludeAccountSwitcher
		v15 = not v14 and v13 and isAccountSwitcherEnabled
	else
		v14 = false
		v15 = false
	end

	local v16

	if v14 then
		v16 = module11.State.SwitchAccountsExclusionsHidden
	elseif v13 then
		v16 = if v15 then module11.State.SwitchAccountsShown else module11.State.SwitchAccountsAmpHidden
	else
		v16 = module11.State.SwitchAccountsU13Hidden
	end

	if self.reportedAuthButtonShownState ~= v16 then
		self.reportedAuthButtonShownState = v16
		self.props.authAnalytics.reportAuthButtonShown(
			module11.Context.MorePage,
			module11.Button.SwitchAccounts,
			v16,
			module11.Origin.MoreMenu
		)
	end

	local v17

	if isDirectional then
		v17 = not getFFlagUIBloxUseFoundationButton() and 72 or v6 + 72
	else
		v17 = not getFFlagUIBloxUseFoundationButton() and 48 or v6 + 48
	end

	local v18 = isDirectional and 1024 or 640
	local v19 = if v15 then v12 + 2 * gutter + v17 * 2 else v12 + 2 * gutter + v17

	if fFlagEnableMorePageExitButtonSupport and self.props.isExitButtonSupported then
		v19 = v19 + v17 + (not v15 and 0 or gutter)
	end

	local v20 = v19 + 38 + gutter

	if isDirectional then
		v20 += 200
	end

	if fFlagAppIaScrollAway and module2.getScrollAwayEnabled() then
		v20 += topBarHeight
	end

	local v21

	if v15 then
		local v22 = self.props.itemTable[2][1]
		v21 = module9.createElement(module8, {
			buttonHeight = v17,
			buttonMaxWidth = v18,
			item = v22,
			layoutOrder = 2,
			enableSignedOutAccounts = self.props.enableSignedOutAccounts,
			showLoginRevamp = self.props.showLoginRevamp
		})
	end

	local v22 = (not module14 or self.props.navBarPlacement ~= module2.Placement.Bottom) and 0
		or module12.BOTTOM_BAR_SIZE

	local createElement = module9.createElement

	local v25 = if not (fFlagAppIaScrollAway and module2.getScrollAwayEnabled()) then UDim2.fromOffset(0, topBarHeight) else nil
	local udim

	if fFlagAppIaScrollAway and module2.getScrollAwayEnabled() then
		udim = UDim2.new(1, 0, 1, 0)
	elseif module14 then
		udim = UDim2.new(1, 0, 1, -topBarHeight - v22)
	else
		udim = UDim2.new(1, 0, 1, -topBarHeight - module12.BOTTOM_BAR_SIZE)
	end

	local v26 = {
		UIPadding = module9.createElement("UIPadding", {
			PaddingTop = UDim.new(0, gutter)
		}),
		Content = 0
	}

	local createElement2 = module9.createElement
	local v28 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		[module9.Ref] = self.contentRef,
		[module9.Change.AbsoluteSize] = self.onResize
	}
	local v29 = {
		NavigationEvents = module9.createElement(navigationEvents, {
			onWillFocus = self.onWillFocus
		}),
		VerticalScrollViewWithMargin = 0
	}

	local createElement3 = module9.createElement
	local scrollviewRefsByRef = {
		["canvasSizeY"] = nil,
		["canvasSizeY"] = nil,
		["canvasSizeY"] = nil,
		canvasSizeY = UDim.new(0, v20),
		paddingHorizontal = paddingHorizontal
	}

	if not (fFlagAppIaScrollAway and module2.getScrollAwayEnabled()) then
		topBarHeight = nil
	end

	scrollviewRefsByRef.paddingTop = topBarHeight
	scrollviewRefsByRef[module9.Ref] = self.scrollviewRef
	scrollviewRefsByRef.Selectable = false
	local children = {
		UIListLayout = module9.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, gutter),
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		TenFootMoreHeader = 0,
		MoreGrid = 0,
		MoreSwitchAccount = 0,
		MoreLogOut = 0,
		MoreExitAppButton = 0,
		MoreFooter = 0
	}

	local v31 = if isDirectional then module9.createElement(module7) else nil
	children.TenFootMoreHeader = v31
	children.MoreGrid = module9.createElement(module3, {
		defaultFocusRef = self.props.defaultFocusRef,
		size = UDim2.new(1, 0, 0, v12),
		gridCellPadding = gutter,
		gridCellSize = gridCellSize,
		items = v9,
		renderItem = self.renderGridItem,
		layoutOrder = 1
	})

	children.MoreSwitchAccount = v21

	children.MoreLogOut = module9.createElement(module5, {
		buttonHeight = v17,
		buttonMaxWidth = v18,
		item = v10,
		layoutOrder = 3
	})

	local v32 = if fFlagEnableMorePageExitButtonSupport and v5 and self.props.isExitButtonSupported then module9.createElement(v5, {
		layoutOrder = 4,
		buttonMaxWidth = v18,
		buttonHeight = v17
	}) else nil
	children.MoreExitAppButton = v32

	local v33 = if module6 then module9.createElement(module6, {
		layoutOrder = 5,
		height = 38
	}) else nil
	children.MoreFooter = v33
	v29.VerticalScrollViewWithMargin = createElement3(
		verticalScrollViewWithMargin,
		scrollviewRefsByRef,
		children
	)
	v26.Content = createElement2("Frame", v28, v29)
	return createElement("Frame", {
		BackgroundTransparency = 1,
		Position = v25,
		Size = udim
	}, v26)
end

local v9 = roactAppPolicy.connect(function(p2)
	return {
		excludeAccountSwitcher = p2.getExcludeAccountSwitcher(),
		isAccountSwitcherEnabled = p2.getAccountSwitcherEnabled()
	}
end)(extended)

local v10 = roactServices.connect({ authAnalytics = module10 })(v9)

if module13 == true then
	v10 = RoactAppExperiment.connectBrowserTrackerLayer(
		{ appBtidLayers.AccountSwitcherLayer },
		function(p2, p3)
			return {
				enableSignedOutAccounts = (p2[appBtidLayers.AccountSwitcherLayer] or {}).enableAccountSwitcherSignedOutAccounts == true
			}
		end
	)(v10)
end

return (RoactAppExperiment.connectBrowserTrackerLayer({ fStringLuaLoginRevampIxpLayer }, function(p2, p3)
	local v11 = p2[fStringLuaLoginRevampIxpLayer] or {}
	return {
		showLoginRevamp = fFlagLoginV2FullFlowDevOverride or v11.showLoginRevamp
	}
end)(v10))
