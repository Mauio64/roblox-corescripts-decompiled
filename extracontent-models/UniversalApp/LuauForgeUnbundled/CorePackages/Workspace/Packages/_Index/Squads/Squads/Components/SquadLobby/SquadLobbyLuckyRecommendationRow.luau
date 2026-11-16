local HttpService = game:GetService("HttpService")

local FFlagSquadsEnableFoundationTestIds = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Flags/FFlagSquadsEnableFoundationTestIds")

local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies")
local react = dependencies.React
local foundation = dependencies.Foundation
local useEffectOnce = dependencies.Hooks.useEffectOnce
local useLocalization = dependencies.Hooks.useLocalization

local icon = foundation.Icon
local text = foundation.Text
local view = foundation.View
local iconSize = foundation.Enums.IconSize
local useTokens = foundation.Hooks.useTokens

local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RobloxAppHooks").useLocalUserId

local squadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/SquadExternalContractProvider").SquadExternalContractContext
local useCurrentSquadMembers = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Hooks").useCurrentSquadMembers
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/EventNames")

local SquadLobbyLuckyRecommendationModal = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/SquadLobby/SquadLobbyLuckyRecommendationModal")

local function SquadLobbyLuckyRecommendationRow(p2)
	local v5 = useTokens()
	local state, setState = react.useState(false)
	local v6 = useLocalization({
		title = "Feature.Squads.Label.LuckyRecommendationRow",
		body = "Feature.Squads.Description.LuckyRecommendationRow"
	})

	local v7 = tonumber(useLocalUserId()) or 0
	local v8 = react.useContext(squadExternalContractContext)
	local v9 = useCurrentSquadMembers()
	local ref = react.useRef(v9)
	ref.current = v9

	local ref2 = react.useRef("")

	useEffectOnce(function()
		v8.fireSquadAnalytics(EventNames.LuckyRecommendationRowImpression, {
			localUserId = v7,
			clientTimestamp = os.time()
		})
	end, true)

	local v10 = react.useCallback(function()
		local guid = HttpService:GenerateGUID(false)
		ref2.current = guid
		local current = ref.current
		v8.fireSquadAnalytics(EventNames.LuckyRecommendationInvoked, {
			luckyRecommendationSessionId = guid,
			localUserId = v7,
			squadMemberCount = current and #current or 0,
			clientTimestamp = os.time()
		})

		setState(true)
	end, { v7, v8 })

	local v11 = react.useCallback(function()
		setState(false)
	end, {})

	local createElement = react.createElement
	local fragment = react.Fragment
	local v13 = {
		Row = react.createElement(view, { tag = "size-full-0 auto-y padding-x-xlarge" }, {
			Card = react.createElement(view, {
				tag = "row align-y-center gap-medium size-full-0 auto-y stroke-standard stroke-position-inner stroke-default radius-medium bg-surface-0 gui-object-defaults",
				padding = {
					left = UDim.new(0, v5.Padding.XLarge),
					right = UDim.new(0, v5.Padding.Medium),
					top = UDim.new(0, v5.Padding.Large),
					bottom = UDim.new(0, v5.Padding.Large)
				},
				onActivated = v10,
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-lucky-recommendation-row" or nil
			}, {
				Content = react.createElement(
					view,
					{ tag = "col fill gap-xsmall auto-y", LayoutOrder = 1 },
					{
						Title = react.createElement(text, {
							tag = "size-full-0 auto-y text-title-medium text-no-wrap text-align-x-left text-truncate-end content-emphasis",
							LayoutOrder = 1,
							Text = v6.title,
							testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-lucky-recommendation-row--title" or nil
						}),
						Body = react.createElement(text, {
							tag = "size-full-0 auto-y text-body-medium text-no-wrap text-align-x-left text-truncate-end content-default",
							LayoutOrder = 2,
							Text = v6.body,
							testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-lucky-recommendation-row--body" or nil
						})
					}
				),
				Chevron = react.createElement(icon, {
					LayoutOrder = 2,
					name = "chevron-large-right",
					size = iconSize.Small
				})
			})
		}),
		Modal = 0
	}

	local v14 = if state then react.createElement(SquadLobbyLuckyRecommendationModal, {
		onClose = v11,
		sessionId = ref2.current
	}) else nil
	v13.Modal = v14
	return createElement(fragment, nil, v13)
end

return SquadLobbyLuckyRecommendationRow
