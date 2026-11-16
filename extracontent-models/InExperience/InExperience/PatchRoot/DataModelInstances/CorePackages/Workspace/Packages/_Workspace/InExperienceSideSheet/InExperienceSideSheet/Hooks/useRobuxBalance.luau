local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local parent = InExperienceSideSheet.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local fetchRobuxBalance = require(InExperienceSideSheet.Utils.fetchRobuxBalance)
local getSideSheetVisibility = require(InExperienceSideSheet.Utils.getSideSheetVisibility)

local function useRobuxBalance()
	local state, setState = React.useState(nil)
	local ref = React.useRef(true)
	local v = SignalsReact.useSignalState(getSideSheetVisibility)

	React.useEffect(function()
		ref.current = true
		return function()
			ref.current = false
		end
	end, {})

	local v2 = React.useCallback(function()
		fetchRobuxBalance(function(p: number)
			if ref.current then
				setState(p)
			end
		end)
	end, {})

	React.useEffect(function()
		if v then
			v2()
		end
	end, { v, v2 })

	return state
end

return useRobuxBalance
