local BuildExperience = script:FindFirstAncestor("BuildExperience")
local Signals = require(BuildExperience.Parent.Signals)

local defineFastString = game:DefineFastString(
	"BuildExperienceLibraryImageClasses",
	"Decal,Texture,ImageLabel,ImageButton"
)
local defineFastString2 = game:DefineFastString("BuildExperienceLibrarySoundClasses", "Sound")
local defineFastString3 = game:DefineFastString(
	"BuildExperienceLibraryRoots",
	"Workspace,ReplicatedStorage,ReplicatedFirst,Lighting,SoundService,StarterGui,StarterPack,StarterPlayer"
)

local defineFastString4 = game:DefineFastString("BuildExperienceLibraryDescriptionAttribute", "SemanticDescription")

local v = {
	Decal = "Texture",
	Texture = "Texture",
	ImageLabel = "Image",
	ImageButton = "Image",
	ParticleEmitter = "Texture",
	Beam = "Texture",
	Trail = "Texture"
}

local v2 = { Sound = "SoundId", AudioPlayer = "Asset" }

local v3 = { Model = 1, Image = 2, Sound = 3 }

local function parseList(value: string)
	local list = {}

	for k in string.gmatch(value, "[^,]+") do
		local v4 = string.match(k, "^%s*(.-)%s*$")

		if v4 == "" or table.find(list, v4) then
			continue
		end

		table.insert(list, v4)
	end

	return list
end

local function createBuildLibraryStore(p)
	local v4 = p or game
	local v5 = parseList(defineFastString)
	local v6 = parseList(defineFastString2)
	local v7 = parseList(defineFastString3)
	local signal, v8 = Signals.createSignal({})
	local object = setmetatable({}, { __mode = "k" })
	local count = 0
	local v9 = nil
	local function getId(p2) -- 2 equivalent calls inferred from this helper
		if object[p2] == nil then
			count += 1
			object[p2] = `Instance:{count}`
		end

		return object[p2]
	end

	local v10 = {}

	local function sameItems(list, list2): boolean
		if #list ~= #list2 then
			return false
		end

		for k, item in list2 do
			local item2 = list[k]

			for k2, v11 in item do
				if item2[k2] ~= v11 then
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
			local v11 = {}
			local set = {}
			v9 = nil
			local function parentFolderId(child, result, serviceName: string, kind: string)
				local parent = child.Parent

				while parent ~= nil and parent ~= result do
					if parent.ClassName == "Folder" then
						local formatted = `{getId(parent)}:{kind}` -- inferred equivalent call

						if not set[formatted] then
							set[formatted] = true
							table.insert(v11, {
								id = formatted,
								instance = parent,
								displayName = parent.Name,
								path = parent:GetFullName(),
								className = "Folder",
								kind = kind,
								folderId = parentFolderId(parent, result, serviceName, kind),
								rootName = serviceName
							})
						end

						return formatted
					end

					parent = parent.Parent
				end

				return nil
			end

			for _, serviceName in v7 do
				local success, result = pcall(function()
					return v4:GetService(serviceName)
				end)

				if not (success and result ~= nil) then
					continue
				end

				if serviceName == "Workspace" then
					v9 = result
				end

				local children = result:GetChildren()
				local v12 = 1

				while v12 <= #children do
					local child = children[v12]
					v12 += 1
					local className = child.ClassName

					if className ~= "Model" then
						for _, child2 in child:GetChildren() do
							table.insert(children, child2)
						end
					end

					local v13

					if table.find(v5, className) then
						v13 = v[className]
					end

					local v14

					if table.find(v6, className) then
						v14 = v2[className]
					end

					local kind

					if className == "Model" then
						kind = "Model"
					elseif v14 == nil then
						if v13 == nil then
							continue
						end

						kind = "Image"
					else
						v13 = v14
						kind = "Sound"
					end

					local soundId

					if v13 ~= nil then
						soundId = child[v13]
					end

					if soundId == "" then
						continue
					end

					local attribute = child:GetAttribute(defineFastString4)
					local v15 = {
						id = getId(child), -- inferred equivalent call
						instance = child,
						displayName = child.Name,
						path = child:GetFullName(),
						className = className,
						kind = kind,
						folderId = parentFolderId(child, result, serviceName, kind),
						rootName = serviceName,
						description = 0,
						image = 0,
						soundId = 0,
						model = 0
					}

					if type(attribute) ~= "string" or attribute == "" then
						attribute = nil
					end

					v15.description = attribute
					local image

					if kind == "Image" then
						image = soundId
					end

					v15.image = image

					if kind ~= "Sound" then
						soundId = nil
					end

					v15.soundId = soundId

					if kind ~= "Model" then
						child = nil
					end

					v15.model = child
					table.insert(v11, v15)
				end
			end

			local displayNames = {}

			for _, v12 in v11 do
				displayNames[v12] = string.lower(v12.displayName)
			end

			table.sort(v11, function(a, b): boolean
				if a.kind ~= b.kind then
					return v3[a.kind] < v3[b.kind]
				end

				local v12 = displayNames[a]
				local v13 = displayNames[b]

				if v12 ~= v13 then
					return v12 < v13
				end

				if a.path == b.path then
					return a.id < b.id
				end

				return a.path < b.path
			end)

			if sameItems(signal(false), v11) then
				return
			end

			v10 = {}

			for _, v12 in v11 do
				v10[v12.id] = v12
			end

			v8(v11)
		end,
		getItems = signal,
		getItem = function(p2, p3: string)
			signal(p2)
			return v10[p3]
		end,
		resolveWorldItem = function(instance)
			while instance ~= nil do
				local v11 = object[instance]
				local selected

				if v11 ~= nil then
					selected = v10[v11]
				end

				if selected == nil or selected.model ~= instance then
					instance = instance.Parent
				elseif v9 == nil or not instance:IsDescendantOf(v9) then
					return nil
				else
					return selected
				end
			end

			return nil
		end
	}
end

return createBuildLibraryStore
