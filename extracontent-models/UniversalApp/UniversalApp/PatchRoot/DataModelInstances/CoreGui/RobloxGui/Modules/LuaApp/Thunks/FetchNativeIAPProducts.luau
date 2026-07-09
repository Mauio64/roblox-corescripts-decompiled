local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local default = require(CorePackages.Workspace.Packages.PaymentsProtocol).PaymentsProtocol.default
local SetNativeRobuxProducts = require(Modules.LuaApp.Actions.SetNativeRobuxProducts)
local PlatformService = nil

pcall(function() -- line: 9
	-- upvalues: PlatformService (ref)
	PlatformService = game:GetService("PlatformService")
end)

local GetFFlagNativeProductFallbackToPlatformService = require(Modules.LuaApp.Flags.GetFFlagNativeProductFallbackToPlatformService)
local t1 = {}

local function parseRobuxValue(p1) -- line: 20
	return (tonumber((string.gsub(p1.Name, "%D+", ""))))
end

function t1.Fetch() -- line: 25
	-- upvalues: default (copy), SetNativeRobuxProducts (copy), GetFFlagNativeProductFallbackToPlatformService (copy), PlatformService (ref)
	return function(p2) -- line: 26
		-- upvalues: default (copy), SetNativeRobuxProducts (copy), GetFFlagNativeProductFallbackToPlatformService (copy), PlatformService (ref)
		default:isAvailable():andThen(function(p3) -- line: 27
			-- upvalues: default (copy), p2 (copy), SetNativeRobuxProducts (copy), GetFFlagNativeProductFallbackToPlatformService (copy), PlatformService (ref)
			local function v12(p4, p5) -- line: 28
				return p4.robuxAmount < p5.robuxAmount
			end

			if p3 then
				default:listNativeProducts():andThen(function(p6) -- line: 36
					-- upvalues: v12 (copy), p2 (copy), SetNativeRobuxProducts (copy)
					table.sort(p6.products, v12)
					p2:dispatch(SetNativeRobuxProducts(p6.products))
				end)

				return
			end

			if GetFFlagNativeProductFallbackToPlatformService() then
				local u13 = nil
				local ok, _ = pcall(function() -- line: 44
					-- upvalues: u13 (ref), PlatformService (ref)
					u13 = PlatformService:BeginGetCatalogInfo()
				end)

				if ok then
					local t2 = {}

					for _, v18 in u13 do
						table.insert(t2, {
							productId = v18.Name,
							price = tonumber(v18.Price) or 0,
							nativeProductId = v18.ProductId,
							robuxAmount = tonumber((string.gsub(v18.Name, "%D+", ""))) or 0,
							displayPrice = v18.DisplayPrice
						})
					end

					table.sort(t2, v12)
					p2:dispatch(SetNativeRobuxProducts(t2))
				else
					p2:dispatch(SetNativeRobuxProducts(nil))
				end

				return
			end

			p2:dispatch(SetNativeRobuxProducts(nil))
		end)
	end
end

return t1
