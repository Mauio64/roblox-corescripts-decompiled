local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
local React = require(PeopleReactViewParent.React)
local SignalsReact = require(PeopleReactViewParent.SignalsReact)
local GetScrollingFrameStore = require(PeopleReactView.Stores.GetScrollingFrameStore)

local function useScrollingFrameStore(p1) -- line: 9
	-- upvalues: SignalsReact (copy), GetScrollingFrameStore (copy), React (copy)
	local v8 = SignalsReact.useSignalState(GetScrollingFrameStore)
	local v9 = React.useRef(false)

	if not v9.current and p1 then
		v8.setScrollingFrame(p1)
		v9.current = true
	end

	React.useEffect(function() -- line: 18
		-- upvalues: v8 (copy)
		return function() -- line: 19
			-- upvalues: v8 (copy)
			v8.cleanUp()
		end
	end, { v8 })

	return v8
end

return useScrollingFrameStore
