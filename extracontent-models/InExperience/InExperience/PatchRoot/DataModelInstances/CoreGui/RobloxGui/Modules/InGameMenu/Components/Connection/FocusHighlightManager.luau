local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t
local ParentParent = script.Parent.Parent.Parent
local InputType = require(ParentParent.Resources.Constants).InputType
local GetFFlagIGMGamepadSelectionHistory = require(ParentParent.Flags.GetFFlagIGMGamepadSelectionHistory)
local FocusHandler = require(script.Parent.FocusHandler)
local v11 = Roact.PureComponent:extend("FocusHighlightManager")

v11.validateProps = t.strictInterface({
	menuOpen = t.boolean,
	inputType = t.string
})

function v11.render(p1) -- line: 22
	-- upvalues: GetFFlagIGMGamepadSelectionHistory (copy), Roact (copy), FocusHandler (copy), InputType (copy), GuiService (copy)
	if GetFFlagIGMGamepadSelectionHistory() then
		return Roact.createElement(FocusHandler, {
			isFocused = not p1.props.menuOpen or p1.props.inputType ~= InputType.Gamepad,
			didFocus = function() -- line: 26
				-- upvalues: GuiService (copy)
				GuiService.SelectedCoreObject = nil
			end
		})
	end

	return Roact.createElement(FocusHandler, {
		isFocused = p1.props.menuOpen and p1.props.inputType == InputType.Gamepad,
		didBlur = function() -- line: 33
			-- upvalues: GuiService (copy)
			GuiService.SelectedCoreObject = nil
		end
	})
end

return RoactRodux.UNSTABLE_connect2(function(p2) -- line: 40
	return {
		menuOpen = p2.isMenuOpen,
		inputType = p2.displayOptions.inputType
	}
end)(v11)
