local audioDuckingFastInts = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/audioDuckingFastInts")

local function createAudioGraph(parent, targetInstance, options)
	local v5 = options or {}

	local v6 = v5.masterVolume == nil and 0.2 or v5.masterVolume
	local enableDucking = v5.enableDucking == true

	local masterFader = Instance.new("AudioFader")
	masterFader.Name = "MasterFader"
	masterFader.Volume = v6
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

	local v7 = {}
	local masterMuted = false

	local flag = false

	local function applyStem(data)
		data.fader.Volume = data.muted and 0 or data.targetVolume
	end

	local function removeStem(p2)
		local v8 = v7[p2]

		if not v8 then
			return
		end

		v7[p2] = nil

		v8.fader:Destroy()
	end

	return {
		addStem = function(p2, sourceInstance, value, value2)
			assert(not flag, "createAudioGraph: addStem after dispose")
			assert(not v7[p2], `createAudioGraph: stem "{p2}" already added`)

			local v8 = value or 1

			local audioFader = Instance.new("AudioFader")
			audioFader.Name = `Stem_{p2}`
			audioFader.Volume = v8
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

			v7[p2] = { fader = audioFader, targetVolume = v8, muted = false }

			return function()
				local v9 = p2
				local v10 = v7[v9]

				if not v10 then
					return
				end

				v7[v9] = nil

				v10.fader:Destroy()
			end
		end,
		setVolume = function(p2, targetVolume)
			assert(not flag, "createAudioGraph: setVolume after dispose")
			local v8 = v7[p2]
			assert(v8, `createAudioGraph: no stem "{p2}"`)
			v8.targetVolume = targetVolume
			v8.fader.Volume = v8.muted and 0 or v8.targetVolume
		end,
		setMuted = function(p2, muted)
			assert(not flag, "createAudioGraph: setMuted after dispose")
			local v8 = v7[p2]
			assert(v8, `createAudioGraph: no stem "{p2}"`)
			v8.muted = muted
			v8.fader.Volume = v8.muted and 0 or v8.targetVolume
		end,
		setMasterMuted = function(p2)
			assert(not flag, "createAudioGraph: setMasterMuted after dispose")
			masterMuted = p2
			masterFader.Volume = p2 and 0 or v6
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

			for k, v8 in v7 do
				v8.fader:Destroy()
			end

			table.clear(v7)

			if duckCompressor ~= nil then
				duckCompressor:Destroy()
			end

			masterFader:Destroy()
		end
	}
end

return createAudioGraph
