local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/VerticalPager/Types")
local createPagerStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/VerticalPager/createPagerStore")

local function noop() end

local signal = Signals.createSignal(1)
local signal2 = Signals.createSignal("Idle")
local signal3 = Signals.createSignal(false)

local v5 = createPagerStore()

local context = React.createContext({
	store = v5,
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

return {
	VerticalPagerContext = context,
	PagerItemContext = context2,
	useVerticalPager = function()
		return React.useContext(context)
	end,
	usePagerItem = function()
		return React.useContext(context2)
	end,
	useIsPagerItemActive = function()
		local v6 = React.useContext(context2)

		return SignalsReact.useSignalState(v6.getIsActive)
	end
}
