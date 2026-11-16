local fFlagLuaAppEnableSduiHomePage = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagLuaAppEnableSduiHomePage

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiIntegrationTypes")

local v5 = {}

local function isArrayLike(list): boolean
	return typeof(list) == "table" and #list > 0
end

local function shallowAssignFromNew(p2, items)
	for k, item in items do
		p2[k] = item
	end
end

local function appendArray(list, items)
	for k, item in items do
		table.insert(list, item)
	end
end

local function mergeInto(clone, items, callback, list)
	for k, item in items do
		if typeof(item) == "table" then
			table.insert(list, (tostring(k)))

			local v6 = if callback then callback(list, item, clone[k]) else nil

			if not fFlagLuaAppEnableSduiHomePage or v6 ~= "preserve" then
				if v6 == "replace" then
					clone[k] = item
				elseif v6 == "merge" then
					if clone[k] == nil then
						clone[k] = item
					else
						local v7 = clone[k]

						for k2, v8 in item do
							v7[k2] = v8
						end
					end
				elseif v6 == "append" then
					if clone[k] == nil then
						clone[k] = item
					else
						local v7 = typeof(item) == "table" and #item > 0

						if v7 then
							local v8 = clone[k]

							for k2, v9 in item do
								table.insert(v8, v9)
							end
						else
							local v8 = clone[k]

							for k2, v9 in item do
								v8[k2] = v9
							end
						end
					end
				else
					if clone[k] == nil then
						clone[k] = {}
					end

					local v7 = typeof(item) == "table" and #item > 0

					if v7 then
						local v8 = clone[k]

						for k2, v9 in item do
							table.insert(v8, v9)
						end
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

function v5.merge(p2, p3, p4)
	local clone = table.clone(p2)
	mergeInto(clone, p3, p4, {})
	return clone
end

return v5
