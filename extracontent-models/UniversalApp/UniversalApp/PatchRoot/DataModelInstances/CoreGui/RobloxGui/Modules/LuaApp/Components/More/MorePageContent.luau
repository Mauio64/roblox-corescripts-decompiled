local CorePackages = game:GetService("CorePackages")
local NavigationEvents = require(CorePackages.Packages.RoactNavigation).NavigationEvents
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local AppNavBar = require(CorePackages.Workspace.Packages.AppNavBar)
local UserInputService = game:GetService("UserInputService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local MoreGrid = require(Modules.LuaApp.Components.More.MoreGrid)
local MoreGridItem = require(Modules.LuaApp.Components.More.MoreGridItem)
local MoreLogOut = require(Modules.LuaApp.Components.More.MoreLogOut)
local FFlagEnableMorePageExitButtonSupport = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableMorePageExitButtonSupport
local v14 = if not FFlagEnableMorePageExitButtonSupport then nil else require(Modules.LuaApp.Components.More.MoreExitApp)
local FFlagMorePageTermsPrivacyFooter = require(Modules.LuaApp.Flags.FFlagMorePageTermsPrivacyFooter)
local v16 = if not FFlagMorePageTermsPrivacyFooter then nil else require(Modules.LuaApp.Components.More.MoreFooter)
local TenFootMoreHeader = require(Modules.LuaApp.Components.More.TenFootMoreHeader)
local MoreSwitchAccount = require(Modules.LuaApp.Components.More.MoreSwitchAccount)
local Roact = require(Modules.Common.Roact)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactAnalyticsAuthEvents = require(Modules.LuaApp.Services.RoactAnalyticsAuthEvents)
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local GetFFlagUIBloxUseFoundationButton = SharedFlags.UIBlox.GetFFlagUIBloxUseFoundationButton
local Constants = require(Modules.LuaApp.Constants)
local AppStorageUtilities = require(CorePackages.Workspace.Packages.AuthCommon).Utils.AppStorageUtilities
local authPageload = require(CorePackages.Workspace.Packages.AuthAnalytics).Events.authPageload
local FFlagEnableLuaAccountSwitch = require(Modules.LuaApp.Flags.FFlagEnableLuaAccountSwitch)
local FFlagLuaAccountSwitchExperimentBypassBackdoorDev = require(Modules.LuaApp.Flags.FFlagLuaAccountSwitchExperimentBypassBackdoorDev)
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local AppBtidLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppBtidLayers
local v33 = game:DefineFastFlag("FixMorePageContentValidateProps", false)
local FFlagFixMorePageLogOutCutOff = require(Modules.LuaApp.Flags.FFlagFixMorePageLogOutCutOff)
local FFlagAuthSecExclusions = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAuthSecExclusions
local FFlagEnableMorePageDirectionalLayoutRolloutFix = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableMorePageDirectionalLayoutRolloutFix
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole
local FFlagMorePageGateAccountSwitcherByCachedVariantId = require(CorePackages.Workspace.Packages.SharedFlags).FFlagMorePageGateAccountSwitcherByCachedVariantId
local GetFStringAccountSwitcherTruthyVariantId = require(CorePackages.Workspace.Packages.SharedFlags).GetFStringAccountSwitcherTruthyVariantId
local GetFStringAccountSwitcherFalsyVariantId = require(CorePackages.Workspace.Packages.SharedFlags).GetFStringAccountSwitcherFalsyVariantId
local GetFFlagEnableAccountSwitcherRedesignIXP = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableAccountSwitcherRedesignIXP
local FFlagEnableLuaLoginRevamp = SharedFlags.FFlagEnableLuaLoginRevamp
local FStringLuaLoginRevampIxpLayer = SharedFlags.FStringLuaLoginRevampIxpLayer
local FFlagLuaAppsDefaultSelection = SharedFlags.FFlagLuaAppsDefaultSelection
local FFlagEnableAuthButtonShownEvent = SharedFlags.FFlagEnableAuthButtonShownEvent
local GridMetrics = UIBlox.App.Grid.GridMetrics
local VerticalScrollViewWithMargin = UIBlox.App.Container.VerticalScrollViewWithMargin
local v48 = not GetFFlagUIBloxUseFoundationButton() and 0 or 2
local v49 = Roact.PureComponent:extend("MorePageContent")
local User = require(script.Parent.Parent.Parent.Thunks.Authentication.User)

v49.validateProps = t.strictInterface({
	isWideView = t.boolean,
	itemTable = t.table,
	topBarHeight = t.integer,
	isDirectional = t.optional(t.boolean),
	isExitButtonSupported = t.optional(t.boolean),
	isAccountSwitcherEnabled = if not v33 or not FFlagEnableLuaAccountSwitch then nil else t.optional(t.boolean),
	enableFoundationDesign = t.optional(t.boolean),
	enableSignedOutAccounts = t.optional(t.boolean),
	navBarPlacement = if not FFlagFixMorePageLogOutCutOff then nil else t.valueOf(AppNavBar.Placement),
	excludeAccountSwitcher = t.optional(t.boolean),
	defaultFocusRef = if not FFlagLuaAppsDefaultSelection then nil else t.optional(t.callback),
	authAnalytics = if not FFlagEnableAuthButtonShownEvent then nil else t.table
})

function v49.init(p1) -- line: 109
	-- upvalues: Roact (copy), GridMetrics (copy), MoreGridItem (copy), FFlagEnableMorePageDirectionalLayoutRolloutFix (copy), UserInputService (copy), UserGameSettings (copy)
	p1.shouldResize = true
	p1.scrollviewRef = Roact.createRef()
	p1.contentRef = Roact.createRef()

	function p1.onWillFocus() -- line: 116
		-- upvalues: p1 (copy)
		if p1.scrollviewRef.current then
			local _ = p1.scrollviewRef.current.AbsoluteCanvasSize
		end
	end
	function p1.onResize(p2) -- line: 125
		-- upvalues: p1 (copy), GridMetrics (copy)
		if not p1.shouldResize then
			return
		end

		local AbsoluteSizeX

		if p1.contentRef.current then
			AbsoluteSizeX = p1.contentRef.current.AbsoluteSize.X
		else
			if not p2 then
				return
			end

			AbsoluteSizeX = p2.AbsoluteSize.X
		end

		local isWideView = p1.props.isWideView

		if p1.props.isDirectional then
			local n1, n2

			if #p1.props.itemTable[1] <= 4 then
				n1 = 36
				n2 = 4
			else
				n1 = 48
				n2 = 5
			end

			local n3 = 96
			local v96 = (AbsoluteSizeX - (n2 - 1) * n1 - 2 * n3) / n2

			p1:setState({
				gridCellSize = math.floor(v96),
				gridCellsInARow = n2,
				gutter = n1,
				paddingHorizontal = n3
			})

			return
		end

		local n4, v98

		if isWideView then
			n4 = 24
			v98 = not (AbsoluteSizeX > 1020) and 48 or (AbsoluteSizeX - 924) / 2
		else
			n4 = 12
			v98 = not (AbsoluteSizeX < 360) and 24 or 12
		end

		local v99 = AbsoluteSizeX - 2 * v98

		if v99 <= 0 then
			return
		end

		local v100 = GridMetrics.getMediumMetrics(v99, n4)

		p1:setState({
			gridCellSize = v100.itemWidth,
			gridCellsInARow = v100.itemsPerRow,
			gutter = n4,
			paddingHorizontal = v98
		})
	end
	function p1.renderGridItem(p3, p4) -- line: 195
		-- upvalues: Roact (copy), MoreGridItem (copy), FFlagEnableMorePageDirectionalLayoutRolloutFix (copy), p1 (copy)
		return Roact.createElement(MoreGridItem, {
			item = p3,
			layoutOrder = p4,
			isDirectional = if not FFlagEnableMorePageDirectionalLayoutRolloutFix then nil else p1.props.isDirectional
		})
	end

	p1.statusBarTappedConnection = UserInputService.StatusBarTapped:Connect(function() -- line: 203
		-- upvalues: p1 (copy), UserGameSettings (copy)
		local current = p1.scrollviewRef.current

		if not current then
			return
		end

		if UserGameSettings.ReducedMotion then
			current.CanvasPosition = Vector2.new(0, 0)

			return
		end

		current:ScrollToTop()
	end)
	p1:setState({
		gridCellSize = 1,
		gridCellsInARow = 1,
		gutter = 12,
		paddingHorizontal = 12
	})
end
function v49.willUnmount(p5) -- line: 224
	p5.shouldResize = false
	p5.statusBarTappedConnection:Disconnect()
end
function v49.didUpdate(p6, p7, _) -- line: 229
	if p7.isWideView ~= p6.props.isWideView then
		p6.onResize(nil)
	end
end
function v49.render(p9) -- line: 235
	-- upvalues: User (copy), FFlagEnableLuaAccountSwitch (copy), FFlagLuaAccountSwitchExperimentBypassBackdoorDev (copy), FFlagMorePageGateAccountSwitcherByCachedVariantId (copy), AppStorageUtilities (copy), GetFStringAccountSwitcherTruthyVariantId (copy), GetFStringAccountSwitcherFalsyVariantId (copy), authPageload (copy), FFlagAuthSecExclusions (copy), EventStreamConstants (copy), FFlagEnableAuthButtonShownEvent (copy), GetFFlagUIBloxUseFoundationButton (copy), v48 (copy), FFlagEnableMorePageExitButtonSupport (copy), FFlagMorePageTermsPrivacyFooter (copy), FFlagAppIaScrollAway (copy), AppNavBar (copy), Roact (copy), MoreSwitchAccount (copy), FFlagFixMorePageLogOutCutOff (copy), Constants (copy), FFlagEnableLeftNavOnConsole (copy), NavigationEvents (copy), VerticalScrollViewWithMargin (copy), TenFootMoreHeader (copy), MoreGrid (copy), FFlagLuaAppsDefaultSelection (copy), MoreLogOut (copy), v14 (copy), v16 (copy)
	local gridCellSize = p9.state.gridCellSize
	local gridCellsInARow = p9.state.gridCellsInARow
	local gutter = p9.state.gutter
	local paddingHorizontal = p9.state.paddingHorizontal
	local v62 = p9.props.itemTable[1]
	local v63 = p9.props.itemTable[2][1]
	local topBarHeight = p9.props.topBarHeight
	local v65 = #v62
	local isDirectional = p9.props.isDirectional

	if isDirectional then
		gridCellsInARow = not (#v62 <= 4) and 5 or 4
	end

	local v67 = math.ceil(v65 / gridCellsInARow) * (gridCellSize + gutter) - gutter
	local v68 = User.fromLocalStorage().isUnder13 ~= true
	local v69 = false
	local v70 = false

	if FFlagEnableLuaAccountSwitch then
		local v71 = p9.props.isAccountSwitcherEnabled or FFlagLuaAccountSwitchExperimentBypassBackdoorDev == true

		if FFlagMorePageGateAccountSwitcherByCachedVariantId then
			local v72 = AppStorageUtilities.getAccountSwitcherAvailableByVariantId()

			if v72 == nil then
				local v73 = if not v71 then GetFStringAccountSwitcherFalsyVariantId() else GetFStringAccountSwitcherTruthyVariantId()

				AppStorageUtilities.setAccountSwitcherExperimentVariantId(v73)
				AppStorageUtilities.flush()
				authPageload("userEnrolledInCachedAs", (tostring(v71)))
			else
				v71 = v72
				authPageload("morePageCachedAsValue", (tostring(v72)))
			end
		end

		v70 = p9.props.excludeAccountSwitcher and FFlagAuthSecExclusions
		v69 = not v70 and (v68 and v71)
	end

	local v74 = if not v70 then if v68 then if not v69 then EventStreamConstants.State.SwitchAccountsIxpHidden else EventStreamConstants.State.SwitchAccountsShown else EventStreamConstants.State.SwitchAccountsU13Hidden else EventStreamConstants.State.SwitchAccountsExclusionsHidden

	if FFlagEnableAuthButtonShownEvent and v74 ~= p9.reportedAuthButtonShownState then
		p9.reportedAuthButtonShownState = v74
		p9.props.authAnalytics.reportAuthButtonShown(EventStreamConstants.Context.MorePage, EventStreamConstants.Button.SwitchAccounts, v74, EventStreamConstants.Origin.MoreMenu)
	end

	local v75 = if not isDirectional then not GetFFlagUIBloxUseFoundationButton() and 48 or v48 + 48 else not GetFFlagUIBloxUseFoundationButton() and 72 or v48 + 72
	local v76 = not isDirectional and 640 or 1024
	local v77 = if not v69 then v67 + 2 * gutter + v75 else v67 + 2 * gutter + v75 * 2

	if FFlagEnableMorePageExitButtonSupport and p9.props.isExitButtonSupported then
		v77 = v77 + v75 + (not v69 and 0 or gutter)
	end

	if FFlagMorePageTermsPrivacyFooter then
		v77 = v77 + 38 + gutter
	end

	if isDirectional then
		v77 += 200
	end

	if FFlagAppIaScrollAway and AppNavBar.getScrollAwayEnabled() then
		v77 += topBarHeight
	end

	local v78 = nil

	if v69 then
		local v79 = p9.props.itemTable[2][1]

		v78 = Roact.createElement(MoreSwitchAccount, {
			layoutOrder = 2,
			buttonHeight = v75,
			buttonMaxWidth = v76,
			item = v79,
			enableFoundationDesign = p9.props.enableFoundationDesign,
			enableSignedOutAccounts = p9.props.enableSignedOutAccounts,
			showLoginRevamp = p9.props.showLoginRevamp
		})
	end

	local v80 = (not FFlagFixMorePageLogOutCutOff or p9.props.navBarPlacement ~= AppNavBar.Placement.Bottom) and 0 or Constants.BOTTOM_BAR_SIZE

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = if not FFlagAppIaScrollAway or not AppNavBar.getScrollAwayEnabled() then UDim2.fromOffset(0, topBarHeight) else nil,
		Size = if not FFlagAppIaScrollAway or not AppNavBar.getScrollAwayEnabled() then if not FFlagFixMorePageLogOutCutOff then UDim2.new(1, 0, 1, -topBarHeight - Constants.BOTTOM_BAR_SIZE) else UDim2.new(1, 0, 1, -topBarHeight - v80) else UDim2.new(1, 0, 1, 0)
	}, {
		UIPadding = Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, gutter)
		}),
		Content = Roact.createElement("Frame", {
			BackgroundTransparency = (not isDirectional or FFlagEnableLeftNavOnConsole) and 1 or 0,
			Size = UDim2.new(1, 0, 1, 0),
			[Roact.Ref] = p9.contentRef,
			[Roact.Change.AbsoluteSize] = p9.onResize
		}, {
			UIGradient = if not isDirectional or FFlagEnableLeftNavOnConsole then nil else Roact.createElement("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new(Color3.new(0, 0, 0)),
				Transparency = NumberSequence.new(1, 0.4)
			}),
			NavigationEvents = Roact.createElement(NavigationEvents, {
				onWillFocus = p9.onWillFocus
			}),
			VerticalScrollViewWithMargin = Roact.createElement(VerticalScrollViewWithMargin, {
				canvasSizeY = UDim.new(0, v77),
				paddingHorizontal = paddingHorizontal,
				paddingTop = if not FFlagAppIaScrollAway or not AppNavBar.getScrollAwayEnabled() then nil else topBarHeight,
				[Roact.Ref] = p9.scrollviewRef,
				Selectable = false
			}, {
				UIListLayout = Roact.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, gutter),
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				TenFootMoreHeader = if not isDirectional then nil else Roact.createElement(TenFootMoreHeader),
				MoreGrid = Roact.createElement(MoreGrid, {
					layoutOrder = 1,
					defaultFocusRef = if not FFlagLuaAppsDefaultSelection then nil else p9.props.defaultFocusRef,
					size = UDim2.new(1, 0, 0, v67),
					gridCellPadding = gutter,
					gridCellSize = gridCellSize,
					items = v62,
					renderItem = p9.renderGridItem
				}),
				MoreSwitchAccount = v78,
				MoreLogOut = Roact.createElement(MoreLogOut, {
					layoutOrder = 3,
					buttonHeight = v75,
					buttonMaxWidth = v76,
					item = v63
				}),
				MoreExitAppButton = if not FFlagEnableMorePageExitButtonSupport or (not v14 or not p9.props.isExitButtonSupported) then nil else Roact.createElement(v14, {
					layoutOrder = 4,
					buttonMaxWidth = v76,
					buttonHeight = v75
				}),
				MoreFooter = if not FFlagMorePageTermsPrivacyFooter or not v16 then nil else Roact.createElement(v16, {
					layoutOrder = 5,
					height = 38
				})
			})
		})
	})
