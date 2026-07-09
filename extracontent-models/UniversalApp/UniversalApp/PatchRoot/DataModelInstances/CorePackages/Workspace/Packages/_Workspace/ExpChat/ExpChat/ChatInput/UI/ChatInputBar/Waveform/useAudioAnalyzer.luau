local Parent = script:FindFirstAncestor("ExpChat").Parent
local React = require(Parent.React)

local function useAudioAnalyzer(p1) -- line: 10
	-- upvalues: React (copy)
	local v5 = React.useRef(nil)

	React.useEffect(function() -- line: 13
		-- upvalues: p1 (copy), v5 (copy)
		if not p1 then
			return
		end

		local AudioAnalyzer = Instance.new("AudioAnalyzer")

		AudioAnalyzer.SpectrumEnabled = false
		AudioAnalyzer.Name = "WaveformAnalyzer"
		AudioAnalyzer.Parent = p1.Parent
		v5.current = AudioAnalyzer

		local Wire = Instance.new("Wire")

		Wire.SourceInstance = p1
		Wire.TargetInstance = AudioAnalyzer
		Wire.Parent = p1.Parent

		return function() -- line: 29
			-- upvalues: Wire (copy), AudioAnalyzer (copy), v5 (copy)
			Wire:Destroy()
			AudioAnalyzer:Destroy()
			v5.current = nil
		end
	end, { p1 })

	return v5
end

return useAudioAnalyzer
