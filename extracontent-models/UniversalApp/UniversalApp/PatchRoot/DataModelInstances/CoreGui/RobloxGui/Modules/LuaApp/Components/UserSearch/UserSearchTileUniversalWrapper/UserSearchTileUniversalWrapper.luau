local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local NavigateToUserInfo = require(Modules.LuaApp.Thunks.NavigateToUserInfo)
local Enums = require(CorePackages.Workspace.Packages.ProfilePlatform.Enums)
local UserSearchTile = require(script.Parent.Parent.api).UserSearchTile
local ImpressionsTaggerWrapper = require(CorePackages.Workspace.Packages.Impressions).ImpressionsTaggerWrapper
local FFlagLuaAppSearchPeopleUnifiedSchemaFields = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppSearchPeopleUnifiedSchemaFields

require(CorePackages.Workspace.Packages.GraphQLServer)

return function(t1: {[any]: any}) -- line: 77
	-- upvalues: useDispatch (copy), NavigateToUserInfo (copy), Enums (copy), Roact (copy), ImpressionsTaggerWrapper (copy), UserSearchTile (copy), FFlagLuaAppSearchPeopleUnifiedSchemaFields (copy)
	local v11 = useDispatch()

	local function v12(t2: {[any]: any}) -- line: 80
		-- upvalues: v11 (copy), NavigateToUserInfo (copy), Enums (copy), t1 (copy)
		v11(NavigateToUserInfo(t2.userId, {
			profilePeekViewProps = {
				resetPeekView = false,
				source = Enums.Sources.PlayerSearch,
				contextualInfoType = t2.contextualInfoType,
				contextualInfoDisplay = t2.contextualInfoDisplay,
				analyticsProps = {
					userSearchSessionId = t1.Analytics.getInfoForAllEvents().userSearchSessionId
				}
			}
		}))
	end

	return Roact.createElement(ImpressionsTaggerWrapper, {
		impressionsIndex = t1.index,
		impressionsTag = t1.impressionsTag,
		renderComponent = function() -- line: 98
			-- upvalues: Roact (copy), UserSearchTile (copy), t1 (copy), v12 (copy), FFlagLuaAppSearchPeopleUnifiedSchemaFields (copy)
			return Roact.createElement(UserSearchTile, {
				index = t1.index,
				user = t1.user,
				size = t1.size,
				searchParameters = t1.searchParameters,
				hasEmphasis = t1.hasEmphasis,
				profileInsight = t1.profileInsight,
				luaAppNavigation = {
					navigateToUserInfo = v12
				},
				fireAnalyticsEvent = t1.Analytics.fireAnalyticsEvent,
				shouldUseCompactTiles = t1.shouldUseCompactTiles,
				enablePresenceIndicator = t1.enablePresenceIndicator,
				subpage = t1.subpage,
				rowInSort = t1.rowInSort,
				positionInRow = if not FFlagLuaAppSearchPeopleUnifiedSchemaFields then nil else t1.positionInRow,
				feedRowNumber = if not FFlagLuaAppSearchPeopleUnifiedSchemaFields then nil else t1.feedRowNumber
			})
		end
	})
end
