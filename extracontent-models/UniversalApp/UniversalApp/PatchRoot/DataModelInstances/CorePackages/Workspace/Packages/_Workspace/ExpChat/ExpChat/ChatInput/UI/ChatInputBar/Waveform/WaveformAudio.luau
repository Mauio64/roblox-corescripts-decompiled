local useAudioAnalyzer = require(script.Parent.useAudioAnalyzer)
local random = Random.new()

return {
	BAR_WIDTH = 2,
	BAR_GAP = 2,
	ITEM_WIDTH = 4,
	RENDER_INTERVAL = 0.1,
	amplitudeToDecibels = function(n1: number) -- line: 13
		if n1 <= 0 then
			return -1e999
		end

		return math.log10(n1) * 20
	end,
	amplitudeToNormalized = function(n2: number) -- line: 20
		local v5 = if not (n2 <= 0) then math.log10(n2) * 20 else -1e999

		if v5 == -1e999 then
			return 0
		end

		return (math.clamp((v5 - -60) / 60, 0, 1))
	end,
	sampleVolume = function(p1, t1: {[any]: any}, b1: boolean) -- line: 33
		-- upvalues: random (copy)
		if not p1 then
			return random:NextNumber(0, 1)
		end

		local RmsLevel = p1.RmsLevel
		local v10 = if not (RmsLevel <= 0) then math.log10(RmsLevel) * 20 else -1e999
		local v11 = if v10 ~= -1e999 then math.clamp((v10 - -60) / 60, 0, 1) else 0
		local v12 = math.max(t1.current * 0.95, v11)

		t1.current = v12

		if b1 then
			if v12 > 0.01 then
				return v11 / v12
			end

			return v11
		end

		return v11
	end,
	useAudioAnalyzer = useAudioAnalyzer
}
