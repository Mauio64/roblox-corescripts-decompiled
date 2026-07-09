local ServerTriggeredModals = script:FindFirstAncestor("ServerTriggeredModals")
local ServerTriggeredModalsParent = ServerTriggeredModals.Parent
local React = require(ServerTriggeredModalsParent.React)
local SduiFeatureEntryPoint = require(ServerTriggeredModalsParent.SduiSharedUtilities).SduiFeatureEntryPoint
local Logger = require(ServerTriggeredModals.Logger)
local reportPromptImpression = require(ServerTriggeredModals.reportPromptImpression)
local sendModalImpressionEvent = require(ServerTriggeredModals.sendModalImpressionEvent)
local PromptStyle = require(ServerTriggeredModals.SduiV2.PromptStyle)
local usePromptEntries = require(ServerTriggeredModals.SduiV2.usePromptEntries)
local useModalSignalStore = require(ServerTriggeredModals.SignalStores.useModalSignalStore)

local function CoachmarkRenderer(t1: {[any]: any}) -- line: 38
	-- upvalues: useModalSignalStore (copy), React (copy), usePromptEntries (copy), PromptStyle (copy), reportPromptImpression (copy), Logger (copy), sendModalImpressionEvent (copy), SduiFeatureEntryPoint (copy)
	local surfaceConfig = t1.surfaceConfig
	local hasShownKey = t1.hasShownKey
	local v15 = useModalSignalStore()
	local v16, v17 = React.useState(false)

	React.useEffect(function() -- line: 44
		-- upvalues: v16 (copy), v15 (copy), hasShownKey (copy), v17 (copy)
		if not v16 and v15.tryClaimPrimaryHandler(hasShownKey) then
			v17(true)
		end

		return function() -- line: 48
			-- upvalues: v16 (copy), v15 (copy), hasShownKey (copy)
			if v16 then
				v15.releasePrimaryHandler(hasShownKey)
			end
		end
	end, {
		v16,
		hasShownKey,
		v15
	})

	local v18 = usePromptEntries(surfaceConfig.configKey, PromptStyle.Coachmark)
	local v19 = React.useMemo(function() -- line: 57
		-- upvalues: v16 (copy), v18 (copy)
		if not v16 then
			return ""
		end

		local t2 = {}

		for _, v25 in v18 do
			if v25.identifier and v25.title and v25.config then
				table.insert(t2, `{ v25.identifier }:{ v25.title }`)
			end
		end

		return table.concat(t2, "|")
	end, {
		v16,
		v18
	})

	React.useEffect(function() -- line: 72
		-- upvalues: v19 (copy), v18 (copy), reportPromptImpression (copy), Logger (copy), sendModalImpressionEvent (copy)
		if v19 == "" then
			return
		end

		for _, v27 in v18 do
			if v27.identifier and v27.title and v27.config then
				reportPromptImpression(v27.title, v27.identifier):catch(function() -- line: 78
					-- upvalues: Logger (copy)
					Logger:warning("Failed to report coachmark prompt impression")
				end)
				sendModalImpressionEvent(v27.identifier, v27.title)
			end
		end
	end, { v19 })

	if not v16 then
		return nil
	end

	local t3 = {}

	for _, v22 in v18 do
		if v22.config ~= nil and v22.identifier ~= nil and v22.title ~= nil then
			t3[v22.identifier] = React.createElement(SduiFeatureEntryPoint, {
				shouldDisplayLoading = false,
				shouldDisplayError = false,
				configKey = surfaceConfig.configKey,
				identifier = v22.identifier,
				appPage = surfaceConfig.appPage
			})
		end
	end

	return React.createElement(React.Fragment, nil, t3)
end

return React.memo(CoachmarkRenderer)
