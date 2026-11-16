local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

require(Foundation.Enums.HeaderBarSlot)

local context = React.createContext({ testId = "" })

local function HeaderBarProvider(props)
	local v = React.useMemo(function()
		return { testId = props.testId, slot = props.slot }
	end, { props.testId, props.slot })

	return React.createElement(context.Provider, { value = v }, props.children)
end

return { Context = context, Provider = HeaderBarProvider }
