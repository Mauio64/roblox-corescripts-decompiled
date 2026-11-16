local parent = script:FindFirstAncestor("PeopleService").Parent

local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")

local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local onPersonBlockButtonActivated = require(script.Parent.Parent.onPersonBlockButtonActivated)
local PeopleAnalyticsManager = require(script.Parent.Parent.Analytics.PeopleAnalyticsManager)
local FocusNavigationService = require(script.Parent.Parent.FocusNavigationService)
local SettingsHubService = require(script.Parent.SettingsHubService)

local function createPeopleBlockingModalManager()
	local localPlayer = Players.LocalPlayer

	local signal, v = Signals.createSignal(false)
	local signal2, v2 = Signals.createSignal(nil)

	local v3 = nil

	local function closeModal() -- 2 equivalent calls inferred from this helper
		FocusNavigationService.setBlockingModalRestoreMode(true)
		v(false)
		v2(nil)
		ContextActionService:UnbindCoreAction("BlockingModalScreen")
	end

	local function openModal(p, p2, p3)
		FocusNavigationService.saveScrollPosition()

		local v4 = onPersonBlockButtonActivated(p, PeopleAnalyticsManager, localPlayer.UserId, p2, v3, p3)

		function v4.modalProps.closeModal()
			v4.resolvePromise()
			closeModal() -- inferred equivalent call
		end

		v2(v4.modalProps)
		v(true)

		return v4.promise
	end

	local function getModalManager(p, p2)
		v3 = p2

		local function BlockingModalManager()
			local current = useSignalState(signal)

			local v4 = React.useContext(ReactFocusNavigation.FocusNavigationContext)
			local ref = React.useRef(false)

			local v5 = React.useMemo(function()
				return signal2(false)
			end, { current })

			React.useEffect(function()
				if current then
					ContextActionService:BindCoreAction("BlockingModalScreen", function()
						closeModal() -- inferred equivalent call
					end, false, Enum.KeyCode.ButtonB, Enum.KeyCode.Escape)
				else
					ContextActionService:UnbindCoreAction("BlockingModalScreen")
				end

				return function()
					ContextActionService:UnbindCoreAction("BlockingModalScreen")
				end
			end, { current })

			React.useEffect(function()
				if ref.current and not current then
					local pageRef = SettingsHubService.pageRef()

					if v4 and pageRef then
						v4:focusGuiObject(pageRef, true)
					end
				end

				ref.current = current
			end, { current, v4 })

			if current and v5 then
				return React.createElement(p, v5)
			end

			return nil
		end

		return BlockingModalManager
	end

	return { closeModal = closeModal, openModal = openModal, getModalManager = getModalManager }
end

return createPeopleBlockingModalManager()
