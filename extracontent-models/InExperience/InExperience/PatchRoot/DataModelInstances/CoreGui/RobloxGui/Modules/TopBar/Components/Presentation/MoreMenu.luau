local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local ContextActionService = game:GetService("ContextActionService")
local VRService = game:GetService("VRService")
local StarterGui = game:GetService("StarterGui")

require(CorePackages.Packages.Signals)
require(CorePackages.Workspace.Packages.Display)

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Signals = require(CorePackages.Packages.Signals)
local Display = require(CorePackages.Workspace.Packages.Display)
local ContextualMenu = UIBlox.App.Menu.ContextualMenu
local MenuDirection = UIBlox.App.Menu.MenuDirection
local Images = UIBlox.App.ImageSet.Images
local withStyle = UIBlox.Core.Style.withStyle
local ParentParent = script.Parent.Parent.Parent
local Actions = ParentParent.Actions
local SetKeepOutArea = require(Actions.SetKeepOutArea)
local RemoveKeepOutArea = require(Actions.RemoveKeepOutArea)
local SetMoreMenuOpen = require(Actions.SetMoreMenuOpen)
local Analytics = require(ParentParent.Analytics)
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagTopBarSignalizeKeepOutAreas = CoreGuiCommon.Flags.FFlagTopBarSignalizeKeepOutAreas
local FFlagTopBarSignalizeScreenSize = CoreGuiCommon.Flags.FFlagTopBarSignalizeScreenSize
local v25 = require(ParentParent.Flags.GetFFlagEnableTopBarAnalytics)()
local Constants = require(ParentParent.Constants)
local _ = Constants.InputType
local IconButton = require(script.Parent.IconButton)
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Modules = RobloxGui.Modules
local TenFootInterface = require(Modules.TenFootInterface)
local VRHub = require(CorePackages.Workspace.Packages.VrCommon).VRHub
local EmotesMenuMaster = require(Modules.EmotesMenu.EmotesMenuMaster)
local FFlagEnableNewBackpack = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableNewBackpack
local v35 = if not FFlagEnableNewBackpack then nil else require(CorePackages.Workspace.Packages.System).Features
local v36 = if FFlagEnableNewBackpack then nil else require(Modules.BackpackScript)
local ChatSelector = require(Modules.ChatSelector)
local PlayerListManager = require(Modules.PlayerList.PlayerListManager)
local Constants2 = require(Modules.EmotesMenu.Constants)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local FFlagMountCoreGuiBackpack = require(Modules.Flags.FFlagMountCoreGuiBackpack)
local v43 = Images["icons/controls/emoteOn"]
local v44 = Images["icons/controls/emoteOff"]
local v45 = Roact.PureComponent:extend("MoreMenu")

v45.validateProps = t.strictInterface({
	layoutOrder = t.integer,
	moreMenuOpen = t.boolean,
	setMoreMenuOpen = t.callback,
	screenSize = if not FFlagTopBarSignalizeScreenSize then t.Vector2 else nil,
	isSmallTouchDevice = t.boolean,
	topBarEnabled = t.boolean,
	leaderboardEnabled = t.boolean,
	emotesEnabled = t.boolean,
	backpackEnabled = if not FFlagMountCoreGuiBackpack then t.boolean else nil,
	leaderboardOpen = t.boolean,
	backpackOpen = t.boolean,
	emotesOpen = t.boolean,
	setKeepOutArea = if not FFlagTopBarSignalizeKeepOutAreas then t.callback else nil,
	removeKeepOutArea = if not FFlagTopBarSignalizeKeepOutAreas then t.callback else nil
})

