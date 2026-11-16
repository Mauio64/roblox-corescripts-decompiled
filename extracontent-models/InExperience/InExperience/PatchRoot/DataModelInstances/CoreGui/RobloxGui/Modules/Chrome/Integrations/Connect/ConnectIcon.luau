local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Foundation = require(CorePackages.Packages.Foundation)
local React = require(CorePackages.Packages.React)
local Constants = require(Chrome.ChromeShared.Unibar.Constants)
local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local useMappedSignal = Chrome2.Hooks.useMappedSignal

local MappedSignal = ChromeUtils.MappedSignal
local useTokens = Foundation.Hooks.useTokens
local Chrome3 = require(CorePackages.Workspace.Packages.Chrome)
local UnibarStyle = Chrome3.UnibarStyle

local SubMenuContext = require(Chrome.ChromeShared.Unibar.SubMenuContext)
local InExperienceAppChatModal = require(CorePackages.Workspace.Packages.AppChat.InExperienceAppChatModal)

local getAppChatNavbarItemConfig = require(CorePackages.Workspace.Packages.AppChat.getAppChatNavbarItemConfig)

local Flags = require(Chrome.ChromeShared.Flags)
local FFlagTokenizeUnibarConstantsWithStyleProvider = Flags.FFlagTokenizeUnibarConstantsWithStyleProvider

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableChatIconUnibarDropdownFixEnabled = SharedFlags.FFlagEnableChatIconUnibarDropdownFixEnabled

local appChatNavbarItemConfig = getAppChatNavbarItemConfig()

local v = { integrationId = "", shouldShowCustomBadge = true, isSquadIndicatorEnabled = false }

local function ConnectIcon(p)
	local union = Cryo.Dictionary.union(v, p)
	local v2 = useTokens()
	local ICON_SIZE

	if FFlagTokenizeUnibarConstantsWithStyleProvider then
		ICON_SIZE = UnibarStyle.use().ICON_SIZE
	else
		ICON_SIZE = Constants.ICON_SIZE
	end

	local state, setState = React.useState(InExperienceAppChatModal.default.unreadCount)

	if union.shouldShowCustomBadge then
		React.useEffect(function()
			local eventConnection = InExperienceAppChatModal.default.unreadCountSignal.Event:Connect(function(p2)
				setState(p2)
			end)
			return function()
				eventConnection:Disconnect()
			end
		end, { setState })
	else
		state = 0
	end

	local v3 = nil
	local state2, setState2

	if union.isSquadIndicatorEnabled then
		state2, setState2 = React.useState(InExperienceAppChatModal.default.currentSquadId)
	else
		setState2 = nil
	end

	React.useEffect(function()
		if not union.isSquadIndicatorEnabled then
			return function() end
		end

		local eventConnection = InExperienceAppChatModal.default.currentSquadIdSignal.Event:Connect(function(p2)
			setState2(p2)
		end)

		return function()
			eventConnection:Disconnect()
		end
	end, { union.isSquadIndicatorEnabled, setState2 })

	if union.isSquadIndicatorEnabled then
		if state2 == "" then
			if state > 0 then
				v3 = v2.Color.System.Contrast
			end
		else
			v3 = v2.Color.System.Success
		end
	end

	local v4

	if union.isSquadIndicatorEnabled then
		v4 = v3
	else
		v4 = state > 0
	end

	local v5 = useMappedSignal((MappedSignal.new(InExperienceAppChatModal.default.visibilitySignal.Event, function(_)
		return InExperienceAppChatModal:getVisible()
	end)))

	local v6 = React.useContext(SubMenuContext)
	local function getTransparency(transparency: number) -- 3 equivalent calls inferred from this helper
		if v6 then
			return (v6:map(function(p2)
				return transparency + (1 - transparency) * (1 - p2)
			end))
		end

		return transparency
	end

	local style

	if FFlagEnableChatIconUnibarDropdownFixEnabled then
		local transparency = v2.Color.Content.Default.Transparency

		if v6 then
			style = v6:map(function(p2)
				return {
					Color3 = v2.Color.Content.Default.Color3,
					Transparency = transparency + (1 - transparency) * (1 - p2)
				}
			end)
		else
			style = v2.Color.Content.Default
		end
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v7 = {
		Size = UDim2.new(0, ICON_SIZE, 0, ICON_SIZE)
	}

	local createElement2 = React.createElement
	local icon = Foundation.Icon
	local v8 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		name = appChatNavbarItemConfig.icon,
		variant = 0,
		style = 0
	}
	local variant

	if v5 then
		variant = Foundation.Enums.IconVariant.Filled
	else
		variant = Foundation.Enums.IconVariant.Regular
	end

	v8.variant = variant

	if not FFlagEnableChatIconUnibarDropdownFixEnabled then
		style = nil
	end

	v8.style = style
	local v9 = { Icon = createElement2(icon, v8), Badge = 0 }
	local badge

	if v4 then
		local createElement3 = React.createElement
		local view2 = Foundation.View
		local v10 = {
			Position = UDim2.new(1, -v2.Stroke.Thicker, 0, v2.Stroke.Thicker),
			backgroundStyle = 0,
			stroke = 0,
			tag = 0,
			ZIndex = 2
		}
		local backgroundStyle

		if union.isSquadIndicatorEnabled then
			backgroundStyle = { Color3 = v3.Color3, Transparency = 0 }
			backgroundStyle.Transparency = getTransparency(v3.Transparency) -- inferred equivalent call
		else
			backgroundStyle = { Color3 = v2.Color.System.Contrast.Color3, Transparency = 0 }
			backgroundStyle.Transparency = getTransparency(v2.Color.System.Contrast.Transparency) -- inferred equivalent call
		end

		v10.backgroundStyle = backgroundStyle

		v10.stroke = {
			Color = v2.Color.Surface.Surface_0.Color3,
			Transparency = getTransparency(v2.Color.Surface.Surface_0.Transparency), -- inferred equivalent call
			Thickness = v2.Stroke.Thicker
		}

		v10.tag = {
			["anchor-top-right radius-circle size-200"] = true,
			["stroke-thicker"] = not FFlagEnableChatIconUnibarDropdownFixEnabled
		}
		badge = createElement3(view2, v10)
	end

	v9.Badge = badge
	return createElement(view, v7, v9)
end

return ConnectIcon
