local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local t = InGameMenuDependencies.t
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local UIBlox = require(CorePackages.Packages.UIBlox)
local ControllerBar = UIBlox.App.Bar.ControllerBar

local SetControllerBarHeight = require(script.Parent.Parent.Actions.SetControllerBarHeight)
local parent = script.Parent.Parent
local withLocalization = require(parent.Localization.withLocalization)

local Constants = require(script.Parent.Parent.Resources.Constants)

local extended = Roact.PureComponent:extend("IGMControllerBar")

local v = {
	cancel = "CoreScripts.InGameMenu.ControllerBar.Cancel",
	respawn = "CoreScripts.InGameMenu.ControllerBar.Respawn",
	openMoreMenu = "CoreScripts.InGameMenu.ControllerBar.OpenMoreMenu",
	closeMoreMenu = "CoreScripts.InGameMenu.ControllerBar.CloseMoreMenu",
	back = "CoreScripts.InGameMenu.ControllerBar.Back",
	respawnCharacter = "CoreScripts.InGameMenu.ControllerBar.RespawnCharacter",
	leave = "CoreScripts.InGameMenu.ControllerBar.Leave"
}

extended.validateProps = t.strictInterface({
	isMenuOpen = t.boolean,
	isMainPageMoreMenuOpen = t.boolean,
	currentPage = t.string,
	respawnDialogOpen = t.boolean,
	inputType = t.string,
	screenSize = t.Vector2,
	setControllerBarHeight = t.callback
})

function extended:didMount()
	if self:getHints(v) then
		self.props.setControllerBarHeight(Constants.ControllerBarHeight)
	else
		self.props.setControllerBarHeight(0)
	end
end

function extended:didUpdate()
	if self:getHints(v) then
		self.props.setControllerBarHeight(Constants.ControllerBarHeight)
	else
		self.props.setControllerBarHeight(0)
	end
end

function extended.willUnmount(p)
	p.props.setControllerBarHeight(0)
end

function extended:getHints(data)
	if self.props.inputType ~= Constants.InputType.Gamepad then
		return nil
	end

	if self.props.respawnDialogOpen then
		return {
			leftHint = { text = data.cancel, keyCode = Enum.KeyCode.ButtonB },
			rightHints = {
				{ text = data.respawn, keyCode = Enum.KeyCode.ButtonA }
			}
		}
	end

	if not (self.props.isMenuOpen and self.props.currentPage == "MainPage") then
		return nil
	end

	local text

	if self.props.isMainPageMoreMenuOpen then
		text = data.closeMoreMenu
	else
		text = data.openMoreMenu
	end

	return {
		leftHint = { text = data.back, keyCode = Enum.KeyCode.ButtonB },
		rightHints = {
			{ text = text, keyCode = Enum.KeyCode.ButtonL3 },
			{ text = data.respawnCharacter, keyCode = Enum.KeyCode.ButtonY },
			{ text = data.leave, keyCode = Enum.KeyCode.ButtonX }
		}
	}
end

function extended:render()
	return withLocalization(v)(function(p)
		local hints = self:getHints(p)

		if hints then
			return Roact.createElement(ControllerBar, hints)
		end

		return nil
	end)
end

local function mapStateToProps(data, _)
	return {
		isMenuOpen = data.isMenuOpen,
		isMainPageMoreMenuOpen = data.isMainPageMoreMenuOpen,
		currentPage = data.menuPage,
		respawnDialogOpen = data.respawn.dialogOpen,
		inputType = data.displayOptions.inputType,
		screenSize = data.screenSize
	}
end

return RoactRodux.connect(mapStateToProps, function(callback)
	return {
		setControllerBarHeight = function(p)
			callback(SetControllerBarHeight(p))
		end
	}
end)(extended)