end

local v51 = RoactAppPolicy.connect(function(p10, _) -- line: 442
	return {
		excludeAccountSwitcher = p10.getExcludeAccountSwitcher()
	}
end)(v49)

if FFlagEnableAuthButtonShownEvent then
	v51 = RoactServices.connect({
		authAnalytics = RoactAnalyticsAuthEvents
	})(v51)
end

if FFlagEnableLuaAccountSwitch == true then
	v51 = RoactAppExperiment.connectBrowserTrackerLayer({ AppBtidLayers.AccountSwitcherLayer }, function(p12, _) -- line: 457
		-- upvalues: AppBtidLayers (copy), GetFFlagEnableAccountSwitcherRedesignIXP (copy)
		local v85 = p12[AppBtidLayers.AccountSwitcherLayer] or {}
		local t1 = {
			isAccountSwitcherEnabled = v85.isAccountSwitcherEnabled
		}

		if GetFFlagEnableAccountSwitcherRedesignIXP() then
			t1.enableFoundationDesign = v85.enableAccountSwitcherFoundationDesign == true
			t1.enableSignedOutAccounts = v85.enableAccountSwitcherSignedOutAccounts == true

			return t1
		end

		t1.enableFoundationDesign = true
		t1.enableSignedOutAccounts = true

		return t1
	end)(v51)
end

if FFlagEnableLuaLoginRevamp then
	v51 = RoactAppExperiment.connectBrowserTrackerLayer({ FStringLuaLoginRevampIxpLayer }, function(p14, _) -- line: 476
		-- upvalues: FStringLuaLoginRevampIxpLayer (copy)
		return {
			showLoginRevamp = (p14[FStringLuaLoginRevampIxpLayer] or {}).showLoginRevamp
		}
	end)(v51)
end

return v51
