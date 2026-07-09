local StarterGui = game:GetService("StarterGui")
local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local Signals = require(InExperienceShopParent.Signals)
local FFlagEnableExperienceShopGlobalIcon = require(InExperienceShop.Flags.FFlagEnableExperienceShopGlobalIcon)
local FFlagExperienceShopGlobalIconSkipCoreGuiCheck = require(InExperienceShop.Flags.FFlagExperienceShopGlobalIconSkipCoreGuiCheck)
local getInExperienceShopStore = require(InExperienceShop.Stores.getInExperienceShopStore)
local GetShopGlobalIconStore = require(InExperienceShop.Stores.GetShopGlobalIconStore)

local function initShopGlobalIcon() -- line: 20
	-- upvalues: FFlagEnableExperienceShopGlobalIcon (copy), GetShopGlobalIconStore (copy), FFlagExperienceShopGlobalIconSkipCoreGuiCheck (copy), StarterGui (copy), Signals (copy), getInExperienceShopStore (copy)
	if not FFlagEnableExperienceShopGlobalIcon then
		return nil
	end

	local v10 = GetShopGlobalIconStore(false)
	local u11 = not not FFlagExperienceShopGlobalIconSkipCoreGuiCheck or (StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.All) or StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.ExperienceShop))
	local u12 = false

	local function updateEnabled() -- line: 37
		-- upvalues: v10 (copy), u11 (ref), u12 (ref)
		v10.setEnabled(u11 and u12)
	end

	local v14 = if not FFlagExperienceShopGlobalIconSkipCoreGuiCheck then StarterGui.CoreGuiChangedSignal:Connect(function(p1, p2) -- line: 43
		-- upvalues: u11 (ref), v10 (copy), u12 (ref)
		if p1 == Enum.CoreGuiType.ExperienceShop or p1 == Enum.CoreGuiType.All then
			u11 = p2
			v10.setEnabled(u11 and u12)
		end
	end) else nil
	local u15 = nil

	u15 = Signals.createEffect(function(p3) -- line: 53
		-- upvalues: getInExperienceShopStore (copy), u12 (ref), v10 (copy), u11 (ref), u15 (ref)
		local v19 = getInExperienceShopStore(false)

		if v19.getLoading(p3) then
			return
		end

		if not v19.getGlobalIconBackendEnabled(p3) then
			return
		end

		u12 = true
		v10.setEnabled(u11 and u12)
		v10.setStatusIndicatorEnabled(v19.getGlobalIconHasNewOffers(p3))
		task.defer(function() -- line: 64
			-- upvalues: u15 (ref)
			if u15 then
				u15()
				u15 = nil
			end
		end)
	end)

	return function() -- line: 72
		-- upvalues: FFlagExperienceShopGlobalIconSkipCoreGuiCheck (copy), v14 (copy), u15 (ref)
		if not FFlagExperienceShopGlobalIconSkipCoreGuiCheck and v14 then
			v14:Disconnect()
		end

		if u15 then
			u15()
			u15 = nil
		end
	end
end

return initShopGlobalIcon
