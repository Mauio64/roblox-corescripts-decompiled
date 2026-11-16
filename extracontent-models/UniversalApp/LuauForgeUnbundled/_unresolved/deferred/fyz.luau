local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)

return function(props)
	return React.createElement(Foundation.Dropdown.Root, {
		testId = "--devicesettings-dropdown-uiscale",
		label = "",
		items = props.items,
		value = props.value,
		onItemChanged = props.onItemChanged,
		width = props.width,
		maxHeight = props.maxHeight,
		size = Foundation.Enums.InputSize.Large,
		scrollingFrameRef = props.menuRef,
		ref = props.controlRef,
		selectionGroup = {
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
			SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop
		}
	})
end
