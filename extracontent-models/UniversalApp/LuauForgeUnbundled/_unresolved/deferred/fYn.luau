local module = require("@luauforge/bundled/eee")
local module2 = require("@luauforge/bundled/fYo")
local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")
local module4 = require("@luauforge/bundled/dCp")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dCu").NavigationCommands
else
	navigationCommands = nil
end

return function()
	return function(object)
		local function onClose()
			if fFlagSignalsNavP3Dispatch then
				navigationCommands.back()
			else
				object:dispatch(RobloxAppToastsRodux())
			end
		end

		local v5 = {
			name = module4.VerifiedBadgeModal,
			extraProps = {
				onConfirm = function()
					local v6 = {
						name = module4.GenericWebPage,
						detail = "https://en.help.roblox.com/hc/en-us/articles/7997207259156",
						extraProps = { onClose = onClose }
					}

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.fromWebView(navigationCommands.fromLegacyPage(v6))
					else
						object:dispatch(module2(v6))
					end
				end,
				onClose = onClose
			}
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v5))
		else
			object:dispatch(module(v5))
		end
	end
end
