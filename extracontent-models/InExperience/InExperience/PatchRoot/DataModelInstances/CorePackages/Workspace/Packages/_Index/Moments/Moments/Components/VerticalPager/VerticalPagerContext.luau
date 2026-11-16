local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

require(script.Parent.Types)
local createPagerStore = require(script.Parent.createPagerStore)

local function noop() end

local signal = Signals.createSignal(1)
local signal2 = Signals.createSignal("Idle")
local signal3 = Signals.createSignal(false)

local pagerStore = createPagerStore()

local context = React.createContext({
	store = pagerStore,
	getActiveIndex = signal,
	getScrollState = signal2,
	scrollToIndex = noop,
	next = noop,
	previous = noop,
	removeItem = noop,
	analytics = nil
})

local context2 = React.createContext({
	index = 0,
	item = nil,
	getIsActive = signal3,
	getIsVisible = signal3
})

local function usePagerItem() -- 1 equivalent call inferred from this helper
	return (React.useContext(context2))
end

local VerticalPagerContext = {}
VerticalPagerContext.VerticalPagerContext = context
VerticalPagerContext.PagerItemContext = context2

function VerticalPagerContext.useVerticalPager()
	return (React.useContext(context))
end

VerticalPagerContext.usePagerItem = usePagerItem

function VerticalPagerContext.useIsPagerItemActive()
	local v = usePagerItem() -- inferred equivalent call
	return SignalsReact.useSignalState(v.getIsActive)
end

return VerticalPagerContext
