local Parent = script:FindFirstAncestor("PeopleService").Parent
local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local React = require(Parent.React)
local ReactFocusNavigation = require(Parent.ReactFocusNavigation)
local Signals = require(Parent.Signals)
local useSignalState = require(Parent.SignalsReact).useSignalState
local FFlagIEMFocusNavPeoplePageToButtons = require(Parent.SharedFlags).FFlagIEMFocusNavPeoplePageToButtons
local onPersonBlockButtonActivated = require(script.Parent.Parent.onPersonBlockButtonActivated)
local PeopleAnalyticsManager = require(script.Parent.Parent.Analytics.PeopleAnalyticsManager)
local FocusNavigationService = require(script.Parent.Parent.FocusNavigationService)
local SettingsHubService = require(script.Parent.SettingsHubService)

local function createPeopleBlockingModalManager() -- line: 34
	-- upvalues: Players (copy), Signals (copy), FocusNavigationService (copy), ContextActionService (copy), onPersonBlockButtonActivated (copy), PeopleAnalyticsManager (copy), useSignalState (copy), FFlagIEMFocusNavPeoplePageToButtons (copy), React (copy), ReactFocusNavigation (copy), SettingsHubService (copy)
	local LocalPlayer = Players.LocalPlayer
	local v15, v16 = Signals.createSignal(false)
	local v17, v18 = Signals.createSignal(nil)
	local u19 = nil

	return {
		closeModal = function() -- line: 46
			-- upvalues: FocusNavigationService (copy), v16 (copy), v18 (copy), ContextActionService (copy)
			FocusNavigationService.setBlockingModalRestoreMode(true)
			v16(false)
			v18(nil)
			ContextActionService:UnbindCoreAction("BlockingModalScreen")
		end,
		openModal = function(p1, p2, p3) -- line: 53
			-- upvalues: FocusNavigationService (copy), onPersonBlockButtonActivated (copy), PeopleAnalyticsManager (copy), LocalPlayer (copy), u19 (ref), v16 (copy), v18 (copy), ContextActionService (copy)
			FocusNavigationService.saveScrollPosition()

			local v23 = onPersonBlockButtonActivated(p1, PeopleAnalyticsManager, LocalPlayer.UserId, p2, u19, p3)

			function v23.modalProps.closeModal() -- line: 65
				-- upvalues: v23 (copy), FocusNavigationService (copy), v16 (copy), v18 (copy), ContextActionService (copy)
				v23.resolvePromise()
				FocusNavigationService.setBlockingModalRestoreMode(true)
				v16(false)
				v18(nil)
				ContextActionService:UnbindCoreAction("BlockingModalScreen")
			end

			v18(v23.modalProps)
			v16(true)

			return v23.promise
		end,
		getModalManager = function(p4, p5) -- line: 76
			-- upvalues: u19 (ref), useSignalState (copy), v15 (copy), FFlagIEMFocusNavPeoplePageToButtons (copy), React (copy), ReactFocusNavigation (copy), v17 (copy), ContextActionService (copy), FocusNavigationService (copy), v16 (copy), v18 (copy), SettingsHubService (copy)
			u19 = p5

			local function BlockingModalManager() -- line: 80
				-- upvalues: useSignalState (copy), v15 (copy), FFlagIEMFocusNavPeoplePageToButtons (copy), React (copy), ReactFocusNavigation (copy), v17 (copy), ContextActionService (copy), FocusNavigationService (copy), v16 (copy), v18 (copy), SettingsHubService (copy), p4 (copy)
				local v27 = useSignalState(v15)
				local u28 = nil
				local u29 = nil

				if FFlagIEMFocusNavPeoplePageToButtons then
					u28 = React.useContext(ReactFocusNavigation.FocusNavigationContext)
					u29 = React.useRef(false)
				end

				local v30 = React.useMemo(function() -- line: 89
					-- upvalues: v17 (copy)
					return v17(false)
				end, { v27 })

				React.useEffect(function() -- line: 94
					-- upvalues: v27 (copy), ContextActionService (copy), FocusNavigationService (copy), v16 (copy), v18 (copy)
					if v27 then
						ContextActionService:BindCoreAction("BlockingModalScreen", function() -- line: 96
							-- upvalues: FocusNavigationService (copy), v16 (copy), v18 (copy), ContextActionService (copy)
							FocusNavigationService.setBlockingModalRestoreMode(true)
							v16(false)
							v18(nil)
							ContextActionService:UnbindCoreAction("BlockingModalScreen")
						end, false, Enum.KeyCode.ButtonB, Enum.KeyCode.Escape)
					else
						ContextActionService:UnbindCoreAction("BlockingModalScreen")
					end

					return function() -- line: 103
						-- upvalues: ContextActionService (copy)
						ContextActionService:UnbindCoreAction("BlockingModalScreen")
					end
				end, { v27 })

				if FFlagIEMFocusNavPeoplePageToButtons then
					React.useEffect(function() -- line: 114
						-- upvalues: u29 (ref), v27 (copy), SettingsHubService (copy), u28 (ref)
						if u29.current and not v27 then
							local v31 = SettingsHubService.pageRef()

							if u28 and v31 then
								u28:focusGuiObject(v31, true)
							end
						end

						u29.current = v27
					end, {
						v27,
						u28
					})
				end

				if not v27 or not v30 then
					return nil
				end

				return React.createElement(p4, v30)
			end

			return BlockingModalManager
		end
	}
end

return (createPeopleBlockingModalManager())
