local CorePackages = game:GetService("CorePackages")

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local Cryo = require(CorePackages.Packages.Cryo)
local default = require("@luauforge/bundled/bZg").GameProtocol.default

local gamesMultigetPlaceDetails = require("@luauforge/bundled/dBl").GamesByPlaceId.GamesMultigetPlaceDetails
local ixpServiceWrapper = require("@luauforge/bundled/fwW").IXPServiceWrapper
local launchGame = require("@luauforge/bundled/fIT").LaunchGame
local UrlBuilder = require(CorePackages.Packages.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local module = require("@luauforge/bundled/ehC")

local module2 = require("@luauforge/bundled/fIU")
local sources = module.Sources
local profileTypes = module.ProfileTypes

local module3 = require("@luauforge/bundled/dPN")
require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux")
local module4 = require("@luauforge/bundled/fBF")

local module5 = require("@luauforge/bundled/fIV")
require("@luauforge/bundled/fIx")

return {
	[module5.Asset] = function(p2, p3, p4)
		local asset = module3.ItemType.Asset
		local v6 = asset .. p2
		return {
			{
				{ name = avatarScreen.AvatarExperienceLandingPage },
				{ name = avatarScreen.Catalog },
				{
					name = avatarScreen.ItemDetails,
					detail = v6,
					extraProps = {
						itemId = p2,
						itemType = asset,
						mountAsFullView = true,
						mountAnimation = false
					}
				}
			}
		}
	end,
	[module5.Bundle] = function(p2, p3, p4)
		local bundle = module3.ItemType.Bundle
		local v6 = bundle .. p2
		return {
			{
				{ name = avatarScreen.AvatarExperienceLandingPage },
				{ name = avatarScreen.Catalog },
				{
					name = avatarScreen.ItemDetails,
					detail = v6,
					extraProps = {
						itemId = p2,
						itemType = bundle,
						mountAsFullView = true,
						mountAnimation = false
					}
				}
			}
		}
	end,
	[module5.ExperienceDetails] = function(p2, p3, p4)
		local v6, v7 = gamesMultigetPlaceDetails(p4.network, p2):andThen(function(p5)
			local universeId = tostring(p5.responseBody[1].universeId)
			return {
				{
					{ name = appPage.Games },
					{ name = appPage.GameDetail, detail = universeId, extraProps = p3 }
				}
			}
		end):catch(function(): nil
			return nil
		end):await()

		return v7
	end,
	[module5.Group] = function(p2, p3, p4)
		local v6

		if module2.FFlagIsSetupEnabled then
			ixpServiceWrapper:WaitForInitialization()
			module2.logExposure()
			local layerData = ixpServiceWrapper:GetLayerData(module2.EnableCommunityProfilePageExperimentLayer)
				or {}

			v6 = module2.isFeatureActive({
				[module2.EnableCommunityProfilePageExperimentLayer] = layerData
			})
		end

		if module2.FFlagIsSetupEnabled and v6 then
			return {
				{
					{ name = appPage.Home },
					{
						name = appPage.ProfilePlatform,
						detail = p2,
						extraProps = Cryo.Dictionary.union(p3, {
							profileType = profileTypes.Community,
							source = sources.ProfileShare
						})
					}
				}
			}
		end

		local group = urlBuilder.user.group({ groupId = p2 })

		return {
			{
				{ name = appPage.Home },
				{
					name = appPage.GenericWebPage,
					detail = group,
					extraProps = {
						titleKey = "CommonUI.Features.Label.Groups",
						transitionAnimation = module4.None
					}
				}
			}
		}
	end,
	[module5.Look] = function(p2, p3, p4)
		local look = module3.ItemType.Look
		local v6 = look .. p2
		return {
			{
				{ name = avatarScreen.AvatarExperienceLandingPage },
				{ name = avatarScreen.Catalog },
				{
					name = avatarScreen.LookDetails,
					detail = v6,
					extraProps = {
						itemId = p2,
						itemType = look,
						mountAsFullView = true,
						mountAnimation = false
					}
				}
			}
		}
	end,
	[module5.Server] = function(p2, state, p3)
		if state.code then
			local code = state.code
			state.code = nil
			state.linkCode = code
		end

		if state.linkCode then
			launchGame(p2, "Static" .. module5.Server, state, default)
		end

		local v6, v7 = gamesMultigetPlaceDetails(p3.network, p2):andThen(function(p4)
			local universeId = tostring(p4.responseBody[1].universeId)
			return {
				{
					{ name = appPage.Games },
					{
						name = appPage.GameDetail,
						detail = universeId,
						extraProps = state
					}
				}
			}
		end):catch(function(): nil
			return nil
		end):await()

		return v7
	end,
	[module5.UserProfile] = function(p2, p3, p4)
		return {
			{
				{ name = appPage.Home },
				{ name = appPage.ProfilePlatform, detail = p2, extraProps = p3 }
			}
		}
	end,
	[module5.Unknown] = function(p2, p3, p4): nil
		return nil
	end
}
