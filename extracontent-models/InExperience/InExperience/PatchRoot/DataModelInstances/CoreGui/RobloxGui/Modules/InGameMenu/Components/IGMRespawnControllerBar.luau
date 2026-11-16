local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t

local parent = script.Parent.Parent
local IGMControllerBar2 = require(script.Parent.IGMControllerBar2)
local Constants = require(parent.Resources.Constants)
local withLocalization = require(parent.Localization.withLocalization)

local extended = Roact.PureComponent:extend("IGMRespawnControllerBar")

extended.validateProps = t.strictInterface({ inputType = t.string })

function extended.render(p)
	if p.props.inputType == Constants.InputType.Gamepad then
		return withLocalization({
			cancel = "CoreScripts.InGameMenu.ControllerBar.Cancel",
			respawn = "CoreScripts.InGameMenu.ControllerBar.Respawn"
		})(function(p2)
			return Roact.createElement(IGMControllerBar2, {
				leftHint = { text = p2.cancel, keyCode = Enum.KeyCode.ButtonB },
				rightHints = {
					{ text = p2.respawn, keyCode = Enum.KeyCode.ButtonA }
				}
			})
		end)
	end

	return nil
end

return extended
