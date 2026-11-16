local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle
local Interactable = UIBlox.Core.Control.Interactable
local ControlState = UIBlox.Core.Control.Enum.ControlState

local parent = script.Parent.Parent

local FocusHandler = require(parent.Components.Connection.FocusHandler)
local ZonePortal = require(parent.Components.ZonePortal)

local CloseMenu = require(parent.Thunks.CloseMenu)
local SetCurrentPage = require(parent.Actions.SetCurrentPage)

local Constants = require(parent.Resources.Constants)
local Direction = require(parent.Enums.Direction)

local CloseMenuButton = require(script.CloseMenuButton)
local HomeButton = require(script.HomeButton)
local SystemMenuButton = require(script.SystemMenuButton)

local InGameMenuPolicy = require(parent.InGameMenuPolicy)

local GetFFlagIGMGamepadSelectionHistory = require(parent.Flags.GetFFlagIGMGamepadSelectionHistory)

local extended = Roact.PureComponent:extend("SideNavigation")

local strictInterface = t.strictInterface
local v = {
	open = t.boolean,
	closeMenu = t.callback,
	goToHomePage = t.callback,
	goToSystemMenu = t.callback,
	currentPage = t.string,
	canCaptureFocus = t.optional(t.boolean),
	currentZone = 0,
	enableInGameHomeIcon = 0
}
local currentZone

if GetFFlagIGMGamepadSelectionHistory() then
	currentZone = t.optional(t.number) or nil
end

v.currentZone = currentZone

v.enableInGameHomeIcon = t.optional(t.boolean)
extended.validateProps = strictInterface(v)

function extended:init()
	function self.controlStateUpdated(p, p2)
		if
			p == ControlState.Hover
			and p2 ~= ControlState.Hover
			and self.props.currentPage == Constants.InitalPageKey
		then
			self.props.closeMenu()
		end
	end

	self.firstItemRef = Roact.createRef()

	function self.onContainerRendered(p)
		if p then
			GuiService:RemoveSelectionGroup("SideNavigation_IGMSelectionGroup")
			GuiService:AddSelectionParent("SideNavigation_IGMSelectionGroup", p)
		end
	end
end

function extended:oldRender()
	local shouldForgetPreviousSelection

	if GetFFlagIGMGamepadSelectionHistory() then
		shouldForgetPreviousSelection = self.props.currentZone ~= 0 or not self.props.open
	else
		shouldForgetPreviousSelection = nil
	end

	return withFoundationOrUIBloxStyle(function(p)
		return {
			Theme = {
				BackgroundUIContrast = {
					Color = p.Color.OverMedia.OverMedia_0.Color3,
					Transparency = p.Color.OverMedia.OverMedia_0.Transparency
				}
			}
		}
	end, function(p)
		local createElement = Roact.createElement
		local onContainerRenderedsByRef = {
			AutoButtonColor = false,
			Text = "",
			BackgroundColor3 = p.Theme.BackgroundUIContrast.Color,
			BackgroundTransparency = p.Theme.BackgroundUIContrast.Transparency,
			BorderSizePixel = 0,
			Size = UDim2.new(0, 64, 1, 0),
			Visible = self.props.open,
			Selectable = false,
			[Roact.Ref] = self.onContainerRendered
		}
		local children = {
			Padding = Roact.createElement("UIPadding", { PaddingTop = UDim.new(0, 1) }),
			CloseMenuButton = Roact.createElement(CloseMenuButton, {
				onActivated = self.props.closeMenu,
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0, 4),
				[Roact.Ref] = self.firstItemRef
			}),
			FocusHandler = Roact.createElement(FocusHandler, {
				isFocused = self.props.canCaptureFocus,
				shouldForgetPreviousSelection = shouldForgetPreviousSelection,
				didFocus = GetFFlagIGMGamepadSelectionHistory() and function(p2)
					GuiService.SelectedCoreObject = p2 or self.firstItemRef:getValue()
				end or function()
					GuiService.SelectedCoreObject = self.firstItemRef:getValue()
				end
			}),
			ZonePortal = 0
		}
		local zonePortal

		if self.props.currentPage ~= Constants.InitalPageKey then
			zonePortal = Roact.createElement(ZonePortal, {
				targetZone = 1,
				direction = Direction.Right
			}) or nil
		end

		children.ZonePortal = zonePortal
		return createElement("TextButton", onContainerRenderedsByRef, children)
	end)