function v45.init(p1) -- line: 110
	-- upvalues: Roact (copy), v25 (copy), Analytics (copy), Signals (copy), Display (copy), FFlagMountCoreGuiBackpack (copy), StarterGui (copy), FFlagTopBarSignalizeKeepOutAreas (copy), CoreGuiCommon (copy), FFlagTopBarSignalizeScreenSize (copy)
	p1.rootRef = Roact.createRef()

	if v25 then
		p1.analytics = Analytics.default
	end

	p1.disposeUiScaleEffect = Signals.createEffect(function(p2) -- line: 115
		-- upvalues: Display (copy), p1 (copy)
		local v72 = Display.GetDisplayStore(p2)

		p1:setState({
			UiScale = v72.getUIScale(p2)
		})
	end)

	if FFlagMountCoreGuiBackpack then
		p1:setState({
			vrShowMenuIcon = false,
			mountBackpack = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack)
		})
		StarterGui.CoreGuiChangedSignal:Connect(function(p3, b1: boolean) -- line: 128
			-- upvalues: p1 (copy)
			if p3 == Enum.CoreGuiType.Backpack or p3 == Enum.CoreGuiType.All then
				p1:setState({
					mountBackpack = b1
				})
			end
		end)
	else
		p1:setState({
			vrShowMenuIcon = false
		})
	end

	p1.chatWasHidden = false
	p1.boundAction = false

	function p1.moreButtonActivated() -- line: 145
		-- upvalues: p1 (copy)
		p1.props.setMoreMenuOpen(not p1.props.moreMenuOpen)

		if p1.analytics then
			p1.analytics:onMoreMenuActivated()
		end
	end

	if FFlagTopBarSignalizeKeepOutAreas then
		p1.keepOutAreasStore = CoreGuiCommon.Stores.GetKeepOutAreasStore(false)
	end

	if FFlagTopBarSignalizeScreenSize then
		local getViewportSize = Display.GetDisplayStore(false).getViewportSize

		p1.disposeScreenSize = Signals.createEffect(function(p4) -- line: 159
			-- upvalues: p1 (copy), getViewportSize (copy)
			p1:setState({
				screenSize = getViewportSize(p4)
			})
		end)
	end
end
function v45.willUnmount(p5) -- line: 167
	-- upvalues: FFlagTopBarSignalizeScreenSize (copy)
	if FFlagTopBarSignalizeScreenSize then
		p5.disposeScreenSize()
	end

	if p5.disposeUiScaleEffect then
		p5.disposeUiScaleEffect()
	end
