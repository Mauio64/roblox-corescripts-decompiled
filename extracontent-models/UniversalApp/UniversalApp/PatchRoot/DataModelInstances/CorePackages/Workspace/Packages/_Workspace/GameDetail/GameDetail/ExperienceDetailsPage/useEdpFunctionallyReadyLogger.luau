local Parent = script:FindFirstAncestor("GameDetail").Parent
local React = require(Parent.React)
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local FetchGamePlayButtonData = require(Parent.GamePlayButton).FetchGamePlayButtonData

require(Parent.SduiSharedUtilities)

local Milestone = require(Parent.TimeToInteractiveTracker).TimeToInteractiveTracker.Milestone

local function useEdpFunctionallyReadyLogger(p1, s1: string?) -- line: 16
	-- upvalues: useSelector (copy), FetchGamePlayButtonData (copy), React (copy), Milestone (copy)
	local v9 = useSelector(function(p2) -- line: 17
		-- upvalues: s1 (copy), FetchGamePlayButtonData (copy)
		if s1 then
			return FetchGamePlayButtonData.IsLoading(p2, s1)
		end

		return true
	end)

	React.useEffect(function() -- line: 24
		-- upvalues: v9 (copy), s1 (copy), p1 (copy), Milestone (copy)
		if not v9 and (s1 and p1.trackOnce) then
			p1.trackOnce(Milestone.FunctionallyReady)
		end
	end, {
		v9,
		s1,
		p1
	})
end

return useEdpFunctionallyReadyLogger
