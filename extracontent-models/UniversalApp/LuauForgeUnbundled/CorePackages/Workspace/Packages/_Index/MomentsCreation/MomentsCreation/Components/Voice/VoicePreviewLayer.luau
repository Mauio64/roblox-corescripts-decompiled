local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals")

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")

local GetFFlagMomentsTTSStartTimePositioning = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/GetFFlagMomentsTTSStartTimePositioning")

local useEffect = React.useEffect
local useRef = React.useRef
local useState = React.useState

local function VoicePreviewLayer(p2): nil
	local controller = p2.controller

	local ttsAudio = controller.ttsAudio
	assert(ttsAudio ~= nil, "VoicePreviewLayer requires controller.ttsAudio")

	local state, setState = useState(controller.getActiveTool(false))
	local state2, setState2 = useState(controller.getEffectiveTTS(false))

	local state3, setState3 = useState(ttsAudio.getIsLoaded(false))
	useEffect(function()
		return Signals.createEffect(function(p3)
			setState(controller.getActiveTool(p3))
			setState2(controller.getEffectiveTTS(p3))
			setState3(ttsAudio.getIsLoaded(p3))
		end)
	end, { controller, ttsAudio })

	local v5 = useRef(false)
	local v6 = useRef(0)

	local v7 = not (state == nil) and state.kind == "voice"
	local v8 = not v7 and state2 ~= nil
	local v9 = state2 == nil and "" or `{state2.text}:{state2.voiceId}`

	local v10 = state2 == nil and 0 or state2.startTime or 0

	useEffect(function()
		if not v8 or state2 == nil then
			return
		end

		ttsAudio.generate(state2.text, state2.voiceId)
	end, { v8, v9 })

	useEffect(function()
		if v7 and v5.current then
			ttsAudio.pause()
			v5.current = false
		end
	end, { v7 })

	local state4, setState4 = useState(controller.preview.playback.getIsPlaying(false))
	useEffect(function()
		return Signals.createEffect(function(p3)
			setState4(controller.preview.playback.getIsPlaying(p3))
		end)
	end, { controller })

	useEffect(function()
		if not v8 or state2 == nil or not ttsAudio.getIsLoaded(false) then
			return
		end

		local timeLength = ttsAudio.getTimeLength(false)

		if timeLength <= 0 then
			return
		end

		local startTime = state2.startTime or 0
		local v11 = startTime + timeLength

		local position = controller.preview.playback.getPosition(false)

		if state4 and startTime <= position and position < v11 then
			local v12 = position - startTime

			if math.abs(ttsAudio.getTimePosition(false) - v12) > 0.1 then
				ttsAudio.seek(v12)
			end

			ttsAudio.play()
			v5.current = true
		elseif (not state4 or GetFFlagMomentsTTSStartTimePositioning) and v5.current then
			ttsAudio.pause()
			v5.current = false
		end

		return function()
			if v5.current then
				ttsAudio.pause()
				v5.current = false
			end
		end
	end, { v8, v9, v10, state4, state3 })

	useEffect(function()
		if not v8 or state2 == nil then
			return
		end

		local startTime = state2.startTime or 0

		return Signals.createEffect(function(p3)
			local position = controller.preview.playback.getPosition(p3)
			local current = v6.current
			v6.current = position

			if not (ttsAudio.getIsLoaded(false) and controller.preview.playback.getIsPlaying(false)) then
				return
			end

			local timeLength = ttsAudio.getTimeLength(false)

			if timeLength <= 0 then
				return
			end

			local v11 = startTime + timeLength
			local v12 = startTime <= position and position < v11

			if current - position > 0.5 then
				if v12 then
					ttsAudio.seek(position - startTime)
					ttsAudio.play()
					v5.current = true
				elseif GetFFlagMomentsTTSStartTimePositioning then
					ttsAudio.pause()
					v5.current = false
				end
			elseif GetFFlagMomentsTTSStartTimePositioning and current < startTime and v12 then
				ttsAudio.seek(position - startTime)
				ttsAudio.play()
				v5.current = true
			end
		end)
	end, { v8, v9, v10 })

	return nil
end

return VoicePreviewLayer
