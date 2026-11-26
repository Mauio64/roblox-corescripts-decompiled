local module = require("@luauforge/deferred/eil")

local useAppPolicy = require("@luauforge/deferred/ekh").useAppPolicy
local useLocalization = require("@luauforge/deferred/ejG").Hooks.useLocalization

local module2 = require("@luauforge/deferred/eiy")
local module3 = require("@luauforge/deferred/eiD")

local module4 = require("@luauforge/deferred/emn")

local function isHiddenOnInit(): boolean
	return module4.getValue() ~= 0
end

local function useFriendingOSAEducationSubtitle()
	local v5 = module.useState(isHiddenOnInit)

	local v6 = module3()

	local v7 = useAppPolicy(function(p2)
		return p2.getRequiresOSAFriendingEducation()
	end)

	local v8 = useLocalization({
		educationText = "Feature.Friends.Subtitle.FriendsEducation"
	})
	local v9 = v7 and not v5
	local v10 = module.useCallback(function()
		v6(module2.FriendingOSAEducationSubtitleImpression)

		module4.incrementValue()
	end, { v6 })

	module.useEffect(function()
		if v9 then
			v10()
		end
	end, { v9 })

	if v9 then
		return v8.educationText
	end

	return nil
end

return useFriendingOSAEducationSubtitle
