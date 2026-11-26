local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local topicInfosReducer = require("@luauforge/bundled/dCQ").TopicInfosReducer
local topicContentsReducer = require("@luauforge/bundled/dCO").TopicContentsReducer

local omniFeedProps = require("@luauforge/bundled/dtb").Modules.Personalization.OmniFeed.OmniFeedProps

local module = require("@luauforge/bundled/iqL")

function LUAUFORGE_MODULE_GLOBALS_iqK_SearchPillCarouselFeedItem(p2)
	local v5 = p2[omniFeedProps.key]
	local appPage = v5.appPage

	local v6 = useSelector(function(p3)
		return p3.Personalization.OrderedOmniItems[appPage]
	end)

	local v7 = useSelector(function(p3)
		return p3.Personalization[topicInfosReducer.key]
	end)

	local v8 = useSelector(function(p3)
		return p3.Personalization[topicContentsReducer.key]
	end)

	local allItem = v6.allItems[p2.sortIndex]

	if not allItem then
		warn(`no omni item found for index: {p2.sortIndex}`)
		return nil
	end

	local sortName = allItem.treatmentProps.sortName

	if not sortName then
		warn(`no sort name found for index: {p2.sortIndex}`)
		return nil
	end

	local v9 = v7[sortName]

	if not v9 then
		warn(`no topic info found for sort: {sortName}`)
		return nil
	end

	local displayName = v9.displayName

	if not displayName then
		warn(`no display name found for sort: {sortName}`)
		return nil
	end

	local v10 = v8[sortName]

	if not v10 then
		warn(`no topic contents found for sort: {sortName}`)
		return nil
	end

	local entries = v10.entries

	if entries then
		return React.createElement(module, {
			entries = entries,
			headerText = displayName,
			pageContext = appPage,
			sortIndex = p2.sortIndex,
			sortName = sortName,
			scrollViewPositionChangedSignal = v5.scrollViewPositionChangedSignal,
			verticalScrollingFrameRef = v5.verticalScrollingFrameRef
		})
	end

	warn(`no sort entries found for sort: {sortName}`)
	return nil
end

return LUAUFORGE_MODULE_GLOBALS_iqK_SearchPillCarouselFeedItem
