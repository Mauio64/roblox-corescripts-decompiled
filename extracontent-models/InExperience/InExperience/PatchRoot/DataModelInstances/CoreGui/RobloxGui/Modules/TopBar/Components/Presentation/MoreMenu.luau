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

local parent = script.Parent.Parent.Parent

local actions = parent.Actions
local SetKeepOutArea = require(actions.SetKeepOutArea)
local RemoveKeepOutArea = require(actions.RemoveKeepOutArea)
local SetMoreMenuOpen = require(actions.SetMoreMenuOpen)

local Analytics = require(parent.Analytics)

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagTopBarSignalizeKeepOutAreas = CoreGuiCommon.Flags.FFlagTopBarSignalizeKeepOutAreas
local FFlagTopBarSignalizeScreenSize = CoreGuiCommon.Flags.FFlagTopBarSignalizeScreenSize

local GetFFlagEnableTopBarAnalytics = require(parent.Flags.GetFFlagEnableTopBarAnalytics)
local fFlagEnableTopBarAnalytics = GetFFlagEnableTopBarAnalytics()

local Constants = require(parent.Constants)
local InputType = Constants.InputType

local IconButton = require(script.Parent.IconButton)

local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Modules = RobloxGui.Modules
local TenFootInterface = require(Modules.TenFootInterface)
local VrCommon = require(CorePackages.Workspace.Packages.VrCommon)
local VRHub = VrCommon.VRHub

local EmotesMenuMaster = require(Modules.EmotesMenu.EmotesMenuMaster)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableNewBackpack = SharedFlags.FFlagEnableNewBackpack
local features

if FFlagEnableNewBackpack then
	local System = require(CorePackages.Workspace.Packages.System)
	features = System.Features
else
	features = nil
end

local BackpackScript

if FFlagEnableNewBackpack then
	BackpackScript = nil
else
	BackpackScript = require(Modules.BackpackScript)
end

local ChatSelector = require(Modules.ChatSelector)
local PlayerListManager = require(Modules.PlayerList.PlayerListManager)

local Constants2 = require(Modules.EmotesMenu.Constants)

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local ExternalEventConnection = RoactUtils.ExternalEventConnection

local FFlagMountCoreGuiBackpack = require(Modules.Flags.FFlagMountCoreGuiBackpack)

local iconscontrolsemoteOn = Images["icons/controls/emoteOn"]
local iconscontrolsemoteOff = Images["icons/controls/emoteOff"]

local extended = Roact.PureComponent:extend("MoreMenu")

local strictInterface = t.strictInterface
local v = {
	layoutOrder = t.integer,
	moreMenuOpen = t.boolean,
	setMoreMenuOpen = t.callback,
	screenSize = 0,
	isSmallTouchDevice = 0,
	topBarEnabled = 0,
	leaderboardEnabled = 0,
	emotesEnabled = 0,
	backpackEnabled = 0,
	leaderboardOpen = 0,
	backpackOpen = 0,
	emotesOpen = 0,
	setKeepOutArea = 0,
	removeKeepOutArea = 0
}
local screenSize2

if not FFlagTopBarSignalizeScreenSize then
	screenSize2 = t.Vector2
end

v.screenSize = screenSize2
v.isSmallTouchDevice = t.boolean

v.topBarEnabled = t.boolean
v.leaderboardEnabled = t.boolean
v.emotesEnabled = t.boolean
local backpackEnabled

if not FFlagMountCoreGuiBackpack then
	backpackEnabled = t.boolean
end

v.backpackEnabled = backpackEnabled

v.leaderboardOpen = t.boolean
v.backpackOpen = t.boolean
v.emotesOpen = t.boolean
local setKeepOutArea

if not FFlagTopBarSignalizeKeepOutAreas then
	setKeepOutArea = t.callback
end

v.setKeepOutArea = setKeepOutArea
local removeKeepOutArea

if not FFlagTopBarSignalizeKeepOutAreas then
	removeKeepOutArea = t.callback
end

v.removeKeepOutArea = removeKeepOutArea
extended.validateProps = strictInterface(v)

function extended:init()
	self.rootRef = Roact.createRef()

	if fFlagEnableTopBarAnalytics then
		self.analytics = Analytics.default
	end

	self.disposeUiScaleEffect = Signals.createEffect(function(p)
		self:setState({
			UiScale = Display.GetDisplayStore(p).getUIScale(p)
		})
	end)

	if FFlagMountCoreGuiBackpack then
		self:setState({
			mountBackpack = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack),
			vrShowMenuIcon = false
		})

		StarterGui.CoreGuiChangedSignal:Connect(function(p, mountBackpack: boolean)
			if p == Enum.CoreGuiType.Backpack or p == Enum.CoreGuiType.All then
				self:setState({ mountBackpack = mountBackpack })
			end
		end)
	else
		self:setState({ vrShowMenuIcon = false })
	end

	self.chatWasHidden = false

	self.boundAction = false

	function self.moreButtonActivated()
		self.props.setMoreMenuOpen(not self.props.moreMenuOpen)

		if self.analytics then
			self.analytics:onMoreMenuActivated()
		end
	end

	if FFlagTopBarSignalizeKeepOutAreas then
		self.keepOutAreasStore = CoreGuiCommon.Stores.GetKeepOutAreasStore(false)
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

	if p.disposeUiScaleEffect then
		p.disposeUiScaleEffect()
	end
