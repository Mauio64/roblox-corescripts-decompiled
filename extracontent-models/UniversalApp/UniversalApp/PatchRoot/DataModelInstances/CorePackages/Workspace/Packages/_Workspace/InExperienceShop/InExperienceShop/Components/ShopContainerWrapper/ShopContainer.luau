local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local React = require(InExperienceShopParent.React)
local SignalsReact = require(InExperienceShopParent.SignalsReact)
local FFlagEnableShopPrefetch = require(InExperienceShop.Flags.FFlagEnableShopPrefetch)
local getInExperienceShopStore = require(InExperienceShop.Stores.getInExperienceShopStore)
local logCounter = require(InExperienceShop.Internal.logCounter)
local ShopDebugLogger = require(InExperienceShop.Internal.ShopDebugLogger)
local FirstOpenCounter = require(InExperienceShop.Events.FirstOpenCounter)
local FirstOpenPrefetchHitCounter = require(InExperienceShop.Events.FirstOpenPrefetchHitCounter)
local OpenCounter = require(InExperienceShop.Events.OpenCounter)
local ShopView = require(script.Parent.ShopView)
local useShopViewModel = require(script.Parent.useShopViewModel)
local u14 = false

local function ShopContainer(p1) -- line: 25
	-- upvalues: SignalsReact (copy), getInExperienceShopStore (copy), React (copy), FFlagEnableShopPrefetch (copy), u14 (ref), ShopDebugLogger (copy), logCounter (copy), OpenCounter (copy), FirstOpenCounter (copy), FirstOpenPrefetchHitCounter (copy), useShopViewModel (copy), ShopView (copy)
	local v17 = SignalsReact.useSignalState(getInExperienceShopStore)

	React.useEffect(function() -- line: 43
		-- upvalues: FFlagEnableShopPrefetch (copy), u14 (ref), ShopDebugLogger (copy), logCounter (copy), OpenCounter (copy), FirstOpenCounter (copy), v17 (copy), FirstOpenPrefetchHitCounter (copy)
		local v19 = FFlagEnableShopPrefetch and not u14

		ShopDebugLogger.logLazy(function() -- line: 51
			-- upvalues: v19 (copy)
			return "ShopContainer: mount isFirstOpen=" .. tostring(v19)
		end)
		logCounter(OpenCounter)

		if v19 then
			u14 = true
			logCounter(FirstOpenCounter)

			local v20 = #v17.getCategories(false) > 0

			ShopDebugLogger.logLazy(function() -- line: 61
				-- upvalues: v20 (copy)
				return "ShopContainer: prefetch cache hit=" .. tostring(v20)
			end)

			if v20 then
				logCounter(FirstOpenPrefetchHitCounter)
			end
		end

		task.spawn(function() -- line: 68
			-- upvalues: ShopDebugLogger (copy), v17 (copy)
			ShopDebugLogger.log("ShopContainer: calling onShopOpened")
			v17.onShopOpened()
		end)
	end, {
		v17.onShopOpened,
		v17.getCategories
	})

	local v18 = useShopViewModel(p1)

	return React.createElement(ShopView, v18)
end

return ShopContainer
