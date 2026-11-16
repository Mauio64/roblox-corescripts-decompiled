local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Dash = require(parent.Dash)
local React = require(parent.React)

local Button = require(Foundation.Components.Button)
local InputSize = require(Foundation.Enums.InputSize)
local Logger = require(Foundation.Utility.Logger)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local AlertConstants = require(script.Parent.AlertConstants)
local MAX_ACTION_COUNT = AlertConstants.MAX_ACTION_COUNT

local v = { testId = "--foundation-alert-actions" }

local function AlertActions(p)
	local v2 = withDefaults(p, v)
	React.useEffect(function()
		if v2.actions and MAX_ACTION_COUNT < #v2.actions then
			Logger:warning(`Alert components only support up to {MAX_ACTION_COUNT} actions`)
		end
	end, { v2.actions })

	local v3 = React.useMemo(function()
		if not (v2.actions and #v2.actions > 0) then
			return nil
		end

		local children = {}

		for k, action in v2.actions do
			if MAX_ACTION_COUNT < k then
				break
			end

			local joined = Dash.join(action, {
				LayoutOrder = k,
				size = InputSize.Small,
				testId = `{v2.testId}--action-{k}`
			})

			children["ActionButton" .. k] = React.createElement(Button, joined)
		end

		return children
	end, { v2.actions, v2.testId })

	if v3 then
		return React.createElement(View, withCommonProps(v2, {
			tag = v2.tag or "auto-xy row gap-small",
			padding = v2.padding
		}), v3)
	end

	return nil
end

return React.memo(AlertActions)