end

function extended:renderWithStyle(p)
	local buttonProps = {}
	local v2

	if self.props.leaderboardEnabled then
		table.insert(buttonProps, {
			icon = self.props.leaderboardOpen and "rbxasset://textures/ui/TopBar/leaderboardOn.png" or "rbxasset://textures/ui/TopBar/leaderboardOff.png",
			text = RobloxTranslator:FormatByKey("CoreScripts.TopBar.Leaderboard"),
			onActivated = function()
				local leaderboardOpen = self.props.leaderboardOpen

				if VRService.VREnabled then
					local InGameMenu = require(RobloxGui.Modules.InGameMenu)
					InGameMenu.openPlayersPage()
				else
					PlayerListManager:SetVisibility(not PlayerListManager:GetSetVisible())
					self.props.setMoreMenuOpen(false)
				end

				if self.analytics then
					self.analytics:onLeaderboardActivated(not leaderboardOpen)
				end
			end
		})
		v2 = true
	else
		v2 = false
	end

	if self.props.emotesEnabled then
		local icon = iconscontrolsemoteOn

		if not self.props.emotesOpen then
			icon = iconscontrolsemoteOff
		end

		local _emoteMenuOpenKey = Constants2.EmoteMenuOpenKey

		table.insert(buttonProps, {
			icon = icon,
			text = RobloxTranslator:FormatByKey("CoreScripts.TopBar.Emotes"),
			onActivated = function()
				if EmotesMenuMaster:isOpen() then
					EmotesMenuMaster:close()
				else
					if self.chatWasHidden then
						ChatSelector:SetVisible(true)
						self.chatWasHidden = false
					end

					EmotesMenuMaster:open()
				end

				self.props.setMoreMenuOpen(false)

				if self.analytics then
					self.analytics:onEmotesActivated(EmotesMenuMaster:isOpen())
				end
			end
		})
		v2 = true
	end

	local v3

	if FFlagMountCoreGuiBackpack then
		v3 = self.state.mountBackpack
	else
		v3 = self.props.backpackEnabled
	end

	if v3 then
		table.insert(buttonProps, {
			icon = self.props.backpackOpen and "rbxasset://textures/ui/TopBar/inventoryOn.png" or "rbxasset://textures/ui/TopBar/inventoryOff.png",
			text = RobloxTranslator:FormatByKey("CoreScripts.TopBar.Inventory"),
			onActivated = function()
				if FFlagEnableNewBackpack then
					features.toggleVisibility(features.FeatureName.Backpack)
					self.props.setMoreMenuOpen(false)

					if self.analytics then
						self.analytics:onInventoryActivated(features.getVisibility(features.FeatureName.Backpack))
					end
				else
					BackpackScript:OpenClose()
					self.props.setMoreMenuOpen(false)

					if self.analytics then
						self.analytics:onInventoryActivated(BackpackScript.IsOpen)
					end
				end
			end
		})
		v2 = true
	end

	local screenSize

	if FFlagTopBarSignalizeScreenSize then
		screenSize = self.state.screenSize
	else
		screenSize = self.props.screenSize
	end

	local udim = UDim2.new(0, 324, 0, screenSize.Y)

	if screenSize.X < 450 then
		udim = UDim2.new(0, screenSize.X - 24, 0, screenSize.Y)
	end

	local icon = self.props.moreMenuOpen and "rbxasset://textures/ui/TopBar/moreOn.png"
		or "rbxasset://textures/ui/TopBar/moreOff.png"

	local visible = not TenFootInterface:IsEnabled() and self.props.topBarEnabled and v2 and not VRService.VREnabled

	local function fn(current)
		if visible and current then
			if FFlagTopBarSignalizeKeepOutAreas then
				self.keepOutAreasStore.setKeepOutArea(
					Constants.MoreMenuKeepOutAreaId,
					current.AbsolutePosition,
					current.AbsoluteSize
				)
			else
				self.props.setKeepOutArea(
					Constants.MoreMenuKeepOutAreaId,
					current.AbsolutePosition,
					current.AbsoluteSize
				)
			end
		elseif FFlagTopBarSignalizeKeepOutAreas then
			self.keepOutAreasStore.removeKeepOutArea(Constants.MoreMenuKeepOutAreaId)
		else
			self.props.removeKeepOutArea(Constants.MoreMenuKeepOutAreaId)
		end
	end

	if self.rootRef.current then
		fn(self.rootRef.current)
	end

	return Roact.createElement("Frame", {
		Visible = visible,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 32, 1, 0),
		LayoutOrder = self.props.layoutOrder,
		[Roact.Change.AbsoluteSize] = fn,
		[Roact.Change.AbsolutePosition] = fn,
		[Roact.Ref] = self.rootRef
	}, {
		OpenButton = Roact.createElement(IconButton, {
			icon = icon,
			iconSize = 24,
			onActivated = self.moreButtonActivated
		}),
		MoreMenuContainer = Roact.createElement("Frame", {
			ZIndex = 3,
			BackgroundTransparency = 1,
			Position = UDim2.new(1, 12, 0, 0),
			Size = udim,
			AnchorPoint = Vector2.new(1, 0)
		}, {
			ContextualMenu = Roact.createElement(ContextualMenu, {
				buttonProps = buttonProps,
				open = self.props.moreMenuOpen,
				menuDirection = MenuDirection.Down,
				openPositionY = UDim.new(0, Constants.TopBarHeight * self.state.UiScale + 12),
				background = p.Theme.BackgroundUIContrast,
				closeBackgroundVisible = false,
				screenSize = screenSize,
				onDismiss = function()
					self.props.setMoreMenuOpen(false)
					PlayerListManager:SetMinimized(false)
				end
			})
		}),
		ShowTopBarListener = Roact.createElement(ExternalEventConnection, {
			event = VRHub.ShowTopBarChanged.Event,
			callback = function()
				self:setState({
					vrShowMenuIcon = VRService.VREnabled and VRHub.ShowTopBar and v2
				})
			end
		})
	})
