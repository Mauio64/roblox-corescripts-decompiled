local PlatformService = nil

pcall(function() -- line: 7
	-- upvalues: PlatformService (ref)
	PlatformService = game:GetService("PlatformService")
end)

local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.Promise)

local function parseRobuxValue(p1) -- line: 18
	local v7 = p1 and p1.Name
	local v8 = string.gsub(v7, ",", "")
	local v9 = v8 and string.match(v8, "[0-9]+") or nil

	return v9 and tonumber(v9) or 1000
end
local function createAvailableProductsTable(p2) -- line: 25
	local t1 = {}

	for _, v13 in p2 do
		local t2 = {}
		local v15 = v13 and v13.Name
		local v16 = string.gsub(v15, ",", "")
		local v17 = v16 and string.match(v16, "[0-9]+") or nil

		t2.robuxValue = v17 and tonumber(v17) or 1000
		t2.productId = v13.ProductId
		table.insert(t1, t2)
	end

	return t1
end

return function() -- line: 39
	-- upvalues: Promise (copy), PlatformService (ref), createAvailableProductsTable (copy)
	return Promise.new(function(resolve, reject) -- line: 40
		-- upvalues: PlatformService (ref)
		local ok, result = pcall(function() -- line: 41
			-- upvalues: PlatformService (ref)
			return PlatformService:BeginGetCatalogInfo()
		end)

		if ok and result then
			resolve(result)

			return
		end

		reject(result)
	end):andThen(function(p3) -- line: 50
		-- upvalues: Promise (copy), createAvailableProductsTable (copy)
		return Promise.resolve((createAvailableProductsTable(p3)))
	end)
end
