local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local VRService = game:GetService("VRService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local ParentParent = script.Parent.Parent
local Actions = ParentParent.Actions
local ParentParentParent = ParentParent.Parent
local EventStream = require(CorePackages.Workspace.Packages.Analytics).AnalyticsReporters.EventStream
local Analytics = require(ParentParent.Analytics)
local FFlagEnableNewBackpack = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableNewBackpack
local v11 = if not FFlagEnableNewBackpack then nil else require(CorePackages.Workspace.Packages.System).Features
local v12 = if FFlagEnableNewBackpack then nil else require(ParentParentParent.BackpackScript)
local ShowMenu = require(Actions.ShowMenu)
local v14 = Analytics.new():withEventStream(EventStream.new(RbxAnalyticsService))

local function OpenMenu(_) -- line: 23
	-- upvalues: GuiService (copy), VRService (copy), FFlagEnableNewBackpack (copy), v11 (copy), v12 (copy), v14 (copy), ShowMenu (copy)
	return function(p2) -- line: 24
		-- upvalues: GuiService (copy), VRService (copy), FFlagEnableNewBackpack (copy), v11 (copy), v12 (copy), v14 (copy), ShowMenu (copy)
		if GuiService.MenuIsOpen then
			if not VRService.VREnabled then
				return
			end

			GuiService:SetMenuIsOpen(false, "VRMenu")
		end

		if FFlagEnableNewBackpack then
			v11.setVisibility(v11.FeatureName.Backpack, false)

			if v11.getVisibility(v11.FeatureName.Backpack) then
				return
			end
		else
			if v12.IsOpen then
				v12.OpenClose()
			end

			if v12.IsOpen then
				return
			end
		end

		v14:onMenuOpened()
		p2:dispatch(ShowMenu())
	end
end

return OpenMenu
