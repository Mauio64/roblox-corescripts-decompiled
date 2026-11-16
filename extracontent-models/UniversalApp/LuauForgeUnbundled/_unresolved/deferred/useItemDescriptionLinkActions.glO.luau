local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands = require("@luauforge/bundled/dCu").NavigationCommands
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useAvatarRoute = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.Hooks.useAvatarRoute
require("@luauforge/deferred/gkq")
require("@luauforge/deferred/glL")
local profileTypes = require("@luauforge/bundled/eef").ProfileTypes

local module = require("@luauforge/bundled/fWW")
local module2 = require("@luauforge/bundled/dMx")
local module3 = require("@luauforge/bundled/fsq")
local module4 = require("@luauforge/bundled/dCp")
local module5 = require("@luauforge/bundled/eee")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local module7 = require("@luauforge/deferred/glP")

local v5 = module3.fromString("www:communities/{groupId}#!/store")

local function useCanOpenNativeCommunityPage(): boolean
	if module.FFlagIsSetupEnabled then
		return module.useIsFeatureActive({ isExposureEnabled = false }) == true
	end

	return false
end

local function useItemDescriptionLinkActions(callback)
	local v6 = useDispatch()
	local v7 = useNavigation()
	local v8 = useAvatarRoute()
	local opaque = if v8 then v8.opaque else nil
	local v9 = useAppPolicy(function(p2)
		return p2.getWebViewSupport()
	end) == true
	local v10

	if module.FFlagIsSetupEnabled then
		v10 = module.useIsFeatureActive({ isExposureEnabled = false }) == true
	else
		v10 = false
	end

	local v11 = React.useCallback(function(p2)
		if callback == nil then
			return
		end

		local v12 = if p2.itemType == module2.ItemType.Bundle then module2.ItemType.Bundle else module2.ItemType.Asset
		callback({ itemId = p2.id, itemType = v12 }, v6)
	end, { callback, v6 })

	local v12 = React.useCallback(function(p2)
		v6(module7(p2.query or {}, v7, opaque))
	end, { v7, opaque, v6 })

	local v13 = React.useCallback(function(p2)
		local id = p2.id

		if module.FFlagIsSetupEnabled then
			module.logExposure()
		end

		local v14

		if v10 then
			v14 = {
				name = module4.ProfilePlatform,
				detail = id,
				extraProps = {
					profileType = profileTypes.Community,
					source = "ItemDetailsPage"
				}
			}
		else
			v14 = {
				name = module4.GenericWebPage,
				detail = module3.user.group({ groupId = id }),
				extraProps = { titleKey = "CommonUI.Features.Label.Groups" }
			}
		end

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v14))
		else
			v6(module5(v14))
		end
	end, { v10, v6 })

	local v14 = React.useCallback(function(p2)
		local v15 = {
			name = module4.GenericWebPage,
			detail = v5({ groupId = p2.id }),
			extraProps = { titleKey = "CommonUI.Features.Label.Groups" }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v15))
		else
			v6(module5(v15))
		end
	end, { v6 })

	local v15 = v10 or v9
	return React.useMemo(function()
		return {
			OpenItem = if callback then v11 else nil,
			OpenCatalog = v12,
			OpenCommunity = if v15 then v13 else nil,
			OpenCommunityStore = if v9 then v14 else nil
		}
	end, { callback, v11, v12, v15, v13, v9, v14 })
end

return useItemDescriptionLinkActions
