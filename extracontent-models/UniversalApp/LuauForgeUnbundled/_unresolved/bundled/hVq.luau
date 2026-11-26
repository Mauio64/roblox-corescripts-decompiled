local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/hVr")
local module2 = require("@luauforge/bundled/hUV")

local path = module2.createPath("AppShellHome")
local path2 = module2.createPath("AppShellForYou")
local path3 = module2.createPath("AppShellCharts")
local path4 = module2.createPath("AppShellPlayground")
local path5 = module2.createPath("AppShellPlaygroundRoot")
local path6 = module2.createPath("AppShellPlaygroundDetails")
local path7 = module2.createPath("AppShellChat")
local path8 = module2.createPath("AppShellNotifications")
local path9 = module2.createPath("AppShellRobux")
local path10 = module2.createPath("AppShellLogin")
local path11 = module2.createPath("AppShellExperienceDetails")
local path12 = module2.createPath("AppShellProfile")
local path13 = module2.createPath("AppShellWhatsNew")

local function ExampleView(p2)
	return React.createElement("TextLabel", { Text = p2.route.name })
end

return module.root({
	tabs = {
		module.tab(
			path,
			module.switch({
				module.page(path2, ExampleView, {
					titleKey = "Feature.Home.ForYou.Label"
				}),
				module.page(path3, ExampleView, {
					titleKey = "Feature.Home.Charts.Label"
				})
			}),
			{
				navigationItem = {
					labelKey = "CommonUI.Features.Label.Home",
					icon = "icons/navigation/home"
				}
			}
		),
		module.tab(
			path4,
			module.stack({
				module.page(path5, ExampleView, {
					titleKey = "Feature.Playground.Label"
				}),
				module.page(path6, ExampleView, {
					titleKey = "Feature.Playground.Details.Label",
					leadingAction = "back"
				})
			}),
			{
				navigationItem = {
					labelKey = "Feature.Playground.Label",
					icon = "icons/navigation/more"
				}
			}
		),
		module.tab(path7, ExampleView, {
			navigationItem = {
				labelKey = "CommonUI.Features.Label.Chat",
				icon = "icons/navigation/chat"
			}
		})
	},
	pages = {
		module.page(path8, ExampleView, {
			titleKey = "CommonUI.Features.Label.Notifications",
			leadingAction = "back"
		}),
		module.page(path9, ExampleView, {
			titleKey = "CommonUI.Features.Label.Robux",
			leadingAction = "back"
		}),
		module.page(path10, ExampleView, {
			titleKey = "Feature.Login.Label",
			leadingAction = "close"
		}),
		module.page(path11, ExampleView, {
			titleKey = "Feature.ExperienceDetails.Label",
			leadingAction = "back",
			support = true
		}),
		module.page(path12, ExampleView, {
			titleKey = "Feature.Profile.Label",
			leadingAction = "back",
			support = true
		})
	},
	overlays = { module.overlay(path13, ExampleView, { region = "central" }) }
})
