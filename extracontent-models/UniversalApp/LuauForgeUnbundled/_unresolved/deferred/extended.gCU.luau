local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local module = require("@luauforge/bundled/dzG")
local sendSocialLinkClickEvent = module.Events.sendSocialLinkClickEvent
local sendOpenLeavingRobloxModalEvent = module.Events.sendOpenLeavingRobloxModalEvent
local module2 = require("@luauforge/deferred/gBS")
local module3 = require("@luauforge/deferred/gCV")

local UIBlox = require(CorePackages.Packages.UIBlox)
local images = UIBlox.App.ImageSet.Images

local module4 = require("@luauforge/deferred/gCQ")

local fFlagLuaAppAddSocialLinkClickTelemetryToEdp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppAddSocialLinkClickTelemetryToEdp

local v5 = {
	[module2.Twitter] = images["icons/brands/x"],
	[module2.Facebook] = images["icons/brands/facebook"],
	[module2.Discord] = images["icons/brands/discord"],
	[module2.RobloxGroup] = images["icons/logo/block"],
	[module2.YouTube] = images["icons/brands/youtube"],
	[module2.Twitch] = images["icons/brands/twitch"],
	[module2.Guilded] = images["icons/brands/guilded"]
}
local amazon = module2.Amazon
local v6 = if module4 then images["icons/brands/amazon_simple"] else nil
v5[amazon] = v6

local function fn() end

local extended = Roact.PureComponent:extend("ExperienceLogoTray")

local strictInterface = t.strictInterface
local v7 = {
	layoutOrder = t.optional(t.integer),
	socialLinks = t.table,
	linking = t.table,
	openLeaveRobloxAlertUIBlox = t.callback,
	closeAlert = t.callback,
	impressionsTag = t.string,
	onAbsolutePositionChanged = t.optional(t.callback),
	forwardRef = t.optional(t.table),
	universeId = 0
}
local v8 = if fFlagLuaAppAddSocialLinkClickTelemetryToEdp then t.string else nil
v7.universeId = v8
extended.validateProps = strictInterface(v7)

extended.defaultProps = { openLeaveRobloxAlertUIBlox = fn, closeAlert = fn }

function extended:init()
	function self.createItems(list)
		local result = {}
		local urlsByType = {}

		for i, item in ipairs(list) do
			local kind = item.type

			if v5[kind] == nil then
				continue
			end

			table.insert(result, { key = kind, logo = v5[kind] })

			urlsByType[kind] = item.url
		end

		return result, urlsByType
	end

	function self.getItemClickCallback(p3)
		return function(p4)
			local v9 = p3[p4]

			if fFlagLuaAppAddSocialLinkClickTelemetryToEdp then
				sendOpenLeavingRobloxModalEvent({
					assignment_id = tonumber(self.props.universeId),
					assignment_type = "game",
					social_link_type = p4,
					social_link_display_type = "badge"
				})
			end

			self.props.openLeaveRobloxAlertUIBlox(function()
				if fFlagLuaAppAddSocialLinkClickTelemetryToEdp then
					sendSocialLinkClickEvent({
						assignment_id = tonumber(self.props.universeId),
						assignment_type = "game",
						social_link_type = p4,
						social_link_url = v9,
						social_link_display_type = "badge"
					})
				end

				local v10 = v9

				if p4 == module2.Twitter then
					local match = v9:match("twitter.com/+([a-zA-Z0-9_]+)/*")

					if match ~= nil then
						v10 = "twitter://user?screen_name=" .. match
					end
				end

				local linking = self.props.linking
				linking:openURL(v10):andThen(function(p5)
					if p5 == false then
						linking:openURL(v9)
					end
				end)
				self.props.closeAlert()
			end)
		end
	end
end

function extended.render(props)
	local items, v9 = props.createItems(props.props.socialLinks)
	return Roact.createElement(module3, {
		layoutOrder = 1,
		itemList = items,
		handleItemClick = props.getItemClickCallback(v9),
		impressionsTag = props.props.impressionsTag,
		onAbsolutePositionChanged = props.props.onAbsolutePositionChanged,
		forwardRef = props.props.forwardRef
	})
end

return extended
