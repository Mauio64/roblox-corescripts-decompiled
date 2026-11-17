local BuildExperience = script:FindFirstAncestor("BuildExperience")

local FIntBuildExperienceLibraryWorldFocusRadius = require(BuildExperience.Flags.FIntBuildExperienceLibraryWorldFocusRadius)
local getModelBox = require(script.Parent.getModelBox)

local function median(list) -- 3 equivalent calls inferred from this helper
	table.sort(list)
	local v = #list // 2

	if #list % 2 == 1 then
		return list[v + 1]
	end

	return (list[v] + list[v + 1]) / 2
end

local function getSpawnPosition(instance) -- 1 equivalent call inferred from this helper
	local spawnLocation

	if instance ~= nil then
		spawnLocation = instance:FindFirstChildWhichIsA("SpawnLocation", true)
	end

	return if spawnLocation ~= nil then spawnLocation.Position else nil
end

local function getMiddleModelCenter(modelBoxes)
	local v = {}
	local v2 = {}
	local zes = {}

	for _, item in modelBoxes do
		table.insert(v, item.center.X)
		table.insert(v2, item.center.Y)
		table.insert(zes, item.center.Z)
	end

	local vector3 = Vector3.new(median(v), median(v2), median(zes)) -- inferred equivalent call
	local center = modelBoxes[1].center

	for i = 2, #modelBoxes do
		if (modelBoxes[i].center - vector3).Magnitude < (center - vector3).Magnitude then
			center = modelBoxes[i].center
		end
	end

	return center
end

local function getDefaultWorldFocus(items, instance)
	local modelBoxes = {}

	for _, item in items do
		local modelBox = getModelBox(item)

		if modelBox ~= nil then
			table.insert(modelBoxes, modelBox)
		end
	end

	if #modelBoxes == 0 then
		return nil
	end

	local position = getSpawnPosition(instance) or getMiddleModelCenter(modelBoxes) -- inferred equivalent call
	local magnitudes = {}

	for _, v in modelBoxes do
		magnitudes[v] = (v.center - position).Magnitude
	end

	table.sort(modelBoxes, function(a, b): boolean
		return magnitudes[a] < magnitudes[b]
	end)

	local minimum = modelBoxes[1].minimum
	local maximum = modelBoxes[1].maximum

	for i = 2, math.max(1, (math.ceil(#modelBoxes * 0.8))) do
		minimum = minimum:Min(modelBoxes[i].minimum)
		maximum = maximum:Max(modelBoxes[i].maximum)
	end

	local radius = (maximum - minimum).Magnitude / 2
	local radius2 = math.max(1, FIntBuildExperienceLibraryWorldFocusRadius)

	if radius2 < radius then
		return { position = position, radius = radius2 }
	end

	return {
		position = (minimum + maximum) / 2,
		radius = radius
	}
end

return getDefaultWorldFocus
