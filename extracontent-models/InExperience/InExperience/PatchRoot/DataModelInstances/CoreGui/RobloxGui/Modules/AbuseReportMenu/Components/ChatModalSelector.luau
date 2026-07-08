local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local Foundation = require(CorePackages.Packages.Foundation)
local React = require(CorePackages.Packages.React)
local Icon = Foundation.Icon
local FoundationText = Foundation.Text
local View = Foundation.View
local ChatModalSelectorDialogController = require(AbuseReportMenu.Components.ChatModalSelectorDialogController)

require(AbuseReportMenu.Components.Types)

local FFlagHideShortcutsOnReportDropdown = require(AbuseReportMenu.Flags.FFlagHideShortcutsOnReportDropdown)

local function ChatModalSelector(t1: {[any]: any}) -- line: 27
	-- upvalues: FFlagHideShortcutsOnReportDropdown (copy), React (copy), ChatModalSelectorDialogController (copy), View (copy), FoundationText (copy), Icon (copy)
	local u12 = nil

	if FFlagHideShortcutsOnReportDropdown then
		u12 = React.useCallback(function() -- line: 30
			-- upvalues: t1 (copy)
			t1.onMenuOpenChange(true)
		end, { t1.onMenuOpenChange })
	end

	local v13 = React.useCallback(function() -- line: 35
		-- upvalues: ChatModalSelectorDialogController (copy), FFlagHideShortcutsOnReportDropdown (copy), t1 (copy)
		ChatModalSelectorDialogController.unmountModalSelector()

		if FFlagHideShortcutsOnReportDropdown then
			t1.onMenuOpenChange(false)
		end
	end, { t1.onMenuOpenChange })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, t1.selectorHeight)
	}, {
		ControlButton = React.createElement(View, {
			tag = "size-full stroke-thicker stroke-emphasis radius-medium",
			onActivated = function() -- line: 48
				-- upvalues: ChatModalSelectorDialogController (copy), v13 (copy), u12 (ref), t1 (copy)
				ChatModalSelectorDialogController.mountModalSelector(v13, u12, t1.onSelect)
			end
		}, {
			Text = React.createElement(FoundationText, {
				tag = "size-full anchor-center-center position-center-center",
				Text = t1.selectedValue or t1.placeholderText,
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

return ChatModalSelector
