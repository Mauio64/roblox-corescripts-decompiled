local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

require(parent.MomentsTypes)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)

local useAnimatedBinding = ReactOtter.useAnimatedBinding
local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef

local Constants = require(MomentsCreation.Constants)

local SegmentSelectorWidth = Constants.AudioWaveform.SegmentSelectorWidth

local function useMusicEditorController(flag: boolean, callback, callback2, callback3, p, p2: number)
	local waveformRef = useRef(nil)
	local waveformDisplayRef = useRef(nil)
	local waveformPosition, v = useAnimatedBinding(0)
	local v2 = useRef(nil)

	local v3 = useCallback(function()
		v2.current = waveformPosition:getValue()
		callback2()
	end, { callback2 })

	local v4 = useCallback(function()
		local current = waveformRef.current
		local current2 = waveformDisplayRef.current

		if current == nil or current2 == nil then
			return
		end

		local current3 = v2.current or 0
		local v4 = current.DragUDim2.X.Offset / SegmentSelectorWidth
		local v5 = current2.AbsoluteSize.X / SegmentSelectorWidth

		if 1 - v5 > 0 then
			return
		end

		local v6 = math.clamp(current3 + v4, 1 - v5, 0)
		callback3(p2 * (-v6 / v5))
		v(ReactOtter.instant(v6))
	end, { p2, callback3 })

	local v5 = useCallback(function()
		v2.current = nil
		callback()
	end, { callback })

	useEffect(function()
		if not flag then
			return
		end

		local connections = {}
		local current = waveformRef.current

		if current ~= nil then
			table.insert(connections, current.DragStart:Connect(v3))
			table.insert(connections, current.DragContinue:Connect(v4))
			table.insert(connections, current.DragEnd:Connect(v5))
		end

		return function()
			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end, { flag, v3, v4, v5 })

	useEffect(function()
		local current = waveformDisplayRef.current

		if current == nil or p2 <= 0 then
			return
		end

		local v6 = current.AbsoluteSize.X / SegmentSelectorWidth
		v(ReactOtter.instant(-p.startTime / p2 * v6))
	end, { p.startTime, p2 })

	return {
		waveformRef = waveformRef,
		waveformPosition = waveformPosition,
		waveformDisplayRef = waveformDisplayRef
	}
end

return useMusicEditorController
