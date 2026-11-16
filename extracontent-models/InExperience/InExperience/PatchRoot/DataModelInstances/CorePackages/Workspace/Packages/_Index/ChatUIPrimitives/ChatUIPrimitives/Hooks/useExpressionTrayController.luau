local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent
local React = require(parent.React)
require(ChatUIPrimitives.UniversalMessage.Types)

local function useExpressionTrayController(p)
	local categoryGroups = p.categoryGroups

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState("")

	React.useEffect(function()
		setState2(function(p2: string)
			for _, categoryGroup in categoryGroups do
				if categoryGroup.categoryGroupId == p2 then
					return p2
				end
			end

			if #categoryGroups > 0 then
				return categoryGroups[1].categoryGroupId
			end

			return ""
		end)
	end, { categoryGroups })

	return {
		isOpen = state,
		activeGroupId = state2,
		onEntryActivated = React.useCallback(function()
			setState(function(flag: boolean): boolean
				return not flag
			end)
		end, {}),
		onGroupActivated = setState2,
		close = React.useCallback(function()
			setState(false)
		end, {})
	}
end

return useExpressionTrayController
