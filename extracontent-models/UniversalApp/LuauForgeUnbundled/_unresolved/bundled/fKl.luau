local module = require("@luauforge/bundled/fJc")

local view = require("@luauforge/bundled/fKe").View

local dropdownWithPopover = require("@luauforge/bundled/fJy").Components.DropdownWithPopover
require("@luauforge/bundled/fJj")

return function(props)
	local v5 = module.useMemo(function()
		if not (props.phonePrefixList and #props.phonePrefixList > 0) then
			return {}
		end

		local result = {}

		for i, phonePrefix in ipairs(props.phonePrefixList) do
			table.insert(result, {
				value = i,
				text = string.format("%s (+%s)", phonePrefix.localizedName, phonePrefix.prefix or "")
			})
		end

		return result
	end, { props.phonePrefixList })

	return module.createElement(
		view,
		{ tag = "size-full-0 auto-y col gap-small", LayoutOrder = props.LayoutOrder },
		{
			DropdownMenuContainer = module.createElement(
				view,
				{
					tag = "size-full-0 auto-y col gap-small",
					LayoutOrder = 1,
					ZIndex = 3
				},
				{
					DropdownWithPopover = module.createElement(dropdownWithPopover, {
						value = props.value,
						onChange = props.onChange,
						cellDatas = v5,
						errorState = false,
						layoutOrder = 1,
						topOffset = props.topOffset
					})
				}
			)
		}
	)
end
