local Chrome = script:FindFirstAncestor("Chrome")

local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")

local React = require(CorePackages.Packages.React)
local ReactUtils = require(CorePackages.Packages.ReactUtils)
local useEventConnection = ReactUtils.useEventConnection
local Service = require(Chrome.Service)
local ViewportUtil = require(Chrome.ChromeShared.Service.ViewportUtil)
require(Chrome.ChromeShared.Service.WindowSizeSignal)
local Constants = require(Chrome.ChromeShared.Unibar.Constants)

local InExperienceShop = require(CorePackages.Workspace.Packages.InExperienceShop)
local ShopContainer = InExperienceShop.ShopContainer

local function ShopChromeWrapper(props)
	local windowSize = props.windowSize
	local state, setState = React.useState(false)

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

		setState(v)
	end, { windowSize, props.maxWindowWidth, props.maxWindowHeight })

	useEventConnection(GuiService:GetPropertyChangedSignal("TopbarInset"), function()
		v(ViewportUtil.screenSize:get())
	end)

	React.useEffect(function()
		local screenSizeConnection = ViewportUtil.screenSize:connect(v)
		v(ViewportUtil.screenSize:get())
		return function()
			screenSizeConnection:disconnect()
		end
	end, { v })

	local toggleWindow = React.useCallback(function()
		Service:toggleWindow(Constants.IN_EXPERIENCE_SHOP_ID)
	end, {})

	return React.createElement(ShopContainer, { fullScreen = state, toggleWindow = toggleWindow })
end

return ShopChromeWrapper
