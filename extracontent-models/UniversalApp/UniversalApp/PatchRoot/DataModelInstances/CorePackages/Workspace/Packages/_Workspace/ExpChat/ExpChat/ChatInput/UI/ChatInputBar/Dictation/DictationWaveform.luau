local Parent = script:FindFirstAncestor("ExpChat").Parent
local React = require(Parent.React)
local useTokens = require(Parent.Foundation).Hooks.useTokens
local Waveform = require(script.Parent.Parent.Waveform)

require(script.Parent.useTranscribedSamples)

local v5 = React.createBinding({})

local function isItemTranscribed(t1: {[any]: any}, n1: number) -- line: 34
	for _, v13 in t1 do
		if n1 >= v13.startIdx and n1 <= v13.endIdx then
			return true
		end
	end

	return false
end
local function fadeInTransparency(n2: number, n3: number) -- line: 43
	if n3 <= n2 then
		return 0
	end

	return 1 - n2 / n3
end
local function compositeWithFade(n4: number, n5: number) -- line: 50
	return n4 + n5 * (1 - n4)
end
local function DictationWaveform(t2: {[any]: any}) -- line: 63
	-- upvalues: useTokens (copy), v5 (copy), React (copy), Waveform (copy)
	local v19 = useTokens()
	local EmphasisColor3 = v19.Color.Content.Emphasis.Color3
	local MutedColor3 = v19.Color.Content.Muted.Color3
	local SuccessColor3 = v19.Color.System.Success.Color3
	local v23 = t2.transcribedSamplesBinding or v5
	local transparencyValue = t2.transparencyValue
	local v25 = t2.fadeInTicks or 10
	local v26 = React.useCallback(function(p1) -- line: 74
		-- upvalues: v23 (copy), transparencyValue (copy), React (copy), MutedColor3 (copy), SuccessColor3 (copy), v25 (copy), EmphasisColor3 (copy)
		local t3 = {
			sample = p1,
			transcribed = v23
		}

		if transparencyValue ~= nil then
			t3.fade = transparencyValue
		end

		return React.joinBindings(t3):map(function(p2) -- line: 82
			-- upvalues: MutedColor3 (copy), SuccessColor3 (copy), v25 (copy), EmphasisColor3 (copy)
			local sample = p2.sample
			local transcribed = p2.transcribed
			local v32, n6

			if sample.age == nil then
				v32 = MutedColor3
				n6 = 0.85
			else
				local itemIdx = sample.itemIdx
				local g38 = nil
				local v37 = nil

				for _, v36 in transcribed do
					if itemIdx >= v36.startIdx and itemIdx <= v36.endIdx then
						v37 = true
						g38 = true
					end

					if g38 then
						break
					end
				end

				if not g38 then
					v37 = false
				end

				g38 = false

				if v37 then
					v32 = SuccessColor3

					local age = sample.age
					local v40 = v25

					n6 = if not (v40 <= age) then 1 - age / v40 else 0
				else
					v32 = EmphasisColor3

					local age = sample.age
					local v42 = v25

					n6 = if not (v42 <= age) then 1 - age / v42 else 0
				end
			end

			if p2.fade ~= nil then
				n6 += p2.fade * (1 - n6)
			end

			return {
				color = v32,
				transparency = n6
			}
		end)
	end, {
		EmphasisColor3,
		MutedColor3,
		SuccessColor3,
		v23,
		transparencyValue,
		v25
	})

	return React.createElement(Waveform, {
		isActive = t2.isActive,
		audioDeviceInput = t2.audioDeviceInput,
		onSample = t2.onSample,
		bindBarStyle = v26
	})
end

return React.memo(DictationWaveform)
