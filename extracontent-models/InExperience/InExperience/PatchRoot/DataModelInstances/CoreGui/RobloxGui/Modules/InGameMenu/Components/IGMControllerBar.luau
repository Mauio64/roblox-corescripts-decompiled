local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local t = InGameMenuDependencies.t
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local ControllerBar = require(CorePackages.Packages.UIBlox).App.Bar.ControllerBar
local SetControllerBarHeight = require(script.Parent.Parent.Actions.SetControllerBarHeight)
local ParentParent = script.Parent.Parent
local withLocalization = require(ParentParent.Localization.withLocalization)
local Constants = require(script.Parent.Parent.Resources.Constants)
local v11 = Roact.PureComponent:extend("IGMControllerBar")
local t1 = {
	cancel = "CoreScripts.InGameMenu.ControllerBar.Cancel",
	respawn = "CoreScripts.InGameMenu.ControllerBar.Respawn",
	openMoreMenu = "CoreScripts.InGameMenu.ControllerBar.OpenMoreMenu",
	closeMoreMenu = "CoreScripts.InGameMenu.ControllerBar.CloseMoreMenu",
	back = "CoreScripts.InGameMenu.ControllerBar.Back",
	respawnCharacter = "CoreScripts.InGameMenu.ControllerBar.RespawnCharacter",
	leave = "CoreScripts.InGameMenu.ControllerBar.Leave"
}

v11.validateProps = t.strictInterface({
	isMenuOpen = t.boolean,
	isMainPageMoreMenuOpen = t.boolean,
	currentPage = t.string,
	respawnDialogOpen = t.boolean,
	inputType = t.string,
	screenSize = t.Vector2,
	setControllerBarHeight = t.callback
})

function v11.didMount(p1) -- line: 39
	-- upvalues: t1 (copy), Constants (copy)
	if p1:getHints(t1) then
		p1.props.setControllerBarHeight(Constants.ControllerBarHeight)

		return
	end

	p1.props.setControllerBarHeight(0)
end
function v11.didUpdate(p2) -- line: 48
	-- upvalues: t1 (copy), Constants (copy)
	if p2:getHints(t1) then
		p2.props.setControllerBarHeight(Constants.ControllerBarHeight)

		return
	end

	p2.props.setControllerBarHeight(0)
end
function v11.willUnmount(p3) -- line: 57
	p3.props.setControllerBarHeight(0)
end
function v11.getHints(p4, p5) -- line: 61
	-- upvalues: Constants (copy)
	if p4.props.inputType == Constants.InputType.Gamepad then
		if p4.props.respawnDialogOpen then
			return {
				leftHint = {
					text = p5.cancel,
					keyCode = Enum.KeyCode.ButtonB
				},
				rightHints = {{
					text = p5.respawn,
					keyCode = Enum.KeyCode.ButtonA
				}}
			}
		end

		if p4.props.isMenuOpen and p4.props.currentPage == "MainPage" then
			local v19 = if p4.props.isMainPageMoreMenuOpen then p5.closeMoreMenu else p5.openMoreMenu

			return {
				leftHint = {
					text = p5.back,
					keyCode = Enum.KeyCode.ButtonB
				},
				rightHints = {
					{
						text = v19,
						keyCode = Enum.KeyCode.ButtonL3
					},
					{
						text = p5.respawnCharacter,
						keyCode = Enum.KeyCode.ButtonY
					},
					{
						text = p5.leave,
						keyCode = Enum.KeyCode.ButtonX
					}
				}
			}
		end
	end

	return nil
end
function v11.render(p6) -- line: 111
	-- upvalues: withLocalization (copy), t1 (copy), Roact (copy), ControllerBar (copy)
	return withLocalization(t1)(function(p7) -- line: 112
		-- upvalues: p6 (copy), Roact (copy), ControllerBar (copy)
		local v25 = p6:getHints(p7)

		if v25 then
			return Roact.createElement(ControllerBar, v25)
		end

		return nil
	end)
end

local function mapStateToProps(p8, _) -- line: 122
	return {
		isMenuOpen = p8.isMenuOpen,
		isMainPageMoreMenuOpen = p8.isMainPageMoreMenuOpen,
		currentPage = p8.menuPage,
		respawnDialogOpen = p8.respawn.dialogOpen,
		inputType = p8.displayOptions.inputType,
		screenSize = p8.screenSize
	}
end

return RoactRodux.connect(mapStateToProps, function(p10) -- line: 133
	-- upvalues: SetControllerBarHeight (copy)
	return {
		setControllerBarHeight = function(p11) -- line: 135
			-- upvalues: p10 (copy), SetControllerBarHeight (copy)
			p10(SetControllerBarHeight(p11))
		end
	}
end)(v11)
