local CorePackages = game:GetService("CorePackages")
local VRService = game:GetService("VRService")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local ParentParent = script.Parent.Parent
local IGMControllerBar2 = require(script.Parent.IGMControllerBar2)
local withLocalization = require(ParentParent.Localization.withLocalization)
local v9 = Roact.PureComponent:extend("IGMMainPageControllerBar")

v9.validateProps = t.strictInterface({
	canCaptureFocus = t.boolean,
	isMainPageMoreMenuOpen = t.boolean
})

function v9.render(p1) -- line: 19
	-- upvalues: withLocalization (copy), VRService (copy), Roact (copy), IGMControllerBar2 (copy)
	if p1.props.canCaptureFocus then
		return withLocalization({
			openMoreMenu = "CoreScripts.InGameMenu.ControllerBar.OpenMoreMenu",
			closeMoreMenu = "CoreScripts.InGameMenu.ControllerBar.CloseMoreMenu",
			back = "CoreScripts.InGameMenu.ControllerBar.Back",
			respawnCharacter = "CoreScripts.InGameMenu.ControllerBar.RespawnCharacter",
			leave = "CoreScripts.InGameMenu.ControllerBar.Leave"
		})(function(p2) -- line: 27
			-- upvalues: VRService (copy), p1 (copy), Roact (copy), IGMControllerBar2 (copy)
			local v12 = if VRService.VREnabled then {
				{
					text = p2.respawnCharacter,
					keyCode = Enum.KeyCode.ButtonY
				},
				{
					text = p2.leave,
					keyCode = Enum.KeyCode.ButtonX
				}
			} else {
				{
					text = p1.props.isMainPageMoreMenuOpen and p2.closeMoreMenu or p2.openMoreMenu,
					keyCode = Enum.KeyCode.ButtonL3
				},
				{
					text = p2.respawnCharacter,
					keyCode = Enum.KeyCode.ButtonY
				},
				{
					text = p2.leave,
					keyCode = Enum.KeyCode.ButtonX
				}
			}

			return Roact.createElement(IGMControllerBar2, {
				leftHint = {
					text = p2.back,
					keyCode = Enum.KeyCode.ButtonB
				},
				rightHints = v12
			})
		end)
	end

	return nil
end

return v9
