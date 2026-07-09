local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local getInstanceProperties = require(script.Parent.getInstanceProperties)

local function hasGuiBase2dChildren(p1) -- line: 10
	-- upvalues: hasGuiBase2dChildren (copy)
	if p1 == nil then
		return false
	end

	for _, child in p1:GetChildren() do
		if child:IsA("GuiBase2d") then
			return true
		end

		if hasGuiBase2dChildren(child) then
			return true
		end
	end

	return false
end
local function getDataModelNode(p2, t1: {[any]: any}?) -- line: 28
	-- upvalues: hasGuiBase2dChildren (copy), getDataModelNode (copy), getInstanceProperties (copy)
	if p2 == nil then
		return nil
	end

	local v12 = p2:IsA("Folder")
	local v13 = p2:IsA("GuiBase2d")

	if not v12 and not v13 then
		return nil
	end

	if v12 and not hasGuiBase2dChildren(p2) then
		return nil
	end

	local t2 = {}

	for _, child in p2:GetChildren() do
		local v17 = getDataModelNode(child, t1)

		if v17 ~= nil then
			table.insert(t2, v17)
		end
	end

	return {
		Children = t2,
		Properties = getInstanceProperties(p2, t1)
	}
end
local function getDataModelRoot(t3: {[any]: any}?) -- line: 58
	-- upvalues: CoreGui (copy), getDataModelNode (copy), GuiService (copy)
	local t4 = {
		0,
		0
	}
	local CurrentCamera = game.Workspace.CurrentCamera

	if CurrentCamera then
		t4 = {
			CurrentCamera.ViewportSize.X,
			CurrentCamera.ViewportSize.Y
		}
	end

	local t5 = {}

	for _, child in CoreGui:GetChildren() do
		local v24 = getDataModelNode(child, t3)

		if v24 ~= nil then
			table.insert(t5, v24)
		end
	end

	local v25, v26 = GuiService:GetGuiInset()
	local t6 = {
		v25.X,
		v25.Y,
		v26.X,
		v26.Y
	}

	return {
		Children = t5,
		Properties = {
			Name = "CoreGui",
			Viewport = t4,
			GuiInset = t6
		}
	}
end

return getDataModelRoot
