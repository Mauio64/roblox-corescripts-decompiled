local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local Foundation = require(CorePackages.Packages.Foundation)
local React = require(CorePackages.Packages.React)
local Icon = Foundation.Icon
local FoundationText = Foundation.Text
local View = Foundation.View
local ModalBasedSelectorDialogController = require(AbuseReportMenu.Components.ModalBasedSelectorDialogController)
local FFlagHideShortcutsOnReportDropdown = require(AbuseReportMenu.Flags.FFlagHideShortcutsOnReportDropdown)

local function ModalBasedSelector(p1) -- line: 23
	-- upvalues: FFlagHideShortcutsOnReportDropdown (copy), React (copy), ModalBasedSelectorDialogController (copy), View (copy), FoundationText (copy), Icon (copy)
	local u12 = nil

	if FFlagHideShortcutsOnReportDropdown then
		u12 = React.useCallback(function() -- line: 26
			-- upvalues: p1 (copy)
			p1.onMenuOpenChange(true)
		end, { p1.onMenuOpenChange })
	end

	local v13 = React.useCallback(function() -- line: 31
		-- upvalues: ModalBasedSelectorDialogController (copy), FFlagHideShortcutsOnReportDropdown (copy), p1 (copy)
		ModalBasedSelectorDialogController.unmountModalSelector()

		if FFlagHideShortcutsOnReportDropdown then
			p1.onMenuOpenChange(false)
		end
	end, { p1.onMenuOpenChange })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, p1.selectorHeight)
	}, {
		ControlButton = React.createElement(View, {
			tag = "size-full stroke-thicker stroke-emphasis radius-medium",
			onActivated = function() -- line: 44
				-- upvalues: ModalBasedSelectorDialogController (copy), p1 (copy), v13 (copy), u12 (ref)
				ModalBasedSelectorDialogController.mountModalSelector(p1.viewportHeight, p1.viewportWidth, p1.selections, p1.onSelect, v13, u12)
			end
		}, {
			Text = React.createElement(FoundationText, {
				tag = "size-full anchor-center-center position-center-center",
				Text = p1.selectedValue or p1.placeholderText,
				TextTruncate = Enum.TextTruncate.AtEnd
			}),
			Icon = React.createElement(Icon, {
				name = "icons/actions/truncationExpand",
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, 0, 0, 0)
			})
		})
	})
end

return ModalBasedSelector
