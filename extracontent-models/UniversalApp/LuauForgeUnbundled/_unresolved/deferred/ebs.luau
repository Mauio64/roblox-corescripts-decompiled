local module = require("@luauforge/deferred/dZD")
local module2 = require("@luauforge/deferred/dZi")
local appPage = require("@luauforge/deferred/dZn").AppPage
local navigateDown = module2.Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@luauforge/deferred/ebq").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/deferred/ebr").NavigationCommands else nil

return function(p2)
	return function(object)
		local v5 = "Asset" .. p2
		local v7 = {
			name = appPage.AvatarExperienceWrapper,
			detail = v5,
			extraProps = {
				routeName = "ItemDetails",
				params = module.Dictionary.join({
					fromContentFeed = true,
					itemDetailsPeekViewRefs = {},
					itemId = p2,
					itemType = "Asset",
					mountAnimation = false,
					mountAsFullView = true
				}, { detail = v5 })
			}
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v7))
		else
			object:dispatch(navigateDown(v7))
		end
	end
end
