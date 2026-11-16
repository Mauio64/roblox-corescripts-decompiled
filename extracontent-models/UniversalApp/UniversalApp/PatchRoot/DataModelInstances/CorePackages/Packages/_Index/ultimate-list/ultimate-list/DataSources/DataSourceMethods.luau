local ultimatelist = script:FindFirstAncestor("ultimate-list")

require(script.Parent)
local exhaustiveMatch = require(ultimatelist.Util.exhaustiveMatch)
local DataSourceMethods = {}

function DataSourceMethods.get(data, p: number)
	assert(p >= 1, "index < 1")

	if data.type == "array" then
		local function get(p2: number)
			if p2 < 1 or #data.array < p2 then
				return nil
			end

			return {
				before = function()
					return get(p2 - 1)
				end,
				value = data.array[p2],
				after = function()
					return get(p2 + 1)
				end
			}
		end

		return (get(p))
	end

	if data.type == "mutableSource" then
		return data.methods.get(p)
	end

	return exhaustiveMatch(data.type)
end

function DataSourceMethods.getByRange(data, vector3: Vector3)
	if data.type == "array" then
		return table.move(data.array, vector3.X, vector3.Y, 1, {})
	end

	if data.type ~= "mutableSource" then
		return exhaustiveMatch(data.type)
	end

	if data.methods.getByRange ~= nil then
		return data.methods.getByRange(vector3.X, vector3.Y)
	end

	local v = data.methods.get(vector3.X)
	local result = {}

	for _ = 0, vector3.Y - vector3.X do
		if v == nil then
			break
		end

		table.insert(result, v.value)
		v = v.after()
	end

	return result
end

function DataSourceMethods.back(data)
	if data.type == "array" then
		return data.array[#data.array]
	end

	if data.type ~= "mutableSource" then
		return exhaustiveMatch(data.type)
	end

	if data.methods.back ~= nil then
		return data.methods.back()
	end

	local v = data.methods.get(data.methods.length())
	return v and v.value
end

function DataSourceMethods.length(data)
	if data.type == "array" then
		return #data.array
	end

	if data.type == "mutableSource" then
		return data.methods.length()
	end

	return exhaustiveMatch(data.type)
end

function DataSourceMethods.equals(data, data2)
	if data.type ~= data2.type then
		return false
	end

	if data.type == "array" then
		assert(data2.type == "array", "Luau")
		return data.array == data2.array
	end

	if data.type ~= "mutableSource" then
		return exhaustiveMatch(data.type)
	end

	assert(data2.type == "mutableSource", "Luau")
	return data.methods == data2.methods
end

return DataSourceMethods
