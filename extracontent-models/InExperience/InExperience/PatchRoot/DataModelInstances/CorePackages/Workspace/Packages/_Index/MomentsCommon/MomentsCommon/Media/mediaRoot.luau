local CoreGui = game:GetService("CoreGui")

local function getOrCreateFolder(parent, name: string)
	local folder = parent:FindFirstChild(name)

	if folder and folder:IsA("Folder") then
		return folder
	end

	local folder2 = Instance.new("Folder")
	folder2.Name = name
	folder2.Parent = parent
	return folder2
end

local function createMediaRoot(name: string, p)
	local parent = p or CoreGui
	local momentMedia = parent:FindFirstChild("MomentMedia")

	if not (momentMedia and momentMedia:IsA("Folder")) then
		momentMedia = Instance.new("Folder")
		momentMedia.Name = "MomentMedia"
		momentMedia.Parent = parent
	end

	local folder = momentMedia:FindFirstChild(name)

	if not (folder and folder:IsA("Folder")) then
		folder = Instance.new("Folder")
		folder.Name = name
		folder.Parent = momentMedia
	end

	return {
		folder = folder,
		dispose = function()
			folder:Destroy()

			if #momentMedia:GetChildren() == 0 then
				momentMedia:Destroy()
			end
		end
	}
end

return createMediaRoot
