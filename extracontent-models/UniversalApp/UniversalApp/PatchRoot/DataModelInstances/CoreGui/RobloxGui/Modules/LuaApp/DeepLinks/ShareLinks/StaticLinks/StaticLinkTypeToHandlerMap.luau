local CorePackages = game:GetService("CorePackages")
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Cryo = require(CorePackages.Packages.Cryo)
local default = require(CorePackages.Workspace.Packages.ExperienceService).GameProtocol.default
local GamesMultigetPlaceDetails = require(CorePackages.Workspace.Packages.GameDetailRodux).GamesByPlaceId.GamesMultigetPlaceDetails
local IXPServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper).IXPServiceWrapper
local LaunchGame = require(CorePackages.Workspace.Packages.GameLaunch).LaunchGame
local UrlBuilder = require(CorePackages.Packages.UrlBuilder).UrlBuilder
local Enums = require(CorePackages.Workspace.Packages.ProfilePlatform.Enums)
local EnableCommunityProfilePageIXP = require(CorePackages.Workspace.Packages.ProfilePlatform.EnableCommunityProfilePageIXP)
local Sources = Enums.Sources
local ProfileTypes = Enums.ProfileTypes
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.Common.Constants)

require(CorePackages.Workspace.Packages.NavigationRodux)

local TransitionAnimation = require(Modules.LuaApp.Enum.TransitionAnimation)
local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local StaticShareLinkTypes = require(scriptParent.StaticShareLinkTypes)

require(scriptParentParent.Types)

return {
	[StaticShareLinkTypes.Asset] = function(p1, _, _) -- line: 31
		-- upvalues: Constants (copy), AvatarScreen (copy)
		local Asset = Constants.ItemType.Asset
		local v24 = Asset .. p1

		return {{
			{
				name = AvatarScreen.AvatarExperienceLandingPage
			},
			{
				name = AvatarScreen.Catalog
			},
			{
				name = AvatarScreen.ItemDetails,
				detail = v24,
				extraProps = {
					mountAsFullView = true,
					mountAnimation = false,
					itemId = p1,
					itemType = Asset
				}
			}
		}}
	end,
	[StaticShareLinkTypes.Bundle] = function(p4, _, _) -- line: 52
		-- upvalues: Constants (copy), AvatarScreen (copy)
		local Bundle = Constants.ItemType.Bundle
		local v29 = Bundle .. p4

		return {{
			{
				name = AvatarScreen.AvatarExperienceLandingPage
			},
			{
				name = AvatarScreen.Catalog
			},
			{
				name = AvatarScreen.ItemDetails,
				detail = v29,
				extraProps = {
					mountAsFullView = true,
					mountAnimation = false,
					itemId = p4,
					itemType = Bundle
				}
			}
		}}
	end,
	[StaticShareLinkTypes.ExperienceDetails] = function(p7, p8, p9) -- line: 73
		-- upvalues: GamesMultigetPlaceDetails (copy), AppPage (copy)
		local _, v34 = GamesMultigetPlaceDetails(p9.network, p7):andThen(function(p10) -- line: 75
			-- upvalues: AppPage (copy), p8 (copy)
			local str = tostring(p10.responseBody[1].universeId)

			return {{
				{
					name = AppPage.Games
				},
				{
					name = AppPage.GameDetail,
					detail = str,
					extraProps = p8
				}
			}}
		end):catch(function() -- line: 88
			return nil
		end):await()

		return v34
	end,
	[StaticShareLinkTypes.Group] = function(p11, p12, _) -- line: 96
		-- upvalues: EnableCommunityProfilePageIXP (copy), IXPServiceWrapper (copy), AppPage (copy), Cryo (copy), ProfileTypes (copy), Sources (copy), UrlBuilder (copy), TransitionAnimation (copy)
		local v38 = nil

		if EnableCommunityProfilePageIXP.FFlagIsSetupEnabled then
			IXPServiceWrapper:WaitForInitialization()
			EnableCommunityProfilePageIXP.logExposure()

			local v39 = IXPServiceWrapper:GetLayerData(EnableCommunityProfilePageIXP.EnableCommunityProfilePageExperimentLayer) or {}

			v38 = EnableCommunityProfilePageIXP.isFeatureActive({
				[EnableCommunityProfilePageIXP.EnableCommunityProfilePageExperimentLayer] = v39
			})
		end

		if EnableCommunityProfilePageIXP.FFlagIsSetupEnabled and v38 then
			return {{
				{
					name = AppPage.Home
				},
				{
					name = AppPage.ProfilePlatform,
					detail = p11,
					extraProps = Cryo.Dictionary.union(p12, {
						profileType = ProfileTypes.Community,
						source = Sources.ProfileShare
					})
				}
			}}
		end

		local v40 = UrlBuilder.user.group({
			groupId = p11
		})

		return {{
			{
				name = AppPage.Home
			},
			{
				name = AppPage.GenericWebPage,
				detail = v40,
				extraProps = {
					titleKey = "CommonUI.Features.Label.Groups",
					transitionAnimation = TransitionAnimation.None
				}
			}
		}}
	end,
	[StaticShareLinkTypes.Look] = function(p14, _, _) -- line: 144
		-- upvalues: Constants (copy), AvatarScreen (copy)
		local Look = Constants.ItemType.Look
		local v45 = Look .. p14

		return {{
			{
				name = AvatarScreen.AvatarExperienceLandingPage
			},
			{
				name = AvatarScreen.Catalog
			},
			{
				name = AvatarScreen.LookDetails,
				detail = v45,
				extraProps = {
					mountAsFullView = true,
					mountAnimation = false,
					itemId = p14,
					itemType = Look
				}
			}
		}}
	end,
	[StaticShareLinkTypes.Server] = function(p17, p18, p19) -- line: 167
		-- upvalues: LaunchGame (copy), StaticShareLinkTypes (copy), default (copy), GamesMultigetPlaceDetails (copy), AppPage (copy)
		if p18.code then
			local code = p18.code

			p18.code = nil
			p18.linkCode = code
		end

		if p18.linkCode then
			LaunchGame(p17, "Static" .. StaticShareLinkTypes.Server, p18, default)
		end

		local _, v51 = GamesMultigetPlaceDetails(p19.network, p17):andThen(function(p20) -- line: 179
			-- upvalues: AppPage (copy), p18 (copy)
			local str = tostring(p20.responseBody[1].universeId)

			return {{
				{
					name = AppPage.Games
				},
				{
					name = AppPage.GameDetail,
					detail = str,
					extraProps = p18
				}
			}}
		end):catch(function() -- line: 192
			return nil
		end):await()

		return v51
	end,
	[StaticShareLinkTypes.UserProfile] = function(p21, p22, _) -- line: 200
		-- upvalues: AppPage (copy)
		return {{
			{
				name = AppPage.Home
			},
			{
				name = AppPage.ProfilePlatform,
				detail = p21,
				extraProps = p22
			}
		}}
	end,
	[StaticShareLinkTypes.Unknown] = function(_, _, _) -- line: 213
		return nil
	end
}
