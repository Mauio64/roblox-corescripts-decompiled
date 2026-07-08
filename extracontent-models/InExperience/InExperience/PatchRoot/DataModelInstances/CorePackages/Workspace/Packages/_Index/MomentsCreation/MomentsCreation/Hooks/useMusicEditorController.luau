local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent

require(MomentsCreationParent.MomentsTypes)

local React = require(MomentsCreationParent.React)
local ReactOtter = require(MomentsCreationParent.ReactOtter)
local useAnimatedBinding = ReactOtter.useAnimatedBinding
local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef
local SegmentSelectorWidth = require(MomentsCreation.Constants).AudioWaveform.SegmentSelectorWidth

local function useMusicEditorController(b1: boolean, p1: ((...any) -> ...any), p2: ((...any) -> ...any), p3: ((...any) -> ...any), p4, n1: number) -- line: 27
	-- upvalues: useRef (copy), useAnimatedBinding (copy), useCallback (copy), SegmentSelectorWidth (copy), ReactOtter (copy), useEffect (copy)
	local v17 = useRef(nil)
	local v18 = useRef(nil)
	local v19, v20 = useAnimatedBinding(0)
	local v21 = useRef(nil)
	local v22 = useCallback(function() -- line: 40
		-- upvalues: v21 (copy), v19 (copy), p2 (copy)
		v21.current = v19:getValue()
		p2()
	end, { p2 })
	local v23 = useCallback(function() -- line: 45
		-- upvalues: v17 (copy), v18 (copy), v21 (copy), SegmentSelectorWidth (copy), p3 (copy), n1 (copy), v20 (copy), ReactOtter (copy)
		local current = v17.current
		local current2 = v18.current

		if current == nil or current2 == nil then
			return
		end

		local v27 = v21.current or 0
		local v28 = current.DragUDim2.X.Offset / SegmentSelectorWidth
		local v29 = current2.AbsoluteSize.X / SegmentSelectorWidth

		if 1 - v29 > 0 then
			return
		end

		local v30 = math.clamp(v27 + v28, 1 - v29, 0)

		p3(n1 * (-v30 / v29))
		v20(ReactOtter.instant(v30))
	end, {
		n1,
		p3
	})
	local v24 = useCallback(function() -- line: 66
		-- upvalues: v21 (copy), p1 (copy)
		v21.current = nil
		p1()
	end, { p1 })

	useEffect(function() -- line: 71
		-- upvalues: b1 (copy), v17 (copy), v22 (copy), v23 (copy), v24 (copy)
		if not b1 then
			return
		end

		local t1 = {}
		local current = v17.current

		if current ~= nil then
			table.insert(t1, current.DragStart:Connect(v22))
			table.insert(t1, current.DragContinue:Connect(v23))
			table.insert(t1, current.DragEnd:Connect(v24))
		end

		return function() -- line: 84
			-- upvalues: t1 (copy)
			for _, v36 in t1 do
				v36:Disconnect()
			end
		end
	end, {
		b1,
		v22,
		v23,
		v24
	})
	useEffect(function() -- line: 91
		-- upvalues: v18 (copy), n1 (copy), SegmentSelectorWidth (copy), v20 (copy), ReactOtter (copy), p4 (copy)
		local current = v18.current

		if current == nil or n1 <= 0 then
			return
		end

		local v34 = current.AbsoluteSize.X / SegmentSelectorWidth

		v20(ReactOtter.instant(-p4.startTime / n1 * v34))
	end, {
		p4.startTime,
		n1
	})

	return {
		waveformRef = v17,
		waveformPosition = v19,
		waveformDisplayRef = v18
	}
end

return useMusicEditorController
