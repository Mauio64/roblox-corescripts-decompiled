local AddFriends = script:FindFirstAncestor("AddFriends")
local AddFriendsParent = AddFriends.Parent
local React = require(AddFriendsParent.React)
local SchoolEntryTooltipContainer = require(AddFriendsParent.Schools).Components.SchoolEntryTooltipContainer
local useLocalization = require(AddFriendsParent.Localization).Hooks.useLocalization
local useNavigation = require(AddFriendsParent.Navigation).useNavigation
local AppPage = require(AddFriendsParent.RobloxAppEnums).AppPage
local Contexts = require(AddFriendsParent.SocialLuaAnalytics).Analytics.Enums.Contexts
local EventNames = require(AddFriends.Analytics).EventNames

local function SchoolChannel(t1: {[any]: any}) -- line: 28
	-- upvalues: React (copy), useNavigation (copy), EventNames (copy), AppPage (copy), Contexts (copy), useLocalization (copy), SchoolEntryTooltipContainer (copy)
	local component = t1.component
	local componentUIProps = t1.componentUIProps
	local fireAnalyticsEvent = t1.fireAnalyticsEvent
	local v15, v16 = React.useState(nil)
	local v17 = React.useRef(nil)
	local v18 = React.useCallback(function(p1) -- line: 36
		-- upvalues: v16 (copy)
		v16(p1)
	end, {})
	local v19 = useNavigation()
	local v20 = React.useCallback(function() -- line: 42
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), v17 (copy), v19 (copy), AppPage (copy), Contexts (copy)
		fireAnalyticsEvent(EventNames.SchoolBtnClick)

		local current = v17.current

		if current then
			current()
		end

		v19.navigate(AppPage.Schools, {
			extraProps = {
				source = Contexts.AddFriends
			}
		})
	end, {
		fireAnalyticsEvent,
		v19
	})
	local v21 = React.useCallback(function() -- line: 55
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy)
		fireAnalyticsEvent(EventNames.SchoolBtnImpression)
	end, { fireAnalyticsEvent })
	local v22 = useLocalization({
		schoolTitle = "Feature.AddFriends.Label.SchoolTile"
	})
	local v23 = React.useMemo(function() -- line: 63
		-- upvalues: v15 (copy)
		return {
			current = v15
		}
	end, { v15 })

	return React.createElement(React.Fragment, nil, {
		Tile = React.createElement(component, {
			icon = "icons/menu/education",
			title = v22.schoolTitle,
			onActivated = v20,
			onMounted = v21,
			ref = v18,
			componentUIProps = componentUIProps
		}),
		Tooltip = React.createElement(SchoolEntryTooltipContainer, {
			anchorRef = v23,
			dismissTooltipRef = v17
		})
	})
end

return SchoolChannel
