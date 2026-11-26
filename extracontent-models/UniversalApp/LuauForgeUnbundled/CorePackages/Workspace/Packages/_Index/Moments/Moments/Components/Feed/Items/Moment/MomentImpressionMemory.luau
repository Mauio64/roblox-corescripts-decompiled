local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local VerticalPager = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/VerticalPager")

local useSignalState = SignalsReact.useSignalState
local useVerticalPager = VerticalPager.useVerticalPager
local usePagerItem = VerticalPager.usePagerItem

local context = React.createContext(nil)

return table.freeze({
	Provider = function(p2)
		local v5 = useVerticalPager()
		local item = usePagerItem().item

		local ref = React.useRef({})
		local v6 = React.useCallback(function(p3)
			local v7 = ref.current[p3]

			if v7 == nil then
				v7 = { current = false }
				ref.current[p3] = v7
			end

			return v7
		end, {})

		local v8 = useSignalState((React.useMemo(function()
			return Signals.createComputed(function(p3): boolean
				return item ~= nil and v5.store.getCurrentItem(p3) == item
			end)
		end, { v5, item })))

		React.useEffect(function()
			if v8 then
				return
			end

			for k, v9 in ref.current do
				v9.current = false
			end
		end, { v8 })

		return React.createElement(context.Provider, { value = v6 }, p2.children)
	end,
	useImpressionRef = function(p2)
		local v5 = React.useContext(context)
		local ref = React.useRef(false)

		if v5 == nil then
			return ref
		end

		return (v5(p2))
	end
})
