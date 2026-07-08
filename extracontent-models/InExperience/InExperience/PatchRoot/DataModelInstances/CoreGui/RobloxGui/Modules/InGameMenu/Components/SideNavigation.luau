local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t
local withStyle = UIBlox.Core.Style.withStyle
local Interactable = UIBlox.Core.Control.Interactable
local ControlState = UIBlox.Core.Control.Enum.ControlState
local ParentParent = script.Parent.Parent
local FocusHandler = require(ParentParent.Components.Connection.FocusHandler)
local ZonePortal = require(ParentParent.Components.ZonePortal)
local CloseMenu = require(ParentParent.Thunks.CloseMenu)
local SetCurrentPage = require(ParentParent.Actions.SetCurrentPage)
local Constants = require(ParentParent.Resources.Constants)
local Direction = require(ParentParent.Enums.Direction)
local CloseMenuButton = require(script.CloseMenuButton)
local HomeButton = require(script.HomeButton)
local SystemMenuButton = require(script.SystemMenuButton)
local InGameMenuPolicy = require(ParentParent.InGameMenuPolicy)
local GetFFlagIGMGamepadSelectionHistory = require(ParentParent.Flags.GetFFlagIGMGamepadSelectionHistory)
local v23 = Roact.PureComponent:extend("SideNavigation")

v23.validateProps = t.strictInterface({
	open = t.boolean,
	closeMenu = t.callback,
	goToHomePage = t.callback,
	goToSystemMenu = t.callback,
	currentPage = t.string,
	canCaptureFocus = t.optional(t.boolean),
	currentZone = GetFFlagIGMGamepadSelectionHistory() and t.optional(t.number) or nil,
	enableInGameHomeIcon = t.optional(t.boolean)
})

function v23.init(p1) -- line: 51
	-- upvalues: ControlState (copy), Constants (copy), Roact (copy), GuiService (copy)
	function p1.controlStateUpdated(p2, p3) -- line: 52
		-- upvalues: ControlState (copy), p1 (copy), Constants (copy)
		if p2 == ControlState.Hover and (p3 ~= ControlState.Hover and p1.props.currentPage == Constants.InitalPageKey) then
			p1.props.closeMenu()
		end
	end

	p1.firstItemRef = Roact.createRef()

	function p1.onContainerRendered(p4) -- line: 62
		-- upvalues: GuiService (copy)
		if p4 then
			GuiService:RemoveSelectionGroup("SideNavigation_IGMSelectionGroup")
			GuiService:AddSelectionParent("SideNavigation_IGMSelectionGroup", p4)
		end
	end
end
function v23.oldRender(p5) -- line: 71
	-- upvalues: GetFFlagIGMGamepadSelectionHistory (copy), withStyle (copy), Roact (copy), CloseMenuButton (copy), FocusHandler (copy), GuiService (copy), Constants (copy), ZonePortal (copy), Direction (copy)
	local u27 = nil

	if GetFFlagIGMGamepadSelectionHistory() then
		u27 = p5.props.currentZone ~= 0 or not p5.props.open
	end

	return withStyle(function(p6) -- line: 77
		-- upvalues: Roact (copy), p5 (copy), CloseMenuButton (copy), FocusHandler (copy), u27 (ref), GetFFlagIGMGamepadSelectionHistory (copy), GuiService (copy), Constants (copy), ZonePortal (copy), Direction (copy)
		return Roact.createElement("TextButton", {
			AutoButtonColor = false,
			Text = "",
			BackgroundColor3 = p6.Theme.BackgroundUIContrast.Color,
			BackgroundTransparency = p6.Theme.BackgroundUIContrast.Transparency,
			BorderSizePixel = 0,
			Size = UDim2.new(0, 64, 1, 0),
			Visible = p5.props.open,
			Selectable = false,
			[Roact.Ref] = p5.onContainerRendered
		}, {
			Padding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 1)
			}),
			CloseMenuButton = Roact.createElement(CloseMenuButton, {
				onActivated = p5.props.closeMenu,
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0, 4),
				[Roact.Ref] = p5.firstItemRef
			}),
			FocusHandler = Roact.createElement(FocusHandler, {
				isFocused = p5.props.canCaptureFocus,
				shouldForgetPreviousSelection = u27,
				didFocus = GetFFlagIGMGamepadSelectionHistory() and function(p7) -- line: 102
					-- upvalues: GuiService (copy), p5 (copy)
					GuiService.SelectedCoreObject = p7 or p5.firstItemRef:getValue()
				end or function() -- line: 104
					-- upvalues: GuiService (copy), p5 (copy)
					GuiService.SelectedCoreObject = p5.firstItemRef:getValue()
				end
			}),
			ZonePortal = p5.props.currentPage ~= Constants.InitalPageKey and Roact.createElement(ZonePortal, {
				targetZone = 1,
				direction = Direction.Right
			}) or nil
		})
	end)
