local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")

local defineFastString = game:DefineFastString(
	"BuildExperienceLibraryImageClasses",
	"Decal,Texture,ImageLabel,ImageButton"
)
local defineFastString2 = game:DefineFastString("BuildExperienceLibrarySoundClasses", "Sound")
local defineFastString3 = game:DefineFastString(
	"BuildExperienceLibraryRoots",
	"Workspace,ReplicatedStorage,ReplicatedFirst,Lighting,SoundService,StarterGui,StarterPack,StarterPlayer"
)

local defineFastString4 = game:DefineFastString(
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

local v6 = { Sound = "SoundId", AudioPlayer = "Asset" }

local v7 = { Model = 1, Image = 2, Sound = 3 }

local function parseList(value)
	local list = {}

	for k in string.gmatch(value, "[^,]+") do
		local v8 = string.match(k, "^%s*(.-)%s*$")

		if v8 == "" or table.find(list, v8) then
			continue
		end

		table.insert(list, v8)
	end

	return list
end

local function createBuildLibraryStore(p2)
	local v8 = p2 or game
	local v9 = parseList(defineFastString)
	local v10 = parseList(defineFastString2)
	local v11 = parseList(defineFastString3)
	local signal, v12 = Signals.createSignal({})
	local object = setmetatable({}, { __mode = "k" })
	local count = 0
	local v13 = nil
	local function getId(p3)
		if object[p3] == nil then
			count += 1
			object[p3] = `Instance:{count}`
		end

		return object[p3]
	end

	local v14 = {}

	local function sameItems(list, list2): boolean
		if #list ~= #list2 then
			return false
		end

		for k, item in list2 do
			local item2 = list[k]

			for k2, v15 in item do
				if item2[k2] ~= v15 then
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
			local v15 = {}
			local set = {}
			v13 = nil
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
							table.insert(v15, {
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

			for k, serviceName in v11 do
				local success, result = pcall(function()
					return v8:GetService(serviceName)
				end)

				if not (success and result ~= nil) then
					continue
				end

				if serviceName == "Workspace" then
					v13 = result
				end

				local children = result:GetChildren()
				local v16 = 1

				while v16 <= #children do
					local child = children[v16]
					v16 += 1
					local className = child.ClassName

					if className ~= "Model" then
						for i, child2 in child:GetChildren() do
							table.insert(children, child2)
						end
					end

					local v17 = if table.find(v9, className) then v5[className] else nil
					local v18 = if table.find(v10, className) then v6[className] else nil
					local v19

					if className == "Model" then
						v19 = "Model"
					elseif v18 == nil then
						if v17 == nil then
							continue
						end

						v19 = "Image"
					else
						v17 = v18
						v19 = "Sound"
					end

					local v20 = if v17 ~= nil then child[v17] else nil

					if v20 == "" then
						continue
					end

					local attribute = child:GetAttribute(defineFastString4)

					if object[child] == nil then
						count += 1
						object[child] = `Instance:{count}`
					end

					local v21 = {
						id = object[child],
						instance = child,
						displayName = child.Name,
						path = child:GetFullName(),
						className = className,
						kind = v19,
						folderId = parentFolderId(child, result, serviceName, v19),
						rootName = serviceName,
						description = 0,
						image = 0,
						soundId = 0,
						model = 0
					}

					if type(attribute) ~= "string" or attribute == "" then
						attribute = nil
					end

					v21.description = attribute
					local v22 = if v19 == "Image" then v20 else nil
					v21.image = v22

					if v19 ~= "Sound" then
						v20 = nil
					end

					v21.soundId = v20

					if v19 ~= "Model" then
						child = nil
					end

					v21.model = child
					table.insert(v15, v21)
				end
			end

			local displayNames = {}

			for k, v16 in v15 do
				displayNames[v16] = string.lower(v16.displayName)
			end

			table.sort(v15, function(a, b): boolean
				if a.kind ~= b.kind then
					return v7[a.kind] < v7[b.kind]
				end

				local v16 = displayNames[a]
				local v17 = displayNames[b]

				if v16 ~= v17 then
					return v16 < v17
				end

				if a.path == b.path then
					return a.id < b.id
				end

				return a.path < b.path
			end)

			if sameItems(signal(false), v15) then
				return
			end

			v14 = {}

			for k, v16 in v15 do
				v14[v16.id] = v16
			end

			v12(v15)
		end,
		getItems = signal,
		getItem = function(p3, p4)
			signal(p3)
			return v14[p4]
		end,
		resolveWorldItem = function(instance)
			while instance ~= nil do
				local v15 = object[instance]
				local v16 = if v15 ~= nil then v14[v15] else nil

				if v16 == nil or v16.model ~= instance then
					instance = instance.Parent
				elseif v13 == nil or not instance:IsDescendantOf(v13) then
					return nil
				else
					return v16
				end
			end

			return nil
		end
	}
end

return createBuildLibraryStore
