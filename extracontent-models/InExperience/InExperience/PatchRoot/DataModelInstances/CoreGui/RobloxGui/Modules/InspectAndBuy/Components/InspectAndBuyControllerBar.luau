local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local ControllerBar = UIBlox.App.Bar.ControllerBar
local ControllerShortcutKeycodes = require(script.Parent.Common.ControllerShortcutKeycodes)
local Favorite = ControllerShortcutKeycodes.Favorite
local TryOn = ControllerShortcutKeycodes.TryOn
local t = require(CorePackages.Packages.t)
local _ = {
	back = "CoreScripts.TopBar.Back",
	confirm = "InGame.InspectMenu.Action.Confirm",
	favorite = "InGame.InspectMenu.Action.Favorite",
	unfavorite = "InGame.InspectMenu.Action.Unfavorite",
	tryOn = "InGame.InspectMenu.Action.TryOn",
	takeOff = "InGame.InspectMenu.Action.TakeOff"
}
local v12 = Roact.PureComponent:extend("InspectAndBuyControllerBar")

v12.validateProps = t.strictInterface({
	showTryOn = t.boolean,
	showFavorite = t.boolean,
	isFavorited = t.boolean
})

function v12.render(p1) -- line: 31
	-- upvalues: RobloxTranslator (copy), TryOn (copy), Favorite (copy), Roact (copy), CoreGui (copy), ControllerBar (copy)
	local t1 = {{
		text = RobloxTranslator:FormatByKey("InGame.InspectMenu.Action.Confirm"),
		keyCode = Enum.KeyCode.ButtonA
	}}

	if p1.props.showTryOn then
		table.insert(t1, 1, {
			text = p1.props.tryingOn and RobloxTranslator:FormatByKey("InGame.InspectMenu.Action.TakeOff") or RobloxTranslator:FormatByKey("InGame.InspectMenu.Action.TryOn"),
			keyCode = TryOn
		})
	end

	if p1.props.showFavorite then
		table.insert(t1, 1, {
			text = p1.props.isFavorited and RobloxTranslator:FormatByKey("InGame.InspectMenu.Action.Unfavorite") or RobloxTranslator:FormatByKey("InGame.InspectMenu.Action.Favorite"),
			keyCode = Favorite
		})
	end

	return Roact.createElement(Roact.Portal, {
		target = CoreGui
	}, {
		InspectAndBuyControllerBar = Roact.createElement("ScreenGui", {
			DisplayOrder = 1,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		}, {
			ControllerBar = Roact.createElement(ControllerBar, {
				leftHint = {
					text = RobloxTranslator:FormatByKey("CoreScripts.TopBar.Back"),
					keyCode = Enum.KeyCode.ButtonB
				},
				rightHints = t1
			})
		})
	})
end

return v12