end
function v23.newRender(p8) -- line: 116
	-- upvalues: Roact (copy), SystemMenuButton (copy), Constants (copy), HomeButton (copy), ZonePortal (copy), Direction (copy), withStyle (copy), Interactable (copy)
	local currentPage = p8.props.currentPage
	local t1 = {
		Padding = Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 4)
		}),
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 4)
		}),
		SystemMenuButton = Roact.createElement(SystemMenuButton, {
			layoutOrder = 1,
			on = currentPage == Constants.MainPagePageKey,
			onClose = p8.props.closeMenu,
			onActivated = p8.props.goToSystemMenu,
			anchorPoint = Vector2.new(0.5, 0),
			position = UDim2.new(0.5, 0, 0, 4),
			canCaptureFocus = p8.props.canCaptureFocus
		}),
		HomeButton = Roact.createElement(HomeButton, {
			layoutOrder = 2,
			on = currentPage == Constants.LeaveToAppPromptPageKey,
			onActivated = p8.props.goToHomePage,
			anchorPoint = Vector2.new(0.5, 0),
			position = UDim2.new(0.5, 0, 0, 8)
		})
	}
	local t2 = {
		Padding = Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 1)
		}),
		Content = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Selectable = false,
			Size = UDim2.fromScale(1, 1)
		}, t1),
		ZonePortal = p8.props.currentPage ~= Constants.InitalPageKey and Roact.createElement(ZonePortal, {
			targetZone = 1,
			direction = Direction.Right
		}) or nil
	}

	return withStyle(function(p9) -- line: 162
		-- upvalues: Roact (copy), Interactable (copy), p8 (copy), t2 (copy)
		return Roact.createElement(Interactable, {
			onStateChanged = p8.controlStateUpdated,
			AutoButtonColor = false,
			BackgroundColor3 = p9.Theme.BackgroundUIContrast.Color,
			BackgroundTransparency = p9.Theme.BackgroundUIContrast.Transparency,
			BorderSizePixel = 0,
			Size = UDim2.new(0, 64, 1, 0),
			Visible = p8.props.open,
			Selectable = false,
			[Roact.Ref] = p8.onContainerRendered
		}, t2)
	end)
end
function v23.render(p10) -- line: 178
	if p10.props.enableInGameHomeIcon then
		return p10:newRender()
	end

	return p10:oldRender()
end

local v24 = InGameMenuPolicy.connect(function(p11, _) -- line: 185
	return {
		enableInGameHomeIcon = p11.enableInGameHomeIcon()
	}
end)(v23)

return RoactRodux.UNSTABLE_connect2(function(p13, _) -- line: 191
	-- upvalues: Constants (copy), GetFFlagIGMGamepadSelectionHistory (copy)
	local v37 = p13.isMenuOpen and (not p13.respawn.dialogOpen and (p13.displayOptions.inputType == Constants.InputType.Gamepad and p13.currentZone == 0))
	local currentZone = nil

	if GetFFlagIGMGamepadSelectionHistory() then
		currentZone = p13.currentZone
	end

	return {
		canCaptureFocus = v37,
		currentPage = p13.menuPage,
		open = p13.isMenuOpen,
		currentZone = currentZone
	}
end, function(p15) -- line: 208
	-- upvalues: CloseMenu (copy), SetCurrentPage (copy), Constants (copy)
	return {
		closeMenu = function() -- line: 210
			-- upvalues: p15 (copy), CloseMenu (copy)
			p15(CloseMenu)
		end,
		goToSystemMenu = function() -- line: 213
			-- upvalues: p15 (copy), SetCurrentPage (copy), Constants (copy)
			p15(SetCurrentPage(Constants.MainPagePageKey))
		end,
		goToHomePage = function() -- line: 216
			-- upvalues: p15 (copy), SetCurrentPage (copy), Constants (copy)
			p15(SetCurrentPage(Constants.LeaveToAppPromptPageKey))
		end
	}
end)(v24)
