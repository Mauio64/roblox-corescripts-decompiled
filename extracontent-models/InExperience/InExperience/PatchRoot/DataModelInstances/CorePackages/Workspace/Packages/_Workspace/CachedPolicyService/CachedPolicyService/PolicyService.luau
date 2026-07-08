local Players = game:GetService("Players")
local u2 = true
local u3 = false
local PolicyInfoForPlayerAsync = nil
local u5 = false
local u6 = false
local BindableEvent = Instance.new("BindableEvent")

return {
	InitAsync = function(_) -- line: 21
		-- upvalues: u2 (ref), u3 (ref), u5 (ref), u6 (ref), BindableEvent (copy), Players (copy), PolicyInfoForPlayerAsync (ref)
		if _G.__TESTEZ_RUNNING_TEST__ then
			u2 = false
			u3 = true

			return
		end

		if u5 then
			return
		end

		if u6 then
			BindableEvent.Event:Wait()

			return
		end

		u6 = true

		local LocalPlayer = Players.LocalPlayer

		while not LocalPlayer do
			Players.PlayerAdded:Wait()
			LocalPlayer = Players.LocalPlayer
		end

		assert(LocalPlayer, "")
		pcall(function() -- line: 45
			-- upvalues: PolicyInfoForPlayerAsync (ref), LocalPlayer (ref)
			PolicyInfoForPlayerAsync = game:GetService("PolicyService"):GetPolicyInfoForPlayerAsync(LocalPlayer)
		end)

		if PolicyInfoForPlayerAsync then
			u2 = PolicyInfoForPlayerAsync.IsSubjectToChinaPolicies
			u3 = PolicyInfoForPlayerAsync.IsContentSharingAllowed
		end

		u5 = true
		BindableEvent:Fire()
	end,
	IsSubjectToChinaPolicies = function(p2) -- line: 57
		-- upvalues: u2 (ref)
		p2:InitAsync()

		return u2
	end,
	IsContentSharingAllowed = function(p3) -- line: 63
		-- upvalues: u3 (ref)
		p3:InitAsync()

		return u3
	end
}
