local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Signals = require(CorePackages.Packages.Signals)
local Display = require(CorePackages.Workspace.Packages.Display)
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t
local UIBlox = InGameMenuDependencies.UIBlox
local ParentParent = script.Parent.Parent
local withLocalization = require(ParentParent.Localization.withLocalization)
local SetMenuIconTooltipOpen = require(ParentParent.Actions.SetMenuIconTooltipOpen)
local Constants = require(ParentParent.Parent.TopBar.Constants)
local Tooltip = UIBlox.App.Dialog.Tooltip
local v15 = Roact.PureComponent:extend("MenuIconTooltip")

v15.validateProps = t.strictInterface({
	isTooltipOpen = t.boolean,
	onDismiss = t.callback
})

function v15.init(p1) -- line: 28
	-- upvalues: Signals (copy), Display (copy)
	p1.disposeUiScaleEffect = Signals.createEffect(function(p2) -- line: 29
		-- upvalues: Display (copy), p1 (copy)
		local v23 = Display.GetDisplayStore(p2)

		p1:setState({
			UiScale = v23.getUIScale(p2)
		})
	end)
end
function v15.render(p3) -- line: 37
	-- upvalues: withLocalization (copy), Constants (copy), Roact (copy), CoreGui (copy), Tooltip (copy)
	return withLocalization({
		bodyText = "CoreScripts.InGameMenu.EducationalPopup.MenuIconTooltip"
	})(function(p4) -- line: 40
		-- upvalues: Constants (copy), p3 (copy), Roact (copy), CoreGui (copy), Tooltip (copy)
		local v25 = Constants.TopBarHeight * p3.state.UiScale
		local v26 = Constants.ScreenSideOffset * p3.state.UiScale
		local vector2 = Vector2.new(v26, v25 - 32)

		return p3.props.isTooltipOpen and Roact.createElement(Roact.Portal, {
			target = CoreGui
		}, {
			TooltipScreenGui = Roact.createElement("ScreenGui", {
				IgnoreGuiInset = true,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			}, {
				Tooltip = Roact.createElement(Tooltip, {
					forceClickTriggerPoint = true,
					triggerPosition = vector2,
					triggerSize = Vector2.new(32, 32),
					bodyText = p4.bodyText,
					onDismiss = p3.props.onDismiss
				})
			})
		})
	end)
end
function v15.willUnmount(p5) -- line: 65
	if p5.disposeUiScaleEffect then
		p5.disposeUiScaleEffect()
	end
end

return RoactRodux.UNSTABLE_connect2(function(p6, _) -- line: 72
	return {
		isTooltipOpen = p6.nativeClosePrompt.menuIconTooltipOpen
	}
end, function(p8) -- line: 76
	-- upvalues: SetMenuIconTooltipOpen (copy)
	return {
		onDismiss = function() -- line: 78
			-- upvalues: p8 (copy), SetMenuIconTooltipOpen (copy)
			p8(SetMenuIconTooltipOpen(false))
		end
	}
end)(v15)
