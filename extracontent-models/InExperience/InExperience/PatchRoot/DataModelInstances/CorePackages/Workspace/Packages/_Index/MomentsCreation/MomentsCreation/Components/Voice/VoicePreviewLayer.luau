local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)

require(MomentsCreation.Types.CreationFlowTypes)

local GetFFlagMomentsTTSStartTimePositioning = require(MomentsCreation.Flags.GetFFlagMomentsTTSStartTimePositioning)

local useEffect = React.useEffect
local useRef = React.useRef
local useState = React.useState

local function VoicePreviewLayer(p): nil
	local controller = p.controller

	local ttsAudio = controller.ttsAudio
	assert(ttsAudio ~= nil, "VoicePreviewLayer requires controller.ttsAudio")

	local state, setState = useState(controller.getActiveTool(false))
	local state2, setState2 = useState(controller.getEffectiveTTS(false))

	local state3, setState3 = useState(ttsAudio.getIsLoaded(false))
	useEffect(function()
		return Signals.createEffect(function(p2)
			setState(controller.getActiveTool(p2))
			setState2(controller.getEffectiveTTS(p2))
			setState3(ttsAudio.getIsLoaded(p2))
		end)
	end, { controller, ttsAudio })

	local v = useRef(false)
	local v2 = useRef(0)
	local v3

	if state == nil then
		v3 = false
	else
		v3 = state.kind == "voice"
	end

	local v4 = not v3 and state2 ~= nil
	local v5 = state2 == nil and "" or `{state2.text}:{state2.voiceId}`

	local v6 = state2 == nil and 0 or state2.startTime or 0

	useEffect(function()
		if not v4 or state2 == nil then
			return
		end

		ttsAudio.generate(state2.text, state2.voiceId)
	end, { v4, v5 })

	useEffect(function()
		if v3 and v.current then
			ttsAudio.pause()
			v.current = false
		end
	end, { v3 })

	local state4, setState4 = useState(controller.preview.playback.getIsPlaying(false))
	useEffect(function()
		return Signals.createEffect(function(p2)
			setState4(controller.preview.playback.getIsPlaying(p2))
		end)
	end, { controller })

	useEffect(function()
		if not v4 or state2 == nil or not ttsAudio.getIsLoaded(false) then
			return
		end

		local timeLength = ttsAudio.getTimeLength(false)

		if timeLength <= 0 then
			return
		end

		local startTime = state2.startTime or 0
		local v7 = startTime + timeLength

		local position = controller.preview.playback.getPosition(false)

		if state4 and startTime <= position and position < v7 then
			local v8 = position - startTime

			if math.abs(ttsAudio.getTimePosition(false) - v8) > 0.1 then
				ttsAudio.seek(v8)
			end

			ttsAudio.play()
			v.current = true
		elseif (not state4 or GetFFlagMomentsTTSStartTimePositioning) and v.current then
			ttsAudio.pause()
			v.current = false
		end

		return function()
			if v.current then
				ttsAudio.pause()
				v.current = false
			end
		end
	end, { v4, v5, v6, state4, state3 })

	useEffect(function()
		if not v4 or state2 == nil then
			return
		end

		local startTime = state2.startTime or 0

		return Signals.createEffect(function(p2)
			local position = controller.preview.playback.getPosition(p2)
			local current = v2.current
			v2.current = position

			if not (ttsAudio.getIsLoaded(false) and controller.preview.playback.getIsPlaying(false)) then
				return
			end

			local timeLength = ttsAudio.getTimeLength(false)

			if timeLength <= 0 then
				return
			end

			local v7 = startTime + timeLength
			local v8

			if startTime <= position then
				v8 = position < v7
			else
				v8 = false
			end

			if current - position > 0.5 then
				if v8 then
					ttsAudio.seek(position - startTime)
					ttsAudio.play()
					v.current = true
				elseif GetFFlagMomentsTTSStartTimePositioning then
					ttsAudio.pause()
					v.current = false
				end
			elseif GetFFlagMomentsTTSStartTimePositioning and current < startTime and v8 then
				ttsAudio.seek(position - startTime)
				ttsAudio.play()
				v.current = true
			end
		end)
	end, { v4, v5, v6 })

	return nil
end

return VoicePreviewLayer
