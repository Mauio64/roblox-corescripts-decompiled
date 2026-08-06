local HttpService = game:GetService("HttpService")
local Squads = script:FindFirstAncestor("Squads")
local SquadsParent = Squads.Parent
local dependencies = require(Squads.dependencies)
local React = dependencies.React
local Foundation = dependencies.Foundation
local useEffectOnce = dependencies.Hooks.useEffectOnce
local useLocalization = dependencies.Hooks.useLocalization
local Icon = Foundation.Icon
local FoundationText = Foundation.Text
local View = Foundation.View
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local useLocalUserId = require(SquadsParent.RobloxAppHooks).useLocalUserId
local SquadExternalContractContext = require(SquadsParent.SquadsCore.SquadExternalContractProvider).SquadExternalContractContext
local useCurrentSquadMembers = require(SquadsParent.SquadsCore.Hooks).useCurrentSquadMembers
local EventNames = require(SquadsParent.SquadsCore.EventNames)
local SquadLobbyLuckyRecommendationModal = require(script.Parent.SquadLobbyLuckyRecommendationModal)

local function SquadLobbyLuckyRecommendationRow(_: {[any]: any}) -- line: 28
	-- upvalues: useTokens (copy), React (copy), useLocalization (copy), useLocalUserId (copy), SquadExternalContractContext (copy), useCurrentSquadMembers (copy), useEffectOnce (copy), EventNames (copy), HttpService (copy), View (copy), FoundationText (copy), Icon (copy), IconSize (copy), SquadLobbyLuckyRecommendationModal (copy)
	local v21 = useTokens()
	local v22, v23 = React.useState(false)
	local v24 = useLocalization({
		title = "Feature.Squads.Label.LuckyRecommendationRow",
		body = "Feature.Squads.Description.LuckyRecommendationRow"
	})
	local v25 = tonumber(useLocalUserId()) or 0
	local v26 = React.useContext(SquadExternalContractContext)
	local v27 = useCurrentSquadMembers()
	local v28 = React.useRef(v27)

	v28.current = v27

	local v29 = React.useRef("")

	useEffectOnce(function() -- line: 44
		-- upvalues: v26 (copy), EventNames (copy), v25 (copy)
		v26.fireSquadAnalytics(EventNames.LuckyRecommendationRowImpression, {
			localUserId = v25,
			clientTimestamp = os.time()
		})
	end, true)

	local v30 = React.useCallback(function() -- line: 51
		-- upvalues: HttpService (copy), v29 (copy), v28 (copy), v26 (copy), EventNames (copy), v25 (copy), v23 (copy)
		local guid = HttpService:GenerateGUID(false)

		v29.current = guid

		local current = v28.current

		v26.fireSquadAnalytics(EventNames.LuckyRecommendationInvoked, {
			luckyRecommendationSessionId = guid,
			localUserId = v25,
			squadMemberCount = not current and 0 or #current,
			clientTimestamp = os.time()
		})
		v23(true)
	end, {
		v25,
		v26
	})
	local v31 = React.useCallback(function() -- line: 64
		-- upvalues: v23 (copy)
		v23(false)
	end, {})

	return React.createElement(React.Fragment, nil, {
		Row = React.createElement(View, {
			tag = "size-full-0 auto-y padding-x-xlarge"
		}, {
			Card = React.createElement(View, {
				tag = "row align-y-center gap-medium size-full-0 auto-y stroke-standard stroke-position-inner stroke-default radius-medium bg-surface-0 gui-object-defaults",
				padding = {
					left = UDim.new(0, v21.Padding.XLarge),
					right = UDim.new(0, v21.Padding.Medium),
					top = UDim.new(0, v21.Padding.Large),
					bottom = UDim.new(0, v21.Padding.Large)
				},
				onActivated = v30
			}, {
				Content = React.createElement(View, {
					tag = "col fill gap-xsmall auto-y",
					LayoutOrder = 1
				}, {
					Title = React.createElement(FoundationText, {
						tag = "size-full-0 auto-y text-title-medium text-no-wrap text-align-x-left text-truncate-end content-emphasis",
						LayoutOrder = 1,
						Text = v24.title
					}),
					Body = React.createElement(FoundationText, {
						tag = "size-full-0 auto-y text-body-medium text-no-wrap text-align-x-left text-truncate-end content-default",
						LayoutOrder = 2,
						Text = v24.body
					})
				}),
				Chevron = React.createElement(Icon, {
					LayoutOrder = 2,
					name = "chevron-large-right",
					size = IconSize.Small
				})
			})
		}),
		Modal = if not v22 then nil else React.createElement(SquadLobbyLuckyRecommendationModal, {
			onClose = v31,
			sessionId = v29.current
		})
	})
end

return SquadLobbyLuckyRecommendationRow
