local HttpService = game:GetService("HttpService")

local Squads = script:FindFirstAncestor("Squads")
local parent = Squads.Parent

local FFlagSquadsEnableFoundationTestIds = require(Squads.Flags.FFlagSquadsEnableFoundationTestIds)

local dependencies = require(Squads.dependencies)
local react = dependencies.React
local foundation = dependencies.Foundation
local useEffectOnce = dependencies.Hooks.useEffectOnce
local useLocalization = dependencies.Hooks.useLocalization

local icon = foundation.Icon
local text = foundation.Text
local view = foundation.View
local iconSize = foundation.Enums.IconSize
local useTokens = foundation.Hooks.useTokens

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId

local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local Hooks = require(parent.SquadsCore.Hooks)
local useCurrentSquadMembers = Hooks.useCurrentSquadMembers
local EventNames = require(parent.SquadsCore.EventNames)

local SquadLobbyLuckyRecommendationModal = require(script.Parent.SquadLobbyLuckyRecommendationModal)

local function SquadLobbyLuckyRecommendationRow(_)
	local v = useTokens()
	local state, setState = react.useState(false)
	local v2 = useLocalization({
		title = "Feature.Squads.Label.LuckyRecommendationRow",
		body = "Feature.Squads.Description.LuckyRecommendationRow"
	})

	local localUserId = tonumber(useLocalUserId()) or 0
	local v3 = react.useContext(SquadExternalContractContext)
	local current2 = useCurrentSquadMembers()
	local ref = react.useRef(current2)
	ref.current = current2

	local ref2 = react.useRef("")

	useEffectOnce(function()
		v3.fireSquadAnalytics(EventNames.LuckyRecommendationRowImpression, {
			localUserId = localUserId,
			clientTimestamp = os.time()
		})
	end, true)

	local onActivated = react.useCallback(function()
		local guid = HttpService:GenerateGUID(false)
		ref2.current = guid
		local current = ref.current
		v3.fireSquadAnalytics(EventNames.LuckyRecommendationInvoked, {
			luckyRecommendationSessionId = guid,
			localUserId = localUserId,
			squadMemberCount = current and #current or 0,
			clientTimestamp = os.time()
		})

		setState(true)
	end, { localUserId, v3 })

	local onClose = react.useCallback(function()
		setState(false)
	end, {})

	local createElement = react.createElement
	local fragment = react.Fragment
	local v4 = {
		Row = react.createElement(view, { tag = "size-full-0 auto-y padding-x-xlarge" }, {
			Card = react.createElement(view, {
				tag = "row align-y-center gap-medium size-full-0 auto-y stroke-standard stroke-position-inner stroke-default radius-medium bg-surface-0 gui-object-defaults",
				padding = {
					left = UDim.new(0, v.Padding.XLarge),
					right = UDim.new(0, v.Padding.Medium),
					top = UDim.new(0, v.Padding.Large),
					bottom = UDim.new(0, v.Padding.Large)
				},
				onActivated = onActivated,
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-lucky-recommendation-row" or nil
			}, {
				Content = react.createElement(view, {
					tag = "col fill gap-xsmall auto-y",
					LayoutOrder = 1
				}, {
					Title = react.createElement(text, {
						tag = "size-full-0 auto-y text-title-medium text-no-wrap text-align-x-left text-truncate-end content-emphasis",
						LayoutOrder = 1,
						Text = v2.title,
						testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-lucky-recommendation-row--title" or nil
					}),
					Body = react.createElement(text, {
						tag = "size-full-0 auto-y text-body-medium text-no-wrap text-align-x-left text-truncate-end content-default",
						LayoutOrder = 2,
						Text = v2.body,
						testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-lucky-recommendation-row--body" or nil
					})
				}),
				Chevron = react.createElement(icon, {
					LayoutOrder = 2,
					name = "chevron-large-right",
					size = iconSize.Small
				})
			})
		}),
		Modal = 0
	}
	local modal

	if state then
		modal = react.createElement(SquadLobbyLuckyRecommendationModal, {
			onClose = onClose,
			sessionId = ref2.current
		})
	end

	v4.Modal = modal
	return createElement(fragment, nil, v4)
end

return SquadLobbyLuckyRecommendationRow
