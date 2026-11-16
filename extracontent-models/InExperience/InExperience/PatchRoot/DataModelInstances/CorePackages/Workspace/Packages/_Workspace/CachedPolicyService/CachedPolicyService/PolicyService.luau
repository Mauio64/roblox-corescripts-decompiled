local Players = game:GetService("Players")

local v = true
local v2 = false
local policyInfoForPlayerAsync = nil
local flag = false
local flag2 = false

local bindableEvent = Instance.new("BindableEvent")
local PolicyService_2 = {}

function PolicyService_2:InitAsync()
	if _G.__TESTEZ_RUNNING_TEST__ then
		v = false
		v2 = true
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
			v = policyInfoForPlayerAsync.IsSubjectToChinaPolicies
			v2 = policyInfoForPlayerAsync.IsContentSharingAllowed
		end

		flag = true
		bindableEvent:Fire()
	end
end

function PolicyService_2:IsSubjectToChinaPolicies()
	self:InitAsync()

	return v
end

function PolicyService_2:IsContentSharingAllowed()
	self:InitAsync()

	return v2
end

return PolicyService_2
