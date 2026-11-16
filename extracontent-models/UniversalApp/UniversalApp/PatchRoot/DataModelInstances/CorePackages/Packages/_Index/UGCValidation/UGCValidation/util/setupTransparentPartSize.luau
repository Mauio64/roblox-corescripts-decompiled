local parent = script.Parent.Parent
require(parent.util.Types)
local AssetTraversalUtils = require(parent.util.AssetTraversalUtils)
local ConstantsInterface = require(parent.ConstantsInterface)
local R15plusUtils = require(parent.util.R15plusUtils)
local getAttachmentCFrameInPartSpace = require(parent.util.getAttachmentCFrameInPartSpace)

return function(p, instance, p2, p3, p4): boolean
	local v = {}

	if Enum.AssetType.DynamicHead == p3 then
		AssetTraversalUtils.calculateBounds(p3, p2, CFrame.new(), v, p4)

		p.CFrame = CFrame.new()
		instance.CFrame = CFrame.new()

		p.Size = instance.Size
	else
		local v2 = AssetTraversalUtils.assetHierarchy[p3]
		AssetTraversalUtils.traverseHierarchy(nil, p2, p3, nil, CFrame.new(), v2.root, v2, v, p4)
		local function moveParts(instance2, root: string?, cframe: CFrame, childName: string, child)
			local child2 = instance2:FindFirstChild(childName)

			if root then
				local child3 = instance2:FindFirstChild(root)
				local rigAttachmentToParent = ConstantsInterface.getRigAttachmentToParent(p3, childName)
				local child4 = child3:FindFirstChild(rigAttachmentToParent, R15plusUtils.checkFlagEnabledForAllowHrd())

				local child5 = child2:FindFirstChild(rigAttachmentToParent, R15plusUtils.checkFlagEnabledForAllowHrd())

				cframe = cframe * getAttachmentCFrameInPartSpace(child4) * getAttachmentCFrameInPartSpace(child5):Inverse()
			end

			child2.CFrame = cframe

			if child.children then
				for k, child3 in child.children do
					moveParts(instance2, childName, cframe, k, child3)
				end
			end
		end
		local cframe = CFrame.new()
		local root = v2.root
		local findFirstChild = instance:FindFirstChild(root)

		findFirstChild.CFrame = cframe

		if v2.children then
			for k, child in v2.children do
				moveParts(instance, root, cframe, k, child)
			end
		end

		Vector3.new()
		Vector3.new()
		local v3

		if v.maxOverall then
			v3 = v.maxOverall
		else
			v3 = Vector3.new()
		end

		local v4

		if v.minOverall then
			v4 = v.minOverall
		else
			v4 = Vector3.new()
		end

		if v.minOverall == nil or v.maxOverall == nil then
			return false
		end

		p.Size = Vector3.new(v3.X - v4.X, v3.Y - v4.Y, v3.Z - v4.Z)
		p.Position = Vector3.new(v4.X + p.Size.X / 2, v4.Y + p.Size.Y / 2, v4.Z + p.Size.Z / 2)
	end

	return true
end
