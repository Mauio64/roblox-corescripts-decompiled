local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/Foundation")

local searchInput = Foundation.SearchInput

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
			Input = React.createElement(searchInput, {
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
