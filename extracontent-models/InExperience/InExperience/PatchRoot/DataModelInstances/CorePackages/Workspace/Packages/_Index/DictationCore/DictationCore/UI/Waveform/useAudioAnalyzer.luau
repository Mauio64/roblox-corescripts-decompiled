local parent = script:FindFirstAncestor("DictationCore").Parent

local React = require(parent.React)

local function useAudioAnalyzer(sourceInstance)
	local ref = React.useRef(nil)

	React.useEffect(function()
		if not sourceInstance then
			return
		end

		local waveformAnalyzer = Instance.new("AudioAnalyzer")
		waveformAnalyzer.SpectrumEnabled = false
		waveformAnalyzer.Name = "WaveformAnalyzer"
		waveformAnalyzer.Parent = sourceInstance.Parent
		ref.current = waveformAnalyzer

		local wire = Instance.new("Wire")
		wire.SourceInstance = sourceInstance
		wire.TargetInstance = waveformAnalyzer
		wire.Parent = sourceInstance.Parent

		return function()
			wire:Destroy()
			waveformAnalyzer:Destroy()
			ref.current = nil
		end
	end, { sourceInstance })

	return ref
end

return useAudioAnalyzer
