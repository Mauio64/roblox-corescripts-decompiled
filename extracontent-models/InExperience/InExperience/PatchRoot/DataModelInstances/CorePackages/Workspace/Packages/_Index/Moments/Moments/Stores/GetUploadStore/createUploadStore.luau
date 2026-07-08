local Parent = script:FindFirstAncestor("Moments").Parent
local createSignal = require(Parent.Signals).createSignal

local function createUploadStore() -- line: 31
	-- upvalues: createSignal (copy)
	local v4, v5 = createSignal("Idle")
	local v6, v7 = createSignal(nil)
	local v8, v9 = createSignal(nil)

	return {
		getState = v4,
		getErrorKind = v6,
		getUploadedMoment = v8,
		setUploading = function() -- line: 36
			-- upvalues: v5 (copy), v7 (copy), v9 (copy)
			v5("Uploading")
			v7(nil)
			v9(nil)
		end,
		setSuccess = function(p1) -- line: 42
			-- upvalues: v5 (copy), v7 (copy), v9 (copy)
			v5("Success")
			v7(nil)
			v9(p1)
		end,
		setFailed = function(s1: string) -- line: 48
			-- upvalues: v5 (copy), v7 (copy), v9 (copy)
			v5("Failed")
			v7(s1)
			v9(nil)
		end,
		reset = function() -- line: 54
			-- upvalues: v5 (copy), v7 (copy), v9 (copy)
			v5("Idle")
			v7(nil)
			v9(nil)
		end
	}
end

return createUploadStore
