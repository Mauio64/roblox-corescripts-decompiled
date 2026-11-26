local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local getInstanceProperties = require("@game/CorePackages/Workspace/Packages/_Workspace/DataModelStreaming/DataModelStreaming/getInstanceProperties")
local function hasGuiBase2dChildren(instance): boolean
	if instance == nil then
		return false
	end

	for i, guiBase2d in instance:GetChildren() do
		if guiBase2d:IsA("GuiBase2d") or hasGuiBase2dChildren(guiBase2d) then
			return true
		end
	end

	return false
end

local function getDataModelNode(child, p2)
	if child == nil then
		return nil
	end

	local isA = child:IsA("Folder")
	local isA2 = child:IsA("GuiBase2d")

	if not (isA or isA2) or isA and not hasGuiBase2dChildren(child) then
		return nil
	end

	local v5 = {}

	for i, child2 in child:GetChildren() do
		local v6 = getDataModelNode(child2, p2)

		if v6 ~= nil then
			table.insert(v5, v6)
		end
	end

	return { Children = v5, Properties = getInstanceProperties(child, p2) }
end

local function getDataModelRoot(p2)
	local currentCamera = game.Workspace.CurrentCamera
	local v5 = currentCamera and { currentCamera.ViewportSize.X, currentCamera.ViewportSize.Y } or { 0, 0 }

	local dataModelNodes = {}

	for i, child in CoreGui:GetChildren() do
		local dataModelNode = getDataModelNode(child, p2)

		if dataModelNode ~= nil then
			table.insert(dataModelNodes, dataModelNode)
		end
	end

	local guiInset, v6 = GuiService:GetGuiInset()
	return {
		Children = dataModelNodes,
		Properties = {
			Viewport = v5,
			Name = "CoreGui",
			GuiInset = { guiInset.X, guiInset.Y, v6.X, v6.Y }
		}
	}
end

return getDataModelRoot
