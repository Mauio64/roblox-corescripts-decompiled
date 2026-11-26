local module = require("@luauforge/deferred/geF")

local module2 = require("@luauforge/deferred/geB")
local module3 = require("@luauforge/deferred/geG")

local v5 = {}

function v5.new()
	return {}
end

function v5.mock()
	local v6 = { module2.Active, module2.Inactive }

	local v7 = { module3.Open, module3.Closed, module3.Archived }

	local function stringChoose(value)
		local v8 = math.random(1, #value)
		return value:sub(v8, v8)
	end

	local function getSyllable()
		local v8 = math.random(1, 6)
		local v9 = ("aeiouy"):sub(v8, v8)
		local v10 = math.random(1, 20)
		return v9 .. ("bcdfghjklmnpqrstvwxz"):sub(v10, v10)
	end

	local function getWord()
		local word = ""

		for i = 1, math.random(1, 4) do
			local v8 = math.random(1, 6)
			local v9 = ("aeiouy"):sub(v8, v8)
			local v10 = math.random(1, 20)
			word ..= v9 .. ("bcdfghjklmnpqrstvwxz"):sub(v10, v10)
		end

		return word
	end

	local function getSentence()
		local v8 = {}

		for i = 1, math.random(1, 32) do
			local v9 = ""

			for j = 1, math.random(1, 4) do
				local v10 = math.random(1, 6)
				local v11 = ("aeiouy"):sub(v10, v10)
				local v12 = math.random(1, 20)
				v9 ..= v11 .. ("bcdfghjklmnpqrstvwxz"):sub(v12, v12)
			end

			table.insert(v8, v9)
		end

		return table.concat(v8, " ")
	end

	local v8 = v5.new()
	v8.id = math.random(1, 420)
	v8.status = v6[math.random(1, #v6)]
	local v9 = ""

	for i = 1, math.random(1, 4) do
		local v10 = math.random(1, 6)
		local v11 = ("aeiouy"):sub(v10, v10)
		local v12 = math.random(1, 20)
		v9 ..= v11 .. ("bcdfghjklmnpqrstvwxz"):sub(v12, v12)
	end

	v8.name = v9
	v8.price = math.random(1, 420)
	v8.image = 0
	v8.planStatus = v7[math.random(1, #v7)]
	v8.description = getSentence()
	v8.gameId = 1515
	v8.isAutoRenewing = true
	v8.expirationDate = ""
	v8.gameData = {}
	return v8
end

function v5.fromJsonData(data)
	if not module.DevSubJsonCheck(data) then
		return nil
	end

	local v6 = v5.new()
	v6.id = data.id
	v6.status = data.status
	v6.isAutoRenewing = data.isAutoRenewing
	v6.expirationDate = data.expirationDate
	v6.name = data.planData.name
	v6.price = data.planData.priceInRobux
	v6.image = data.planData.imageAssetId
	v6.planStatus = data.planData.status
	v6.description = data.planData.description
	v6.gameId = data.planData.universeId
	v6.gameData = data.gameData
	return v6
end

return v5
