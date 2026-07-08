local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local ParentParent = script.Parent.Parent.Parent
local SetPlayerListVisibility = require(ParentParent.Actions.SetPlayerListVisibility)
local ClosePlayerDropDown = require(ParentParent.Actions.ClosePlayerDropDown)
local FFlagPlayerListReduceRerenders = require(ParentParent.Flags.FFlagPlayerListReduceRerenders)
local FFlagAddNewPlayerListMobileFocusNav = PlayerList.Flags.FFlagAddNewPlayerListMobileFocusNav
local FFlagPlayerListUseMobileOnSmallDisplay = PlayerList.Flags.FFlagPlayerListUseMobileOnSmallDisplay
local v14 = Roact.PureComponent:extend("ContextActionsBinder")
local t1 = {
	Enum.UserInputType.Gamepad1,
	Enum.UserInputType.Gamepad2,
	Enum.UserInputType.Gamepad3,
	Enum.UserInputType.Gamepad4,
	Enum.UserInputType.Gamepad5,
	Enum.UserInputType.Gamepad6,
	Enum.UserInputType.Gamepad7,
	Enum.UserInputType.Gamepad8
}

function v14.init(p1) -- line: 37
	p1.boundPlayerListActions = false
end
function v14.bindActions(p2) -- line: 41
	-- upvalues: ContextActionService (copy), FFlagPlayerListUseMobileOnSmallDisplay (copy), GuiService (copy), t1 (copy), FFlagAddNewPlayerListMobileFocusNav (copy)
	ContextActionService:BindCoreAction("RbxPlayerListToggle", function(_, p4, _) -- line: 42
		-- upvalues: FFlagPlayerListUseMobileOnSmallDisplay (copy), p2 (copy), GuiService (copy)
		if FFlagPlayerListUseMobileOnSmallDisplay and p2.props.displayOptions.isSmallTouchDevice then
			return Enum.ContextActionResult.Pass
		end

		if GuiService.MenuIsOpen then
			return Enum.ContextActionResult.Pass
		end

		if p4 ~= Enum.UserInputState.Begin then
			return Enum.ContextActionResult.Pass
		end

		p2.props.setVisibility(not p2.props.displayOptions.isVisible)

		return Enum.ContextActionResult.Sink
	end, false, Enum.KeyCode.Tab)
	ContextActionService:BindCoreAction("RbxPlayerListStopMovement", function(_, _, _) -- line: 59
		-- upvalues: p2 (copy)
		if p2.props.displayOptions.isVisible and p2.props.displayOptions.isTenFootInterface then
			return Enum.ContextActionResult.Sink
		end

		return Enum.ContextActionResult.Pass
	end, false, unpack(t1))
	ContextActionService:BindCoreAction("RbxPlayerListGamepadClose", function(_, p10, _) -- line: 66
		-- upvalues: p2 (copy), FFlagAddNewPlayerListMobileFocusNav (copy)
		if p10 ~= Enum.UserInputState.Begin then
			return Enum.ContextActionResult.Pass
		end

		if not p2.props.displayOptions.isTenFootInterface and (not FFlagAddNewPlayerListMobileFocusNav or not p2.props.displayOptions.isSmallTouchDevice) then
			return Enum.ContextActionResult.Pass
		end

		if FFlagAddNewPlayerListMobileFocusNav and p2.props.playerDropDown.isVisible then
			p2.props.closePlayerDropDown()

			return Enum.ContextActionResult.Sink
		end

		if FFlagAddNewPlayerListMobileFocusNav then
			if p2.props.displayOptions.isVisible then
				p2.props.setVisibility(false)

				return Enum.ContextActionResult.Sink
			end
		elseif p2.props.displayOptions.isVisible and p2.props.displayOptions.isTenFootInterface then
			p2.props.setVisibility(false)

			return Enum.ContextActionResult.Sink
		end

		return Enum.ContextActionResult.Pass
	end, false, Enum.KeyCode.ButtonB, if not FFlagAddNewPlayerListMobileFocusNav then Enum.KeyCode.ButtonStart else Enum.KeyCode.ButtonB)
	p2.boundPlayerListActions = true
end
function v14.unbindActions(p12) -- line: 101
	-- upvalues: ContextActionService (copy)
	ContextActionService:UnbindCoreAction("RbxPlayerListToggle")
	ContextActionService:UnbindCoreAction("RbxPlayerListStopMovement")
	ContextActionService:UnbindCoreAction("RbxPlayerListGamepadClose")
	p12.boundPlayerListActions = false
end
function v14.didMount(p13) -- line: 108
	p13:bindActions()
end
function v14.render(_) -- line: 112
	return nil
end
function v14.willUnmount(p15) -- line: 116
	if p15.boundPlayerListActions then
		p15:unbindActions()
	end
end

local function mapStateToProps(p16) -- line: 122
	-- upvalues: FFlagAddNewPlayerListMobileFocusNav (copy)
	return {
		displayOptions = p16.displayOptions,
		playerDropDown = if not FFlagAddNewPlayerListMobileFocusNav then nil else p16.playerDropDown
	}
end
local function mapDispatchToProps(p17) -- line: 129
	-- upvalues: SetPlayerListVisibility (copy), FFlagAddNewPlayerListMobileFocusNav (copy), ClosePlayerDropDown (copy)
	return {
		setVisibility = function(p18) -- line: 131
			-- upvalues: p17 (copy), SetPlayerListVisibility (copy)
			return p17(SetPlayerListVisibility(p18))
		end,
		closePlayerDropDown = if not FFlagAddNewPlayerListMobileFocusNav then nil else function() -- line: 135
			-- upvalues: p17 (copy), ClosePlayerDropDown (copy)
			return p17(ClosePlayerDropDown())
		end
	}
end

if FFlagPlayerListReduceRerenders then
	return React.memo(RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v14))
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v14)
