local AccountRecovery = script:FindFirstAncestor("AccountRecovery")
local AccountRecoveryParent = AccountRecovery.Parent
local React = require(AccountRecoveryParent.React)
local View = require(AccountRecoveryParent.Foundation).View
local DropdownWithPopover = require(AccountRecoveryParent.AuthCommon).Components.DropdownWithPopover

require(AccountRecovery.Common.AccountRecoveryRequestTypes)

return function(t1: {[any]: any}) -- line: 21
	-- upvalues: React (copy), View (copy), DropdownWithPopover (copy)
	local v7 = React.useMemo(function() -- line: 22
		-- upvalues: t1 (copy)
		if t1.phonePrefixList and #t1.phonePrefixList > 0 then
			local t2 = {}

			for i, v in ipairs(t1.phonePrefixList) do
				table.insert(t2, {
					value = i,
					text = string.format("%s (+%s)", v.localizedName, v.prefix or "")
				})
			end

			return t2
		end

		return {}
	end, { t1.phonePrefixList })

	return React.createElement(View, {
		tag = "size-full-0 auto-y col gap-small",
		LayoutOrder = t1.LayoutOrder
	}, {
		DropdownMenuContainer = React.createElement(View, {
			tag = "size-full-0 auto-y col gap-small",
			LayoutOrder = 1,
			ZIndex = 3
		}, {
			DropdownWithPopover = React.createElement(DropdownWithPopover, {
				errorState = false,
				layoutOrder = 1,
				value = t1.value,
				onChange = t1.onChange,
				cellDatas = v7,
				topOffset = t1.topOffset
			})
		})
	})
end
