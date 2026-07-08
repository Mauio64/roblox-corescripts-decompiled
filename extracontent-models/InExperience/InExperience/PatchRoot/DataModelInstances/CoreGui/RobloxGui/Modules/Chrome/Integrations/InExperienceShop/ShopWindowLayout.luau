local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local Service = require(Chrome.Service)
local ViewportUtil = require(Chrome.ChromeShared.Service.ViewportUtil)
local Constants = require(Chrome.ChromeShared.Unibar.Constants)
local FFlagCenterInExperienceShopWindow = require(CorePackages.Workspace.Packages.InExperienceShop).FFlagCenterInExperienceShopWindow
local u8 = false

local function getCenteredShopWindowPosition() -- line: 20
	-- upvalues: ViewportUtil (copy), GuiService (copy)
	local v11 = ViewportUtil.screenSize:get()
	local MaxY = GuiService.TopbarInset.Max.Y
	local v13 = v11.Y - MaxY
	local v14 = v11.X < 844 or v13 < 754
	local v15 = if not v14 then math.min(844, v11.X) else v11.X
	local v16 = if not v14 then math.min(754, v13) else v13
	local v17 = (v11.X - v15) / 2
	local v18 = MaxY + (v13 - v16) / 2

	return UDim2.fromOffset(v17, v18)
end
local function applyInitialWindowPositionIfNeeded() -- line: 34
	-- upvalues: FFlagCenterInExperienceShopWindow (copy), u8 (ref), Service (copy), Constants (copy), getCenteredShopWindowPosition (copy)
	if not FFlagCenterInExperienceShopWindow or u8 then
		return
	end

	Service:updateWindowPosition(Constants.IN_EXPERIENCE_SHOP_ID, getCenteredShopWindowPosition())
	u8 = true
end

return {
	MAX_WINDOW_WIDTH = 844,
	MAX_WINDOW_HEIGHT = 754,
	getCenteredShopWindowPosition = getCenteredShopWindowPosition,
	getStartingWindowPosition = function() -- line: 42
		-- upvalues: FFlagCenterInExperienceShopWindow (copy), getCenteredShopWindowPosition (copy)
		if FFlagCenterInExperienceShopWindow then
			return getCenteredShopWindowPosition()
		end

		return nil
	end,
	toggleInExperienceShopWindow = function() -- line: 49
		-- upvalues: Service (copy), Constants (copy), FFlagCenterInExperienceShopWindow (copy), u8 (ref), getCenteredShopWindowPosition (copy)
		if not Service:isWindowOpen(Constants.IN_EXPERIENCE_SHOP_ID) and (FFlagCenterInExperienceShopWindow and not u8) then
			Service:updateWindowPosition(Constants.IN_EXPERIENCE_SHOP_ID, getCenteredShopWindowPosition())
			u8 = true
		end

		Service:toggleWindow(Constants.IN_EXPERIENCE_SHOP_ID)
	end
}
