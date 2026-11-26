local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local module = require("@luauforge/bundled/dFs")

local v5 = {}

function v5.check()
	return {
		workspacePresent = Workspace:FindFirstChild("debug_test_for_datamodel_availability_workspace") ~= nil,
		replicatedStoragePresent = ReplicatedStorage:FindFirstChild("debug_test_for_datamodel_availability_replicated_storage") ~= nil
	}
end

function v5.run(): boolean
	local v6 = v5.check()

	if v6.workspacePresent and v6.replicatedStoragePresent then
		return true
	end

	module(string.format(
		"AXDebugMobileRbxlContentProbe: Mobile.rbxl markers missing workspace=%s replicatedStorage=%s",
		tostring(v6.workspacePresent),
		(tostring(v6.replicatedStoragePresent))
	))

	return false
end

return v5