end

function extended:render()
	return withStyle(function(p)
		return self:renderWithStyle(p)
	end)
end

function extended:updateActionBound()
	if self.props.moreMenuOpen then
		ContextActionService:BindCoreAction("CloseMoreMenuAction", function(_, p, _)
			if p ~= Enum.UserInputState.Begin then
				return Enum.ContextActionResult.Pass
			end

			self.props.setMoreMenuOpen(false)
			return Enum.ContextActionResult.Sink
		end, false, Enum.KeyCode.Escape)

		self.boundAction = true
	elseif self.boundAction then
		ContextActionService:UnbindCoreAction("CloseMoreMenuAction")

		self.boundAction = false
	end
end

function extended:didUpdate(p, _)
	if self.props.moreMenuOpen ~= p.moreMenuOpen then
		PlayerListManager:SetMinimized(self.props.moreMenuOpen)

		self:updateActionBound()
		local v2

		if FFlagTopBarSignalizeScreenSize then
			v2 = self.state.screenSize
		else
			v2 = self.props.screenSize
		end

		if v2.X < 600 then
			if self.props.moreMenuOpen and ChatSelector:GetVisibility() then
				self.chatWasHidden = true
				ChatSelector:SetVisible(false)
			elseif not self.props.moreMenuOpen and self.chatWasHidden then
				ChatSelector:SetVisible(true)
				self.chatWasHidden = false
			end
		end
	end
end

local function mapStateToProps(data)
	local screenSize

	if not FFlagTopBarSignalizeScreenSize then
		screenSize = data.displayOptions.screenSize
	end

	local v2 = {
		screenSize = screenSize,
		moreMenuOpen = data.moreMenu.open,
		isSmallTouchDevice = data.displayOptions.isSmallTouchDevice,
		topBarEnabled = data.displayOptions.topbarEnabled,
		leaderboardEnabled = data.coreGuiEnabled[Enum.CoreGuiType.PlayerList],
		emotesEnabled = data.moreMenu.emotesEnabled and data.coreGuiEnabled[Enum.CoreGuiType.EmotesMenu],
		backpackEnabled = 0,
		leaderboardOpen = 0,
		backpackOpen = 0,
		emotesOpen = 0
	}
	local backpackEnabled2

	if not FFlagMountCoreGuiBackpack then
		backpackEnabled2 = data.coreGuiEnabled[Enum.CoreGuiType.Backpack]
	end

	v2.backpackEnabled = backpackEnabled2

	v2.leaderboardOpen = data.moreMenu.leaderboardOpen
	v2.backpackOpen = data.moreMenu.backpackOpen
	v2.emotesOpen = data.moreMenu.emotesOpen
	return v2
end

local function mapDispatchToProps(callback)
	return {
		setMoreMenuOpen = function(p)
			return callback(SetMoreMenuOpen(p))
		end,
		setKeepOutArea = not FFlagTopBarSignalizeKeepOutAreas and function(p, p2, p3)
			return callback(SetKeepOutArea(p, p2, p3))
		end or nil,
		removeKeepOutArea = not FFlagTopBarSignalizeKeepOutAreas and function(p)
			return callback(RemoveKeepOutArea(p))
		end or nil
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(extended)
