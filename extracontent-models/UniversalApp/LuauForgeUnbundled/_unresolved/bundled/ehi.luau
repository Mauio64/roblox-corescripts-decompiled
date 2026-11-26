local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch

local module = require("@luauforge/bundled/ehj")
local module2 = require("@luauforge/bundled/ehC")

local userSearchTile = require("@luauforge/bundled/ehc").UserSearchTile
local impressionsTaggerWrapper = require("@luauforge/bundled/egA").ImpressionsTaggerWrapper

local fFlagLuaAppSearchPeopleUnifiedSchemaFields = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppSearchPeopleUnifiedSchemaFields

require("@luauforge/bundled/ehD")

return function(props)
	local v5 = useDispatch()

	local function fn(data)
		v5(module(data.userId, {
			profilePeekViewProps = {
				resetPeekView = false,
				source = module2.Sources.PlayerSearch,
				contextualInfoType = data.contextualInfoType,
				contextualInfoDisplay = data.contextualInfoDisplay,
				analyticsProps = {
					userSearchSessionId = props.Analytics.getInfoForAllEvents().userSearchSessionId
				}
			}
		}))
	end

	return Roact.createElement(impressionsTaggerWrapper, {
		impressionsIndex = props.index,
		impressionsTag = props.impressionsTag,
		renderComponent = function()
			local createElement = Roact.createElement
			local v7 = {
				index = props.index,
				user = props.user,
				size = props.size,
				searchParameters = props.searchParameters,
				hasEmphasis = props.hasEmphasis,
				profileInsight = props.profileInsight,
				luaAppNavigation = { navigateToUserInfo = fn },
				fireAnalyticsEvent = props.Analytics.fireAnalyticsEvent,
				shouldUseCompactTiles = props.shouldUseCompactTiles,
				enablePresenceIndicator = props.enablePresenceIndicator,
				subpage = props.subpage,
				rowInSort = props.rowInSort,
				positionInRow = 0,
				feedRowNumber = 0
			}
			local v8 = if fFlagLuaAppSearchPeopleUnifiedSchemaFields then props.positionInRow else nil
			v7.positionInRow = v8
			local v9 = if fFlagLuaAppSearchPeopleUnifiedSchemaFields then props.feedRowNumber else nil
			v7.feedRowNumber = v9
			return createElement(userSearchTile, v7)
		end
	})
end
