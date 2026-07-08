local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Parent = script:FindFirstAncestor("ExpChat").Parent
local React = require(Parent.React)
local v5 = game:DefineFastFlag("EngineAudioSTTIsDictationEnabled", false)

local function destroyIfExists(t1: {[any]: any}) -- line: 43
	if t1.current then
		t1.current:Destroy()
		t1.current = nil
	end
end
local function disconnectIfExists(t2: {[any]: any}) -- line: 50
	if t2.current then
		t2.current:Disconnect()
		t2.current = nil
	end
end
local function teardownInstances(t3: {[any]: any}) -- line: 57
	local textConnection = t3.textConnection

	if textConnection.current then
		textConnection.current:Disconnect()
		textConnection.current = nil
	end

	local vadConnection = t3.vadConnection

	if vadConnection.current then
		vadConnection.current:Disconnect()
		vadConnection.current = nil
	end

	local wire = t3.wire

	if wire.current then
		wire.current:Destroy()
		wire.current = nil
	end

	local audioSTT = t3.audioSTT

	if audioSTT.current then
		audioSTT.current:Destroy()
		audioSTT.current = nil
	end

	local audioDeviceInput = t3.audioDeviceInput

	if audioDeviceInput.current then
		audioDeviceInput.current:Destroy()
		audioDeviceInput.current = nil
	end

	local container = t3.container

	if container.current then
		container.current:Destroy()
		container.current = nil
	end
