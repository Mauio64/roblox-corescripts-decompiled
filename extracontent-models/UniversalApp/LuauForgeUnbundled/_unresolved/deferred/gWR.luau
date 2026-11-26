local default = require("@luauforge/bundled/gWy").PaymentsProtocol.default
local module = require("@luauforge/bundled/gWS")

local v5 = nil
pcall(function()
	local PlatformService = game:GetService("PlatformService")
	v5 = PlatformService
end)

local module2 = require("@luauforge/deferred/gWT")

local function parseRobuxValue(p2)
	return (tonumber((string.gsub(p2.Name, "%D+", ""))))
end

return {
	Fetch = function()
		return function(object)
			default:isAvailable():andThen(function(p2)
				local function fn(p3, p4): boolean
					return p3.robuxAmount < p4.robuxAmount
				end

				if p2 then
					default:listNativeProducts():andThen(function(p3)
						table.sort(p3.products, fn)
						object:dispatch(module(p3.products))
					end)
					return
				end

				if not module2() then
					object:dispatch(module(nil))

					return
				end

				local v7 = nil

				local success, result = pcall(function()
					v7 = v5:BeginGetCatalogInfo()
				end)

				if success then
					local v8 = {}

					for k, v9 in v7 do
						table.insert(v8, {
							productId = v9.Name,
							price = tonumber(v9.Price) or 0,
							nativeProductId = v9.ProductId,
							robuxAmount = tonumber((string.gsub(v9.Name, "%D+", ""))) or 0,
							displayPrice = v9.DisplayPrice
						})
					end

					table.sort(v8, fn)
					object:dispatch(module(v8))
				else
					object:dispatch(module(nil))
				end
			end)
		end
	end
}
