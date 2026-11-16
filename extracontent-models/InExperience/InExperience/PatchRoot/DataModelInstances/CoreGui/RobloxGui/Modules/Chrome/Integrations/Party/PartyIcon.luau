local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")

local Constants = require(Chrome.ChromeShared.Unibar.Constants)
local Flags = require(Chrome.ChromeShared.Flags)
local Foundation = require(CorePackages.Packages.Foundation)
local React = require(CorePackages.Packages.React)
local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local useMappedSignal = Chrome2.Hooks.useMappedSignal
local usePartyIcon = require(Chrome.Integrations.Party.usePartyIcon)

local MappedSignal = ChromeUtils.MappedSignal
local useTokens = Foundation.Hooks.useTokens
local Chrome3 = require(CorePackages.Workspace.Packages.Chrome)
local UnibarStyle = Chrome3.UnibarStyle

local SubMenuContext = require(Chrome.ChromeShared.Unibar.SubMenuContext)
local InExperienceAppChatModal = require(CorePackages.Workspace.Packages.AppChat.InExperienceAppChatModal)

local FFlagTokenizeUnibarConstantsWithStyleProvider = Flags.FFlagTokenizeUnibarConstantsWithStyleProvider

local function PartyIcon()
	local v = useTokens()
	local ICON_SIZE

	if FFlagTokenizeUnibarConstantsWithStyleProvider then
		ICON_SIZE = UnibarStyle.use().ICON_SIZE
	else
		ICON_SIZE = Constants.ICON_SIZE
	end

	local v2 = usePartyIcon(
		ICON_SIZE,
		24,
		useMappedSignal((MappedSignal.new(InExperienceAppChatModal.default.visibilitySignal.Event, function(_)
			return InExperienceAppChatModal:getVisible()
		end))) and "icons/menu/2-person-with-bubble-on" or "icons/menu/2-person-with-bubble"
	)

	local v3 = React.useContext(SubMenuContext)
	local function getTransparency(transparency: number) -- 3 equivalent calls inferred from this helper
		if v3 then
			return (v3:map(function(p)
				return transparency + (1 - transparency) * (1 - p)
			end))
		end

		return transparency
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v4 = {
		Size = UDim2.new(0, ICON_SIZE, 0, ICON_SIZE)
	}

	local createElement2 = React.createElement
	local image = Foundation.Image
	local v5 = {
		Size = v2.size:map(function(p)
			return UDim2.fromOffset(p, p)
		end),
		backgroundStyle = 0,
		Image = 0,
		imageStyle = 0,
		tag = "anchor-center-center position-center-center radius-circle"
	}
	local backgroundStyle

	if v2.image.backgroundColor then
		backgroundStyle = { Color3 = v2.image.backgroundColor, Transparency = 0 }
		local transparency

		if v3 then
			local v6
			v6 = 0
			transparency = v3:map(function(p)
				return v6 + (1 - v6) * (1 - p)
			end)
		else
			transparency = 0
		end

		backgroundStyle.Transparency = transparency
	else
		backgroundStyle = v.Color.None
	end

	v5.backgroundStyle = backgroundStyle

	v5.Image = v2.image.thumbnail
	v5.imageStyle = {
		Color3 = v.Color.Content.Emphasis.Color3,
		Transparency = getTransparency(v.Color.Content.Emphasis.Transparency) -- inferred equivalent call
	}
	return createElement(view, v4, {
		Icon = createElement2(image, v5),
		Badge = React.createElement(Foundation.View, {
			Position = UDim2.new(1, -v.Stroke.Thicker, 0, v.Stroke.Thicker),
			backgroundStyle = {
				Color3 = v.Color.System.Success.Color3,
				Transparency = getTransparency(v.Color.System.Success.Transparency) -- inferred equivalent call
			},
			stroke = {
				Color = v.Color.Surface.Surface_0.Color3,
				Transparency = getTransparency(v.Color.Surface.Surface_0.Transparency), -- inferred equivalent call
				Thickness = v.Stroke.Thicker
			},
			tag = "anchor-top-right radius-circle size-200 stroke-thicker",
			ZIndex = 2
		})
	})
end

return PartyIcon
