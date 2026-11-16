local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local SearchInput = Foundation.SearchInput
local View = Foundation.View

local function SearchBarView(props)
	return React.createElement(
		View,
		{ LayoutOrder = props.LayoutOrder, tag = "size-full-0 auto-y", testId = "SearchBar" },
		{
			Input = React.createElement(SearchInput, {
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
