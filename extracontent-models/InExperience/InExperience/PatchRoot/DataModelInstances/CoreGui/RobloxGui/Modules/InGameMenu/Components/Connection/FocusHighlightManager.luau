local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t

local parent = script.Parent.Parent.Parent
local Constants = require(parent.Resources.Constants)
local InputType = Constants.InputType
local GetFFlagIGMGamepadSelectionHistory = require(parent.Flags.GetFFlagIGMGamepadSelectionHistory)
local FocusHandler = require(script.Parent.FocusHandler)

local extended = Roact.PureComponent:extend("FocusHighlightManager")

extended.validateProps = t.strictInterface({ menuOpen = t.boolean, inputType = t.string })

function extended.render(p)
	if GetFFlagIGMGamepadSelectionHistory() then
		return Roact.createElement(FocusHandler, {
			isFocused = not p.props.menuOpen or p.props.inputType ~= InputType.Gamepad,
			didFocus = function()
				GuiService.SelectedCoreObject = nil
			end
		})
	end

	return Roact.createElement(FocusHandler, {
		isFocused = p.props.menuOpen and p.props.inputType == InputType.Gamepad,
		didBlur = function()
			GuiService.SelectedCoreObject = nil
		end
	})
end

return RoactRodux.UNSTABLE_connect2(function(p)
	return { menuOpen = p.isMenuOpen, inputType = p.displayOptions.inputType }
end)(extended)
