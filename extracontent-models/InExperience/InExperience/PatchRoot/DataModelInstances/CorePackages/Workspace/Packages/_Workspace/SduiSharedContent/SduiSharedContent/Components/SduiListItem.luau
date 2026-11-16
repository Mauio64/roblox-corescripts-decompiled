local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local IconName = Foundation.Enums.IconName
local List = Foundation.List

local function SduiListItem(props)
	local leading = React.useMemo(function()
		if props.leadingIcon then
			return IconName[props.leadingIcon] or { iconName = props.leadingIcon }
		end

		return nil
	end, { props.leadingIcon })

	local title = React.useMemo(function()
		if props.titleMetadata then
			return {
				title = props.title or "",
				metadata = props.titleMetadata
			}
		end

		return props.title or ""
	end, { props.title, props.titleMetadata })

	local input = React.useMemo(function()
		local input = props.input

		if typeof(input) ~= "table" then
			return input
		end

		local onActivated = input.onActivated

		if typeof(onActivated) ~= "function" then
			return input
		end

		local clone = table.clone(input)
		function clone.onActivated(isChecked: boolean)
			onActivated(nil, nil, { isChecked = isChecked })
		end
		return clone
	end, { props.input })

	return React.createElement(List.Item, {
		leading = leading,
		title = title,
		description = props.description,
		trailing = props.trailing,
		onActivated = props.onActivated,
		input = input,
		LayoutOrder = props.layoutOrder,
		testId = props.testId
	})
end

return React.memo(SduiListItem)
