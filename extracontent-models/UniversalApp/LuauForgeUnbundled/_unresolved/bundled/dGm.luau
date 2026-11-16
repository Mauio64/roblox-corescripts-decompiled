local module = require("@luauforge/bundled/dFV")
local UIBlox = require("@game/CorePackages/Workspace/Packages/UIBlox")
local useLocalization = require("@luauforge/bundled/dGo").Hooks.useLocalization
local appPage = require("@luauforge/bundled/dGb").AppPage

local module3 = require("@luauforge/bundled/dGp")
local module4 = require("@luauforge/bundled/dGq")
local module5 = require("@luauforge/bundled/dGv")
local module6 = require("@luauforge/bundled/dGw")
local module7 = require("@luauforge/bundled/dGA")
local module8 = require("@luauforge/bundled/dGu")

local buttonType = UIBlox.App.Button.Enum.ButtonType

local v5 = {
	okay = "Authentication.TwoStepVerification.Action.Okay",
	header = "Authentication.TwoStepVerification.Label.AttemptReviewed",
	alreadyReviewed = "Authentication.TwoStepVerification.Label.AlreadyReviewed",
	helpMessage = "Authentication.TwoStepVerification.Label.NeedHelpMessage"
}

return function(p2)
	local v6 = useLocalization(v5)
	return module.createElement(module6, {
		title = v6.header,
		closeModal = p2.closeModal,
		makeBodyFragment = function(p3)
			return module.createElement(module.Fragment, nil, {
				Lock = module.createElement(module3, { layoutOrder = 1 }),
				AlreadyCompleted = module.createElement(module4, {
					layoutOrder = 2,
					contentWidth = p3,
					useBold = true,
					useEmphasis = true,
					text = v6.alreadyReviewed
				})
			})
		end,
		buttonConfig = module5({
			{
				onActivated = p2.closeModal,
				text = v6.okay,
				type = buttonType.PrimarySystem
			}
		}),
		footerContent = module7(function(p3)
			return module.createElement(module4, {
				BackgroundTransparency = 0,
				layoutOrder = 1,
				text = v6.helpMessage,
				contentWidth = p3,
				size = module8.Footer,
				onActivated = function()
					p2.navigateToPage({
						name = appPage.GenericWebPage,
						detail = "https://en.help.roblox.com/hc/en-us/articles/212459863-Add-2-Step-Verification-to-Your-Account",
						extraProps = { title = "" }
					})
				end
			})
		end)
	})
end
