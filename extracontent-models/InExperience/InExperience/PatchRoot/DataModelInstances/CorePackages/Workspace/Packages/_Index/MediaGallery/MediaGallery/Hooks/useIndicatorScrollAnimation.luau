local MediaGallery = script:FindFirstAncestor("MediaGallery")
local MediaGalleryParent = MediaGallery.Parent
local Otter = require(MediaGalleryParent.Otter)
local React = require(MediaGalleryParent.React)

require(MediaGalleryParent.ReactOtter)
require(MediaGalleryParent.AppCommonLib)

local MAX_VISIBLE_INDICATORS = require(MediaGallery.MediaGalleryConstants).MAX_VISIBLE_INDICATORS

local function getFirstVisibleIndex(n1: number, n2: number, s1: string) -- line: 21
	-- upvalues: MAX_VISIBLE_INDICATORS (copy)
	if n1 <= MAX_VISIBLE_INDICATORS then
		return 1
	end

	if s1 == "Right" then
		return (math.max(1, math.min(n2, n1 - 2) - MAX_VISIBLE_INDICATORS + 2 + 1))
	end

	return (math.min(n1 - MAX_VISIBLE_INDICATORS + 1, math.max(n2, 3) - 2))
end
local function useIndicatorScrollAnimation(t1: {[any]: any}) -- line: 54
	-- upvalues: React (copy), MAX_VISIBLE_INDICATORS (copy), Otter (copy)
	local v12, v13 = React.useState(t1.startIndex)
	local v14, v15 = React.useState(t1.startIndex)
	local v16, v17 = React.useState(1)
	local v18, v19 = React.useBinding(Vector2.new(0, 0))
	local v20, v21 = React.useState(false)
	local v22, v23 = React.useBinding(0)
	local v24 = React.useCallback(function(n3: number) -- line: 63
		-- upvalues: t1 (copy)
		return Vector2.new((n3 - 1) * (t1.indicatorSize + t1.indicatorPadding), 0)
	end, {
		t1.indicatorSize,
		t1.indicatorPadding
	})

	React.useEffect(function() -- line: 70
		-- upvalues: t1 (copy), MAX_VISIBLE_INDICATORS (copy), v19 (copy), v24 (copy), v17 (copy), v23 (copy), v15 (copy), v13 (copy)
		local numberOfItems = t1.numberOfItems
		local startIndex = t1.startIndex
		local v28 = if not (numberOfItems <= MAX_VISIBLE_INDICATORS) then math.max(1, math.min(startIndex, numberOfItems - 2) - MAX_VISIBLE_INDICATORS + 2 + 1) else 1

		v19(v24(v28))
		v17(v28)
		v23(1)
		v15(t1.startIndex)
		v13(t1.startIndex)
	end, {
		t1.numberOfItems,
		t1.startIndex,
		v24
	})
	React.useEffect(function() -- line: 83
		-- upvalues: t1 (copy), v13 (copy), v15 (copy), v17 (copy), MAX_VISIBLE_INDICATORS (copy), v21 (copy)
		local u29 = t1.scrolledSignal:connect(function(n4: number) -- line: 84
			-- upvalues: v13 (copy), v15 (copy), v17 (copy), t1 (copy), MAX_VISIBLE_INDICATORS (copy), v21 (copy)
			v13(function(p1) -- line: 85
				-- upvalues: n4 (copy), v15 (copy), v17 (copy), t1 (copy), MAX_VISIBLE_INDICATORS (copy), v21 (copy)
				local v36 = not (p1 < n4) and "Left" or "Right"

				v15(p1)

				local v37 = v17
				local numberOfItems = t1.numberOfItems
				local v39 = n4

				v37(if not (numberOfItems <= MAX_VISIBLE_INDICATORS) then if v36 ~= "Right" then math.min(numberOfItems - MAX_VISIBLE_INDICATORS + 1, math.max(v39, 3) - 2) else math.max(1, math.min(v39, numberOfItems - 2) - MAX_VISIBLE_INDICATORS + 2 + 1) else 1)
				v21(true)

				return n4
			end)
		end)

		return function() -- line: 94
			-- upvalues: u29 (ref)
			if u29 ~= nil then
				u29:disconnect()
				u29 = nil
			end
		end
	end, {
		t1.numberOfItems,
		t1.scrolledSignal
	})
	React.useEffect(function() -- line: 107
		-- upvalues: v20 (copy), Otter (copy), t1 (copy), v18 (copy), v24 (copy), v16 (copy), v23 (copy), v19 (copy), v21 (copy)
		if not v20 then
			return
		end

		local v30 = Otter.createSingleMotor(0)

		v30:setGoal(if not t1.useSpring then Otter.instant(1) else Otter.spring(1, t1.springConfig))

		local v31 = v18:getValue()
		local v32 = v24(v16)

		v30:onStep(function(n5: number) -- line: 118
			-- upvalues: v23 (copy), v19 (copy), v31 (copy), v32 (copy)
			v23(n5)
			v19(v31:Lerp(v32, n5))
		end)
		v30:onComplete(function() -- line: 123
			-- upvalues: v21 (copy)
			v21(false)
		end)

		return function() -- line: 127
			-- upvalues: v30 (copy)
			v30:destroy()
		end
	end, {
		t1.useSpring,
		t1.springConfig,
		v20,
		v16,
		v24
	})

	return {
		currentItemIndex = v12,
		previousItemIndex = v14,
		firstVisibleIndex = v16,
		animationProgressBinding = v22,
		canvasPositionBinding = v18
	}
end

return useIndicatorScrollAnimation
