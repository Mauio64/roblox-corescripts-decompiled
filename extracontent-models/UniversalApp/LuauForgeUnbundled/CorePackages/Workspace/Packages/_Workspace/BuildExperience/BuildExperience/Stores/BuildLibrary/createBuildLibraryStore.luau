local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")

local defineFastString = game:DefineFastString(
	"BuildExperienceLibraryImageClasses",
	"Decal,Texture,ImageLabel,ImageButton"
)
local defineFastString2 = game:DefineFastString(
	"BuildExperienceLibraryRoots",
	"Workspace,ReplicatedStorage,ReplicatedFirst,Lighting,SoundService,StarterGui,StarterPack,StarterPlayer"
)

local defineFastString3 = game:DefineFastString(
	"BuildExperienceLibraryDescriptionAttribute",
	"SemanticDescription"
)

local v5 = {
	Decal = "Texture",
	Texture = "Texture",
	ImageLabel = "Image",
	ImageButton = "Image",
	ParticleEmitter = "Texture",
	Beam = "Texture",
	Trail = "Texture"
}

local v6 = { Model = 1, Image = 2, Sound = 3 }

local function parseList(value)
	local list = {}

	for k in string.gmatch(value, "[^,]+") do
		local v7 = string.match(k, "^%s*(.-)%s*$")

		if v7 == "" or table.find(list, v7) then
			continue
		end

		table.insert(list, v7)
	end

	return list
end

local function createBuildLibraryStore(p2)
	local v7 = p2 or game
	local v8 = parseList(defineFastString)
	local v9 = parseList(defineFastString2)
	local signal, v10 = Signals.createSignal({})
	local object = setmetatable({}, { __mode = "k" })
	local count = 0
	local v11 = nil
	local function getId(p3)
		if object[p3] == nil then
			count += 1
			object[p3] = `Instance:{count}`
		end

		return object[p3]
	end

	local v12 = {}

	local function sameItems(list, list2): boolean
		if #list ~= #list2 then
			return false
		end

		for k, item in list2 do
			local item2 = list[k]

			for k2, v13 in item do
				if item2[k2] ~= v13 then
					return false
				end
			end

			for k2 in item2 do
				if item[k2] == nil then
					return false
				end
			end
		end

		return true
	end

	return {
		refresh = function()
			local v13 = {}
			local set = {}
			v11 = nil
			local function parentFolderId(child, result, serviceName, p3)
				local parent = child.Parent

				while parent ~= nil and parent ~= result do
					if parent.ClassName == "Folder" then
						if object[parent] == nil then
							count += 1
							object[parent] = `Instance:{count}`
						end

						local formatted = `{object[parent]}:{p3}`

						if not set[formatted] then
							set[formatted] = true
							table.insert(v13, {
								id = formatted,
								instance = parent,
								displayName = parent.Name,
								path = parent:GetFullName(),
								className = "Folder",
								kind = p3,
								folderId = parentFolderId(parent, result, serviceName, p3),
								rootName = serviceName
							})
						end

						return formatted
					end

					parent = parent.Parent
				end

				return nil
			end

			for k, serviceName in v9 do
				local success, result = pcall(function()
					return v7:GetService(serviceName)
				end)

				if not (success and result ~= nil) then
					continue
				end

				if serviceName == "Workspace" then
					v11 = result
				end

				local children = result:GetChildren()
				local v14 = 1

				while v14 <= #children do
					local child = children[v14]
					v14 += 1
					local className = child.ClassName

					if className ~= "Model" then
						for i, child2 in child:GetChildren() do
							table.insert(children, child2)
						end
					end

					local v15 = if table.find(v8, className) then v5[className] else nil
					local v16

					if className == "Model" then
						v16 = "Model"
					elseif className == "Sound" then
						v15 = "SoundId"
						v16 = "Sound"
					elseif v15 == nil then
						continue
					else
						v16 = "Image"
					end

					local v17 = if v15 ~= nil then child[v15] else nil

					if v17 == "" then
						continue
					end

					local attribute = child:GetAttribute(defineFastString3)

					if object[child] == nil then
						count += 1
						object[child] = `Instance:{count}`
					end

					local v18 = {
						id = object[child],
						instance = child,
						displayName = child.Name,
						path = child:GetFullName(),
						className = className,
						kind = v16,
						folderId = parentFolderId(child, result, serviceName, v16),
						rootName = serviceName,
						description = 0,
						image = 0,
						soundId = 0,
						model = 0
					}

					if type(attribute) ~= "string" or attribute == "" then
						attribute = nil
					end

					v18.description = attribute
					local v19 = if v16 == "Image" then v17 else nil
					v18.image = v19

					if v16 ~= "Sound" then
						v17 = nil
					end

					v18.soundId = v17

					if v16 ~= "Model" then
						child = nil
					end

					v18.model = child
					table.insert(v13, v18)
				end
			end

			local displayNames = {}

			for k, v14 in v13 do
				displayNames[v14] = string.lower(v14.displayName)
			end

			table.sort(v13, function(a, b): boolean
				if a.kind ~= b.kind then
					return v6[a.kind] < v6[b.kind]
				end

				local v14 = displayNames[a]
				local v15 = displayNames[b]

				if v14 ~= v15 then
					return v14 < v15
				end

				if a.path == b.path then
					return a.id < b.id
				end

				return a.path < b.path
			end)

			if sameItems(signal(false), v13) then
				return
			end

			v12 = {}

			for k, v14 in v13 do
				v12[v14.id] = v14
			end

			v10(v13)
		end,
		getItems = signal,
		getItem = function(p3, p4)
			signal(p3)
			return v12[p4]
		end,
		resolveWorldItem = function(instance)
			while instance ~= nil do
				local v13 = object[instance]
				local v14 = if v13 ~= nil then v12[v13] else nil

				if v14 == nil or v14.model ~= instance then
					instance = instance.Parent
				elseif v11 == nil or not instance:IsDescendantOf(v11) then
					return nil
				else
					return v14
				end
			end

			return nil
		end
	}
end

return createBuildLibraryStore
