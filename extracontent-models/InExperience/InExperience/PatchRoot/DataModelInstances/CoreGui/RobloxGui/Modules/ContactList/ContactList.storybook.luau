local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Rodux = require(CorePackages.Packages.Rodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Dash = require(CorePackages.Packages.Dash)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Localization = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization
local LocalizationProvider = require(CorePackages.Workspace.Packages.Localization).LocalizationProvider

UIBlox.init(require(CorePackages.Workspace.Packages.RobloxAppUIBloxConfig))

local AppStyleProvider = UIBlox.App.Style.AppStyleProvider

Roact.setGlobalConfig({
	elementTracing = true,
	propValidation = true
})

local t1 = {
	Default = {
		themeName = "Light",
		fontName = "Gotham"
	},
	Light = {
		themeName = "Light",
		fontName = "Gotham"
	},
	Dark = {
		themeName = "Dark",
		fontName = "Gotham"
	}
}
local t2 = {
	language = "en-us"
}
local v12 = Localization.new("en-us")

local function v13(p1) -- line: 40
	-- upvalues: Rodux (copy)
	return Rodux.Store.new(function() -- line: 41
		-- upvalues: p1 (copy)
		return p1
	end, {}, { Rodux.thunkMiddleware })
end

return {
	roact = Roact,
	mapDefinition = function(p2) -- line: 48
		-- upvalues: Dash (copy), t2 (copy)
		local v16 = Dash.join(t2, p2.controls or {})

		return Dash.join(p2, {
			controls = v16
		})
	end,
	mapStory = function(p3) -- line: 52
		-- upvalues: v12 (copy), Roact (copy), RoactRodux (copy), v13 (copy), AppStyleProvider (copy), t1 (copy), LocalizationProvider (copy)
		return function(p4) -- line: 53
			-- upvalues: v12 (copy), Roact (copy), RoactRodux (copy), v13 (copy), AppStyleProvider (copy), t1 (copy), LocalizationProvider (copy), p3 (copy)
			v12:SetLocale(p4.controls.language)

			local v19 = p4.definition.state or {}

			return Roact.createElement(RoactRodux.StoreProvider, {
				store = v13(v19)
			}, { Roact.createElement(AppStyleProvider, {
				style = p4 and t1[p4.theme] or t1.Default
			}, { Roact.createElement(LocalizationProvider, {
				localization = v12
			}, {
				Child = Roact.createElement(p3, p4)
			}) }) })
		end
	end
}
