local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local React = require(CorePackages.Packages.React)
local useEventConnection = require(CorePackages.Packages.ReactUtils).useEventConnection
local Service = require(Chrome.Service)
local ViewportUtil = require(Chrome.ChromeShared.Service.ViewportUtil)

require(Chrome.ChromeShared.Service.WindowSizeSignal)

local Constants = require(Chrome.ChromeShared.Unibar.Constants)
local ShopContainer = require(CorePackages.Workspace.Packages.InExperienceShop).ShopContainer

local function ShopChromeWrapper(t1: {[any]: any}) -- line: 23
	-- upvalues: React (copy), GuiService (copy), useEventConnection (copy), ViewportUtil (copy), Service (copy), Constants (copy), ShopContainer (copy)
	local windowSize = t1.windowSize
	local v13, v14 = React.useState(false)
	local v15 = React.useCallback(function(vector2: Vector2) -- line: 27
		-- upvalues: GuiService (copy), t1 (copy), windowSize (copy), v14 (copy)
		local MaxY = GuiService.TopbarInset.Max.Y
		local v19 = vector2.X < t1.maxWindowWidth or vector2.Y - MaxY < t1.maxWindowHeight

		if v19 then
			windowSize:requestSize(vector2.X, vector2.Y - MaxY)
		else
			windowSize:requestSize(math.min(t1.maxWindowWidth, vector2.X), (math.min(t1.maxWindowHeight, vector2.Y - MaxY)))
		end

		v14(v19)
	end, {
		windowSize,
		t1.maxWindowWidth,
		t1.maxWindowHeight
	})

	useEventConnection(GuiService:GetPropertyChangedSignal("TopbarInset"), function() -- line: 42
		-- upvalues: v15 (copy), ViewportUtil (copy)
		v15(ViewportUtil.screenSize:get())
	end)
	React.useEffect(function() -- line: 46
		-- upvalues: ViewportUtil (copy), v15 (copy)
		local v20 = ViewportUtil.screenSize:connect(v15)

		v15(ViewportUtil.screenSize:get())

		return function() -- line: 49
			-- upvalues: v20 (copy)
			v20:disconnect()
		end
	end, { v15 })

	local v16 = React.useCallback(function() -- line: 54
		-- upvalues: Service (copy), Constants (copy)
		Service:toggleWindow(Constants.IN_EXPERIENCE_SHOP_ID)
	end, {})

	return React.createElement(ShopContainer, {
		fullScreen = v13,
		toggleWindow = v16
	})
end

return ShopChromeWrapper
