local Parent = script:FindFirstAncestor("Moments").Parent
local React = require(Parent.React)
local Signals = require(Parent.Signals)
local SignalsReact = require(Parent.SignalsReact)

require(script.Parent.Types)

local createPagerStore = require(script.Parent.createPagerStore)

local function noop() -- line: 24
end

local v7 = Signals.createSignal(1)
local v8 = Signals.createSignal("Idle")
local v9 = Signals.createSignal(false)
local v10 = createPagerStore()
local v11 = React.createContext({
	analytics = nil,
	store = v10,
	getActiveIndex = v7,
	getScrollState = v8,
	scrollToIndex = noop,
	next = noop,
	previous = noop,
	removeItem = noop
})
local v12 = React.createContext({
	index = 0,
	item = nil,
	getIsActive = v9,
	getIsVisible = v9
})

return {
	VerticalPagerContext = v11,
	PagerItemContext = v12,
	useVerticalPager = function() -- line: 61
		-- upvalues: React (copy), v11 (copy)
		return (React.useContext(v11))
	end,
	usePagerItem = function() -- line: 75
		-- upvalues: React (copy), v12 (copy)
		return (React.useContext(v12))
	end,
	useIsPagerItemActive = function() -- line: 84
		-- upvalues: React (copy), v12 (copy), SignalsReact (copy)
		local v13 = React.useContext(v12)

		return SignalsReact.useSignalState(v13.getIsActive)
	end
}
