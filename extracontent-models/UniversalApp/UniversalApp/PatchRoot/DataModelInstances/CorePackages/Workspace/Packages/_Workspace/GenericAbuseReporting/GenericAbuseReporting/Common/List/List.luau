local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local FFlagAbuseReportMenuV2 = require(Parent.SharedFlags).FFlagAbuseReportMenuV2
local View = Foundation.View
local ListContext = require(script.Parent.ListContext)

local function List(t1: {[any]: any}, p1) -- line: 22
	-- upvalues: React (copy), View (copy), FFlagAbuseReportMenuV2 (copy), ListContext (copy)
	local v10 = React.useCallback(function(s1: string) -- line: 23
		-- upvalues: t1 (copy)
		t1.onValueChanged(s1)
	end, { t1.onValueChanged })

	return React.createElement(View, {
		tag = (not FFlagAbuseReportMenuV2 or not t1.tag) and "size-full-0 auto-y col" or t1.tag,
		LayoutOrder = t1.layoutOrder,
		ref = p1
	}, {
		ListContext = React.createElement(ListContext.Provider, {
			value = {
				value = t1.value,
				onValueChanged = v10
			}
		}, t1.children)
	})
end

return React.memo(React.forwardRef(List))
