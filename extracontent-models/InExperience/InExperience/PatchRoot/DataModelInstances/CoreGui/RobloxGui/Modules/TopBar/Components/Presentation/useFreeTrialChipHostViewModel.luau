local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local InExperienceShop = require(CorePackages.Workspace.Packages.InExperienceShop)
local freeTrialTopBarSlot

if InExperienceShop.FFlagEnableFreeTrialTopBarChip then
	freeTrialTopBarSlot = InExperienceShop.FreeTrialTopBarSlot
else
	freeTrialTopBarSlot = nil
end

local Chrome = script.Parent.Parent.Parent.Parent.Chrome
local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local Enabled = Chrome2.Enabled

require(script.Parent.FreeTrialChipHostView)

local function openInExperienceShop()
	if not Enabled() then
		return
	end

	if InExperienceShop.FFlagCenterInExperienceShopWindow then
		local ShopWindowLayout = require(Chrome.Integrations.InExperienceShop.ShopWindowLayout)
		ShopWindowLayout.toggleInExperienceShopWindow()
	else
		local Constants = require(Chrome.ChromeShared.Unibar.Constants)
		local Service = require(Chrome.Service)
		Service:toggleWindow(Constants.IN_EXPERIENCE_SHOP_ID)
	end
end

local function useFreeTrialChipHostViewModel(data)
	local state, setState = React.useState(nil)
	local slot = freeTrialTopBarSlot

	if slot == nil then
		return nil
	end

	return {
		position = data.position,
		size = data.size,
		zIndex = data.zIndex == nil and 100 or data.zIndex,
		visible = data.visible,
		maxWidth = state,
		onAbsoluteSizeChanged = function(p)
			local x = p.AbsoluteSize.X

			if x > 0 and x ~= state then
				setState(x)
			end
		end,
		onActivated = openInExperienceShop,
		slot = slot
	}
end

return useFreeTrialChipHostViewModel
