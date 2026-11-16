local v = nil
local v2 = false

return function(callback)
	if not v2 then
		local success, result = pcall(function()
			return game:GetService("AudioFocusService")
		end)
		v = success and result or v
		v2 = true
	end

	local v3 = v

	if v3 then
		local v4 = v3:GetFocusedContextId()
		callback(v4)
		local function fn()
			local focusedContextId = v3:GetFocusedContextId()

			if v4 ~= focusedContextId then
				v4 = focusedContextId
				callback(v4)
			end
		end
		v3.OnContextRegistered:Connect(fn)
		v3.OnContextUnregistered:Connect(fn)
		v3.OnDeafenVoiceAudio:Connect(fn)
		v3.OnUndeafenVoiceAudio:Connect(fn)
	end
end
