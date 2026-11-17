local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

require(Foundation.Enums.Breakpoint)
local Flags = require(Foundation.Utility.Flags)
local HeaderBarContext = require(Foundation.Components.HeaderBar.HeaderBarContext)
local HeaderBarSlot = require(Foundation.Enums.HeaderBarSlot)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local constants = require(Foundation.Components.HeaderBar.constants)
local useViewportBreakpoint = require(Foundation.Providers.Responsive.Hooks.useViewportBreakpoint)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local v = { hasBackground = true, testId = "--foundation-header-bar" }

local function HeaderBar(p)
	local v2 = withDefaults(p, v)

	local v3 = useViewportBreakpoint()

	if Flags.FoundationHeaderBarSlotSizing then
		local state, setState = React.useState({ leading = 0, trailing = 0 })

		local onSideWidthChanged = React.useCallback(function(p2, p3: number)
			setState(function(p4)
				local leading

				if p2 == HeaderBarSlot.Leading then
					leading = p3
				else
					leading = p4.leading
				end

				local trailing

				if p2 == HeaderBarSlot.Trailing then
					trailing = p3
				else
					trailing = p4.trailing
				end

				if leading == p4.leading and trailing == p4.trailing then
					return p4
				end

				return { leading = leading, trailing = trailing }
			end)
		end, {})

		return React.createElement(View, withCommonProps(v2, {
			tag = {
				["padding-x-medium"] = true,
				["bg-surface-0"] = v2.hasBackground,
				[`size-full-{constants.SIZE_BY_BREAKPOINT[v3]}`] = true
			}
		}), React.createElement(
			HeaderBarContext.Provider,
			{
				testId = v2.testId,
				leadingWidth = state.leading,
				trailingWidth = state.trailing,
				onSideWidthChanged = onSideWidthChanged
			},
			v2.children
		))
	end

	return React.createElement(View, withCommonProps(v2, {
		tag = {
			["row flex-between gap-small padding-medium"] = true,
			["bg-surface-0"] = v2.hasBackground,
			[`size-full-{constants.SIZE_BY_BREAKPOINT[v3]}`] = true
		}
	}), React.createElement(HeaderBarContext.Provider, { testId = v2.testId }, v2.children))
end

return React.memo(HeaderBar)
