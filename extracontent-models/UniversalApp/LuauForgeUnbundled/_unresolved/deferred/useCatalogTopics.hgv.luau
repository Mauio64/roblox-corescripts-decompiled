local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch

local module = require("@luauforge/bundled/dVl")
local module2 = require("@luauforge/deferred/hgw")
local module3 = require("@luauforge/bundled/eie")
local module4 = require("@luauforge/bundled/egx")
require("@game/CorePackages/Workspace/Packages/Http")
local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals

local defineFastInt = game:DefineFastInt("AXGetTopicsExpirationSeconds", 600)

local v5 = { "____", "______", "_____", "___", "_________" }

local function useCachedTopics(p2, p3, p4)
	local topicRequestKey = module.getTopicRequestKey(p2, p3, p4)

	return useSelector(React.useCallback(function(p5)
		if (p5.AvatarExperience.Catalog.TopicsFetchTimes[topicRequestKey] or 0) + defineFastInt <= tick() then
			return nil
		end

		return p5.AvatarExperience.Catalog.Topics[topicRequestKey]
	end, { topicRequestKey }), getUseSelectorDeepEquals())
end

local function useCatalogTopics(p2, p3, p4)
	local v6 = module3(module4)
	local v7 = useDispatch()

	local state, setState = React.useState(v5)
	local v8 = useCachedTopics(p2, p3, p4)
	local v9 = v8 == nil

	if v8 ~= nil and v8 ~= state then
		setState(v8)
	end

	React.useEffect(function()
		if v8 == nil then
			v7(module2(v6, p2, p3, p4))
		end
	end, { v8, p2, p3, p4 })

	return v8 or state, v9
end

return useCatalogTopics