end
function v45.renderWithStyle(p6, p7) -- line: 176
	-- upvalues: RobloxTranslator (copy), VRService (copy), RobloxGui (copy), PlayerListManager (copy), v43 (copy), v44 (copy), Constants2 (copy), EmotesMenuMaster (copy), ChatSelector (copy), FFlagMountCoreGuiBackpack (copy), FFlagEnableNewBackpack (copy), v35 (copy), v36 (copy), FFlagTopBarSignalizeScreenSize (copy), TenFootInterface (copy), FFlagTopBarSignalizeKeepOutAreas (copy), Constants (copy), Roact (copy), IconButton (copy), ContextualMenu (copy), MenuDirection (copy), ExternalEventConnection (copy), VRHub (copy)
	local t1 = {}
	local u54 = false

	if p6.props.leaderboardEnabled then
		local s1 = "rbxasset://textures/ui/TopBar/leaderboardOn.png"

		if not p6.props.leaderboardOpen then
			s1 = "rbxasset://textures/ui/TopBar/leaderboardOff.png"
		end

		table.insert(t1, {
			icon = s1,
			text = RobloxTranslator:FormatByKey("CoreScripts.TopBar.Leaderboard"),
			onActivated = function() -- line: 189
				-- upvalues: p6 (copy), VRService (copy), RobloxGui (copy), PlayerListManager (copy)
				local leaderboardOpen = p6.props.leaderboardOpen

				if VRService.VREnabled then
					require(RobloxGui.Modules.InGameMenu).openPlayersPage()
				else
					PlayerListManager:SetVisibility(not PlayerListManager:GetSetVisible())
					p6.props.setMoreMenuOpen(false)
				end

				if p6.analytics then
					p6.analytics:onLeaderboardActivated(not leaderboardOpen)
				end
			end
		})
		u54 = true
	end

	if p6.props.emotesEnabled then
		local v56 = v43

		if not p6.props.emotesOpen then
			v56 = v44
		end

		local _ = Constants2.EmoteMenuOpenKey

		table.insert(t1, {
			icon = v56,
			text = RobloxTranslator:FormatByKey("CoreScripts.TopBar.Emotes"),
			onActivated = function() -- line: 217
				-- upvalues: EmotesMenuMaster (copy), p6 (copy), ChatSelector (copy)
				if EmotesMenuMaster:isOpen() then
					EmotesMenuMaster:close()
				else
					if p6.chatWasHidden then
						ChatSelector:SetVisible(true)
						p6.chatWasHidden = false
					end

					EmotesMenuMaster:open()
				end

				p6.props.setMoreMenuOpen(false)

				if p6.analytics then
					p6.analytics:onEmotesActivated(EmotesMenuMaster:isOpen())
				end
			end
		})
		u54 = true
	end

	if if not FFlagMountCoreGuiBackpack then p6.props.backpackEnabled else p6.state.mountBackpack then
		local s2 = "rbxasset://textures/ui/TopBar/inventoryOn.png"

		if not p6.props.backpackOpen then
			s2 = "rbxasset://textures/ui/TopBar/inventoryOff.png"
		end

		table.insert(t1, {
			icon = s2,
			text = RobloxTranslator:FormatByKey("CoreScripts.TopBar.Inventory"),
			onActivated = function() -- line: 252
				-- upvalues: FFlagEnableNewBackpack (copy), v35 (copy), p6 (copy), v36 (copy)
				if FFlagEnableNewBackpack then
					v35.toggleVisibility(v35.FeatureName.Backpack)
					p6.props.setMoreMenuOpen(false)

					if p6.analytics then
						p6.analytics:onInventoryActivated(v35.getVisibility(v35.FeatureName.Backpack))

						return
					end
				else
					v36:OpenClose()
					p6.props.setMoreMenuOpen(false)

					if p6.analytics then
						p6.analytics:onInventoryActivated(v36.IsOpen)
					end
				end
			end
		})
		u54 = true
	end

	local v59 = if not FFlagTopBarSignalizeScreenSize then p6.props.screenSize else p6.state.screenSize
	local uDim2 = UDim2.new(0, 324, 0, v59.Y)

	if v59.X < 450 then
		uDim2 = UDim2.new(0, v59.X - 24, 0, v59.Y)
	end

	local s3 = "rbxasset://textures/ui/TopBar/moreOn.png"

	if not p6.props.moreMenuOpen then
		s3 = "rbxasset://textures/ui/TopBar/moreOff.png"
	end

	local v62 = not TenFootInterface:IsEnabled() and (p6.props.topBarEnabled and (u54 and not VRService.VREnabled))

	local function v63(p8) -- line: 288
		-- upvalues: v62 (copy), FFlagTopBarSignalizeKeepOutAreas (copy), p6 (copy), Constants (copy)
		if v62 and p8 then
			if FFlagTopBarSignalizeKeepOutAreas then
				p6.keepOutAreasStore.setKeepOutArea(Constants.MoreMenuKeepOutAreaId, p8.AbsolutePosition, p8.AbsoluteSize)

				return
			end

			p6.props.setKeepOutArea(Constants.MoreMenuKeepOutAreaId, p8.AbsolutePosition, p8.AbsoluteSize)

			return
		end

		if FFlagTopBarSignalizeKeepOutAreas then
			p6.keepOutAreasStore.removeKeepOutArea(Constants.MoreMenuKeepOutAreaId)

			return
		end

		p6.props.removeKeepOutArea(Constants.MoreMenuKeepOutAreaId)
	end

	if p6.rootRef.current then
		v63(p6.rootRef.current)
	end

	return Roact.createElement("Frame", {
		Visible = v62,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 32, 1, 0),
		LayoutOrder = p6.props.layoutOrder,
		[Roact.Change.AbsoluteSize] = v63,
		[Roact.Change.AbsolutePosition] = v63,
		[Roact.Ref] = p6.rootRef
	}, {
		OpenButton = Roact.createElement(IconButton, {
			iconSize = 24,
			icon = s3,
			onActivated = p6.moreButtonActivated
		}),
		MoreMenuContainer = Roact.createElement("Frame", {
			ZIndex = 3,
			BackgroundTransparency = 1,
			Position = UDim2.new(1, 12, 0, 0),
			Size = uDim2,
			AnchorPoint = Vector2.new(1, 0)
		}, {
			ContextualMenu = Roact.createElement(ContextualMenu, {
				closeBackgroundVisible = false,
				buttonProps = t1,
				open = p6.props.moreMenuOpen,
				menuDirection = MenuDirection.Down,
				openPositionY = UDim.new(0, Constants.TopBarHeight * p6.state.UiScale + 12),
				background = p7.Theme.BackgroundUIContrast,
				screenSize = v59,
				onDismiss = function() -- line: 342
					-- upvalues: p6 (copy), PlayerListManager (copy)
					p6.props.setMoreMenuOpen(false)
					PlayerListManager:SetMinimized(false)
				end
			})
		}),
		ShowTopBarListener = Roact.createElement(ExternalEventConnection, {
			event = VRHub.ShowTopBarChanged.Event,
			callback = function() -- line: 350
				-- upvalues: p6 (copy), VRService (copy), VRHub (copy), u54 (ref)
				p6:setState({
					vrShowMenuIcon = VRService.VREnabled and (VRHub.ShowTopBar and u54)
				})
			end
		})
	})
