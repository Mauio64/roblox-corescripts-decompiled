local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local Foundation = require(CorePackages.Packages.Foundation)
local React = require(CorePackages.Packages.React)
local Icon = Foundation.Icon
local Text = Foundation.Text
local View = Foundation.View

local ModalBasedSelectorDialogController = require(AbuseReportMenu.Components.ModalBasedSelectorDialogController)

local FFlagHideShortcutsOnReportDropdown = require(AbuseReportMenu.Flags.FFlagHideShortcutsOnReportDropdown)

local function ModalBasedSelector(props)
	local v

	if FFlagHideShortcutsOnReportDropdown then
		v = React.useCallback(function()
			props.onMenuOpenChange(true)
		end, { props.onMenuOpenChange })
	else
		v = nil
	end

	local v2 = React.useCallback(function()
		ModalBasedSelectorDialogController.unmountModalSelector()

		if FFlagHideShortcutsOnReportDropdown then
			props.onMenuOpenChange(false)
		end
	end, { props.onMenuOpenChange })

	return React.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, props.selectorHeight),
			BackgroundTransparency = 1
		},
		{
			ControlButton = React.createElement(View, {
				tag = "size-full stroke-thicker stroke-emphasis radius-medium",
				onActivated = function()
					ModalBasedSelectorDialogController.mountModalSelector(
						props.viewportHeight,
						props.viewportWidth,
						props.selections,
						props.onSelect,
						v2,
						v
					)
				end
			}, {
				Text = React.createElement(Text, {
					Text = props.selectedValue or props.placeholderText,
					tag = "size-full anchor-center-center position-center-center",
					TextTruncate = Enum.TextTruncate.AtEnd
				}),
				Icon = React.createElement(Icon, {
					name = "icons/actions/truncationExpand",
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.new(1, 0, 0, 0)
				})
			})
		}
	)
end

return ModalBasedSelector
