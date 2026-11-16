require(script.Parent.Types)
local function readValue(child)
	if child:IsA("StringValue") or (child:IsA("IntValue") or child:IsA("NumberValue")) or child:IsA("BoolValue") then
		return child.Value
	end

	if
		child:IsA("Color3Value")
		or child:IsA("Vector3Value")
		or child:IsA("CFrameValue")
		or child:IsA("ObjectValue")
	then
		return child.Value
	end

	if not child:IsA("Folder") then
		return nil
	end

	local children = child:GetChildren()

	local v = #children > 0
	local v2 = {}

	for _, child2 in children do
		local name = tonumber(child2.Name)

		if name == nil or name < 1 or name % 1 ~= 0 then
			v = false
			break
		end

		table.insert(v2, { index = name, child = child2 })
	end

	if v then
		table.sort(v2, function(a, b): boolean
			return a.index < b.index
		end)

		local result = {}

		for k, v3 in v2 do
			local v4 = readValue(v3.child)

			result[k] = v4

			if v4 == nil then
				warn(`parseSceneAsset: {v3.child:GetFullName()} is a {v3.child.ClassName}, which holds no value this parser reads. Slot {k} is empty.`)
			end
		end

		return result
	else
		local result = {}

		for _, child2 in children do
			result[child2.Name] = readValue(child2)
		end

		return result
	end
end

local function findSceneFolder(instance)
	local momentScene = instance:FindFirstChild("MomentScene")

	if momentScene ~= nil then
		return momentScene
	end

	if not (instance:FindFirstChild("Type") == nil and instance:FindFirstChild("Args") == nil) then
		return instance
	end

	for _, child in instance:GetChildren() do
		if child:FindFirstChild("Type") ~= nil or child:FindFirstChild("Args") ~= nil then
			return child
		end
	end

	return instance
end

local function parseSceneAsset(p)
	local sceneFolder = findSceneFolder(p)

	local value = nil
	local kind

	if sceneFolder then
		kind = sceneFolder:FindFirstChild("Type")
	end

	if kind ~= nil and kind:IsA("StringValue") then
		value = kind.Value
	end

	local args2 = {}
	local args

	if sceneFolder then
		args = sceneFolder:FindFirstChild("Args")
	end

	if args ~= nil then
		for _, child in args:GetChildren() do
			args2[child.Name] = readValue(child)
		end
	end

	return { type = value, args = args2 }
end

return parseSceneAsset
