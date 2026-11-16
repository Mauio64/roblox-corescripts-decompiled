local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)

local parent = script.Parent.Parent.Parent

local SetPlayerListVisibility = require(parent.Actions.SetPlayerListVisibility)
local ClosePlayerDropDown = require(parent.Actions.ClosePlayerDropDown)

local FFlagPlayerListReduceRerenders = require(parent.Flags.FFlagPlayerListReduceRerenders)
local FFlagAddNewPlayerListMobileFocusNav = PlayerList.Flags.FFlagAddNewPlayerListMobileFocusNav
local FFlagPlayerListUseMobileOnSmallDisplay = PlayerList.Flags.FFlagPlayerListUseMobileOnSmallDisplay

local extended = Roact.PureComponent:extend("ContextActionsBinder")

local v = {
	Enum.UserInputType.Gamepad1,
	Enum.UserInputType.Gamepad2,
	Enum.UserInputType.Gamepad3,
	Enum.UserInputType.Gamepad4,
	Enum.UserInputType.Gamepad5,
	Enum.UserInputType.Gamepad6,
	Enum.UserInputType.Gamepad7,
	Enum.UserInputType.Gamepad8
}

function extended:init()
	self.boundPlayerListActions = false
end

function extended:bindActions()
	ContextActionService:BindCoreAction("RbxPlayerListToggle", function(_, p, _)
		if
			FFlagPlayerListUseMobileOnSmallDisplay and self.props.displayOptions.isSmallTouchDevice
			or GuiService.MenuIsOpen
			or p ~= Enum.UserInputState.Begin
		then
			return Enum.ContextActionResult.Pass
		end

		self.props.setVisibility(not self.props.displayOptions.isVisible)
		return Enum.ContextActionResult.Sink
	end, false, Enum.KeyCode.Tab)
	ContextActionService:BindCoreAction("RbxPlayerListStopMovement", function(_, _, _)
		if self.props.displayOptions.isVisible and self.props.displayOptions.isTenFootInterface then
			return Enum.ContextActionResult.Sink
		end

		return Enum.ContextActionResult.Pass
	end, false, unpack(v))
	local function fn(_, p, _)
		if not (p == Enum.UserInputState.Begin and (self.props.displayOptions.isTenFootInterface or FFlagAddNewPlayerListMobileFocusNav and self.props.displayOptions.isSmallTouchDevice)) then
			return Enum.ContextActionResult.Pass
		end

		if FFlagAddNewPlayerListMobileFocusNav and self.props.playerDropDown.isVisible then
			self.props.closePlayerDropDown()
			return Enum.ContextActionResult.Sink
		end

		if FFlagAddNewPlayerListMobileFocusNav then
			if self.props.displayOptions.isVisible then
				self.props.setVisibility(false)
				return Enum.ContextActionResult.Sink
			end
		elseif self.props.displayOptions.isVisible and self.props.displayOptions.isTenFootInterface then
			self.props.setVisibility(false)
			return Enum.ContextActionResult.Sink
		end

		return Enum.ContextActionResult.Pass
	end

	local buttonB = Enum.KeyCode.ButtonB
	local v2

	if FFlagAddNewPlayerListMobileFocusNav then
		v2 = Enum.KeyCode.ButtonB
	else
		v2 = Enum.KeyCode.ButtonStart
	end

	ContextActionService:BindCoreAction("RbxPlayerListGamepadClose", fn, false, buttonB, v2)

	self.boundPlayerListActions = true
end

function extended:unbindActions()
	ContextActionService:UnbindCoreAction("RbxPlayerListToggle")
	ContextActionService:UnbindCoreAction("RbxPlayerListStopMovement")
	ContextActionService:UnbindCoreAction("RbxPlayerListGamepadClose")
	self.boundPlayerListActions = false
end

function extended:didMount()
	self:bindActions()
end

function extended.render(_): nil
	return nil
end

function extended:willUnmount()
	if self.boundPlayerListActions then
		self:unbindActions()
	end
end

local function mapStateToProps(p)
	local v2 = { displayOptions = p.displayOptions, playerDropDown = 0 }
	local playerDropDown

	if FFlagAddNewPlayerListMobileFocusNav then
		playerDropDown = p.playerDropDown
	end

	v2.playerDropDown = playerDropDown
	return v2
end

local function mapDispatchToProps(callback)
	return {
		setVisibility = function(p)
			return callback(SetPlayerListVisibility(p))
		end,
		closePlayerDropDown = FFlagAddNewPlayerListMobileFocusNav and function()
			return callback(ClosePlayerDropDown())
		end or nil
	}
end

if FFlagPlayerListReduceRerenders then
	return React.memo(RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended))
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)
