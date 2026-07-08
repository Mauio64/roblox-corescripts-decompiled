local ChromeShared = script:FindFirstAncestor("ChromeShared")
local CorePackages = game:GetService("CorePackages")
local ReactUtils = require(CorePackages.Packages.ReactUtils)
local React = require(CorePackages.Packages.React)
local UnibarMenu = require(ChromeShared.Unibar.UnibarMenu)
local UnibarStyle = require(CorePackages.Workspace.Packages.Chrome).UnibarStyle
local TooltipProvider = require(ChromeShared.Unibar.Tooltips.TooltipProvider)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local AppFeaturePolicies = require(CorePackages.Workspace.Packages.UniversalAppPolicy).AppFeaturePolicies
local FFlagTokenizeUnibarConstantsWithStyleProvider = require(ChromeShared.Flags).FFlagTokenizeUnibarConstantsWithStyleProvider

local function UnibarMenuWrapper(p1) -- line: 16
	-- upvalues: React (copy), ReactUtils (copy), RoactAppPolicy (copy), AppFeaturePolicies (copy), TooltipProvider (copy), FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), UnibarMenu (copy)
	return React.createElement(ReactUtils.ContextStack, {
		providers = {
			React.createElement(RoactAppPolicy.Provider, {
				policy = { AppFeaturePolicies }
			}),
			React.createElement(TooltipProvider),
			if not FFlagTokenizeUnibarConstantsWithStyleProvider then nil else React.createElement(UnibarStyle.Provider)
		}
	}, {
		UnibarMenu = React.createElement(UnibarMenu, p1)
	})
end

return UnibarMenuWrapper
