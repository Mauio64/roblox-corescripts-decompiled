local module = require("@luauforge/deferred/eko")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceSideSheet/Foundation")
local scrollView = Foundation.ScrollView
local text = Foundation.Text
local view = Foundation.View

local useLocalization = require("@luauforge/deferred/ekQ").Hooks.useLocalization

local module3 = require("@luauforge/deferred/ekq")
local module4 = require("@luauforge/deferred/fcl")
local module5 = require("@luauforge/deferred/fcW")
local module6 = require("@luauforge/deferred/fcX")
local module7 = require("@luauforge/deferred/fcZ")

local function SchoolWaitlist(props)
	local v5 = module5.byVariant[props.variant]

	local v6 = props.schoolName
	local v7 = not (v6 == nil) and v6 ~= ""

	local v8 = useLocalization({
		namedHeading = v7 and v5.headingKey ~= nil and {
			v5.headingKey,
			school = v6
		} or nil,
		noNameHeading = v5.noNameHeadingKey,
		body = v5.bodyKey
	})

	if v7 then
		if v5.headingKey ~= nil then
			v6 = v8.namedHeading
		end
	else
		v6 = v8.noNameHeading
	end

	local createElement = module.createElement
	local v10 = {
		Size = UDim2.fromScale(1, 1),
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.fromScale(1, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			scrollBarVisibility = Foundation.Enums.Visibility.Auto
		}
	}

	local createElement2 = module.createElement

	local v14 = {
		Header = module.createElement(
			view,
			{ LayoutOrder = 1, tag = "col align-x-left gap-xxsmall size-full-0 auto-y" },
			{
				Heading = module.createElement(text, {
					LayoutOrder = 1,
					Text = v6,
					tag = "size-full-0 auto-y text-heading-medium text-wrap text-align-x-left content-default"
				}),
				Body = module.createElement(text, {
					LayoutOrder = 2,
					Text = v8.body,
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
				})
			}
		),
		Timeline = module.createElement(module6, {
			LayoutOrder = 2,
			stages = v5.stages,
			remainingCount = props.remainingCount
		}),
		ShareBanner = module.createElement(module7, {
			LayoutOrder = 3,
			titleKey = v5.shareTitleKey,
			bodyKey = v5.shareBodyKey,
			mediaType = props.variant == module3.SchoolWaitlistVariant.Alumni and "Alumni" or "Reward",
			mediaImage = props.shareMedia,
			onShare = props.onShare
		}),
		InviteList = 0
	}

	local v15 = if module4 then props.inviteList else nil
	v14.InviteList = v15
	return createElement(scrollView, v10, {
		Inner = createElement2(
			view,
			{ tag = "col gap-medium size-full-0 auto-y padding-bottom-xlarge" },
			v14
		)
	})
end

return SchoolWaitlist
