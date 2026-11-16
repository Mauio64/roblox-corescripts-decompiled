local Players = game:GetService("Players")

local v5 = true
local v6 = false
local policyInfoForPlayerAsync = nil
local flag = false
local flag2 = false

local bindableEvent = Instance.new("BindableEvent")

return {
	InitAsync = function(self)
		if _G.__TESTEZ_RUNNING_TEST__ then
			v5 = false
			v6 = true
		else
			if flag then
				return
			end

			if flag2 then
				bindableEvent.Event:Wait()
				return
			end

			flag2 = true

			local localPlayer = Players.LocalPlayer

			while not localPlayer do
				Players.PlayerAdded:Wait()
				localPlayer = Players.LocalPlayer
			end

			assert(localPlayer, "")

			pcall(function()
				local PolicyService = game:GetService("PolicyService")
				policyInfoForPlayerAsync = PolicyService:GetPolicyInfoForPlayerAsync(localPlayer)
			end)

			if policyInfoForPlayerAsync then
				v5 = policyInfoForPlayerAsync.IsSubjectToChinaPolicies
				v6 = policyInfoForPlayerAsync.IsContentSharingAllowed
			end

			flag = true
			bindableEvent:Fire()
		end
	end,
	IsSubjectToChinaPolicies = function(self)
		self:InitAsync()

		return v5
	end,
	IsContentSharingAllowed = function(self)
		self:InitAsync()

		return v6
	end
}
