local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")

local iconName = Foundation.Enums.IconName
local list = Foundation.List

local function SduiListItem(props)
	local v5 = React.useMemo(function()
		if props.leadingIcon then
			return iconName[props.leadingIcon] or { iconName = props.leadingIcon }
		end

		return nil
	end, { props.leadingIcon })

	local v6 = React.useMemo(function()
		if props.titleMetadata then
			return {
				title = props.title or "",
				metadata = props.titleMetadata
			}
		end

		return props.title or ""
	end, { props.title, props.titleMetadata })

	local v7 = React.useMemo(function()
		local input = props.input

		if typeof(input) ~= "table" then
			return input
		end

		local onActivated = input.onActivated

		if typeof(onActivated) ~= "function" then
			return input
		end

		local clone = table.clone(input)
		function clone.onActivated(p2)
			onActivated(nil, nil, { isChecked = p2 })
		end
		return clone
	end, { props.input })

	return React.createElement(list.Item, {
		leading = v5,
		title = v6,
		description = props.description,
		trailing = props.trailing,
		onActivated = props.onActivated,
		input = v7,
		LayoutOrder = props.layoutOrder,
		testId = props.testId
	})
end

return React.memo(SduiListItem)
