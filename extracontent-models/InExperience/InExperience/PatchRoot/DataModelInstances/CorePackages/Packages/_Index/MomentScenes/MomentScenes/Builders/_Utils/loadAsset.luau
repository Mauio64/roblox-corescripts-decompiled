local InsertService = game:GetService("InsertService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local function takePreviewResult(instance, p: number) -- 1 equivalent call inferred from this helper
	if instance == nil or typeof(instance) ~= "Instance" then
		error(`loadAsset: PreviewLoadAsset returned nil for {p}`)
	end

	local clone = instance:Clone()
	instance:Destroy()
	return clone
end

return {
	loadAsset = function(p: number)
		if RunService:IsStudio() and RunService:IsClient() then
			local previewLoadAsset = ReplicatedStorage:FindFirstChild("PreviewLoadAsset")

			if previewLoadAsset ~= nil and previewLoadAsset:IsA("RemoteFunction") then
				return takePreviewResult(previewLoadAsset:InvokeServer(p), p) -- inferred equivalent call
			end
		end

		return InsertService:LoadAsset(p)
	end,
	takePreviewResult = takePreviewResult,
	PREVIEW_REMOTE_NAME = "PreviewLoadAsset"
}
