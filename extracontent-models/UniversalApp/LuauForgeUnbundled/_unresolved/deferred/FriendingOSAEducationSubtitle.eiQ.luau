local module = require("@luauforge/deferred/eeO")
local text = require("@luauforge/deferred/ege").Text

local useAppPolicy = require("@luauforge/deferred/egN").useAppPolicy
local useLocalization = require("@luauforge/deferred/egl").Hooks.useLocalization

local module2 = require("@luauforge/deferred/efb")
local module3 = require("@luauforge/deferred/efg")

local module4 = require("@luauforge/deferred/eiR")
local module5 = require("@luauforge/deferred/eiS")

local defineFastFlag = game:DefineFastFlag("FriendingOSAUseHook", false)

local function isHiddenOnInit(): boolean
	return module4.getValue() ~= 0
end

local function FriendingOSAEducationSubtitle(p2)
	local layoutOrder = p2.layoutOrder

	if defineFastFlag then
		local v5 = module5()

		if v5 then
			return (module.createElement(text, {
				tag = "auto-y grow size-full-0 text-align-x-left text-wrap",
				Text = v5,
				LayoutOrder = layoutOrder
			}))
		end

		return nil
	else
		local v5 = module.useState(isHiddenOnInit)

		local v6 = module3()

		local v7 = useAppPolicy(function(p3)
			return p3.getRequiresOSAFriendingEducation()
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
			return (module.createElement(text, {
				tag = "auto-y grow size-full-0 text-align-x-left text-wrap",
				Text = v8.educationText,
				LayoutOrder = layoutOrder
			}))
		end

		return nil
	end
end

return FriendingOSAEducationSubtitle
