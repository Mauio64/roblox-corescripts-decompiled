local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Rodux = require(CorePackages.Packages.Rodux)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
local Constants = UIBlox.App.Style.Constants

local function dumpInstanceTree(p1, p2) -- line: 14
	-- upvalues: dumpInstanceTree (copy)
	local v13 = p2 or ""

	if p1 == nil then
		print(v13 .. "[nil Instance]")

		return
	end

	print(v13 .. p1.Name)

	local v14 = v13 .. "  "

	for _, child in ipairs(p1:GetChildren()) do
		dumpInstanceTree(child, v14)
	end
end

return function(p3, p4, p5, p6, p7) -- line: 41
	-- upvalues: Rodux (copy), Roact (copy), RoactRodux (copy), AppStyleProvider (copy), Constants (copy), HttpService (copy), CoreGui (copy), dumpInstanceTree (copy)
	local v22 = p6 or {}
	local v23 = p7 or {}
	local v24 = Rodux.Store.new(p5, v22, { Rodux.thunkMiddleware })
	local v25 = Roact.createElement(RoactRodux.StoreProvider, {
		store = v24
	}, {
		AppStyleProvider = Roact.createElement(AppStyleProvider, {
			style = {
				themeName = Constants.ThemeName.Dark,
				fontName = Constants.FontName.Gotham
			}
		}, {
			Folder = Roact.createElement("Folder", {}, {
				Root = Roact.createElement(p4, v23)
			})
		})
	})
	local str = tostring(p4)
	local v27 = Roact.createElement("ScreenGui", {
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
		[str] = v25
	})
	local v28 = "Test-" .. HttpService:GenerateGUID(false)
	local v29 = Roact.mount(v27, CoreGui, v28)
	local v30 = ("game.CoreGui.%s.*[ClassName=Folder].*"):format(v28)
	local ok, result = pcall(function() -- line: 74
		-- upvalues: p3 (copy), v30 (copy)
		p3(v30)
	end)

	if not ok then
		print("Test instance tree:\n")
		dumpInstanceTree(CoreGui:FindFirstChild(v28))
		print()
	end

	Roact.unmount(v29)

	if not ok then
		error(result)
	end
end
