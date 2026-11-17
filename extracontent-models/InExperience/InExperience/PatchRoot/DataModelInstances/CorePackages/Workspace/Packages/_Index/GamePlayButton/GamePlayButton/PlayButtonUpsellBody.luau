local parent = script:FindFirstAncestor("GamePlayButton").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local AppLinking = RoactServiceTags.AppLinking

local CentralOverlay = require(parent.CentralOverlay)
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local RobloxAppEnums = require(parent.RobloxAppEnums)
local CentralOverlayType = RobloxAppEnums.CentralOverlayType

local DiscoveryUtils = require(parent.DiscoveryUtils)
local extractAndStyleRichTextLinks = DiscoveryUtils.extractAndStyleRichTextLinks

local function PlayButtonUpsellBody(p)
	local v = useTokens()
	local v2 = useDispatch()
	local v3 = useRoactService(AppLinking)

	local v4 = React.useMemo(function()
		local v4, styledText = extractAndStyleRichTextLinks(p.bodyText)
		local link

		if #v4 > 0 then
			link = v4[1]
		end

		return { link = link, styledText = styledText }
	end, { p.bodyText })

	local v5 = React.useCallback(function()
		if not v4.link then
			return
		end

		p.onCloseModal()

		v2(SetCentralOverlay(CentralOverlayType.LeaveRobloxAlert, {
			continueFunc = function()
				v3:openURL(v4.link)
				v2(CloseCentralOverlay())
			end
		}))
	end, { p.onCloseModal, v4.link, v2, v3 })

	local createElement = React.createElement
	local v6 = {
		["AutomaticSize"] = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		RichText = true,
		Size = UDim2.new(1, 0, 0, 0),
		Text = v4.styledText,
		TextSize = v.Typography.BodyLarge.FontSize,
		FontFace = normalizeFontFace(v.Typography.BodyLarge.Font),
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextColor3 = v.Color.Content.Emphasis.Color3,
		Active = v4.link ~= nil,
		Selectable = v4.link ~= nil
	}
	local activated = React.Event.Activated

	if not v4.link then
		v5 = nil
	end

	v6[activated] = v5
	return createElement("TextButton", v6)
end

return PlayButtonUpsellBody
