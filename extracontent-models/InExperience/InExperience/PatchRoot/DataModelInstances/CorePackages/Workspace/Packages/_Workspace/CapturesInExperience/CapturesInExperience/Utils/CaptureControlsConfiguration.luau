local parent = script.Parent.Parent
local parent2 = parent.Parent

local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local Cryo = require(parent2.Cryo)
local LuaSocialLibrariesDeps = require(parent2.LuaSocialLibrariesDeps)

local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue
local getLocalUserId = require(parent.Utils.getLocalUserId)

local Constants = require(parent.Constants)

local engineFeature = game:GetEngineFeature("CaptureControlsAppStorageEnabled")

local vector2 = Vector2.new(1, 0.5)

local v = {}

local gameId = tostring(game.GameId)
local localUserId = getLocalUserId(Players)

local defineFastInt = game:DefineFastInt("CaptureControlsStoredAnchorPoints", 100)
local CaptureControlsConfiguration = {}

function CaptureControlsConfiguration.getStoredSnapAnchorPoint()
	if not (engineFeature and localUserId) then
		return vector2
	end

	local success, result = pcall(function()
		return AppStorageService:GetItem(Constants.CaptureControlsPositionStorageKey)
	end)

	if not success then
		return vector2
	end

	local success2, result2 = pcall(function()
		return HttpService:JSONDecode(result)
	end)

	if not success2 then
		return vector2
	end

	v = result2

	local deepValue = getDeepValue(result2, string.format("%s.%s", localUserId, gameId))

	if deepValue then
		return (Vector2.new(deepValue.X, deepValue.Y))
	end

	return vector2
end

function CaptureControlsConfiguration.setStoredSnapAnchorPoint(vector2_2: Vector2)
	if not (engineFeature and localUserId) then
		return
	end

	local v2 = { X = vector2_2.X, Y = vector2_2.Y, timestamp = os.time() }

	local filtered = v[localUserId] or {}

	filtered[gameId] = v2

	local keys = Cryo.Dictionary.keys(filtered)

	if defineFastInt < #keys then
		local sorted = Cryo.List.sort(keys, function(p, p2): boolean
			return filtered[p].timestamp > filtered[p2].timestamp
		end)

		local set = Cryo.List.toSet(Cryo.List.removeRange(sorted, defineFastInt + 1, #sorted))

		filtered = Cryo.Dictionary.filter(filtered, function(_, p)
			return set[p]
		end)
	end

	local union = Cryo.Dictionary.union(v, { [localUserId] = filtered })

	AppStorageService:SetItem(Constants.CaptureControlsPositionStorageKey, HttpService:JSONEncode(union))
	v = union
end

return CaptureControlsConfiguration
