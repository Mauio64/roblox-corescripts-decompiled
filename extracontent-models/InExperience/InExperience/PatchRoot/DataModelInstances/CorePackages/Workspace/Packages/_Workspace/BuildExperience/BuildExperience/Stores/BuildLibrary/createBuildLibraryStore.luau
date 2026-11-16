local BuildExperience = script:FindFirstAncestor("BuildExperience")
local Signals = require(BuildExperience.Parent.Signals)

local defineFastString = game:DefineFastString(
	"BuildExperienceLibraryImageClasses",
	"Decal,Texture,ImageLabel,ImageButton"
)
local defineFastString2 = game:DefineFastString(
	"BuildExperienceLibraryRoots",
	"Workspace,ReplicatedStorage,ReplicatedFirst,Lighting,SoundService,StarterGui,StarterPack,StarterPlayer"
)

local defineFastString3 = game:DefineFastString("BuildExperienceLibraryDescriptionAttribute", "SemanticDescription")

local v = {
	Decal = "Texture",
	Texture = "Texture",
	ImageLabel = "Image",
	ImageButton = "Image",
	ParticleEmitter = "Texture",
	Beam = "Texture",
	Trail = "Texture"
}

local v2 = { Model = 1, Image = 2, Sound = 3 }

local function parseList(value: string)
	local list = {}

	for k in string.gmatch(value, "[^,]+") do
		local v3 = string.match(k, "^%s*(.-)%s*$")

		if v3 == "" or table.find(list, v3) then
			continue
		end

		table.insert(list, v3)
	end

	return list
end

local function createBuildLibraryStore(p)
	local v3 = p or game
	local v4 = parseList(defineFastString)
	local v5 = parseList(defineFastString2)
	local signal, v6 = Signals.createSignal({})
	local object = setmetatable({}, { __mode = "k" })
	local count = 0
	local v7 = nil
	local function getId(p2) -- 2 equivalent calls inferred from this helper
		if object[p2] == nil then
			count += 1
			object[p2] = `Instance:{count}`
		end

		return object[p2]
	end

	local v8 = {}

	local function sameItems(list, list2): boolean
		if #list ~= #list2 then
			return false
		end

		for k, item in list2 do
			local item2 = list[k]

			for k2, v9 in item do
				if item2[k2] ~= v9 then
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
			local v9 = {}
			local set = {}
			v7 = nil
			local function parentFolderId(child, result, serviceName: string, kind: string)
				local parent = child.Parent

				while parent ~= nil and parent ~= result do
					if parent.ClassName == "Folder" then
						local formatted = `{getId(parent)}:{kind}` -- inferred equivalent call

						if not set[formatted] then
							set[formatted] = true
							table.insert(v9, {
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

			for _, serviceName in v5 do
				local success, result = pcall(function()
					return v3:GetService(serviceName)
				end)

				if not (success and result ~= nil) then
					continue
				end

				if serviceName == "Workspace" then
					v7 = result
				end

				local children = result:GetChildren()
				local v10 = 1

				while v10 <= #children do
					local child = children[v10]
					v10 += 1
					local className = child.ClassName

					if className ~= "Model" then
						for _, child2 in child:GetChildren() do
							table.insert(children, child2)
						end
					end

					local v11

					if table.find(v4, className) then
						v11 = v[className]
					end

					local kind

					if className == "Model" then
						kind = "Model"
					elseif className == "Sound" then
						v11 = "SoundId"
						kind = "Sound"
					elseif v11 == nil then
						continue
					else
						kind = "Image"
					end

					local soundId

					if v11 ~= nil then
						soundId = child[v11]
					end

					if soundId == "" then
						continue
					end

					local attribute = child:GetAttribute(defineFastString3)
					local v12 = {
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

					v12.description = attribute
					local image

					if kind == "Image" then
						image = soundId
					end

					v12.image = image

					if kind ~= "Sound" then
						soundId = nil
					end

					v12.soundId = soundId

					if kind ~= "Model" then
						child = nil
					end

					v12.model = child
					table.insert(v9, v12)
				end
			end

			local displayNames = {}

			for _, v10 in v9 do
				displayNames[v10] = string.lower(v10.displayName)
			end

			table.sort(v9, function(a, b): boolean
				if a.kind ~= b.kind then
					return v2[a.kind] < v2[b.kind]
				end

				local v10 = displayNames[a]
				local v11 = displayNames[b]

				if v10 ~= v11 then
					return v10 < v11
				end

				if a.path == b.path then
					return a.id < b.id
				end

				return a.path < b.path
			end)

			if sameItems(signal(false), v9) then
				return
			end

			v8 = {}

			for _, v10 in v9 do
				v8[v10.id] = v10
			end

			v6(v9)
		end,
		getItems = signal,
		getItem = function(p2, p3: string)
			signal(p2)
			return v8[p3]
		end,
		resolveWorldItem = function(instance)
			while instance ~= nil do
				local v9 = object[instance]
				local selected

				if v9 ~= nil then
					selected = v8[v9]
				end

				if selected == nil or selected.model ~= instance then
					instance = instance.Parent
				elseif v7 == nil or not instance:IsDescendantOf(v7) then
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
