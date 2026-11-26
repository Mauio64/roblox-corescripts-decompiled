local CoreGui = game:GetService("CoreGui")

local function getOrCreateFolder(parent, name)
	local folder = parent:FindFirstChild(name)

	if folder and folder:IsA("Folder") then
		return folder
	end

	local folder2 = Instance.new("Folder")
	folder2.Name = name
	folder2.Parent = parent
	return folder2
end

local function createMediaRoot(name, p2)
	local v5 = p2 or CoreGui
	local momentMedia = v5:FindFirstChild("MomentMedia")

	if not (momentMedia and momentMedia:IsA("Folder")) then
		momentMedia = Instance.new("Folder")
		momentMedia.Name = "MomentMedia"
		momentMedia.Parent = v5
	end

	local v6 = momentMedia:FindFirstChild(name)

	if not (v6 and v6:IsA("Folder")) then
		v6 = Instance.new("Folder")
		v6.Name = name
		v6.Parent = momentMedia
	end

	return {
		folder = v6,
		dispose = function()
			v6:Destroy()

			if #momentMedia:GetChildren() == 0 then
				momentMedia:Destroy()
			end
		end
	}
end

return createMediaRoot
