local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Service = require(Chrome.Service)
local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
local ConnectIcon = require(script.Parent.ConnectIcon)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local InExperienceAppChatModal = require(CorePackages.Workspace.Packages.AppChat.InExperienceAppChatModal)
local ChromeIntegrationUtils = require(Chrome.Integrations.ChromeIntegrationUtils)
local LocalStore = require(Chrome.ChromeShared.Service.LocalStore)
local MappedSignal = ChromeUtils.MappedSignal
local GetFStringConnectTooltipLocalStorageKey = require(Chrome.Flags.GetFStringConnectTooltipLocalStorageKey)
local MouseIconOverrideService = require(CorePackages.Workspace.Packages.CoreScriptsCommon).MouseIconOverrideService
local Symbol = require(CorePackages.Workspace.Packages.AppCommonLib).Symbol
local FocusUtils = require(CorePackages.Workspace.Packages.Chrome).FocusUtils
local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy)
local SideSheetPlacement = require(CorePackages.Workspace.Packages.Chrome).Enums.SideSheetPlacement
local v18 = game:DefineFastFlag("AppChatInExpUseUnibarNotification", false)
local v19 = game:DefineFastFlag("ConnectIntegrationCheckForDirectionalInput", false)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagChromeActivatedMappedSignal = SharedFlags.FFlagChromeActivatedMappedSignal
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local ArgoPartyExperimentation = require(CorePackages.Workspace.Packages.SocialExperiments).ArgoPartyExperimentation
local v24 = if not FFlagChromeActivatedMappedSignal then nil else MappedSignal.new(InExperienceAppChatModal.default.visibilitySignal.Event, function() -- line: 38
	-- upvalues: InExperienceAppChatModal (copy)
	return InExperienceAppChatModal:getVisible()
end)

return function(s1: string, n1: number) -- line: 43
	-- upvalues: GetFFlagIsSquadEnabled (copy), Service (copy), SideSheetPlacement (copy), ArgoPartyExperimentation (copy), UniversalAppPolicy (copy), InExperienceAppChatModal (copy), ChromeIntegrationUtils (copy), v19 (copy), Responsive (copy), FocusUtils (copy), LocalStore (copy), GetFStringConnectTooltipLocalStorageKey (copy), FFlagChromeActivatedMappedSignal (copy), v24 (copy), React (copy), ConnectIcon (copy), v18 (copy), Symbol (copy), MouseIconOverrideService (copy)
	local v27 = s1 == "connect_unibar" and GetFFlagIsSquadEnabled()
	local v28 = Service:register({
		id = s1,
		sideSheetPlacement = if s1 ~= "connect_unibar" then SideSheetPlacement.Vertical else SideSheetPlacement.Unibar,
		label = if not ArgoPartyExperimentation.getIsRenameEnabled() then not GetFFlagIsSquadEnabled() and "Feature.Chat.Label.RobloxChat" or "Feature.Squads.Label.Party" else not UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology() and "Feature.Squads.Label.Party" or "Feature.Chat.Title.FriendsChat",
		activated = function() -- line: 56
			-- upvalues: InExperienceAppChatModal (copy), ChromeIntegrationUtils (copy), v19 (copy), Responsive (copy), FocusUtils (copy), LocalStore (copy), GetFStringConnectTooltipLocalStorageKey (copy)
			if InExperienceAppChatModal:getVisible() then
				InExperienceAppChatModal.default:setVisible(false)
			else
				ChromeIntegrationUtils.dismissRobloxMenuAndRun(function() -- line: 60
					-- upvalues: v19 (copy), Responsive (copy), FocusUtils (copy), InExperienceAppChatModal (copy)
					if v19 then
						if Responsive.GetInputModeStore(false).getLastInputType(false) == Responsive.Input.Directional then
							FocusUtils.FocusOffChrome()
						end

						InExperienceAppChatModal.default:setVisible(true)

						return
					end

					FocusUtils.FocusOffChrome(function() -- line: 68
						-- upvalues: InExperienceAppChatModal (copy)
						InExperienceAppChatModal.default:setVisible(true)
					end)
				end)
			end

			LocalStore.storeForLocalPlayer(GetFStringConnectTooltipLocalStorageKey(), true)
		end,
		isActivated = not FFlagChromeActivatedMappedSignal and function() -- line: 78
			-- upvalues: InExperienceAppChatModal (copy)
			return InExperienceAppChatModal:getVisible()
		end or v24,
		components = {
			Icon = function(p1) -- line: 82
				-- upvalues: React (copy), ConnectIcon (copy), s1 (copy), v18 (copy), v27 (copy)
				return React.createElement(ConnectIcon, {
					integrationId = s1,
					isIconVisible = p1.visible,
					shouldShowCustomBadge = not v18,
					isSquadIndicatorEnabled = v27
				})
			end
		},
		initialAvailability = n1
	})

	if v18 then
		if v27 then
			local function updateNotificationBadge(n2: number, b1: boolean) -- line: 97
				-- upvalues: v28 (copy)
				if n2 == 0 or b1 then
					v28.notification:clear()

					return
				end

				v28.notification:fireCount(n2)
			end

			InExperienceAppChatModal.default.currentSquadIdSignal.Event:Connect(function(p2) -- line: 106
				-- upvalues: InExperienceAppChatModal (copy), v28 (copy)
				local unreadCount = InExperienceAppChatModal.default.unreadCount
				local v40 = p2 ~= ""

				if unreadCount == 0 or v40 then
					v28.notification:clear()

					return
				end

				v28.notification:fireCount(unreadCount)
			end)
			InExperienceAppChatModal.default.unreadCountSignal.Event:Connect(function(p3) -- line: 110
				-- upvalues: InExperienceAppChatModal (copy), v28 (copy)
				local v42 = InExperienceAppChatModal.default.currentSquadId ~= ""

				if p3 == 0 or v42 then
					v28.notification:clear()

					return
				end

				v28.notification:fireCount(p3)
			end)

			local unreadCount = InExperienceAppChatModal.default.unreadCount
			local v31 = InExperienceAppChatModal.default.currentSquadId ~= ""

			if unreadCount == 0 or v31 then
				v28.notification:clear()
			else
				v28.notification:fireCount(unreadCount)
			end
		else
			local function updateUnreadMessageCount(p4) -- line: 119
				-- upvalues: v28 (copy)
				if p4 == 0 then
					v28.notification:clear()

					return
				end

				v28.notification:fireCount(p4)
			end

			InExperienceAppChatModal.default.unreadCountSignal.Event:Connect(function(p5) -- line: 127
				-- upvalues: v28 (copy)
				if p5 == 0 then
					v28.notification:clear()

					return
				end

				v28.notification:fireCount(p5)
			end)

			local unreadCount = InExperienceAppChatModal.default.unreadCount

			if unreadCount == 0 then
				v28.notification:clear()
			else
				v28.notification:fireCount(unreadCount)
			end
		end
	end

	local v34 = Symbol.named("InExperienceRobloxConnect")

	InExperienceAppChatModal.default.visibilitySignal.Event:Connect(function(p6) -- line: 137
		-- upvalues: MouseIconOverrideService (copy), v34 (copy)
		if p6 then
			MouseIconOverrideService.push(v34, Enum.OverrideMouseIconBehavior.ForceShow)

			return
		end

		MouseIconOverrideService.pop(v34)
	end)

	return v28
end
