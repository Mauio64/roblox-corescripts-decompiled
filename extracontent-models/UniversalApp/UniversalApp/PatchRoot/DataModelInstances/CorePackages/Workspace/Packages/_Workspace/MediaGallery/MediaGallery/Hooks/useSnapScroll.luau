local MediaGallery = script:FindFirstAncestor("MediaGallery")
local MediaGalleryParent = MediaGallery.Parent
local Otter = require(MediaGalleryParent.Otter)
local React = require(MediaGalleryParent.React)

require(MediaGalleryParent.ReactOtter)

local Signal = require(MediaGalleryParent.AppCommonLib).Signal

require(MediaGallery.MediaGalleryTypes)

local function useSnapScroll(t1: {[any]: any}) -- line: 51
	-- upvalues: React (copy), Signal (copy), Otter (copy)
	local v8, v9 = React.useState(t1.targetIndex or 1)
	local v10 = React.useRef(v8)

	v10.current = v8

	local v11, v12 = React.useBinding(Vector2.new(0, 0))
	local v13 = React.useRef(nil)
	local v14 = React.useRef(false)
	local v15 = React.useRef(nil)
	local v16 = React.useCallback(function(n1: number) -- line: 65
		-- upvalues: v11 (copy), t1 (copy)
		if n1 == 1 then
			return Vector2.new(0, 0)
		end

		local v23 = v11:getValue().X + t1.itemPadding

		return Vector2.new(v23, 0)
	end, { t1.itemPadding })
	local v17, v18 = React.useBinding(v16(v8))

	React.useEffect(function() -- line: 79
		-- upvalues: v11 (copy), v18 (copy), v16 (copy), v8 (copy)
		if v11:getValue().X > 0 then
			v18(v16(v8))
		end
	end, {
		v16,
		v8
	})

	local v19 = React.useRef(Signal.new())
	local v20 = React.useCallback(function(p1, b1: boolean?) -- line: 88
		-- upvalues: v14 (copy), v17 (copy), v11 (copy), t1 (copy), v10 (copy), v19 (copy), v15 (copy), Otter (copy), v18 (copy), v9 (copy)
		if v14.current then
			return
		end

		local v26 = v17:getValue()
		local v27 = v11:getValue().X + t1.itemPadding
		local current = v10.current
		local u29, u30

		if p1 == "Right" then
			u29 = current + 1
			u30 = v26 + Vector2.new(v27, 0)
		else
			u29 = current - 1
			u30 = v26 - Vector2.new(v27, 0)
		end

		if u29 < 1 or t1.itemCount < u29 then
			return
		end

		v14.current = true
		v19.current:fire(u29)

		if v15.current then
			v15.current:destroy()
		end

		local v31 = Otter.createSingleMotor(0)

		v15.current = v31
		v31:onStep(function(n2: number) -- line: 121
			-- upvalues: v18 (copy), v26 (copy), u30 (ref)
			v18(v26:Lerp(u30, n2))
		end)
		v31:onComplete(function() -- line: 125
			-- upvalues: v14 (copy), v15 (copy), v10 (copy), u29 (ref), v9 (copy), t1 (copy), b1 (copy)
			v14.current = false
			v15.current = nil
			v10.current = u29
			v9(u29)

			if t1.onScrollComplete then
				t1.onScrollComplete(u29, b1)
			end
		end)

		if t1.springConfig then
			v31:setGoal(Otter.spring(1, t1.springConfig))
		else
			v31:setGoal(Otter.instant(1))
		end
	end, {
		t1.itemCount,
		t1.itemPadding,
		t1.springConfig,
		t1.onScrollComplete,
		v17
	})
	local v21 = React.useCallback(function(p2) -- line: 151
		-- upvalues: v12 (copy), v14 (copy), v18 (copy), v16 (copy), v10 (copy)
		v12(p2.AbsoluteSize)

		if not v14.current then
			v18(v16(v10.current))
		end
	end, { v16 })

	React.useEffect(function() -- line: 159
		-- upvalues: v9 (copy), t1 (copy)
		v9(t1.targetIndex or 1)
	end, { t1.targetIndex })
	React.useEffect(function() -- line: 165
		-- upvalues: v15 (copy)
		return function() -- line: 166
			-- upvalues: v15 (copy)
			if v15.current then
				v15.current:destroy()
				v15.current = nil
			end
		end
	end, {})

	return {
		currentIndex = v8,
		canvasPosition = v17,
		scrolledSignal = v19.current,
		scrollingFrameRef = v13,
		absoluteSizeBinding = v11,
		scrollInDirection = v20,
		onAbsoluteSizeChanged = v21
	}
end

return useSnapScroll
