local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/dSS")
local module2 = require("@luauforge/bundled/dST")

local module3 = require("@luauforge/bundled/dSU")
local module4 = require("@luauforge/bundled/dSV")
local module5 = require("@luauforge/bundled/dSW")

return Rodux.createReducer({}, {
	[module.name] = function(p2, data)
		return Cryo.Dictionary.join(p2, {
			[data.searchUuid] = {
				focusedWidget = {
					id = data.id,
					active = true,
					title = data.title or "",
					description = data.description or "",
					localizedTitle = data.localizedTitle or "",
					localizedDescription = data.localizedDescription or "",
					localizedTooltip = data.localizedTooltip or "",
					tooltip = data.tooltip or ""
				},
				hideTopBar = true
			}
		})
	end,
	[module2.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, { [p3.searchUuid] = {} })
	end,
	[module3.name] = function(p2, p3)
		return {}
	end,
	[module4.PercievedTrackingStarted.name] = function(p2, p3)
		return (Cryo.Dictionary.join(p2, { perceivedStartTime = p3.startPerceivedTime }))
	end,
	[module4.StartTracking.name] = function(p2, p3)
		local searchUuid = p3.searchUuid
		local v6 = p2[searchUuid] or {}
		local tileLoadingLatency = v6 and v6.tileLoadingLatency or {}
		local joined = Cryo.Dictionary.join(p2, {
			[searchUuid] = Cryo.Dictionary.join(v6, {
				tileLoadingLatency = Cryo.Dictionary.join(tileLoadingLatency, {
					startTime = p3.startTime
				})
			})
		})

		joined[searchUuid].tileLoadingLatency.endTime = nil
		return joined
	end,
	[module4.EndTracking.name] = function(p2, p3)
		local searchUuid = p3.searchUuid
		local v6 = p2[searchUuid] or {}
		return (Cryo.Dictionary.join(p2, {
			[searchUuid] = Cryo.Dictionary.join(v6, {
				tileLoadingLatency = Cryo.Dictionary.join(v6 and v6.tileLoadingLatency or {}, {
					endTime = p3.endTime
				})
			}),
			perceivedStartTime = Cryo.None
		}))
	end,
	[module4.AppendThumbnails.name] = module5.isEnabled() and function(p2, p3)
		local thumbnailsMap = p3.thumbnailsMap

		if not thumbnailsMap then
			return p2
		end

		local clone = table.clone(p2)

		for k, thumbnail in thumbnailsMap do
			local clone2 = table.clone(clone[k] or {})
			local clone3 = table.clone(clone2.tileLoadingLatency or {})
			local clone4 = table.clone(clone3.thumbnails or {})

			for k2, v6 in thumbnail do
				clone4[v6] = clone4[v6] or false
			end

			clone3.thumbnails = clone4
			clone2.tileLoadingLatency = clone3
			clone[k] = clone2
		end

		return clone
	end or nil,
	[module4.AppendThumbnail.name] = function(p2, p3)
		local searchUuid = p3.searchUuid
		local v6 = p2[searchUuid] or {}
		local tileLoadingLatency = v6 and v6.tileLoadingLatency or {}
		local thumbnails = tileLoadingLatency and tileLoadingLatency.thumbnails or {}
		tileLoadingLatency.thumbnails = Cryo.Dictionary.join(thumbnails, {
			[p3.thumbnailId] = false
		})

		return Cryo.Dictionary.join(p2, {
			[searchUuid] = Cryo.Dictionary.join(v6, {
				tileLoadingLatency = tileLoadingLatency
			})
		})
	end,
	[module4.SetLoadedThumbnails.name] = module5.isEnabled() and function(options, p2)
		local searchUuid = p2.searchUuid
		local clone = table.clone(options or {})
		local clone2 = table.clone(clone[searchUuid] or {})
		local clone3 = table.clone(clone2.tileLoadingLatency or {})
		local clone4 = clone2.tileLoadingLatency
			and clone2.tileLoadingLatency.thumbnails
			and table.clone(clone2.tileLoadingLatency.thumbnails)
			or {}

		if p2.thumbnailIds then
			for k, thumbnailId in p2.thumbnailIds do
				clone4[thumbnailId] = true
			end
		end

		clone3.thumbnails = clone4
		clone2.tileLoadingLatency = clone3
		clone[searchUuid] = clone2

		return clone
	end or nil,
	[module4.SetLoadedThumbnail.name] = function(p2, p3)
		local v6 = p2[p3.searchUuid] or {}
		local tileLoadingLatency = v6 and v6.tileLoadingLatency or {}
		local join = Cryo.Dictionary.join
		local thumbnails = tileLoadingLatency.thumbnails or {}
		tileLoadingLatency.thumbnails = join(thumbnails, { [p3.thumbnailId] = true })

		return Cryo.Dictionary.join(p2, {
			[p3.searchUuid] = Cryo.Dictionary.join(v6, {
				tileLoadingLatency = tileLoadingLatency
			})
		})
	end
})
