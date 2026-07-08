local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local React = require(InExperienceShopParent.React)
local FIntScanFrequencyInExperienceShop = require(InExperienceShop.Flags.FIntScanFrequencyInExperienceShop)
local isShopInstanceVisible = require(script.Parent.isShopInstanceVisible)

local function ShopImpressionsDetector(t1: {[any]: any}) -- line: 25
	-- upvalues: React (copy), FIntScanFrequencyInExperienceShop (copy), isShopInstanceVisible (copy)
	local v8 = React.useRef(true)
	local v9 = React.useRef(nil)
	local v10 = React.useRef(nil)
	local v11 = t1.scanDebounceSeconds or FIntScanFrequencyInExperienceShop
	local v12 = React.useCallback(function() -- line: 32
		-- upvalues: t1 (copy)
		if t1.getViewPortBounds then
			return t1.getViewPortBounds()
		end

		return t1.viewPortBounds
	end, {
		t1.getViewPortBounds,
		t1.viewPortBounds
	})
	local v13 = React.useCallback(function() -- line: 40
		-- upvalues: v8 (copy), t1 (copy), v12 (copy), isShopInstanceVisible (copy), v9 (copy)
		if not v8.current then
			return
		end

		if t1.pageFilter and not t1.pageFilter(nil) then
			return
		end

		local v15 = v12()

		if v15 == nil then
			return
		end

		local v16 = t1.parentRef and t1.parentRef.current

		if not v16 or not isShopInstanceVisible(v16, v15) then
			return
		end

		v9.current = tick()

		local t2 = {}
		local collectObjectsFunc = t1.collectObjectsFunc

		for _, v20 in if not collectObjectsFunc then v16:GetChildren() else collectObjectsFunc(v16) do
			if v20:IsA("GuiObject") and isShopInstanceVisible(v20, v15) and (t1.filterImpressionFunc == nil or t1.filterImpressionFunc(v20)) then
				table.insert(t2, v20)
			end
		end

		if #t2 > 0 then
			t1.onImpressionsDetected(t2)
		end
	end, {
		t1.parentRef,
		t1.pageFilter,
		t1.collectObjectsFunc,
		t1.filterImpressionFunc,
		t1.onImpressionsDetected,
		v12
	})
	local v14 = React.useCallback(function() -- line: 90
		-- upvalues: v8 (copy), v10 (copy), t1 (copy), v9 (copy), v11 (copy), v13 (copy)
		if not v8.current then
			return
		end

		if v10.current ~= nil then
			return
		end

		if not t1.parentRef or not t1.parentRef.current then
			return
		end

		local n1 = 0
		local current = v9.current

		if current ~= nil then
			local v23 = current + v11

			v10.current = v23
			n1 = v23 - tick()
		end

		if n1 > 0 then
			task.delay(n1, function() -- line: 112
				-- upvalues: v8 (copy), v10 (copy), v13 (copy)
				if not v8.current then
					return
				end

				if v10.current ~= nil and tick() > v10.current then
					v10.current = nil
					v13()
				end
			end)

			return
		end

		v10.current = nil
		v13()
	end, {
		t1.parentRef,
		v11,
		v13
	})

	React.useEffect(function() -- line: 127
		-- upvalues: v8 (copy), v14 (copy), t1 (copy)
		v8.current = true
		v14()

		local v24 = t1.onRequestImpressionsSignal:connect(function() -- line: 131
			-- upvalues: v14 (copy)
			v14()
		end)

		return function() -- line: 135
			-- upvalues: v8 (copy), v24 (copy)
			v8.current = false
			v24:disconnect()
		end
	end, {
		t1.onRequestImpressionsSignal,
		v14
	})
	React.useEffect(function() -- line: 141
		-- upvalues: v14 (copy)
		v14()
	end, {
		v12,
		v14
	})

	return nil
end

return ShopImpressionsDetector
