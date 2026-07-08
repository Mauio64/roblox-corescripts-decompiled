local u1 = nil
local u2 = false

return function(p1: ((...any) -> ...any)) -- line: 16
	-- upvalues: u2 (ref), u1 (ref)
	if not u2 then
		local ok, result = pcall(function() -- line: 5
			return game:GetService("AudioFocusService")
		end)

		if ok and result then
			u1 = result
		end

		u2 = true
	end

	local v8 = u1

	if v8 then
		local FocusedContextId = v8:GetFocusedContextId()

		p1(FocusedContextId)

		local function v10() -- line: 21
			-- upvalues: v8 (copy), FocusedContextId (ref), p1 (copy)
			local FocusedContextId2 = v8:GetFocusedContextId()

			if FocusedContextId2 ~= FocusedContextId then
				FocusedContextId = FocusedContextId2
				p1(FocusedContextId)
			end
		end

		v8.OnContextRegistered:Connect(v10)
		v8.OnContextUnregistered:Connect(v10)
		v8.OnDeafenVoiceAudio:Connect(v10)
		v8.OnUndeafenVoiceAudio:Connect(v10)
	end
end
