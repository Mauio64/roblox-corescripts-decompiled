local v5 = nil
local v6 = false

return function(callback)
	if not v6 then
		local success, result = pcall(function()
			return game:GetService("AudioFocusService")
		end)
		v5 = success and result or v5
		v6 = true
	end

	local v7 = v5

	if v7 then
		local v8 = v7:GetFocusedContextId()
		callback(v8)
		local function fn()
			local focusedContextId = v7:GetFocusedContextId()

			if v8 ~= focusedContextId then
				v8 = focusedContextId
				callback(v8)
			end
		end
		v7.OnContextRegistered:Connect(fn)
		v7.OnContextUnregistered:Connect(fn)
		v7.OnDeafenVoiceAudio:Connect(fn)
		v7.OnUndeafenVoiceAudio:Connect(fn)
	end
end
