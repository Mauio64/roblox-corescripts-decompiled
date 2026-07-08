local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")
local PartyIcon = require(script.Parent.PartyIcon)
local Service = require(Chrome.Service)
local ChromeIntegrationUtils = require(Chrome.Integrations.ChromeIntegrationUtils)
local GetFStringConnectTooltipLocalStorageKey = require(Chrome.Flags.GetFStringConnectTooltipLocalStorageKey)
local LocalStore = require(Chrome.ChromeShared.Service.LocalStore)
local MappedSignal = require(Chrome.ChromeShared.Service.ChromeUtils).MappedSignal
local FocusUtils = require(CorePackages.Workspace.Packages.Chrome).FocusUtils
local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local InExperienceAppChatModal = require(CorePackages.Workspace.Packages.AppChat.InExperienceAppChatModal)
local MouseIconOverrideService = require(CorePackages.Workspace.Packages.CoreScriptsCommon).MouseIconOverrideService
local React = require(CorePackages.Packages.React)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local Symbol = require(CorePackages.Workspace.Packages.AppCommonLib).Symbol
local SideSheetPlacement = Chrome2.Enums.SideSheetPlacement
local v18 = game:DefineFastFlag("ConnectIntegrationCheckForDirectionalInput", false)
local FFlagChromeActivatedMappedSignal = SharedFlags.FFlagChromeActivatedMappedSignal
local v20 = if not FFlagChromeActivatedMappedSignal then nil else MappedSignal.new(InExperienceAppChatModal.default.visibilitySignal.Event, function() -- line: 31
	-- upvalues: InExperienceAppChatModal (copy)
	return InExperienceAppChatModal:getVisible()
end)

return function(s1: string, n1: number) -- line: 36
	-- upvalues: Service (copy), SideSheetPlacement (copy), InExperienceAppChatModal (copy), ChromeIntegrationUtils (copy), v18 (copy), Responsive (copy), FocusUtils (copy), LocalStore (copy), GetFStringConnectTooltipLocalStorageKey (copy), FFlagChromeActivatedMappedSignal (copy), v20 (copy), React (copy), PartyIcon (copy), Symbol (copy), MouseIconOverrideService (copy)
	local v23 = Service:register({
		label = "Feature.Squads.Label.Party",
		id = s1,
		sideSheetPlacement = SideSheetPlacement.None,
		activated = function() -- line: 41
			-- upvalues: InExperienceAppChatModal (copy), ChromeIntegrationUtils (copy), v18 (copy), Responsive (copy), FocusUtils (copy), LocalStore (copy), GetFStringConnectTooltipLocalStorageKey (copy)
			if InExperienceAppChatModal:getVisible() then
				InExperienceAppChatModal.default:setVisible(false)
			else
				ChromeIntegrationUtils.dismissRobloxMenuAndRun(function() -- line: 45
					-- upvalues: v18 (copy), Responsive (copy), FocusUtils (copy), InExperienceAppChatModal (copy)
					if v18 then
						if Responsive.GetInputModeStore(false).getLastInputType(false) == Responsive.Input.Directional then
							FocusUtils.FocusOffChrome()
						end

						InExperienceAppChatModal.default:setVisible(true)

						return
					end

					FocusUtils.FocusOffChrome(function() -- line: 53
						-- upvalues: InExperienceAppChatModal (copy)
						InExperienceAppChatModal.default:setVisible(true)
					end)
				end)
			end

			LocalStore.storeForLocalPlayer(GetFStringConnectTooltipLocalStorageKey(), true)
		end,
		isActivated = not FFlagChromeActivatedMappedSignal and function() -- line: 63
			-- upvalues: InExperienceAppChatModal (copy)
			return InExperienceAppChatModal:getVisible()
		end or v20,
		components = {
			Icon = function(p1) -- line: 67
				-- upvalues: React (copy), PartyIcon (copy), s1 (copy)
				return React.createElement(PartyIcon, {
					integrationId = s1,
					isIconVisible = p1.visible
				})
			end
		},
		initialAvailability = n1
	})
	local v24 = Symbol.named("InExperienceRobloxParty")

	InExperienceAppChatModal.default.visibilitySignal.Event:Connect(function(p2) -- line: 79
		-- upvalues: MouseIconOverrideService (copy), v24 (copy)
		if p2 then
			MouseIconOverrideService.push(v24, Enum.OverrideMouseIconBehavior.ForceShow)

			return
		end

		MouseIconOverrideService.pop(v24)
	end)

	return v23
end
