local parent = script:FindFirstAncestor("Moments").Parent

local Signals = require(parent.Signals)

local createSignal = Signals.createSignal

local function createUploadStore()
	local signal, v = createSignal("Idle")
	local signal2, v2 = createSignal(nil)
	local signal3, v3 = createSignal(nil)

	return {
		getState = signal,
		getErrorKind = signal2,
		getUploadedMoment = signal3,
		setUploading = function()
			v("Uploading")
			v2(nil)
			v3(nil)
		end,
		setSuccess = function(p)
			v("Success")
			v2(nil)
			v3(p)
		end,
		setFailed = function(p: string)
			v("Failed")
			v2(p)
			v3(nil)
		end,
		reset = function()
			v("Idle")
			v2(nil)
			v3(nil)
		end
	}
end

return createUploadStore
