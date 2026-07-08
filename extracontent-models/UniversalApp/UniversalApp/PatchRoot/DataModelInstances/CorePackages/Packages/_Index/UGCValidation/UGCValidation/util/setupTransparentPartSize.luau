local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local AssetTraversalUtils = require(ParentParent.util.AssetTraversalUtils)
local ConstantsInterface = require(ParentParent.ConstantsInterface)
local R15plusUtils = require(ParentParent.util.R15plusUtils)
local getAttachmentCFrameInPartSpace = require(ParentParent.util.getAttachmentCFrameInPartSpace)

return function(p1, p2, p3, p4, p5) -- line: 15
	-- upvalues: AssetTraversalUtils (copy), ConstantsInterface (copy), R15plusUtils (copy), getAttachmentCFrameInPartSpace (copy)
	local t1 = {}

	if p4 == Enum.AssetType.DynamicHead then
		AssetTraversalUtils.calculateBounds(p4, p3, CFrame.new(), t1, p5)
		p1.CFrame = CFrame.new()
		p2.CFrame = CFrame.new()
		p1.Size = p2.Size
	else
		local v12 = AssetTraversalUtils.assetHierarchy[p4]

		AssetTraversalUtils.traverseHierarchy(nil, p3, p4, nil, CFrame.new(), v12.root, v12, t1, p5)

		local function moveParts(p6, s1: string?, cFrame: CFrame, s2: string, p7) -- line: 48
			-- upvalues: ConstantsInterface (copy), p4 (copy), R15plusUtils (copy), getAttachmentCFrameInPartSpace (copy), moveParts (copy)
			local s2_2 = p6:FindFirstChild(s2)

			if s1 then
				local s1_2 = p6:FindFirstChild(s1)
				local v27 = ConstantsInterface.getRigAttachmentToParent(p4, s2)
				local v28 = s1_2:FindFirstChild(v27, R15plusUtils.checkFlagEnabledForAllowHrd())
				local v29 = s2_2:FindFirstChild(v27, R15plusUtils.checkFlagEnabledForAllowHrd())

				cFrame = cFrame * getAttachmentCFrameInPartSpace(v28) * getAttachmentCFrameInPartSpace(v29):Inverse()
			end

			s2_2.CFrame = cFrame

			if p7.children then
				for v30, v31 in p7.children do
					moveParts(p6, s2, cFrame, v30, v31)
				end
			end
		end

		local cFrame = CFrame.new()
		local root = v12.root

		p2:FindFirstChild(root).CFrame = cFrame

		if v12.children then
			for v16, v17 in v12.children do
				moveParts(p2, root, cFrame, v16, v17)
			end
		end

		Vector3.new()
		Vector3.new()

		local v18 = if not t1.maxOverall then Vector3.new() else t1.maxOverall
		local v19 = if not t1.minOverall then Vector3.new() else t1.minOverall

		if t1.minOverall == nil or t1.maxOverall == nil then
			return false
		end

		p1.Size = Vector3.new(v18.X - v19.X, v18.Y - v19.Y, v18.Z - v19.Z)
		p1.Position = Vector3.new(v19.X + p1.Size.X / 2, v19.Y + p1.Size.Y / 2, v19.Z + p1.Size.Z / 2)
	end

	return true
end
