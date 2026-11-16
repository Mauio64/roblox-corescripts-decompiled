local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local searchInput = Foundation.SearchInput
local view = Foundation.View

local function SearchBarView(props)
	return React.createElement(
		view,
		{
			LayoutOrder = props.LayoutOrder,
			tag = "size-full-0 auto-y",
			testId = "SearchBar"
		},
		{
			Input = React.createElement(searchInput, {
				onChanged = props.onChanged,
				onFocusGained = props.onFocusGained,
				onFocusLost = props.onFocusLost,
				placeholder = props.placeholder,
				testId = "SearchBar.Input",
				text = props.query,
				ref = props.textInputRef,
				width = UDim.new(1, 0)
			})
		}
	)
end

return SearchBarView
