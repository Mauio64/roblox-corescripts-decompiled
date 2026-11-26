require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsTypes")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/ReactOtter")

local useAnimatedBinding = ReactOtter.useAnimatedBinding
local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef

local segmentSelectorWidth = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Constants").AudioWaveform.SegmentSelectorWidth

local function useMusicEditorController(p2, callback, callback2, callback3, p3, p4)
	local v5 = useRef(nil)
	local v6 = useRef(nil)
	local v7, v8 = useAnimatedBinding(0)
	local v9 = useRef(nil)

	local v10 = useCallback(function()
		v9.current = v7:getValue()
		callback2()
	end, { callback2 })

	local v11 = useCallback(function()
		local current = v5.current
		local current2 = v6.current

		if current == nil or current2 == nil then
			return
		end

		local current3 = v9.current or 0
		local v12 = current.DragUDim2.X.Offset / segmentSelectorWidth
		local v13 = current2.AbsoluteSize.X / segmentSelectorWidth

		if 1 - v13 > 0 then
			return
		end

		local v14 = math.clamp(current3 + v12, 1 - v13, 0)
		callback3(p4 * (-v14 / v13))
		v8(ReactOtter.instant(v14))
	end, { p4, callback3 })

	local v12 = useCallback(function()
		v9.current = nil
		callback()
	end, { callback })

	useEffect(function()
		if not p2 then
			return
		end

		local connections = {}
		local current = v5.current

		if current ~= nil then
			table.insert(connections, current.DragStart:Connect(v10))
			table.insert(connections, current.DragContinue:Connect(v11))
			table.insert(connections, current.DragEnd:Connect(v12))
		end

		return function()
			for k, connection in connections do
				connection:Disconnect()
			end
		end
	end, { p2, v10, v11, v12 })

	useEffect(function()
		local current = v6.current

		if current == nil or p4 <= 0 then
			return
		end

		local v13 = current.AbsoluteSize.X / segmentSelectorWidth
		v8(ReactOtter.instant(-p3.startTime / p4 * v13))
	end, { p3.startTime, p4 })

	return { waveformRef = v5, waveformPosition = v7, waveformDisplayRef = v6 }
end

return useMusicEditorController
