local CorePackages = game:GetService("CorePackages")
local VRService = game:GetService("VRService")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t

local parent = script.Parent.Parent
local IGMControllerBar2 = require(script.Parent.IGMControllerBar2)
local withLocalization = require(parent.Localization.withLocalization)

local extended = Roact.PureComponent:extend("IGMMainPageControllerBar")

extended.validateProps = t.strictInterface({
	canCaptureFocus = t.boolean,
	isMainPageMoreMenuOpen = t.boolean
})

function extended.render(p)
	if p.props.canCaptureFocus then
		return withLocalization({
			openMoreMenu = "CoreScripts.InGameMenu.ControllerBar.OpenMoreMenu",
			closeMoreMenu = "CoreScripts.InGameMenu.ControllerBar.CloseMoreMenu",
			back = "CoreScripts.InGameMenu.ControllerBar.Back",
			respawnCharacter = "CoreScripts.InGameMenu.ControllerBar.RespawnCharacter",
			leave = "CoreScripts.InGameMenu.ControllerBar.Leave"
		})(function(props)
			local rightHints

			if VRService.VREnabled then
				rightHints = {
					{ text = props.respawnCharacter, keyCode = Enum.KeyCode.ButtonY },
					{ text = props.leave, keyCode = Enum.KeyCode.ButtonX }
				}
			else
				rightHints = {
					{
						text = p.props.isMainPageMoreMenuOpen and props.closeMoreMenu or props.openMoreMenu,
						keyCode = Enum.KeyCode.ButtonL3
					},
					{ text = props.respawnCharacter, keyCode = Enum.KeyCode.ButtonY },
					{ text = props.leave, keyCode = Enum.KeyCode.ButtonX }
				}
			end

			return Roact.createElement(IGMControllerBar2, {
				leftHint = { text = props.back, keyCode = Enum.KeyCode.ButtonB },
				rightHints = rightHints
			})
		end)
	end

	return nil
end

return extended
