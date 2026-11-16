local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent
local React = require(parent.React)

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiComponent = SduiCoreSystem.SduiComponent
local SduiErrors = SduiCoreSystem.SduiErrors
require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local getSduiFeedStore = require(ServerDrivenUi.DataStore.getSduiFeedStore)

require(ServerDrivenUi.DataStore.SduiFeedStoreTypes)

local function getLayoutOrder(layoutOrder: number?, p: number, p2, itemKey: string, logLayoutConflictFn) -- 2 equivalent calls inferred from this helper
	if layoutOrder and p2[layoutOrder] then
		logLayoutConflictFn({
			layoutOrder = layoutOrder,
			itemKey = itemKey,
			existingComponent = p2[layoutOrder]
		})

		return p
	end

	return layoutOrder or p
end

local function useSduiEdpFeedItemConfigs(data)
	local v = React.useMemo(function()
		return function(p)
			if not data.shouldInterleaveSdui then
				return {}
			end

			local sduiFeedStore = getSduiFeedStore(data.storeKey)

			local result = {}

			for _, v in not sduiFeedStore.getItemCollectionKeys and {} or sduiFeedStore.getItemCollectionKeys(p) do
				local itemCollection = sduiFeedStore.getItemCollection(v)

				if itemCollection then
					result[v] = itemCollection(p)
				end
			end

			return result
		end
	end, { data.storeKey, data.shouldInterleaveSdui })
	local v2 = SignalsReact.useSignalState(v)

	local v3 = React.useMemo(function()
		local result = {}

		if not data.shouldInterleaveSdui then
			return result
		end

		for k, v3 in data.portraitLayoutConfig do
			result[v3] = k
		end

		return result
	end, { data.portraitLayoutConfig, data.shouldInterleaveSdui })

	local v4 = React.useMemo(function()
		local result = {}

		if not data.shouldInterleaveSdui then
			return result
		end

		for k, v4 in data.landscapeLayoutConfig do
			result[v4] = k
		end

		return result
	end, { data.landscapeLayoutConfig, data.shouldInterleaveSdui })

	local v5 = React.useCallback(function(p, itemKey: string, p2: number)
		if not data.shouldInterleaveSdui then
			return {}
		end

		local layoutOrder = p.sduiConfig and p.sduiConfig.props and p.sduiConfig.props.LayoutOrder

		local landscape = data.defaultLayoutOrder + p2

		local layoutOrder2 = getLayoutOrder(layoutOrder, landscape, v3, itemKey, data.logLayoutConflictFn) -- inferred equivalent call

		landscape = getLayoutOrder(layoutOrder, landscape, v4, itemKey, data.logLayoutConflictFn) -- inferred equivalent call

		return { portrait = layoutOrder2, landscape = landscape }
	end, { v4, v3, data.defaultLayoutOrder, data.logLayoutConflictFn, data.shouldInterleaveSdui })

	return React.useMemo(function()
		if not data.shouldInterleaveSdui then
			return {}
		end

		local count = 0
		local result = {}

		for k, v6 in v2 do
			local v7 = v5(v6, k, count)
			count += 1

			local sduiConfig = v6 and v6.sduiConfig or nil
			local formatted = `SduiEdpFeedItem-{data.storeKey}-{k}`

			if sduiConfig == nil then
				data.sduiContext.dependencies.logger.reportError(
					SduiErrors.SduiErrorType.NilComponentConfig,
					{
						name = formatted,
						message = `Unable to render edp feed item for sdui. Feed store key: {data.storeKey}, Collection key: {k}`
					},
					data.sduiContext.appPage
				)
			else
				result[k] = {
					portraitLayoutOrder = v7.portrait,
					landscapeLayoutOrder = v7.landscape,
					renderComponent = function()
						return React.createElement(SduiComponent, {
							debugName = formatted,
							componentConfig = sduiConfig,
							sduiContext = data.sduiContext
						})
					end
				}
			end
		end

		return result
	end, { v2, data.storeKey, data.sduiContext, v5, data.shouldInterleaveSdui })
end

return useSduiEdpFeedItemConfigs
