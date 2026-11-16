local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local getInstanceProperties = require(script.Parent.getInstanceProperties)
local function hasGuiBase2dChildren(instance): boolean
	if instance == nil then
		return false
	end

	for _, guiBase2d in instance:GetChildren() do
		if guiBase2d:IsA("GuiBase2d") or hasGuiBase2dChildren(guiBase2d) then
			return true
		end
	end

	return false
end

local function getDataModelNode(child, p)
	if child == nil then
		return nil
	end

	local isA = child:IsA("Folder")
	local isA2 = child:IsA("GuiBase2d")

	if not (isA or isA2) or isA and not hasGuiBase2dChildren(child) then
		return nil
	end

	local children = {}

	for _, child2 in child:GetChildren() do
		local v = getDataModelNode(child2, p)

		if v ~= nil then
			table.insert(children, v)
		end
	end

	return {
		Children = children,
		Properties = getInstanceProperties(child, p)
	}
end

local function getDataModelRoot(p)
	local currentCamera = game.Workspace.CurrentCamera
	local viewport = currentCamera and { currentCamera.ViewportSize.X, currentCamera.ViewportSize.Y } or { 0, 0 }

	local dataModelNodes = {}

	for _, child in CoreGui:GetChildren() do
		local dataModelNode = getDataModelNode(child, p)

		if dataModelNode ~= nil then
			table.insert(dataModelNodes, dataModelNode)
		end
	end

	local guiInset, v = GuiService:GetGuiInset()
	return {
		Children = dataModelNodes,
		Properties = {
			Viewport = viewport,
			Name = "CoreGui",
			GuiInset = { guiInset.X, guiInset.Y, v.X, v.Y }
		}
	}
end

return getDataModelRoot
