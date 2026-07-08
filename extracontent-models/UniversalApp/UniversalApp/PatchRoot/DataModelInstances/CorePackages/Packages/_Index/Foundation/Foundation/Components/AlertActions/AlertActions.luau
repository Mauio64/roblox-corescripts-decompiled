local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)
local React = require(FoundationParent.React)
local Button = require(Foundation.Components.Button)
local InputSize = require(Foundation.Enums.InputSize)
local Logger = require(Foundation.Utility.Logger)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local MAX_ACTION_COUNT = require(script.Parent.AlertConstants).MAX_ACTION_COUNT
local t1 = {
	testId = "--foundation-alert-actions"
}

local function AlertActions(t2: {[any]: any}) -- line: 33
	-- upvalues: withDefaults (copy), t1 (copy), React (copy), MAX_ACTION_COUNT (copy), Logger (copy), Dash (copy), InputSize (copy), Button (copy), View (copy), withCommonProps (copy)
	local v15 = withDefaults(t2, t1)

	React.useEffect(function() -- line: 35
		-- upvalues: v15 (copy), MAX_ACTION_COUNT (copy), Logger (copy)
		if v15.actions and #v15.actions > MAX_ACTION_COUNT then
			Logger:warning(`Alert components only support up to { MAX_ACTION_COUNT } actions`)
		end
	end, { v15.actions })

	local v16 = React.useMemo(function() -- line: 41
		-- upvalues: v15 (copy), MAX_ACTION_COUNT (copy), Dash (copy), InputSize (copy), React (copy), Button (copy)
		if v15.actions and #v15.actions > 0 then
			local t3 = {}

			for v18, v19 in v15.actions do
				if v18 > MAX_ACTION_COUNT then
					return t3
				end

				local v20 = Dash.join(v19, {
					LayoutOrder = v18,
					size = InputSize.Small,
					testId = `{ v15.testId }--action-{ v18 }`
				})

				t3["ActionButton" .. v18] = React.createElement(Button, v20)
			end

			return t3
		end

		return nil
	end, {
		v15.actions,
		v15.testId
	})

	if not v16 then
		return nil
	end

	return React.createElement(View, withCommonProps(v15, {
		tag = v15.tag or "auto-xy row gap-small",
		padding = v15.padding
	}), v16)
end

return React.memo(AlertActions)
