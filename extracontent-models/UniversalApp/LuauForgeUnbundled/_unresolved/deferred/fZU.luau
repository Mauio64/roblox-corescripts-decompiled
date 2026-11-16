local module = require("@luauforge/deferred/fZV")
local module2 = require("@luauforge/deferred/fZR")

local listTable = require("@luauforge/deferred/fZS").App.Table.ListTable

return module2.memo(function(props)
	local v5 = module2.useMemo(function()
		local children = {}

		for k, row in props.rows do
			table.insert(
				children,
				module2.createElement(module, {
					horizontalPadding = props.horizontalPadding,
					infoData = row.infoData,
					infoName = row.infoName
				})
			)
		end

		return children
	end, { props.horizontalPadding, props.rows })

	return module2.createElement(listTable, {
		automaticSize = Enum.AutomaticSize.Y,
		cells = v5,
		dividerStartOffset = props.dividerStartOffset
	})
end)
