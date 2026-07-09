local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local TopicInfosReducer = require(CorePackages.Workspace.Packages.TopicInfosRodux).TopicInfosReducer
local TopicContentsReducer = require(CorePackages.Workspace.Packages.TopicContentsRodux).TopicContentsReducer
local OmniFeedProps = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.Personalization.OmniFeed.OmniFeedProps
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SearchPillCarousel = require(Modules.Personalization.Search.SearchPillCarousel)

function SearchPillCarouselFeedItem(t1: {[any]: any}) -- line: 30
	-- upvalues: OmniFeedProps (copy), useSelector (copy), TopicInfosReducer (copy), TopicContentsReducer (copy), React (copy), SearchPillCarousel (copy)
	local v10 = t1[OmniFeedProps.key]
	local appPage = v10.appPage
	local v12 = useSelector(function(p1) -- line: 34
		-- upvalues: appPage (copy)
		return p1.Personalization.OrderedOmniItems[appPage]
	end)
	local v13 = useSelector(function(p2) -- line: 37
		-- upvalues: TopicInfosReducer (copy)
		return p2.Personalization[TopicInfosReducer.key]
	end)
	local v14 = useSelector(function(p3) -- line: 40
		-- upvalues: TopicContentsReducer (copy)
		return p3.Personalization[TopicContentsReducer.key]
	end)
	local v15 = v12.allItems[t1.sortIndex]

	if not v15 then
		warn(`no omni item found for index: { t1.sortIndex }`)

		return nil
	end

	local sortName = v15.treatmentProps.sortName

	if not sortName then
		warn(`no sort name found for index: { t1.sortIndex }`)

		return nil
	end

	local v17 = v13[sortName]

	if not v17 then
		warn(`no topic info found for sort: { sortName }`)

		return nil
	end

	local displayName = v17.displayName

	if not displayName then
		warn(`no display name found for sort: { sortName }`)

		return nil
	end

	local v19 = v14[sortName]

	if not v19 then
		warn(`no topic contents found for sort: { sortName }`)

		return nil
	end

	local entries = v19.entries

	if not entries then
		warn(`no sort entries found for sort: { sortName }`)

		return nil
	end

	return (React.createElement(SearchPillCarousel, {
		entries = entries,
		headerText = displayName,
		pageContext = appPage,
		sortIndex = t1.sortIndex,
		sortName = sortName,
		scrollViewPositionChangedSignal = v10.scrollViewPositionChangedSignal,
		verticalScrollingFrameRef = v10.verticalScrollingFrameRef
	}))
end

return SearchPillCarouselFeedItem
