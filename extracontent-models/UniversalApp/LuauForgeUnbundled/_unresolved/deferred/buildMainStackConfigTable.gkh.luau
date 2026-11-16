local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/deferred/gki")

local module2 = require("@luauforge/deferred/gkj")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local module3 = require("@luauforge/deferred/geR")

local module4 = require("@luauforge/deferred/gkl")

local module5 = require("@luauforge/deferred/gqR")

local function buildMainStackConfigTable(p2)
	local v5 = {}

	if not module4[p2] then
		error("Initial route is not supported by AvatarExperienceWrapper: " .. tostring(p2))
	end

	local v6 = module5(module4[p2])

	local function addScreen(p3, p4)
		if not v5[p3] then
			v5[p3] = p4
		end
	end

	local function removeScreen(p3)
		v5[p3] = nil
	end

	for k, v7 in avatarScreen do
		local v8 = module4[v7] ~= nil and module or module2

		if not v5[v7] then
			v5[v7] = v8
		end
	end

	for k, v7 in module3 do
		for k2, v8 in v7 do
			v5[k2] = nil
		end
	end

	v5[avatarScreen.AvatarExperienceMainStackNavigator] = nil
	v5[p2] = nil

	return (Cryo.List.join({
		{ [p2] = v6 }
	}, Cryo.List.map(Cryo.Dictionary.keys(v5), function(p3)
		return { [p3] = v5[p3] }
	end)))
end

return buildMainStackConfigTable
