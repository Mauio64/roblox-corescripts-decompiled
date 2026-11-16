local createSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals").createSignal

local function createUploadStore()
	local signal, v5 = createSignal("Idle")
	local signal2, v6 = createSignal(nil)
	local signal3, v7 = createSignal(nil)

	return {
		getState = signal,
		getErrorKind = signal2,
		getUploadedMoment = signal3,
		setUploading = function()
			v5("Uploading")
			v6(nil)
			v7(nil)
		end,
		setSuccess = function(p2)
			v5("Success")
			v6(nil)
			v7(p2)
		end,
		setFailed = function(p2)
			v5("Failed")
			v6(p2)
			v7(nil)
		end,
		reset = function()
			v5("Idle")
			v6(nil)
			v7(nil)
		end
	}
end

return createUploadStore
