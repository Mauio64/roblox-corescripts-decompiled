local CorePackages = game:GetService("CorePackages")
local RobloxAppHooks = require(CorePackages.Workspace.Packages.RobloxAppHooks)
local RoactServiceTags = require(CorePackages.Workspace.Packages.RoactServiceTags)
local SendGameImpressions = require(CorePackages.Workspace.Packages.GameCollections).SendGameImpressions
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local Localization = require(CorePackages.Workspace.Packages.Localization)
local useNextUpSort = require(script.Parent.useNextUpSort)
local NextUpTile = require(script.Parent.NextUpTile)
local NextUpState = require(script.Parent.NextUpState)
local FFlagEnableNextUpImageLatencyTelemetry = require(script.Parent.Flags.FFlagEnableNextUpImageLatencyTelemetry)
local FFlagEnableInGameExitModalNextUpUiRequestCache = require(script.Parent.Flags.FFlagEnableInGameExitModalNextUpUiRequestCache)
local FFlagInGameExitModalFixModalPadding = require(script.Parent.Flags.FFlagInGameExitModalFixModalPadding)
local useRoactService = RobloxAppHooks.useRoactService
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local RoactAnalytics = RoactServiceTags.RoactAnalytics
local View = Foundation.View
local FoundationText = Foundation.Text
local Divider = Foundation.Divider
local useTokens = Foundation.Hooks.useTokens
local useLocalization = Localization.Hooks.useLocalization

local function tilePairComponent(t1: {[any]: any}) -- line: 32
	-- upvalues: React (copy), View (copy)
	return React.createElement(View, {
		tag = "row flex-x-fill auto-y gap-medium no-wrap align-x-center",
		Size = UDim2.fromOffset(t1.tilePairWidth, 0),
		LayoutOrder = t1.LayoutOrder
	}, t1.children)
end
local function getImpressionIndices(t2: {[any]: any}) -- line: 40
	local t3 = {}

	for i = 1, math.min(4, #t2) do
		table.insert(t3, t2[i].uiIndex)
	end

	return t3
end
local function NextUpComponent(t4: {[any]: any}) -- line: 58
	-- upvalues: useRoactService (copy), AppEventIngestService (copy), RoactAnalytics (copy), useTokens (copy), useLocalization (copy), FFlagEnableInGameExitModalNextUpUiRequestCache (copy), useNextUpSort (copy), React (copy), SendGameImpressions (copy), FFlagEnableNextUpImageLatencyTelemetry (copy), NextUpState (copy), getImpressionIndices (copy), NextUpTile (copy), Divider (copy), View (copy), FFlagInGameExitModalFixModalPadding (copy), FoundationText (copy), tilePairComponent (copy)
	local v30 = useRoactService(AppEventIngestService)
	local v31 = useRoactService(RoactAnalytics)
	local v32 = useTokens()
	local v33 = useLocalization({
		NextUpHeader = "CoreScripts.InGameMenu.NextUpExitMenu.Title"
	})
	local v34 = if not FFlagEnableInGameExitModalNextUpUiRequestCache then useNextUpSort() else t4.nextUpSort
	local data = v34.data
	local loading = v34.loading
	local v37 = React.useCallback(function(t5: {[any]: any}, t6: {[any]: any}, s1: string) -- line: 73
		-- upvalues: SendGameImpressions (copy), v30 (copy), v31 (copy)
		SendGameImpressions.sendFromInGameExitModal(v30, v31, s1, t5, t6)
	end, {
		v30,
		v31
	})

	if FFlagEnableNextUpImageLatencyTelemetry then
		React.useEffect(function() -- line: 86
			-- upvalues: NextUpState (copy)
			NextUpState.nextUpComponentShown()

			return function() -- line: 89
				-- upvalues: NextUpState (copy)
				NextUpState.resetNextUpLatencyTelemetry()
			end
		end, {})
	end

	local v38, v39 = React.useState(false)
	local v40, v41 = React.useState(nil)

	React.useEffect(function() -- line: 98
		-- upvalues: data (copy), v41 (copy), getImpressionIndices (copy), v39 (copy), FFlagEnableNextUpImageLatencyTelemetry (copy), NextUpState (copy)
		if not data then
			return
		end

		v41((getImpressionIndices(data.entries)))
		v39(false)

		if FFlagEnableNextUpImageLatencyTelemetry then
			NextUpState.nextUpComponentSortDataLoaded()
		else
			NextUpState.setNextUpTilesLoaded(true)
		end

		return function() -- line: 111
			-- upvalues: v41 (copy), FFlagEnableNextUpImageLatencyTelemetry (copy), NextUpState (copy)
			v41(nil)

			if not FFlagEnableNextUpImageLatencyTelemetry then
				NextUpState.setNextUpTilesLoaded(false)
			end
		end
	end, { data })
	React.useEffect(function() -- line: 120
		-- upvalues: data (copy), v40 (copy), v38 (copy), v39 (copy), v37 (copy)
		if not data or not v40 then
			return
		end

		if v38 then
			return
		end

		v39(true)
		v37(v40, data.entries, data.topicId)
	end, {
		data,
		v40,
		v38,
		v37
	})

	local v42 = React.useCallback(function(n1: number) -- line: 140
		-- upvalues: data (copy), React (copy), NextUpTile (copy), FFlagEnableNextUpImageLatencyTelemetry (copy), NextUpState (copy)
		local v47 = if not data then nil else data.entries[n1]

		return React.createElement(NextUpTile, {
			entryData = v47,
			topicId = not data and "" or data.topicId,
			positionIndex = n1,
			onTileImageLoaded = if not FFlagEnableNextUpImageLatencyTelemetry or not v47 then nil else function() -- line: 147
				-- upvalues: NextUpState (copy), n1 (copy)
				NextUpState.nextUpTileImageTextureLoaded(n1)
			end
		})
	end, { data })

	if not data and not loading then
		return React.None
	end

	return React.createElement(React.Fragment, nil, {
		divider = React.createElement(Divider, {
			LayoutOrder = 2
		}),
		nextUpSection = React.createElement(View, {
			LayoutOrder = 3,
			tag = not FFlagInGameExitModalFixModalPadding and "size-full-0 auto-y col gap-xxlarge" or "size-full-0 auto-y col gap-large"
		}, {
			header = React.createElement(View, {
				tag = "size-full-0 auto-y row align-x-left gap-small",
				LayoutOrder = 1
			}, {
				text = React.createElement(FoundationText, {
					tag = "text-heading-small text-wrap auto-xy shrink",
					Text = v33.NextUpHeader,
					textStyle = v32.Color.Extended.White.White_100
				})
			}),
			rowContainer = React.createElement(View, {
				tag = "size-full-0 auto-y row gap-medium wrap align-x-center flex-x-fill",
				LayoutOrder = 2
			}, {
				tilesSection1 = React.createElement(tilePairComponent, {
					LayoutOrder = 1,
					tilePairWidth = t4.tilePairWidth
				}, {
					tile1 = v42(1),
					tile2 = v42(2)
				}),
				tilesSection2 = React.createElement(tilePairComponent, {
					LayoutOrder = 2,
					tilePairWidth = t4.tilePairWidth
				}, {
					tile3 = v42(3),
					tile4 = v42(4)
				})
			})
		})
	})
end

return React.memo(NextUpComponent)
