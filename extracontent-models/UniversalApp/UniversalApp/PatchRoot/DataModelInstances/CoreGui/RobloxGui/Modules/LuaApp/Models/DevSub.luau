local Modules = game:GetService("CoreGui").RobloxGui.Modules
local DevSubTypes = require(Modules.LuaApp.Types.DevSubTypes)
local DevSubStatus = require(Modules.LuaApp.Enum.DevSubStatus)
local DevSubPlanStatus = require(Modules.LuaApp.Enum.DevSubPlanStatus)
local t1 = {
	new = function() -- line: 24
		return {}
	end
}

function t1.mock() -- line: 29
	-- upvalues: DevSubStatus (copy), DevSubPlanStatus (copy), t1 (copy)
	local t2 = {
		DevSubStatus.Active,
		DevSubStatus.Inactive
	}
	local t3 = {
		DevSubPlanStatus.Open,
		DevSubPlanStatus.Closed,
		DevSubPlanStatus.Archived
	}

	local function stringChoose(p1) -- line: 42
		local v21 = math.random(1, #p1)

		return p1:sub(v21, v21)
	end
	local function getSyllable() -- line: 46
		local v22 = math.random(1, 6)
		local v23 = ("aeiouy"):sub(v22, v22)
		local v24 = math.random(1, 20)

		return v23 .. ("bcdfghjklmnpqrstvwxz"):sub(v24, v24)
	end
	local function getWord() -- line: 49
		local s1 = ""

		for _ = 1, math.random(1, 4) do
			local v27 = math.random(1, 6)
			local v28 = ("aeiouy"):sub(v27, v27)
			local v29 = math.random(1, 20)

			s1 ..= v28 .. ("bcdfghjklmnpqrstvwxz"):sub(v29, v29)
		end

		return s1
	end
	local function getSentence() -- line: 56
		local t4 = {}

		for _ = 1, math.random(1, 32) do
			local s2 = ""

			for _ = 1, math.random(1, 4) do
				local v34 = math.random(1, 6)
				local v35 = ("aeiouy"):sub(v34, v34)
				local v36 = math.random(1, 20)

				s2 ..= v35 .. ("bcdfghjklmnpqrstvwxz"):sub(v36, v36)
			end

			table.insert(t4, s2)
		end

		return table.concat(t4, " ")
	end

	local v12 = t1.new()

	v12.id = math.random(1, 420)
	v12.status = t2[math.random(1, #t2)]

	local s3 = ""

	for _ = 1, math.random(1, 4) do
		local v15 = math.random(1, 6)
		local v16 = ("aeiouy"):sub(v15, v15)
		local v17 = math.random(1, 20)

		s3 ..= v16 .. ("bcdfghjklmnpqrstvwxz"):sub(v17, v17)
	end

	v12.name = s3
	v12.price = math.random(1, 420)
	v12.image = 0
	v12.planStatus = t3[math.random(1, #t3)]
	v12.description = getSentence()
	v12.gameId = 1515
	v12.isAutoRenewing = true
	v12.expirationDate = ""
	v12.gameData = {}

	return v12
end
function t1.fromJsonData(p2) -- line: 79
	-- upvalues: DevSubTypes (copy), t1 (copy)
	if not DevSubTypes.DevSubJsonCheck(p2) then
		return nil
	end

	local v19 = t1.new()

	v19.id = p2.id
	v19.status = p2.status
	v19.isAutoRenewing = p2.isAutoRenewing
	v19.expirationDate = p2.expirationDate
	v19.name = p2.planData.name
	v19.price = p2.planData.priceInRobux
	v19.image = p2.planData.imageAssetId
	v19.planStatus = p2.planData.status
	v19.description = p2.planData.description
	v19.gameId = p2.planData.universeId
	v19.gameData = p2.gameData

	return v19
end

return t1
