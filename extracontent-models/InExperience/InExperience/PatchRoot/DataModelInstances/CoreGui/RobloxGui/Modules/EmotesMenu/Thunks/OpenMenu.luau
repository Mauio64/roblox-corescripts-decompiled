local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local VRService = game:GetService("VRService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local parent = script.Parent.Parent
local actions = parent.Actions

local parent2 = parent.Parent

local Analytics = require(CorePackages.Workspace.Packages.Analytics)
local EventStream = Analytics.AnalyticsReporters.EventStream

local Analytics2 = require(parent.Analytics)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableNewBackpack = SharedFlags.FFlagEnableNewBackpack
local features

if FFlagEnableNewBackpack then
	local System = require(CorePackages.Workspace.Packages.System)
	features = System.Features
else
	features = nil
end

local BackpackScript

if FFlagEnableNewBackpack then
	BackpackScript = nil
else
	BackpackScript = require(parent2.BackpackScript)
end

local ShowMenu = require(actions.ShowMenu)

local v = Analytics2.new():withEventStream(EventStream.new(RbxAnalyticsService))

local function OpenMenu(_)
	return function(object)
		if GuiService.MenuIsOpen then
			if not VRService.VREnabled then
				return
			end

			GuiService:SetMenuIsOpen(false, "VRMenu")
		end

		if FFlagEnableNewBackpack then
			features.setVisibility(features.FeatureName.Backpack, false)

			if features.getVisibility(features.FeatureName.Backpack) then
				return
			end
		else
			if BackpackScript.IsOpen then
				BackpackScript.OpenClose()
			end

			if BackpackScript.IsOpen then
				return
			end
		end

		v:onMenuOpened()

		object:dispatch(ShowMenu())
	end
end

return OpenMenu