end
function v45.render(p9) -- line: 359
	-- upvalues: withStyle (copy)
	return withStyle(function(p10) -- line: 360
		-- upvalues: p9 (copy)
		return p9:renderWithStyle(p10)
	end)
end
function v45.updateActionBound(p11) -- line: 365
	-- upvalues: ContextActionService (copy)
	if p11.props.moreMenuOpen then
		ContextActionService:BindCoreAction("CloseMoreMenuAction", function(_, p13, _) -- line: 367
			-- upvalues: p11 (copy)
			if p13 == Enum.UserInputState.Begin then
				p11.props.setMoreMenuOpen(false)

				return Enum.ContextActionResult.Sink
			end

			return Enum.ContextActionResult.Pass
		end, false, Enum.KeyCode.Escape)
		p11.boundAction = true

		return
	end

	if p11.boundAction then
		ContextActionService:UnbindCoreAction("CloseMoreMenuAction")
		p11.boundAction = false
	end
end
function v45.didUpdate(p15, p16, _) -- line: 383
	-- upvalues: PlayerListManager (copy), FFlagTopBarSignalizeScreenSize (copy), ChatSelector (copy)
	if p15.props.moreMenuOpen ~= p16.moreMenuOpen then
		PlayerListManager:SetMinimized(p15.props.moreMenuOpen)
		p15:updateActionBound()

		if ((if not FFlagTopBarSignalizeScreenSize then p15.props.screenSize else p15.state.screenSize)).X < 600 then
			if p15.props.moreMenuOpen and ChatSelector:GetVisibility() then
				p15.chatWasHidden = true
				ChatSelector:SetVisible(false)

				return
			end

			if not p15.props.moreMenuOpen and p15.chatWasHidden then
				ChatSelector:SetVisible(true)
				p15.chatWasHidden = false
			end
		end
	end
end

local function mapStateToProps(p18) -- line: 404
	-- upvalues: FFlagTopBarSignalizeScreenSize (copy), FFlagMountCoreGuiBackpack (copy)
	return {
		screenSize = if not FFlagTopBarSignalizeScreenSize then p18.displayOptions.screenSize else nil,
		moreMenuOpen = p18.moreMenu.open,
		isSmallTouchDevice = p18.displayOptions.isSmallTouchDevice,
		topBarEnabled = p18.displayOptions.topbarEnabled,
		leaderboardEnabled = p18.coreGuiEnabled[Enum.CoreGuiType.PlayerList],
		emotesEnabled = p18.moreMenu.emotesEnabled and p18.coreGuiEnabled[Enum.CoreGuiType.EmotesMenu],
		backpackEnabled = if not FFlagMountCoreGuiBackpack then p18.coreGuiEnabled[Enum.CoreGuiType.Backpack] else nil,
		leaderboardOpen = p18.moreMenu.leaderboardOpen,
		backpackOpen = p18.moreMenu.backpackOpen,
		emotesOpen = p18.moreMenu.emotesOpen
	}
end
local function mapDispatchToProps(p19) -- line: 422
	-- upvalues: SetMoreMenuOpen (copy), FFlagTopBarSignalizeKeepOutAreas (copy), SetKeepOutArea (copy), RemoveKeepOutArea (copy)
	return {
		setMoreMenuOpen = function(p20) -- line: 424
			-- upvalues: p19 (copy), SetMoreMenuOpen (copy)
			return p19(SetMoreMenuOpen(p20))
		end,
		setKeepOutArea = not FFlagTopBarSignalizeKeepOutAreas and function(p21, p22, p23) -- line: 429
			-- upvalues: p19 (copy), SetKeepOutArea (copy)
			return p19(SetKeepOutArea(p21, p22, p23))
		end or nil,
		removeKeepOutArea = not FFlagTopBarSignalizeKeepOutAreas and function(p24) -- line: 434
			-- upvalues: p19 (copy), RemoveKeepOutArea (copy)
			return p19(RemoveKeepOutArea(p24))
		end or nil
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(v45)
