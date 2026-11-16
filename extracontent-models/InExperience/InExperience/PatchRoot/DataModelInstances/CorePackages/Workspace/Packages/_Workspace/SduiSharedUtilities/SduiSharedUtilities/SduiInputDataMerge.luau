local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")

local parent = SduiSharedUtilities.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEnableSduiHomePage = SharedFlags.FFlagLuaAppEnableSduiHomePage

require(SduiSharedUtilities.SduiIntegrationTypes)

local SduiInputDataMerge = {}

local function isArrayLike(item): boolean -- 2 equivalent calls inferred from this helper
	return typeof(item) == "table" and #item > 0
end

local function shallowAssignFromNew(p, item) -- 2 equivalent calls inferred from this helper
	for k, item2 in item do
		p[k] = item2
	end
end

local function appendArray(list, item) -- 2 equivalent calls inferred from this helper
	for _, item2 in item do
		table.insert(list, item2)
	end
end

local function mergeInto(clone, items, callback, list)
	for k, item in items do
		if typeof(item) == "table" then
			table.insert(list, (tostring(k)))
			local v

			if callback then
				v = callback(list, item, clone[k])
			end

			if not FFlagLuaAppEnableSduiHomePage or v ~= "preserve" then
				if v == "replace" then
					clone[k] = item
				elseif v == "merge" then
					if clone[k] == nil then
						clone[k] = item
					else
						shallowAssignFromNew(clone[k], item) -- inferred equivalent call
					end
				elseif v == "append" then
					if clone[k] == nil then
						clone[k] = item
					elseif isArrayLike(item) then -- inferred equivalent call
						appendArray(clone[k], item) -- inferred equivalent call
					else
						shallowAssignFromNew(clone[k], item) -- inferred equivalent call
					end
				else
					if clone[k] == nil then
						clone[k] = {}
					end

					if isArrayLike(item) then -- inferred equivalent call
						appendArray(clone[k], item) -- inferred equivalent call
					else
						mergeInto(clone[k], item, callback, list)
					end
				end
			end

			table.remove(list)
		else
			clone[k] = item
		end
	end
end

function SduiInputDataMerge.merge(p, p2, p3)
	local clone = table.clone(p)
	mergeInto(clone, p2, p3, {})
	return clone
end

return SduiInputDataMerge
