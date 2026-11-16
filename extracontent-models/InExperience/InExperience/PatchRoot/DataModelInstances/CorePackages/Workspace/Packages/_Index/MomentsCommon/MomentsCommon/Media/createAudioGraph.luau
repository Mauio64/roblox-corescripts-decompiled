local MomentsCommon = script:FindFirstAncestor("MomentsCommon")

local audioDuckingFastInts = require(MomentsCommon.Media.audioDuckingFastInts)

local function createAudioGraph(parent, targetInstance, options)
	local v = options or {}

	local volume = v.masterVolume == nil and 0.2 or v.masterVolume
	local enableDucking = v.enableDucking == true

	local masterFader = Instance.new("AudioFader")
	masterFader.Name = "MasterFader"
	masterFader.Volume = volume
	masterFader.Parent = parent

	local wire = Instance.new("Wire")
	wire.SourceInstance = masterFader
	wire.TargetInstance = targetInstance
	wire.Parent = masterFader
	local duckCompressor

	if enableDucking then
		local compressorParams = audioDuckingFastInts.getCompressorParams()
		duckCompressor = Instance.new("AudioCompressor")
		duckCompressor.Name = "DuckCompressor"
		duckCompressor.Threshold = compressorParams.threshold
		duckCompressor.Ratio = compressorParams.ratio
		duckCompressor.Attack = compressorParams.attack
		duckCompressor.Release = compressorParams.release
		duckCompressor.MakeupGain = compressorParams.makeupGain
		duckCompressor.Parent = parent

		local wire2 = Instance.new("Wire")
		wire2.SourceInstance = duckCompressor
		wire2.TargetInstance = masterFader
		wire2.Parent = duckCompressor
	else
		duckCompressor = nil
	end

	local v2 = {}
	local masterMuted = false

	local flag = false

	local function applyStem(data) -- 2 equivalent calls inferred from this helper
		data.fader.Volume = data.muted and 0 or data.targetVolume
	end

	local function removeStem(p: string) -- 1 equivalent call inferred from this helper
		local v3 = v2[p]

		if not v3 then
			return
		end

		v2[p] = nil

		v3.fader:Destroy()
	end

	return {
		addStem = function(p: string, sourceInstance, value: number?, value2: string?)
			assert(not flag, "createAudioGraph: addStem after dispose")
			assert(not v2[p], `createAudioGraph: stem "{p}" already added`)

			local v3 = value or 1

			local audioFader = Instance.new("AudioFader")
			audioFader.Name = `Stem_{p}`
			audioFader.Volume = v3
			audioFader.Parent = parent

			local wire2 = Instance.new("Wire")
			wire2.SourceInstance = sourceInstance
			wire2.TargetInstance = audioFader
			wire2.Parent = audioFader

			if enableDucking and (value2 or "input") == "sidechain" then
				local wire3 = Instance.new("Wire")
				wire3.SourceInstance = audioFader
				wire3.TargetInstance = masterFader
				wire3.Parent = audioFader

				local wire4 = Instance.new("Wire")
				wire4.SourceInstance = sourceInstance
				wire4.TargetInstance = duckCompressor
				wire4.TargetName = "Sidechain"
				wire4.Parent = audioFader
			elseif enableDucking then
				local wire3 = Instance.new("Wire")
				wire3.SourceInstance = audioFader
				wire3.TargetInstance = duckCompressor
				wire3.Parent = audioFader
			else
				local wire3 = Instance.new("Wire")
				wire3.SourceInstance = audioFader
				wire3.TargetInstance = masterFader
				wire3.Parent = audioFader
			end

			v2[p] = { fader = audioFader, targetVolume = v3, muted = false }

			return function()
				removeStem(p) -- inferred equivalent call
			end
		end,
		setVolume = function(p: string, targetVolume: number)
			assert(not flag, "createAudioGraph: setVolume after dispose")
			local v3 = v2[p]
			assert(v3, `createAudioGraph: no stem "{p}"`)
			v3.targetVolume = targetVolume
			applyStem(v3) -- inferred equivalent call
		end,
		setMuted = function(p: string, muted: boolean)
			assert(not flag, "createAudioGraph: setMuted after dispose")
			local v3 = v2[p]
			assert(v3, `createAudioGraph: no stem "{p}"`)
			v3.muted = muted
			applyStem(v3) -- inferred equivalent call
		end,
		setMasterMuted = function(flag2: boolean)
			assert(not flag, "createAudioGraph: setMasterMuted after dispose")
			masterMuted = flag2
			masterFader.Volume = flag2 and 0 or volume
		end,
		getMasterMuted = function()
			return masterMuted
		end,
		getOutput = function()
			return targetInstance
		end,
		dispose = function()
			if flag then
				return
			end

			flag = true

			for _, v3 in v2 do
				v3.fader:Destroy()
			end

			table.clear(v2)

			if duckCompressor ~= nil then
				duckCompressor:Destroy()
			end

			masterFader:Destroy()
		end
	}
end

return createAudioGraph
