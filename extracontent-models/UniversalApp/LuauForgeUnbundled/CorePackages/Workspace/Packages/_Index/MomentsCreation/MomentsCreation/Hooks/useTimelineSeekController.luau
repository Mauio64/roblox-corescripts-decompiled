local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals")

local GuiService = game:GetService("GuiService")

local useCallback = React.useCallback
local useEffect = React.useEffect
local useMemo = React.useMemo
local useRef = React.useRef
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets

local computeSeekFraction = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/computeSeekFraction")
local FFlagMomentsTTSScrubberDragInOverlay = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsTTSScrubberDragInOverlay")
local FFlagMomentsScrubberSeekOnRelease = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsScrubberSeekOnRelease")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")

local engineFeature = game:GetEngineFeature("UIDragDetectorFixEventPositionEnabled")

local function useTimelineSeekController(data, callback, p2, p3)
	local v5 = useRef(nil)
	local v6 = useRef(nil)

	local v7 = if FFlagMomentsTTSScrubberDragInOverlay then useRef(nil) else nil

	local v8 = useRef(false)
	local v9 = useRef(false)
	local v10, get, set

	if FFlagMomentsScrubberSeekOnRelease then
		v10 = useRef(nil)

		local v11 = useMemo(function()
			local signal, v12 = Signals.createSignal(nil)
			return { get = signal, set = v12 }
		end, {})
		get = v11.get
		set = v11.set
	else
		set = nil
		v10 = nil
	end

	local v11 = useDeviceInsets()

	local v12 = useCallback(function(p4)
		local current = v5.current

		if not current then
			return
		end

		local v13 = computeSeekFraction(p4, current.AbsolutePosition.X, current.AbsoluteSize.X)
		local v14 = v13 * data.getDuration(false)

		if FFlagMomentsScrubberSeekOnRelease and set and v10 then
			set(v13)
			v10.current = v14
		else
			data.seek(v14)

			if callback then
				callback(v14)
			end
		end
	end, { data, callback, set })

	local v13 = useCallback(function(p4)
		if engineFeature then
			return p4.X
		end

		local guiInset = GuiService:GetGuiInset()
		return p4.X - (guiInset.X + v11.left)
	end, { v11 })

	local v14 = useCallback(function()
		if data.getIsPlaying(false) then
			v9.current = true
			data.toggle()
		end
	end, { data })

	local v15 = useCallback(function(p4)
		v8.current = true

		if p3 then
			return
		end

		v14()
		v12(v13(p4))
	end, { v14, v12, v13, p3 })

	local v16 = useCallback(function(p4)
		if not v8.current then
			return
		end

		if p3 then
			v14()
		end

		v12(v13(p4))
	end, { v14, v12, v13, p3 })

	local v17 = useCallback(function()
		if not v8.current then
			return
		end

		v8.current = false

		if FFlagMomentsScrubberSeekOnRelease and v10 and set then
			local current = v10.current
			v10.current = nil

			if current ~= nil then
				data.seek(current)

				if callback then
					callback(current)
				end
			end

			set(nil)
		end

		if v9.current and not data.getIsPlaying(false) then
			data.toggle()
		end

		v9.current = false
	end, { data, callback, set })

	useEffect(function()
		if not p2 then
			return
		end

		local current = v6.current

		if current == nil then
			return
		end

		local connections = {
			current.DragStart:Connect(v15),
			current.DragContinue:Connect(v16),
			current.DragEnd:Connect(v17)
		}

		if FFlagMomentsTTSScrubberDragInOverlay and v7 then
			local current2 = v7.current

			if current2 ~= nil then
				table.insert(connections, current2.DragStart:Connect(v15))
				table.insert(connections, current2.DragContinue:Connect(v16))
				table.insert(connections, current2.DragEnd:Connect(v17))
			end
		end

		return function()
			for k, connection in connections do
				connection:Disconnect()
			end
		end
	end, { p2, v15, v16, v17 })

	return {
		containerRef = v5,
		dragDetectorRef = v6,
		playheadDragDetectorRef = v7,
		getDragFraction = get
	}
end

return useTimelineSeekController
