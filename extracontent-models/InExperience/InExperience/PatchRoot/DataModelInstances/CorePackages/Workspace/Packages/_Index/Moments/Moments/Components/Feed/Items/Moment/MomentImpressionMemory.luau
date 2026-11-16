local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local VerticalPager = require(Moments.Components.VerticalPager)

local useSignalState = SignalsReact.useSignalState
local useVerticalPager = VerticalPager.useVerticalPager
local usePagerItem = VerticalPager.usePagerItem

local context = React.createContext(nil)

return table.freeze({
	Provider = function(p)
		local v = useVerticalPager()
		local item = usePagerItem().item

		local ref = React.useRef({})
		local v2 = React.useCallback(function(p2: string)
			local v2 = ref.current[p2]

			if v2 == nil then
				v2 = { current = false }
				ref.current[p2] = v2
			end

			return v2
		end, {})

		local v3 = useSignalState((React.useMemo(function()
			return Signals.createComputed(function(p2): boolean
				return item ~= nil and v.store.getCurrentItem(p2) == item
			end)
		end, { v, item })))

		React.useEffect(function()
			if v3 then
				return
			end

			for _, v4 in ref.current do
				v4.current = false
			end
		end, { v3 })

		return React.createElement(context.Provider, { value = v2 }, p.children)
	end,
	useImpressionRef = function(p: string)
		local v = React.useContext(context)
		local ref = React.useRef(false)

		if v == nil then
			return ref
		end

		return (v(p))
	end
})
