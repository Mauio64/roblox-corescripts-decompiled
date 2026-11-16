local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local Rodux = require(CorePackages.Packages.Rodux)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local UIBlox = require(CorePackages.Packages.UIBlox)
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
local Constants = UIBlox.App.Style.Constants

local Foundation = require(CorePackages.Packages.Foundation)
local ColorMode = Foundation.Enums.ColorMode
local function dumpInstanceTree(instance, value)
	value = value or ""

	if instance == nil then
		print(value .. "[nil Instance]")
		return
	end

	print(value .. instance.Name)
	local v = value .. "  "

	for _, child in ipairs(instance:GetChildren()) do
		dumpInstanceTree(child, v)
	end
end

return function(callback, p, p2, options, options2)
	local store = Rodux.Store.new(p2, options or {}, { Rodux.thunkMiddleware })
	local element = Roact.createElement(RoactRodux.StoreProvider, { store = store }, {
		AppStyleProvider = Roact.createElement(AppStyleProvider, {
			style = { themeName = ColorMode.Dark, fontName = Constants.FontName.Gotham }
		}, {
			Folder = Roact.createElement("Folder", {}, {
				Root = Roact.createElement(p, options2 or {})
			})
		})
	})

	local v = tostring(p)

	local element2 = Roact.createElement("ScreenGui", {
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
		[v] = element
	})

	local v2 = "Test-" .. HttpService:GenerateGUID(false)
	local v3 = Roact.mount(element2, CoreGui, v2)

	local formatted = ("game.CoreGui.%s.*[ClassName=Folder].*"):format(v2)

	local success, result = pcall(function()
		callback(formatted)
	end)

	if not success then
		print("Test instance tree:\n")
		dumpInstanceTree(CoreGui:FindFirstChild(v2))
		print()
	end

	Roact.unmount(v3)

	if not success then
		error(result)
	end
end
