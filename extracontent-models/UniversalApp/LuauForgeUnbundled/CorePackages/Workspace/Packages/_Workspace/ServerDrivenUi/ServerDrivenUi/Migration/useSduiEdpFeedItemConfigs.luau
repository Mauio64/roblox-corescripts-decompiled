local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiComponent = SduiCoreSystem.SduiComponent
local sduiErrors = SduiCoreSystem.SduiErrors
require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SignalsReact")
local getSduiFeedStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/DataStore/getSduiFeedStore")

require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/DataStore/SduiFeedStoreTypes")

local function getLayoutOrder(p2, p3, p4, p5, callback)
	if p2 and p4[p2] then
		callback({ layoutOrder = p2, itemKey = p5, existingComponent = p4[p2] })

		return p3
	end

	if p2 then
		return p2
	end

	return p3
end

local function useSduiEdpFeedItemConfigs(data)
	local v5 = React.useMemo(function()
		return function(p2)
			if not data.shouldInterleaveSdui then
				return {}
			end

			local v6 = getSduiFeedStore(data.storeKey)

			local result = {}

			for k, v7 in not v6.getItemCollectionKeys and {} or v6.getItemCollectionKeys(p2) do
				local itemCollection = v6.getItemCollection(v7)

				if itemCollection then
					result[v7] = itemCollection(p2)
				end
			end

			return result
		end
	end, { data.storeKey, data.shouldInterleaveSdui })
	local v6 = SignalsReact.useSignalState(v5)

	local v7 = React.useMemo(function()
		local result = {}

		if not data.shouldInterleaveSdui then
			return result
		end

		for k, v8 in data.portraitLayoutConfig do
			result[v8] = k
		end

		return result
	end, { data.portraitLayoutConfig, data.shouldInterleaveSdui })

	local v8 = React.useMemo(function()
		local result = {}

		if not data.shouldInterleaveSdui then
			return result
		end

		for k, v9 in data.landscapeLayoutConfig do
			result[v9] = k
		end

		return result
	end, { data.landscapeLayoutConfig, data.shouldInterleaveSdui })

	local v9 = React.useCallback(function(p2, p3, p4)
		if not data.shouldInterleaveSdui then
			return {}
		end

		local layoutOrder = p2.sduiConfig and p2.sduiConfig.props and p2.sduiConfig.props.LayoutOrder

		local v10 = data.defaultLayoutOrder + p4

		local v11 = v7

		local logLayoutConflictFn = data.logLayoutConflictFn
		local v12

		if layoutOrder and v11[layoutOrder] then
			logLayoutConflictFn({
				layoutOrder = layoutOrder,
				itemKey = p3,
				existingComponent = v11[layoutOrder]
			})
			v12 = v10
		else
			v12 = layoutOrder or v10
		end

		local v13 = v8

		local logLayoutConflictFn2 = data.logLayoutConflictFn

		if layoutOrder and v13[layoutOrder] then
			logLayoutConflictFn2({
				layoutOrder = layoutOrder,
				itemKey = p3,
				existingComponent = v13[layoutOrder]
			})
		else
			v10 = layoutOrder or v10
		end

		return { portrait = v12, landscape = v10 }
	end, {
		v8,
		v7,
		data.defaultLayoutOrder,
		data.logLayoutConflictFn,
		data.shouldInterleaveSdui
	})

	return React.useMemo(function()
		if not data.shouldInterleaveSdui then
			return {}
		end

		local count = 0
		local result = {}

		for k, v10 in v6 do
			local v11 = v9(v10, k, count)
			count += 1

			local sduiConfig = v10 and v10.sduiConfig or nil
			local formatted = `SduiEdpFeedItem-{data.storeKey}-{k}`

			if sduiConfig == nil then
				data.sduiContext.dependencies.logger.reportError(
					sduiErrors.SduiErrorType.NilComponentConfig,
					{
						name = formatted,
						message = `Unable to render edp feed item for sdui. Feed store key: {data.storeKey}, Collection key: {k}`
					},
					data.sduiContext.appPage
				)
			else
				result[k] = {
					portraitLayoutOrder = v11.portrait,
					landscapeLayoutOrder = v11.landscape,
					renderComponent = function()
						return React.createElement(sduiComponent, {
							debugName = formatted,
							componentConfig = sduiConfig,
							sduiContext = data.sduiContext
						})
					end
				}
			end
		end

		return result
	end, { v6, data.storeKey, data.sduiContext, v9, data.shouldInterleaveSdui })
end

return useSduiEdpFeedItemConfigs