end
local function useDictationAudioPipeline() -- line: 66
	-- upvalues: React (copy), Players (copy), CoreGui (copy), v5 (copy)
	local v19, v20 = React.useState(nil)
	local v21 = React.useRef(nil)
	local v22 = React.useRef(nil)
	local v23 = React.useRef(nil)
	local v24 = React.useRef(nil)
	local v25 = React.useRef(nil)
	local v26 = React.useRef(nil)
	local v27 = React.useMemo(function() -- line: 76
		-- upvalues: v21 (copy), v22 (copy), v23 (copy), v24 (copy), v25 (copy), v26 (copy)
		return {
			audioDeviceInput = v21,
			audioSTT = v22,
			wire = v23,
			container = v24,
			textConnection = v25,
			vadConnection = v26
		}
	end, {})
	local v28 = React.useCallback(function() -- line: 87
		-- upvalues: v27 (copy), v20 (copy)
		local v30 = v27
		local textConnection = v30.textConnection

		if textConnection.current then
			textConnection.current:Disconnect()
			textConnection.current = nil
		end

		local vadConnection = v30.vadConnection

		if vadConnection.current then
			vadConnection.current:Disconnect()
			vadConnection.current = nil
		end

		local wire = v30.wire

		if wire.current then
			wire.current:Destroy()
			wire.current = nil
		end

		local audioSTT = v30.audioSTT

		if audioSTT.current then
			audioSTT.current:Destroy()
			audioSTT.current = nil
		end

		local audioDeviceInput = v30.audioDeviceInput

		if audioDeviceInput.current then
			audioDeviceInput.current:Destroy()
			audioDeviceInput.current = nil
		end

		local container = v30.container

		if container.current then
			container.current:Destroy()
			container.current = nil
		end

		v20(nil)
	end, { v27 })
	local v29 = React.useCallback(function(t4: {[any]: any}, t5: {[any]: any}?) -- line: 93
		-- upvalues: Players (copy), v27 (copy), CoreGui (copy), v5 (copy), v20 (copy)
		local LocalPlayer = Players.LocalPlayer

		if not LocalPlayer then
			error("No local player")
		end

		local v40 = v27
		local textConnection = v40.textConnection

		if textConnection.current then
			textConnection.current:Disconnect()
			textConnection.current = nil
		end

		local vadConnection = v40.vadConnection

		if vadConnection.current then
			vadConnection.current:Disconnect()
			vadConnection.current = nil
		end

		local wire = v40.wire

		if wire.current then
			wire.current:Destroy()
			wire.current = nil
		end

		local audioSTT = v40.audioSTT

		if audioSTT.current then
			audioSTT.current:Destroy()
			audioSTT.current = nil
		end

		local audioDeviceInput = v40.audioDeviceInput

		if audioDeviceInput.current then
			audioDeviceInput.current:Destroy()
			audioDeviceInput.current = nil
		end

		local container = v40.container

		if container.current then
			container.current:Destroy()
			container.current = nil
		end

		local v47 = t5 ~= nil and t5.continuous == true
		local Folder = Instance.new("Folder")

		Folder.Name = "ExpChatDictation"
		Folder.Parent = CoreGui
		v27.container.current = Folder

		local AudioDeviceInput = Instance.new("AudioDeviceInput")

		AudioDeviceInput.Player = LocalPlayer
		AudioDeviceInput.Muted = false
		AudioDeviceInput.Parent = Folder
		AudioDeviceInput.Active = true
		v27.audioDeviceInput.current = AudioDeviceInput

		local AudioSpeechToText = Instance.new("AudioSpeechToText")

		if v5 then
			AudioSpeechToText.DictationEnabled = true
		end

		AudioSpeechToText.Enabled = true
		AudioSpeechToText.Parent = Folder
		v27.audioSTT.current = AudioSpeechToText

		local Wire = Instance.new("Wire")

		Wire.SourceInstance = AudioDeviceInput
		Wire.TargetInstance = AudioSpeechToText
		Wire.Parent = Folder
		v27.wire.current = Wire
		v27.textConnection.current = AudioSpeechToText:GetPropertyChangedSignal("Text"):Connect(function() -- line: 139
			-- upvalues: AudioSpeechToText (copy), v47 (copy), t4 (copy)
			local AudioSpeechToTextText = AudioSpeechToText.Text

			if AudioSpeechToTextText and AudioSpeechToTextText ~= "" then
				if v47 then
					AudioSpeechToText.Text = ""
				end

				t4.onTranscription(AudioSpeechToTextText)
			end
		end)

		if t4.onSpeechStarted then
			local onSpeechStarted = t4.onSpeechStarted

			v27.vadConnection.current = AudioSpeechToText:GetPropertyChangedSignal("VoiceDetected"):Connect(function() -- line: 153
				-- upvalues: AudioSpeechToText (copy), onSpeechStarted (copy)
				if AudioSpeechToText.VoiceDetected then
					onSpeechStarted()
				end
			end)
		end

		v20(AudioDeviceInput)

		return AudioDeviceInput
	end, { v27 })

	React.useEffect(function() -- line: 166
		-- upvalues: v27 (copy)
		return function() -- line: 167
			-- upvalues: v27 (copy)
			local v54 = v27
			local textConnection = v54.textConnection

			if textConnection.current then
				textConnection.current:Disconnect()
				textConnection.current = nil
			end

			local vadConnection = v54.vadConnection

			if vadConnection.current then
				vadConnection.current:Disconnect()
				vadConnection.current = nil
			end

			local wire = v54.wire

			if wire.current then
				wire.current:Destroy()
				wire.current = nil
			end

			local audioSTT = v54.audioSTT

			if audioSTT.current then
				audioSTT.current:Destroy()
				audioSTT.current = nil
			end

			local audioDeviceInput = v54.audioDeviceInput

			if audioDeviceInput.current then
				audioDeviceInput.current:Destroy()
				audioDeviceInput.current = nil
			end

			local container = v54.container

			if container.current then
				container.current:Destroy()
				container.current = nil
			end
		end
	end, { v27 })

	return React.useMemo(function() -- line: 172
		-- upvalues: v29 (copy), v28 (copy), v19 (copy), v21 (copy)
		return {
			start = v29,
			stop = v28,
			audioDeviceInput = v19,
			audioDeviceInputRef = v21
		}
	end, {
		v29,
		v28,
		v19
	})
end

return useDictationAudioPipeline
