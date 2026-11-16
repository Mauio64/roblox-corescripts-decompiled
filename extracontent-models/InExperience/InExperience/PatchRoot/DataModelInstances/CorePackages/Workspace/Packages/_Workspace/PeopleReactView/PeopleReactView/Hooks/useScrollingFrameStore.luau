local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local parent = PeopleReactView.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local GetScrollingFrameStore = require(PeopleReactView.Stores.GetScrollingFrameStore)

local function useScrollingFrameStore(p)
	local v = SignalsReact.useSignalState(GetScrollingFrameStore)
	local ref = React.useRef(false)

	if not ref.current and p then
		v.setScrollingFrame(p)
		ref.current = true
	end

	React.useEffect(function()
		return function()
			v.cleanUp()
		end
	end, { v })

	return v
end

return useScrollingFrameStore
