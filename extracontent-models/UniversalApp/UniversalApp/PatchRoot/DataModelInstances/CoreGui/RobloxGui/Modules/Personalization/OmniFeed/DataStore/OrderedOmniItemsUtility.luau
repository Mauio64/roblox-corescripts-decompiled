local CorePackages = game:GetService("CorePackages")
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local DiscoveryTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes)
local Cryo = require(CorePackages.Packages.Cryo)
local OmniFeedService = require(CorePackages.Workspace.Packages.OmniFeedService).OmniFeedService
local FeedItemModel = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.Personalization.OmniFeed.DataStore.FeedItemModel
local v7 = game:DefineFastFlag("FixFeedItemRenderedRowsEqualityCheck", false)

return {
	combineOmniFeedItems = function(t1: {[any]: any}, t2: {[any]: any}) -- line: 14
		-- upvalues: OmniFeedService (copy), DiscoveryTypes (copy), FeedItemModel (copy), ArgCheck (copy)
		local t3 = {}
		local t4 = {}
		local v12 = OmniFeedService.get():getOmniFeedItemMap()

		if t2 then
			for _, v in ipairs(t2) do
				if v.dataSource ~= DiscoveryTypes.DataSourceType.Local and v12.hasComponent(v.treatmentType) then
					local v15 = FeedItemModel.getUniqueNameForFeed(v)

					if v15 then
						ArgCheck.assert(t4[v15] == nil, "Duplicate feed item id detected: " .. tostring(v15))
						t4[v15] = v
					end

					table.insert(t3, v)
				end
			end
		end

		if t1 then
			for _, v in ipairs(t1) do
				if v.dataSource == DiscoveryTypes.DataSourceType.Local and v12.hasComponent(v.treatmentType) then
					local v18 = FeedItemModel.getUniqueNameForFeed(v)

					assert(v18)

					if t4[v18] == nil then
						t4[v18] = v

						local orderHint = nil

						if v.orderHint then
							orderHint = v.orderHint

							while orderHint <= #t3 and t3[orderHint] and t3[orderHint].dataSource == DiscoveryTypes.DataSourceType.Local and t3[orderHint].orderHint and t3[orderHint].orderHint == v.orderHint do
								orderHint += 1
							end
						end

						if orderHint ~= nil and orderHint <= #t3 then
							table.insert(t3, orderHint, v)
						else
							table.insert(t3, v)
						end
					end
				end
			end
		end

		return t3
	end,
	setFeedItemRenderedRows = function(t5: {[any]: any}?, n1: number, p1, n2: number?) -- line: 90
		-- upvalues: ArgCheck (copy), FeedItemModel (copy), v7 (copy), Cryo (copy)
		if not t5 then
			return nil
		end

		local v24 = t5[n1]

		if not v24 then
			return nil
		end

		if v24 ~= p1 then
			return nil
		end

		ArgCheck.assert(v24.actualRenderedRows ~= nil, `WARNING: feed item was not set up for overwriting its number of rows.  "actualRenderedRows" should be defined in the FeedItemModel (feed item: { FeedItemModel.getUniqueNameForAnalytics(v24) }`)

		local v25 = if not v7 then nil else n2 or -1

		if v24.actualRenderedRows == if not v7 then n2 else v25 then
			return nil
		end

		local v26 = table.clone(t5)

		v26[n1] = Cryo.Dictionary.join(v26[n1], {
			actualRenderedRows = if not v7 then n2 or -1 else v25
		})

		return v26
	end
}
