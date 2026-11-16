local useAudioAnalyzer = require(script.Parent.useAudioAnalyzer)

local random = Random.new()

local function amplitudeToDecibels(p: number) -- 1 equivalent call inferred from this helper
	if p <= 0 then
		return -1e999
	end

	return math.log10(p) * 20
end

local function amplitudeToNormalized(rmsLevel: number) -- 1 equivalent call inferred from this helper
	local v = amplitudeToDecibels(rmsLevel) -- inferred equivalent call

	if v == -1e999 then
		return 0
	end

	return (math.clamp((v - -60) / 60, 0, 1))
end

return {
	BAR_WIDTH = 2,
	BAR_GAP = 2,
	ITEM_WIDTH = 4,
	RENDER_INTERVAL = 0.1,
	amplitudeToDecibels = amplitudeToDecibels,
	amplitudeToNormalized = amplitudeToNormalized,
	sampleVolume = function(p, p2, flag: boolean)
		if not p then
			return random:NextNumber(0, 1)
		end

		local selected = amplitudeToNormalized(p.RmsLevel) -- inferred equivalent call
		local current = math.max(p2.current * 0.95, selected)
		p2.current = current

		if not flag then
			return selected
		end

		if current > 0.01 then
			return selected / current
		end

		return selected
	end,
	useAudioAnalyzer = useAudioAnalyzer
}
