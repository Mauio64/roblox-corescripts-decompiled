local CoreGui = game:GetService("CoreGui")

local function getOrCreateFolder(p1, s1: string) -- line: 23
	local s1_2 = p1:FindFirstChild(s1)

	if s1_2 and s1_2:IsA("Folder") then
		return s1_2
	end

	local Folder = Instance.new("Folder")

	Folder.Name = s1
	Folder.Parent = p1

	return Folder
end
local function createMediaRoot(s2: string, p2) -- line: 35
	-- upvalues: CoreGui (copy)
	local v10 = p2 or CoreGui
	local MomentMedia = v10:FindFirstChild("MomentMedia")

	if MomentMedia and MomentMedia:IsA("Folder") then
	else
		MomentMedia = Instance.new("Folder")
		MomentMedia.Name = "MomentMedia"
		MomentMedia.Parent = v10
	end

	local v12 = MomentMedia
	local s2_2 = v12:FindFirstChild(s2)

	if s2_2 and s2_2:IsA("Folder") then
	else
		s2_2 = Instance.new("Folder")
		s2_2.Name = s2
		s2_2.Parent = v12
	end

	local v14 = s2_2

	return {
		folder = v14,
		dispose = function() -- line: 40
			-- upvalues: v14 (copy), v12 (copy)
			v14:Destroy()

			if #v12:GetChildren() == 0 then
				v12:Destroy()
			end
		end
	}
end

return createMediaRoot