end

function extended:newRender()
	local currentPage = self.props.currentPage

	local v2 = {
		Padding = Roact.createElement("UIPadding", { PaddingTop = UDim.new(0, 4) }),
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 4)
		}),
		SystemMenuButton = Roact.createElement(SystemMenuButton, {
			on = currentPage == Constants.MainPagePageKey,
			onClose = self.props.closeMenu,
			onActivated = self.props.goToSystemMenu,
			layoutOrder = 1,
			anchorPoint = Vector2.new(0.5, 0),
			position = UDim2.new(0.5, 0, 0, 4),
			canCaptureFocus = self.props.canCaptureFocus
		}),
		HomeButton = Roact.createElement(HomeButton, {
			on = currentPage == Constants.LeaveToAppPromptPageKey,
			onActivated = self.props.goToHomePage,
			layoutOrder = 2,
			anchorPoint = Vector2.new(0.5, 0),
			position = UDim2.new(0.5, 0, 0, 8)
		})
	}

	local v3 = {
		Padding = Roact.createElement("UIPadding", { PaddingTop = UDim.new(0, 1) }),
		Content = Roact.createElement(
			"Frame",
			{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Selectable = false },
			v2
		),
		ZonePortal = 0
	}
	local zonePortal

	if self.props.currentPage ~= Constants.InitalPageKey then
		zonePortal = Roact.createElement(ZonePortal, { targetZone = 1, direction = Direction.Right }) or nil
	end

	v3.ZonePortal = zonePortal

	return withFoundationOrUIBloxStyle(function(p)
		return {
			Theme = {
				BackgroundUIContrast = {
					Color = p.Color.OverMedia.OverMedia_0.Color3,
					Transparency = p.Color.OverMedia.OverMedia_0.Transparency
				}
			}
		}
	end, function(p)
		return Roact.createElement(Interactable, {
			onStateChanged = self.controlStateUpdated,
			AutoButtonColor = false,
			BackgroundColor3 = p.Theme.BackgroundUIContrast.Color,
			BackgroundTransparency = p.Theme.BackgroundUIContrast.Transparency,
			BorderSizePixel = 0,
			Size = UDim2.new(0, 64, 1, 0),
			Visible = self.props.open,
			Selectable = false,
			[Roact.Ref] = self.onContainerRendered
		}, v3)
	end)
end

function extended:render()
	if self.props.enableInGameHomeIcon then
		return self:newRender()
	end

	return self:oldRender()
end

local v2 = InGameMenuPolicy.connect(function(p, _)
	return { enableInGameHomeIcon = p.enableInGameHomeIcon() }
end)(extended)

return RoactRodux.UNSTABLE_connect2(function(data, _)
	local canCaptureFocus = data.isMenuOpen and not data.respawn.dialogOpen

	if canCaptureFocus then
		if data.displayOptions.inputType == Constants.InputType.Gamepad then
			canCaptureFocus = data.currentZone == 0
		else
			canCaptureFocus = false
		end
	end

	local currentZone2

	if GetFFlagIGMGamepadSelectionHistory() then
		currentZone2 = data.currentZone
	end

	return {
		canCaptureFocus = canCaptureFocus,
		currentPage = data.menuPage,
		open = data.isMenuOpen,
		currentZone = currentZone2
	}
end, function(callback)
	return {
		closeMenu = function()
			callback(CloseMenu)
		end,
		goToSystemMenu = function()
			callback(SetCurrentPage(Constants.MainPagePageKey))
		end,
		goToHomePage = function()
			callback(SetCurrentPage(Constants.LeaveToAppPromptPageKey))
		end
	}
end)(v2)
