local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local Signals = require(parent.Signals)

local GuiService = game:GetService("GuiService")

local useCallback = React.useCallback
local useEffect = React.useEffect
local useMemo = React.useMemo
local useRef = React.useRef
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets

local computeSeekFraction = require(MomentsCreation.Utils.computeSeekFraction)
local FFlagMomentsTTSScrubberDragInOverlay = require(MomentsCreation.Flags.FFlagMomentsTTSScrubberDragInOverlay)
local FFlagMomentsScrubberSeekOnRelease = require(MomentsCreation.Flags.FFlagMomentsScrubberSeekOnRelease)
require(MomentsCreation.Types.CreationFlowTypes)

local engineFeature = game:GetEngineFeature("UIDragDetectorFixEventPositionEnabled")

local function useTimelineSeekController(data, callback, flag: boolean, flag2: boolean)
	local containerRef = useRef(nil)
	local dragDetectorRef = useRef(nil)
	local playheadDragDetectorRef

	if FFlagMomentsTTSScrubberDragInOverlay then
		playheadDragDetectorRef = useRef(nil)
	else
		playheadDragDetectorRef = nil
	end

	local v = useRef(false)
	local v2 = useRef(false)
	local v3, get, set

	if FFlagMomentsScrubberSeekOnRelease then
		v3 = useRef(nil)

		local v4 = useMemo(function()
			local signal, set2 = Signals.createSignal(nil)
			return { get = signal, set = set2 }
		end, {})
		get = v4.get
		set = v4.set
	else
		set = nil
		v3 = nil
	end

	local v4 = useDeviceInsets()

	local v5 = useCallback(function(p: number)
		local current = containerRef.current

		if not current then
			return
		end

		local v5 = computeSeekFraction(p, current.AbsolutePosition.X, current.AbsoluteSize.X)
		local current2 = v5 * data.getDuration(false)

		if FFlagMomentsScrubberSeekOnRelease and set and v3 then
			set(v5)
			v3.current = current2
		else
			data.seek(current2)

			if callback then
				callback(current2)
			end
		end
	end, { data, callback, set })

	local v6 = useCallback(function(vector2: Vector2)
		if engineFeature then
			return vector2.X
		end

		local guiInset = GuiService:GetGuiInset()
		return vector2.X - (guiInset.X + v4.left)
	end, { v4 })

	local v7 = useCallback(function()
		if data.getIsPlaying(false) then
			v2.current = true
			data.toggle()
		end
	end, { data })

	local v8 = useCallback(function(vector2: Vector2)
		v.current = true

		if flag2 then
			return
		end

		v7()
		v5(v6(vector2))
	end, { v7, v5, v6, flag2 })

	local v9 = useCallback(function(vector2: Vector2)
		if not v.current then
			return
		end

		if flag2 then
			v7()
		end

		v5(v6(vector2))
	end, { v7, v5, v6, flag2 })

	local v10 = useCallback(function()
		if not v.current then
			return
		end

		v.current = false

		if FFlagMomentsScrubberSeekOnRelease and v3 and set then
			local current = v3.current
			v3.current = nil

			if current ~= nil then
				data.seek(current)

				if callback then
					callback(current)
				end
			end

			set(nil)
		end

		if v2.current and not data.getIsPlaying(false) then
			data.toggle()
		end

		v2.current = false
	end, { data, callback, set })

	useEffect(function()
		if not flag then
			return
		end

		local current = dragDetectorRef.current

		if current == nil then
			return
		end

		local connections = {
			current.DragStart:Connect(v8),
			current.DragContinue:Connect(v9),
			current.DragEnd:Connect(v10)
		}

		if FFlagMomentsTTSScrubberDragInOverlay and playheadDragDetectorRef then
			local current2 = playheadDragDetectorRef.current

			if current2 ~= nil then
				table.insert(connections, current2.DragStart:Connect(v8))
				table.insert(connections, current2.DragContinue:Connect(v9))
				table.insert(connections, current2.DragEnd:Connect(v10))
			end
		end

		return function()
			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end, { flag, v8, v9, v10 })

	return {
		containerRef = containerRef,
		dragDetectorRef = dragDetectorRef,
		playheadDragDetectorRef = playheadDragDetectorRef,
		getDragFraction = get
	}
end

return useTimelineSeekController
