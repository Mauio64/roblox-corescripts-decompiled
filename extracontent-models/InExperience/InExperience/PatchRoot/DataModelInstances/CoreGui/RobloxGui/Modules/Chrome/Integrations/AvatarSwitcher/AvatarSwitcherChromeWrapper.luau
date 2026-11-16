local Chrome = script:FindFirstAncestor("Chrome")

local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local React = require(CorePackages.Packages.React)
local ReactUtils = require(CorePackages.Packages.ReactUtils)
local useEventConnection = ReactUtils.useEventConnection
local Foundation = require(CorePackages.Packages.Foundation)
local Service = require(Chrome.Service)
local ViewportUtil = require(Chrome.ChromeShared.Service.ViewportUtil)
require(Chrome.ChromeShared.Service.WindowSizeSignal)
local Constants = require(Chrome.ChromeShared.Unibar.Constants)

local AvatarSwitcher = require(CorePackages.Workspace.Packages.AvatarSwitcher)
local AvatarSwitcherContainer = AvatarSwitcher.Components.AvatarSwitcherContainer

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAvatarWorkshopReplacesAvatarSwitcher = SharedFlags.FFlagAvatarWorkshopReplacesAvatarSwitcher
local avatarWorkshopWindow

if FFlagAvatarWorkshopReplacesAvatarSwitcher then
	local AvatarWorkshop = require(CorePackages.Workspace.Packages.AvatarWorkshop)
	avatarWorkshopWindow = AvatarWorkshop.Components.AvatarWorkshopWindow
else
	avatarWorkshopWindow = nil
end

local function shouldUseVerticalLayout(udim: UDim2): boolean -- 2 equivalent calls inferred from this helper
	return udim.X.Offset / udim.Y.Offset < 1.2
end

local function AvatarSwitcherChromeWrapper(props)
	local windowSize = props.windowSize
	local state, setState = React.useState(shouldUseVerticalLayout(windowSize:get())) -- inferred equivalent call
	local state2, setState2 = React.useState(false)

	local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)

	local v = React.useCallback(function(vector2: Vector2)
		local y = GuiService.TopbarInset.Max.Y
		local v = vector2.X < props.maxWindowWidth or vector2.Y - y < props.maxWindowHeight

		if v then
			windowSize:requestSize(vector2.X, vector2.Y - y)
		else
			windowSize:requestSize(
				math.min(props.maxWindowWidth, vector2.X),
				(math.min(props.maxWindowHeight, vector2.Y - y))
			)
		end

		setState2(v)
	end, { windowSize, props.maxWindowWidth, props.maxWindowHeight, state2 })

	useEventConnection(GuiService:GetPropertyChangedSignal("TopbarInset"), function()
		v(ViewportUtil.screenSize:get())
	end)

	React.useEffect(function()
		local screenSizeConnection = ViewportUtil.screenSize:connect(v)
		local connection = windowSize:connect(function(p)
			setState(shouldUseVerticalLayout(p)) -- inferred equivalent call
		end)
		v(ViewportUtil.screenSize:get())
		return function()
			screenSizeConnection:disconnect()
			connection:disconnect()
		end
	end, { v })

	if FFlagAvatarWorkshopReplacesAvatarSwitcher and avatarWorkshopWindow then
		return React.createElement(Foundation.View, {
			tag = {
				["size-full"] = true,
				["padding-x-large padding-bottom-xlarge padding-top-medium"] = state2
			}
		}, {
			AvatarWorkshopWindow = React.createElement(avatarWorkshopWindow, {
				verticalLayout = state,
				onClose = function()
					Service:toggleWindow(Constants.AVATAR_SWITCHER_ID)
				end
			})
		})
	end

	return React.createElement(Foundation.View, {
		tag = `size-full {state2 and "padding-x-large padding-top-medium padding-bottom-xlarge" or ""}`
	}, {
		AvatarSwitcherContainer = React.createElement(AvatarSwitcherContainer, {
			getRespawnBehaviour = SettingsHub.GetRespawnBehaviour,
			respawnBehaviorChangedEvent = SettingsHub.RespawnBehaviourChangedEvent,
			toggleWindow = function()
				Service:toggleWindow(Constants.AVATAR_SWITCHER_ID)
			end,
			verticalLayout = state
		})
	})
end

return AvatarSwitcherChromeWrapper
