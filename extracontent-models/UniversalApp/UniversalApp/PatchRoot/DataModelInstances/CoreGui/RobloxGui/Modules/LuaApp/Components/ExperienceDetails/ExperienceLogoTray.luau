local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local DiscoveryAnalytics = require(CorePackages.Workspace.Packages.DiscoveryAnalytics)
local sendSocialLinkClickEvent = DiscoveryAnalytics.Events.sendSocialLinkClickEvent
local sendOpenLeavingRobloxModalEvent = DiscoveryAnalytics.Events.sendOpenLeavingRobloxModalEvent
local SocialMediaType = require(Modules.LuaApp.Enum.SocialMediaType)
local LogoTray = require(script.Parent.LogoTray)
local Images = require(CorePackages.Packages.UIBlox).App.ImageSet.Images
local FFlagLuaAppAmazonSocialLinkEdp = require(Modules.Personalization.Flags.FFlagLuaAppAmazonSocialLinkEdp)
local FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp
local FFlagLuaAppAddSocialLinkClickTelemetryToEdp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppAddSocialLinkClickTelemetryToEdp
local t1 = {
	[SocialMediaType.Twitter] = Images["icons/brands/x"],
	[SocialMediaType.Facebook] = Images["icons/brands/facebook"],
	[SocialMediaType.Discord] = Images["icons/brands/discord"],
	[SocialMediaType.RobloxGroup] = Images["icons/logo/block"],
	[SocialMediaType.YouTube] = Images["icons/brands/youtube"],
	[SocialMediaType.Twitch] = Images["icons/brands/twitch"],
	[SocialMediaType.Guilded] = Images["icons/brands/guilded"],
	[SocialMediaType.Amazon] = if not FFlagLuaAppAmazonSocialLinkEdp then nil else Images["icons/brands/amazon_simple"]
}

local function v15() -- line: 32
end

local v16 = Roact.PureComponent:extend("ExperienceLogoTray")

v16.validateProps = t.strictInterface({
	layoutOrder = t.optional(t.integer),
	socialLinks = t.table,
	linking = t.table,
	openLeaveRobloxAlertUIBlox = t.callback,
	closeAlert = t.callback,
	impressionsTag = if not FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp then nil else t.string,
	onAbsolutePositionChanged = if not FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp then nil else t.optional(t.callback),
	forwardRef = if not FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp then nil else t.optional(t.table),
	universeId = if not FFlagLuaAppAddSocialLinkClickTelemetryToEdp then nil else t.string
})
v16.defaultProps = {
	openLeaveRobloxAlertUIBlox = v15,
	closeAlert = v15
}

function v16.init(p1) -- line: 55
	-- upvalues: t1 (copy), FFlagLuaAppAddSocialLinkClickTelemetryToEdp (copy), sendSocialLinkClickEvent (copy), SocialMediaType (copy), sendOpenLeavingRobloxModalEvent (copy)
	function p1.createItems(p2) -- line: 56
		-- upvalues: t1 (copy)
		local t2 = {}
		local t3 = {}

		for _, v in ipairs(p2) do
			local type = v.type

			if t1[type] ~= nil then
				table.insert(t2, {
					key = type,
					logo = t1[type]
				})
				t3[type] = v.url
			end
		end

		return t2, t3
	end
	function p1.getItemClickCallback(p3) -- line: 103
		-- upvalues: FFlagLuaAppAddSocialLinkClickTelemetryToEdp (copy), sendOpenLeavingRobloxModalEvent (copy), p1 (copy), sendSocialLinkClickEvent (copy), SocialMediaType (copy)
		return function(p4) -- line: 104
			-- upvalues: p3 (copy), FFlagLuaAppAddSocialLinkClickTelemetryToEdp (copy), sendOpenLeavingRobloxModalEvent (copy), p1 (copy), sendSocialLinkClickEvent (copy), SocialMediaType (copy)
			local v34 = p3[p4]

			if FFlagLuaAppAddSocialLinkClickTelemetryToEdp then
				sendOpenLeavingRobloxModalEvent({
					assignment_type = "game",
					social_link_display_type = "badge",
					assignment_id = tonumber(p1.props.universeId),
					social_link_type = p4
				})
			end

			p1.props.openLeaveRobloxAlertUIBlox(function() -- line: 75
				-- upvalues: FFlagLuaAppAddSocialLinkClickTelemetryToEdp (copy), sendSocialLinkClickEvent (copy), p1 (copy), p4 (copy), v34 (copy), SocialMediaType (copy)
				if FFlagLuaAppAddSocialLinkClickTelemetryToEdp then
					sendSocialLinkClickEvent({
						assignment_type = "game",
						social_link_display_type = "badge",
						assignment_id = tonumber(p1.props.universeId),
						social_link_type = p4,
						social_link_url = v34
					})
				end

				local v36 = v34

				if p4 == SocialMediaType.Twitter then
					local v37 = v34:match("twitter.com/+([a-zA-Z0-9_]+)/*")

					if v37 ~= nil then
						v36 = "twitter://user?screen_name=" .. v37
					end
				end

				local linking = p1.props.linking

				linking:openURL(v36):andThen(function(p5) -- line: 94
					-- upvalues: linking (copy), v34 (copy)
					if p5 == false then
						linking:openURL(v34)
					end
				end)
				p1.props.closeAlert()
			end)
		end
	end
end
function v16.render(p6) -- line: 120
	-- upvalues: Roact (copy), LogoTray (copy), FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp (copy)
	local v19, v20 = p6.createItems(p6.props.socialLinks)

	return Roact.createElement(LogoTray, {
		layoutOrder = 1,
		itemList = v19,
		handleItemClick = p6.getItemClickCallback(v20),
		impressionsTag = if not FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp then nil else p6.props.impressionsTag,
		onAbsolutePositionChanged = if not FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp then nil else p6.props.onAbsolutePositionChanged,
		forwardRef = if not FFlagLuaAppAddSocialLinkImpressionsTelemetryToEdp then nil else p6.props.forwardRef
	})
end

return v16
