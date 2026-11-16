local Chrome = script:FindFirstAncestor("Chrome")

local CorePackages = game:GetService("CorePackages")

local PartyIcon = require(script.Parent.PartyIcon)

local Service = require(Chrome.Service)
local ChromeIntegrationUtils = require(Chrome.Integrations.ChromeIntegrationUtils)
local GetFStringConnectTooltipLocalStorageKey = require(Chrome.Flags.GetFStringConnectTooltipLocalStorageKey)
local LocalStore = require(Chrome.ChromeShared.Service.LocalStore)

local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
local MappedSignal = ChromeUtils.MappedSignal

local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local FocusUtils = Chrome2.FocusUtils
local Chrome3 = require(CorePackages.Workspace.Packages.Chrome)
local InExperienceAppChatModal = require(CorePackages.Workspace.Packages.AppChat.InExperienceAppChatModal)
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local MouseIconOverrideService = CoreScriptsCommon.MouseIconOverrideService
local React = require(CorePackages.Packages.React)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Symbol = AppCommonLib.Symbol

local SocialCommon = require(CorePackages.Workspace.Packages.SocialCommon)
local ChatEntryPointNames = SocialCommon.Enums.ChatEntryPointNames

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAppChatDistinctUnibarEntryPoint = SharedFlags.FFlagAppChatDistinctUnibarEntryPoint

local SideSheetPlacement = Chrome3.Enums.SideSheetPlacement

local isActivated = MappedSignal.new(InExperienceAppChatModal.default.visibilitySignal.Event, function()
	return InExperienceAppChatModal:getVisible()
end)

return function(p: string, initialAvailability: number)
	local v = Service:register({
		id = p,
		sideSheetPlacement = SideSheetPlacement.None,
		label = "Feature.Squads.Label.Party",
		activated = function()
			if InExperienceAppChatModal:getVisible() then
				InExperienceAppChatModal.default:setVisible(false)
			else
				ChromeIntegrationUtils.dismissRobloxMenuAndRun(function()
					if Responsive.GetInputModeStore(false).getLastInputType(false) == Responsive.Input.Directional then
						FocusUtils.FocusOffChrome()
					end

					if FFlagAppChatDistinctUnibarEntryPoint then
						InExperienceAppChatModal.default:setVisible(true, ChatEntryPointNames.ChromeUnibar)
					else
						InExperienceAppChatModal.default:setVisible(true)
					end
				end)
			end

			LocalStore.storeForLocalPlayer(GetFStringConnectTooltipLocalStorageKey(), true)
		end,
		isActivated = isActivated,
		components = {
			Icon = function(p2)
				return React.createElement(PartyIcon, {
					integrationId = p,
					isIconVisible = p2.visible
				})
			end
		},
		initialAvailability = initialAvailability
	})

	local named = Symbol.named("InExperienceRobloxParty")
	InExperienceAppChatModal.default.visibilitySignal.Event:Connect(function(p2)
		if p2 then
			MouseIconOverrideService.push(named, Enum.OverrideMouseIconBehavior.ForceShow)
		else
			MouseIconOverrideService.pop(named)
		end
	end)

	return v
end
