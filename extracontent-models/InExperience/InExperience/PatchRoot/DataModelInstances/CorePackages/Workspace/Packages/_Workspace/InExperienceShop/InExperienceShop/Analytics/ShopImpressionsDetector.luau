local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local React = require(parent.React)

local FIntScanFrequencyInExperienceShop = require(InExperienceShop.Flags.FIntScanFrequencyInExperienceShop)
local isShopInstanceVisible = require(script.Parent.isShopInstanceVisible)

local function ShopImpressionsDetector(data): nil
	local ref = React.useRef(true)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)

	local scanDebounceSeconds = data.scanDebounceSeconds or FIntScanFrequencyInExperienceShop

	local v = React.useCallback(function()
		if data.getViewPortBounds then
			return data.getViewPortBounds()
		end

		return data.viewPortBounds
	end, { data.getViewPortBounds, data.viewPortBounds })

	local v2 = React.useCallback(function()
		if not ref.current or data.pageFilter and not data.pageFilter(nil) then
			return
		end

		local v2 = v()

		if v2 == nil then
			return
		end

		local current = data.parentRef and data.parentRef.current

		if not (current and isShopInstanceVisible(current, v2)) then
			return
		end

		ref2.current = tick()
		local guiObjects = {}
		local collectObjectsFunc = data.collectObjectsFunc
		local v3

		if collectObjectsFunc then
			v3 = collectObjectsFunc(current)
		else
			v3 = current:GetChildren()
		end

		for _, guiObject in v3 do
			if not (guiObject:IsA("GuiObject") and isShopInstanceVisible(guiObject, v2) and (data.filterImpressionFunc == nil or data.filterImpressionFunc(guiObject))) then
				continue
			end

			table.insert(guiObjects, guiObject)
		end

		if #guiObjects > 0 then
			data.onImpressionsDetected(guiObjects)
		end
	end, {
		data.parentRef,
		data.pageFilter,
		data.collectObjectsFunc,
		data.filterImpressionFunc,
		data.onImpressionsDetected,
		v
	})

	local v3 = React.useCallback(function()
		if not (ref.current and ref3.current == nil and (data.parentRef and data.parentRef.current)) then
			return
		end

		local current = ref2.current
		local v3

		if current == nil then
			v3 = 0
		else
			local current2 = current + scanDebounceSeconds
			ref3.current = current2
			v3 = current2 - tick()
		end

		if v3 > 0 then
			task.delay(v3, function()
				if not ref.current then
					return
				end

				if ref3.current ~= nil and tick() > ref3.current then
					ref3.current = nil
					v2()
				end
			end)
			return
		end

		ref3.current = nil
		v2()
	end, { data.parentRef, scanDebounceSeconds, v2 })

	React.useEffect(function()
		ref.current = true
		v3()

		local onRequestImpressionsSignalConnection = data.onRequestImpressionsSignal:connect(function()
			v3()
		end)

		return function()
			ref.current = false
			onRequestImpressionsSignalConnection:disconnect()
		end
	end, { data.onRequestImpressionsSignal, v3 })

	React.useEffect(function()
		v3()
	end, { v, v3 })

	return nil
end

return ShopImpressionsDetector
