local module = require("@luauforge/bundled/hVu")

require("@luauforge/bundled/hVt")

local module2 = require("@luauforge/bundled/hVx")
local module3 = require("@luauforge/bundled/hVz")
local module4 = require("@luauforge/bundled/hVA")
local module5 = require("@luauforge/bundled/hVB")

local path = module.createPath("AppShellTabs")
local path2 = module.createPath("AppShellStack")

local function resolveRoutes(callback)
	if callback == nil then
		return {}
	end

	if typeof(callback) == "function" then
		return (callback())
	end

	return callback
end

return table.freeze({
	root = function(data)
		local defineNavigator = module.defineNavigator("switch", {
			layout = module4,
			routes = data.tabs
		})

		local defineRoute = module.defineRoute(path, defineNavigator)
		local defineNavigator2 = module.defineNavigator("stack", {
			layout = module2,
			routes = function()
				local v5 = { defineRoute }
				local v6 = data.pages

				if v6 == nil then
					v6 = {}
				elseif typeof(v6) == "function" then
					v6 = v6()
				end

				for k, v9 in v6 do
					table.insert(v5, v9)
				end

				return table.freeze(v5)
			end,
			initial = path
		})

		local defineRoute2 = module.defineRoute(path2, defineNavigator2)
		return module.defineNavigator("stack", {
			layout = module5,
			routes = function()
				local v5 = { defineRoute2 }
				local v6 = data.overlays

				if v6 == nil then
					v6 = {}
				elseif typeof(v6) == "function" then
					v6 = v6()
				end

				for k, v9 in v6 do
					table.insert(v5, v9)
				end

				return table.freeze(v5)
			end,
			initial = path2
		})
	end,
	stack = function(p2)
		return module.defineNavigator("stack", { layout = module2, routes = p2 })
	end,
	switch = function(p2)
		return module.defineNavigator("switch", { layout = module3, routes = p2 })
	end
})
