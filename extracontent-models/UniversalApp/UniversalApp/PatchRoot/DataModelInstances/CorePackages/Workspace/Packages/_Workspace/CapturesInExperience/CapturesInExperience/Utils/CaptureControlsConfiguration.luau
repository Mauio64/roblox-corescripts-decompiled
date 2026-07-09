local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Cryo = require(ParentParentParent.Cryo)
local getDeepValue = require(ParentParentParent.LuaSocialLibrariesDeps).SocialLibraries.config({}).Dictionary.getDeepValue
local getLocalUserId = require(ParentParent.Utils.getLocalUserId)
local Constants = require(ParentParent.Constants)
local EngineFeature = game:GetEngineFeature("CaptureControlsAppStorageEnabled")
local vector2 = Vector2.new(1, 0.5)
local t1 = {}
local t2 = {}
local str = tostring(game.GameId)
local v15 = getLocalUserId(Players)
local v16 = game:DefineFastInt("CaptureControlsStoredAnchorPoints", 100)

function t1.getStoredSnapAnchorPoint() -- line: 28
	-- upvalues: EngineFeature (copy), v15 (copy), vector2 (copy), AppStorageService (copy), Constants (copy), HttpService (copy), t2 (ref), getDeepValue (copy), str (copy)
	if not EngineFeature or not v15 then
		return vector2
	end

	local ok, result = pcall(function() -- line: 33
		-- upvalues: AppStorageService (copy), Constants (copy)
		return AppStorageService:GetItem(Constants.CaptureControlsPositionStorageKey)
	end)

	if not ok then
		return vector2
	end

	local ok2, result2 = pcall(function() -- line: 41
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok2 then
		return vector2
	end

	t2 = result2

	local v21 = getDeepValue(result2, string.format("%s.%s", v15, str))

	if not v21 then
		return vector2
	end

	return (Vector2.new(v21.X, v21.Y))
end
function t1.setStoredSnapAnchorPoint(vector2_2: Vector2) -- line: 62
	-- upvalues: EngineFeature (copy), v15 (copy), t2 (ref), str (copy), Cryo (copy), v16 (copy), AppStorageService (copy), Constants (copy), HttpService (copy)
	if not EngineFeature or not v15 then
		return
	end

	local t3 = {
		X = vector2_2.X,
		Y = vector2_2.Y,
		timestamp = os.time()
	}
	local u24 = t2[v15] or {}

	u24[str] = t3

	local v25 = Cryo.Dictionary.keys(u24)

	if #v25 > v16 then
		local v26 = Cryo.List.sort(v25, function(p1, p2) -- line: 79
			-- upvalues: u24 (ref)
			return u24[p1].timestamp > u24[p2].timestamp
		end)
		local v27 = Cryo.List.toSet(Cryo.List.removeRange(v26, v16 + 1, #v26))

		u24 = Cryo.Dictionary.filter(u24, function(_, p4) -- line: 86
			-- upvalues: v27 (copy)
			return v27[p4]
		end)
	end

	local v28 = Cryo.Dictionary.union(t2, {
		[v15] = u24
	})

	AppStorageService:SetItem(Constants.CaptureControlsPositionStorageKey, HttpService:JSONEncode(v28))
	t2 = v28
end

return t1
