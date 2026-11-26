local module = require("@luauforge/bundled/dFu")
local module2 = require("@luauforge/bundled/ehB")
local module3 = require("@luauforge/bundled/ehm")
local module4 = require("@luauforge/bundled/fAH")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local getFStringVNGWebshopUrl = SharedFlags.GetFStringVNGWebshopUrl
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dFz").NavigationCommands else nil

return function(onClose, p2)
	return function(object)
		object:dispatch(module4(p2)):andThen(function(p3)
			local vngShopRedirectUrl = p3.vngShopRedirectUrl or getFStringVNGWebshopUrl()
			local v5 = {
				name = module.GenericWebPage,
				detail = vngShopRedirectUrl,
				extraProps = { onClose = onClose }
			}

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v5))
			else
				object:dispatch(module2(v5))
			end

			object:dispatch(module3())
		end):catch(function(p3)
			local fStringVNGWebshopUrl = getFStringVNGWebshopUrl()
			local v5 = {
				name = module.GenericWebPage,
				detail = fStringVNGWebshopUrl,
				extraProps = { onClose = onClose }
			}

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v5))
			else
				object:dispatch(module2(v5))
			end

			object:dispatch(module3())
		end)
	end
end
