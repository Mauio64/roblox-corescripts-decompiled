local parent = script:FindFirstAncestor("SocialCommon").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)

local SearchInput = Foundation.SearchInput

local function SearchFieldView(props)
	local testId = props.testId or "SearchField"

	return React.createElement(
		Foundation.View,
		{
			tag = "size-full-0 auto-y",
			testId = `{testId}View`,
			LayoutOrder = props.LayoutOrder,
			ref = props.containerRef
		},
		{
			Input = React.createElement(SearchInput, {
				text = props.text,
				placeholder = props.placeholder,
				onChanged = props.onChanged,
				onFocusGained = props.onFocusGained,
				onFocusLost = props.onFocusLost,
				ref = props.inputRef,
				width = UDim.new(1, 0),
				testId = `{testId}Input`
			})
		}
	)
end

return SearchFieldView
