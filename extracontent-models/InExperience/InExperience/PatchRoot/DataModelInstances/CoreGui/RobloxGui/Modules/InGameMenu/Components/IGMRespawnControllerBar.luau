local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local ParentParent = script.Parent.Parent
local IGMControllerBar2 = require(script.Parent.IGMControllerBar2)
local Constants = require(ParentParent.Resources.Constants)
local withLocalization = require(ParentParent.Localization.withLocalization)
local v9 = Roact.PureComponent:extend("IGMRespawnControllerBar")

v9.validateProps = t.strictInterface({
	inputType = t.string
})

function v9.render(p1) -- line: 18
	-- upvalues: Constants (copy), withLocalization (copy), Roact (copy), IGMControllerBar2 (copy)
	if p1.props.inputType == Constants.InputType.Gamepad then
		return withLocalization({
			cancel = "CoreScripts.InGameMenu.ControllerBar.Cancel",
			respawn = "CoreScripts.InGameMenu.ControllerBar.Respawn"
		})(function(p2) -- line: 23
			-- upvalues: Roact (copy), IGMControllerBar2 (copy)
			return Roact.createElement(IGMControllerBar2, {
				leftHint = {
					text = p2.cancel,
					keyCode = Enum.KeyCode.ButtonB
				},
				rightHints = {{
					text = p2.respawn,
					keyCode = Enum.KeyCode.ButtonA
				}}
			})
		end)
	end

	return nil
end

return v9
