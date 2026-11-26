local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)

local UIBlox = require(CorePackages.Packages.UIBlox)

local contextualMenu = UIBlox.App.Menu.ContextualMenu
local menuDirection = UIBlox.App.Menu.MenuDirection

local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens

local module = require("@luauforge/bundled/dXh")

local module2 = require("@luauforge/deferred/gJH")
local module3 = require("@luauforge/deferred/gJI")

local module4 = require("@luauforge/bundled/dPN")
local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSplitPane

local v5 = if fFlagEnableSplitPane then require("@luauforge/bundled/fCo") else nil

local module5 = require("@luauforge/bundled/gJS")
local module6 = require("@luauforge/bundled/fCe")

local module7 = require("@luauforge/bundled/dzD")

local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals

local defineFastFlag = game:DefineFastFlag("FixNilButtonCrashApp", false)

local function ContextFrame(props)
	local v6 = useNavigation()
	local v7 = useDesignTokens()

	local function onDismiss()
		module.closeOverlay(v6)

		if props.onOverlayClosed ~= nil then
			props.onOverlayClosed()
		end
	end

	local v8 = useSelector(function(p2)
		return p2.ScreenSize
	end, getUseSelectorDeepEquals())

	local v9 = useSelector(function(p2)
		return p2.GamepadBottomBar.boundInputs
	end, getUseSelectorDeepEquals())

	local v10 = useSelector(module5, getUseSelectorDeepEquals())
	local v11

	if v10 then
		v11 = 0
	else
		v11 = if fFlagEnableSplitPane then v5.getLandscapeNavWidth() else module4.LandscapeNavWidth
	end

	local v12

	if v10 then
		v12 = 1
	else
		v12 = if fFlagEnableSplitPane then v5.getLandscapeSceneWidth() else module4.LandscapeSceneWidth
	end

	local v13 = not (module6.getNumElementsWithKeyField(v9) > 0) and -76
		or -76 - module7.GAMEPAD_BOTTOM_BAR_SIZE
	local udim, udim2

	if props.centered and not v10 then
		local v14 = math.min(v8.X, 640)
		udim = UDim2.fromOffset((v8.X - v14) / 2, 0)
		udim2 = UDim2.new(0, v14, 1, 0)
	else
		udim = UDim2.fromScale(v11, 0)
		udim2 = UDim2.fromScale(v12, 1)
	end

	local v14 = React.useMemo(function()
		local v15 = props.contextButtons

		if defineFastFlag then
			v15 = Cryo.List.filter(props.contextButtons, function(p2): boolean
				return p2 ~= nil
			end)
		end

		return Cryo.List.map(v15, function(p2)
			if p2.onActivated then
				return Cryo.Dictionary.join(p2, {
					onActivated = function()
						p2.onActivated(v6)
					end
				})
			end

			return p2
		end)
	end, { props.contextButtons, v6 })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = udim,
		Size = udim2
	}, {
		SizeFrame = React.createElement(
			"Frame",
			{
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.5, 0),
				Size = UDim2.fromScale(1, 1)
			},
			{
				ContextMenuPadding = React.createElement("UIPadding", {
					PaddingRight = UDim.new(0, v7.Size.Size_600),
					PaddingLeft = UDim.new(0, v7.Size.Size_600)
				}),
				ContextMenu = React.createElement(contextualMenu, {
					buttonProps = v14,
					closeBackgroundVisible = true,
					menuDirection = menuDirection.Up,
					onDismiss = onDismiss,
					open = true,
					openPositionY = UDim.new(1, v13),
					screenSize = v8,
					contextMenuWidthOverride = UDim.new(1, 0)
				})
			}
		)
	})
end

return (module3((module2(ContextFrame))))
