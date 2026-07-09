local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local getPageMargin = UIBlox.App.Container.getPageMargin
local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useProperty = require(CorePackages.Workspace.Packages.GuiObjectUtils).useProperty

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local GetFFlagAXEnableNewInventoryItemsList = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableNewInventoryItemsList)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus

local function ResetApplyBar(p1) -- line: 40
	-- upvalues: useStyle (copy), useLocalization (copy), React (copy), useProperty (copy), getPageMargin (copy), GetFFlagAXEnableNewInventoryItemsList (copy), ButtonType (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Focusable (copy), ButtonStack (copy)
	local Theme = useStyle().Theme
	local v17 = useLocalization({
		apply = "CommonUI.Messages.Action.Apply",
		reset = "CommonUI.Messages.Action.Reset"
	})
	local v18 = React.useRef(nil)
	local v19 = p1.frameRef or v18
	local v20 = useProperty(v19, "AbsoluteSize")
	local v21 = not v20 and 0 or getPageMargin(v20.X)
	local v22 = nil

	if GetFFlagAXEnableNewInventoryItemsList() then
		v22 = React.useMemo(function() -- line: 57
			-- upvalues: p1 (copy), v17 (copy), ButtonType (copy)
			local t1 = {}

			if p1.onReset then
				table.insert(t1, {
					props = {
						onActivated = p1.onReset,
						text = v17.reset,
						isDisabled = not p1.canReset
					},
					isDefaultChild = p1.onApply == nil
				})
			end

			if p1.onApply then
				table.insert(t1, {
					isDefaultChild = true,
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = p1.onApply,
						text = v17.apply,
						isDisabled = not p1.canApply
					}
				})
			end

			return t1
		end, {
			p1.onApply,
			p1.onReset,
			v17,
			p1.canReset,
			p1.canApply
		})
	end

	return React.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable.Frame else "Frame", {
		BackgroundColor3 = Theme.BackgroundDefault.Color,
		BackgroundTransparency = Theme.BackgroundUIDefault.Transparency,
		Size = UDim2.new(1, 0, 0, p1.height),
		AutomaticSize = Enum.AutomaticSize.Y,
		NextSelectionUp = if not FFlagAXMigrateAXToGlobalAutofocus then p1.NextSelectionUp else nil,
		NextSelectionDown = if not FFlagAXMigrateAXToGlobalAutofocus then p1.NextSelectionDown else nil,
		NextSelectionRight = if not FFlagAXMigrateAXToGlobalAutofocus then p1.NextSelectionRight else nil,
		NextSelectionLeft = if not FFlagAXMigrateAXToGlobalAutofocus then p1.NextSelectionLeft else nil,
		ref = v19
	}, {
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v21),
			PaddingRight = UDim.new(0, v21),
			PaddingTop = UDim.new(0, 32)
		}),
		Gradient = React.createElement("UIGradient", {
			Rotation = 270,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, Theme.BackgroundDefault.Transparency),
				NumberSequenceKeypoint.new(0.8, Theme.BackgroundDefault.Transparency),
				NumberSequenceKeypoint.new(1, 1)
			})
		}),
		Buttons = React.createElement(ButtonStack, {
			isRoactGamepadEnabled = not FFlagAXMigrateAXToGlobalAutofocus and nil,
			buttons = if not GetFFlagAXEnableNewInventoryItemsList() then {
				{
					props = {
						onActivated = p1.onReset,
						text = v17.reset,
						isDisabled = not p1.canReset
					}
				},
				{
					isDefaultChild = true,
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = p1.onApply,
						text = v17.apply,
						isDisabled = not p1.canApply
					}
				}
			} else v22
		})
	})
end

return ResetApplyBar
