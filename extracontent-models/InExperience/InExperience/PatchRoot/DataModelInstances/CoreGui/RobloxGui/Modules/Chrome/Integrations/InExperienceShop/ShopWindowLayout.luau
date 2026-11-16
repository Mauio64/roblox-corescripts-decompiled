local Chrome = script:FindFirstAncestor("Chrome")

local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")

local Service = require(Chrome.Service)
local ViewportUtil = require(Chrome.ChromeShared.Service.ViewportUtil)
local Constants = require(Chrome.ChromeShared.Unibar.Constants)

local FFlagCenterInExperienceShopWindow = require(CorePackages.Workspace.Packages.InExperienceShop.FFlagCenterInExperienceShopWindow)

local v = false

local function getCenteredShopWindowPosition()
	local v2 = ViewportUtil.screenSize:get()
	local y = GuiService.TopbarInset.Max.Y
	local v3 = v2.Y - y
	local v4 = v2.X < 844 or v3 < 754
	local v5

	if v4 then
		v5 = v2.X
	else
		v5 = math.min(844, v2.X)
	end

	local v6

	if v4 then
		v6 = v3
	else
		v6 = math.min(754, v3)
	end

	local v7 = (v2.X - v5) / 2
	local v8 = y + (v3 - v6) / 2
	return UDim2.fromOffset(v7, v8)
end

local function applyInitialWindowPositionIfNeeded() -- 1 equivalent call inferred from this helper
	if FFlagCenterInExperienceShopWindow and not v then
		Service:updateWindowPosition(Constants.IN_EXPERIENCE_SHOP_ID, getCenteredShopWindowPosition())
		v = true
	end
end

local function toggleInExperienceShopWindow() -- 1 equivalent call inferred from this helper
	if not Service:isWindowOpen(Constants.IN_EXPERIENCE_SHOP_ID) then
		applyInitialWindowPositionIfNeeded() -- inferred equivalent call
	end

	Service:toggleWindow(Constants.IN_EXPERIENCE_SHOP_ID)
end

local ShopWindowLayout = {}
ShopWindowLayout.MAX_WINDOW_WIDTH = 844
ShopWindowLayout.MAX_WINDOW_HEIGHT = 754
ShopWindowLayout.getCenteredShopWindowPosition = getCenteredShopWindowPosition

function ShopWindowLayout.getStartingWindowPosition()
	if FFlagCenterInExperienceShopWindow then
		return getCenteredShopWindowPosition()
	end

	return nil
end

ShopWindowLayout.toggleInExperienceShopWindow = toggleInExperienceShopWindow

function ShopWindowLayout.openInExperienceShopWindow()
	local IN_EXPERIENCE_SHOP_ID = Constants.IN_EXPERIENCE_SHOP_ID

	if Service:isWindowOpen(IN_EXPERIENCE_SHOP_ID) then
		return
	end

	if Service:isIntegrationValid(IN_EXPERIENCE_SHOP_ID) then
		Service:activate(IN_EXPERIENCE_SHOP_ID)
		return
	end

	toggleInExperienceShopWindow() -- inferred equivalent call
end

return ShopWindowLayout
