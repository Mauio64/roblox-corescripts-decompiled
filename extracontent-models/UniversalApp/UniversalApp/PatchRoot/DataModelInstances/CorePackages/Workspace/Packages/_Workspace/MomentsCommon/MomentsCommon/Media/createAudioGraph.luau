local function createAudioGraph(p1, p2, n1: number?) -- line: 43
	local v5 = n1 or 0.2
	local AudioFader = Instance.new("AudioFader")

	AudioFader.Name = "MasterFader"
	AudioFader.Volume = v5
	AudioFader.Parent = p1

	local Wire = Instance.new("Wire")

	Wire.SourceInstance = AudioFader
	Wire.TargetInstance = p2
	Wire.Parent = AudioFader

	local t1 = {}
	local u9 = false
	local u10 = false

	local function applyStem(t2: {[any]: any}) -- line: 62
		t2.fader.Volume = if not t2.muted then t2.targetVolume else 0
	end
	local function removeStem(s1: string) -- line: 66
		-- upvalues: t1 (copy)
		local v15 = t1[s1]

		if not v15 then
			return
		end

		t1[s1] = nil
		v15.fader:Destroy()
	end

	return {
		addStem = function(s2: string, p3, n2: number?) -- line: 77
			-- upvalues: u10 (ref), t1 (copy), p1 (copy), AudioFader (copy)
			assert(not u10, "createAudioGraph: addStem after dispose")
			assert(not t1[s2], `createAudioGraph: stem "{ s2 }" already added`)

			local v19 = n2 or 1
			local AudioFader2 = Instance.new("AudioFader")

			AudioFader2.Name = `Stem_{ s2 }`
			AudioFader2.Volume = v19
			AudioFader2.Parent = p1

			local Wire2 = Instance.new("Wire")

			Wire2.SourceInstance = p3
			Wire2.TargetInstance = AudioFader2
			Wire2.Parent = AudioFader2

			local Wire3 = Instance.new("Wire")

			Wire3.SourceInstance = AudioFader2
			Wire3.TargetInstance = AudioFader
			Wire3.Parent = AudioFader2
			t1[s2] = {
				muted = false,
				fader = AudioFader2,
				targetVolume = v19
			}

			return function() -- line: 104
				-- upvalues: s2 (copy), t1 (copy)
				local v32 = s2
				local v33 = t1[v32]

				if not v33 then
					return
				end

				t1[v32] = nil
				v33.fader:Destroy()
			end
		end,
		setVolume = function(s3: string, n3: number) -- line: 109
			-- upvalues: u10 (ref), t1 (copy)
			assert(not u10, "createAudioGraph: setVolume after dispose")

			local v25 = t1[s3]

			assert(v25, `createAudioGraph: no stem "{ s3 }"`)
			v25.targetVolume = n3
			v25.fader.Volume = if not v25.muted then v25.targetVolume else 0
		end,
		setMuted = function(s4: string, b1: boolean) -- line: 117
			-- upvalues: u10 (ref), t1 (copy)
			assert(not u10, "createAudioGraph: setMuted after dispose")

			local v28 = t1[s4]

			assert(v28, `createAudioGraph: no stem "{ s4 }"`)
			v28.muted = b1
			v28.fader.Volume = if not v28.muted then v28.targetVolume else 0
		end,
		setMasterMuted = function(b2: boolean) -- line: 125
			-- upvalues: u10 (ref), u9 (ref), AudioFader (copy), v5 (copy)
			assert(not u10, "createAudioGraph: setMasterMuted after dispose")
			u9 = b2
			AudioFader.Volume = if not b2 then v5 else 0
		end,
		getMasterMuted = function() -- line: 131
			-- upvalues: u9 (ref)
			return u9
		end,
		getOutput = function() -- line: 135
			-- upvalues: p2 (copy)
			return p2
		end,
		dispose = function() -- line: 139
			-- upvalues: u10 (ref), t1 (copy), AudioFader (copy)
			if u10 then
				return
			end

			u10 = true

			for _, v31 in t1 do
				v31.fader:Destroy()
			end

			table.clear(t1)
			AudioFader:Destroy()
		end
	}
end

return createAudioGraph
