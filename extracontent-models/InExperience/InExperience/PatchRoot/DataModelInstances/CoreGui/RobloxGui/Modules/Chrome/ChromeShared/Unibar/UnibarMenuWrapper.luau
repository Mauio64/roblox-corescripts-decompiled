local ChromeShared = script:FindFirstAncestor("ChromeShared")

local CorePackages = game:GetService("CorePackages")

local ReactUtils = require(CorePackages.Packages.ReactUtils)
local React = require(CorePackages.Packages.React)
local UnibarMenu = require(ChromeShared.Unibar.UnibarMenu)
local Chrome = require(CorePackages.Workspace.Packages.Chrome)
local UnibarStyle = Chrome.UnibarStyle
local TooltipProvider = require(ChromeShared.Unibar.Tooltips.TooltipProvider)
local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy)
local RoactAppPolicy = UniversalAppPolicy.RoactAppPolicy
local UniversalAppPolicy2 = require(CorePackages.Workspace.Packages.UniversalAppPolicy)
local AppFeaturePolicies = UniversalAppPolicy2.AppFeaturePolicies

local Flags = require(ChromeShared.Flags)
local FFlagTokenizeUnibarConstantsWithStyleProvider = Flags.FFlagTokenizeUnibarConstantsWithStyleProvider

local function UnibarMenuWrapper(p)
	local createElement = React.createElement
	local contextStack = ReactUtils.ContextStack

	local element = React.createElement(RoactAppPolicy.Provider, {
		policy = { AppFeaturePolicies }
	})

	local element2 = React.createElement(TooltipProvider)
	local v

	if FFlagTokenizeUnibarConstantsWithStyleProvider then
		v = React.createElement(UnibarStyle.Provider)
	end

	return createElement(contextStack, {
		providers = { element, element2, v }
	}, {
		UnibarMenu = React.createElement(UnibarMenu, p)
	})
end

return UnibarMenuWrapper
