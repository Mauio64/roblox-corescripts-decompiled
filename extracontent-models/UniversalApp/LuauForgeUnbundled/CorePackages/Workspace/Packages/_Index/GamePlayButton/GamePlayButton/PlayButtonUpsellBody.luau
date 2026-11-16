local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Foundation")
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoactUtils").Hooks.RoactRodux.useDispatch

local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RobloxAppHooks").useRoactService
local appLinking = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoactServiceTags").AppLinking

local CentralOverlay = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/CentralOverlay")
local setCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local closeCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/RobloxAppEnums").CentralOverlayType

local extractAndStyleRichTextLinks = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/DiscoveryUtils").extractAndStyleRichTextLinks

local function PlayButtonUpsellBody(p2)
	local v5 = useTokens()
	local v6 = useDispatch()
	local v7 = useRoactService(appLinking)

	local v8 = React.useMemo(function()
		local v9, v10 = extractAndStyleRichTextLinks(p2.bodyText)

		local v12 = if #v9 > 0 then v9[1] else nil
		return { link = v12, styledText = v10 }
	end, { p2.bodyText })

	local v9 = React.useCallback(function()
		if not v8.link then
			return
		end

		p2.onCloseModal()

		v6(setCentralOverlay(centralOverlayType.LeaveRobloxAlert, {
			continueFunc = function()
				v7:openURL(v8.link)
				v6(closeCentralOverlay())
			end
		}))
	end, { p2.onCloseModal, v8.link, v6, v7 })

	local createElement = React.createElement
	local v11 = {}
	v11.AutomaticSize = Enum.AutomaticSize.Y
	v11.BackgroundTransparency = 1
	v11.RichText = true
	v11.Size = UDim2.new(1, 0, 0, 0)
	v11.Text = v8.styledText
	v11.TextSize = v5.Typography.BodyLarge.FontSize
	local v12 = if not foundationFontFaceMigration then v5.Typography.BodyLarge.Font else nil
	v11.Font = v12

	local v13 = if foundationFontFaceMigration then normalizeFontFace(v5.Typography.BodyLarge.Font) else nil
	v11.FontFace = v13

	v11.TextWrapped = true
	v11.TextXAlignment = Enum.TextXAlignment.Left
	v11.TextYAlignment = Enum.TextYAlignment.Center
	v11.TextColor3 = v5.Color.Content.Emphasis.Color3
	v11.Active = v8.link ~= nil
	v11.Selectable = v8.link ~= nil
	local activated = React.Event.Activated

	if not v8.link then
		v9 = nil
	end

	v11[activated] = v9
	return createElement("TextButton", v11)
end

return PlayButtonUpsellBody
