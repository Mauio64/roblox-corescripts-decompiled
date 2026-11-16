local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

local Signals = require(CorePackages.Packages.Signals)
local Display = require(CorePackages.Workspace.Packages.Display)

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t
local UIBlox = InGameMenuDependencies.UIBlox

local parent = script.Parent.Parent
local withLocalization = require(parent.Localization.withLocalization)
local SetMenuIconTooltipOpen = require(parent.Actions.SetMenuIconTooltipOpen)
local Constants = require(parent.Parent.TopBar.Constants)
local Tooltip = UIBlox.App.Dialog.Tooltip

local extended = Roact.PureComponent:extend("MenuIconTooltip")

extended.validateProps = t.strictInterface({ isTooltipOpen = t.boolean, onDismiss = t.callback })

function extended:init()
	self.disposeUiScaleEffect = Signals.createEffect(function(p)
		self:setState({
			UiScale = Display.GetDisplayStore(p).getUIScale(p)
		})
	end)
end

function extended.render(p)
	return withLocalization({ bodyText = "CoreScripts.InGameMenu.EducationalPopup.MenuIconTooltip" })(function(p2)
		local v = Constants.TopBarHeight * p.state.UiScale
		local v2 = Constants.ScreenSideOffset * p.state.UiScale
		local vector2 = Vector2.new(v2, v - 32)
		return p.props.isTooltipOpen and Roact.createElement(Roact.Portal, { target = CoreGui }, {
			TooltipScreenGui = Roact.createElement(
				"ScreenGui",
				{ IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling },
				{
					Tooltip = Roact.createElement(Tooltip, {
						triggerPosition = vector2,
						triggerSize = Vector2.new(32, 32),
						bodyText = p2.bodyText,
						onDismiss = p.props.onDismiss,
						forceClickTriggerPoint = true
					})
				}
			)
		})
	end)
end

function extended.willUnmount(p)
	if p.disposeUiScaleEffect then
		p.disposeUiScaleEffect()
	end
end

return RoactRodux.UNSTABLE_connect2(function(p, _)
	return { isTooltipOpen = p.nativeClosePrompt.menuIconTooltipOpen }
end, function(callback)
	return {
		onDismiss = function()
			callback(SetMenuIconTooltipOpen(false))
		end
	}
end)(extended)
